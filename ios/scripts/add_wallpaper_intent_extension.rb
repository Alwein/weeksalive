#!/usr/bin/env ruby
# Adds the WeeksAliveWallpaperIntent App Intents extension and removes the
# intent sources from the Runner target (they must not run inside Flutter).
# Configures it as an ExtensionKit extension (required by App Store validation
# for com.apple.appintents-extension). Idempotent.

require "xcodeproj"

PROJECT_PATH = File.expand_path("../Runner.xcodeproj", __dir__)
EXTENSION_NAME = "WeeksAliveWallpaperIntent"
APP_GROUP = "group.com.weeksalive"
DEVELOPMENT_TEAM = "XA8VKF93HG"
DEPLOYMENT_TARGET = "16.6"
EXTENSIONKIT_PRODUCT_TYPE = "com.apple.product-type.extensionkit-extension"
EXTENSIONKIT_FILE_TYPE = "wrapper.extensionkit-extension"
EMBED_PHASE_NAME = "Embed ExtensionKit Extensions"

SWIFT_FILES = %w[
  WeeksAliveWallpaperIntent.swift
  GetWallpaperIntent.swift
  WeeksAliveShortcuts.swift
].freeze

REMOVE_FROM_RUNNER = %w[
  GetWallpaperIntent.swift
  WeeksAliveShortcuts.swift
].freeze

def apply_extension_build_settings(extension_target)
  extension_target.build_configurations.each do |config|
    settings = config.build_settings
    settings["PRODUCT_BUNDLE_IDENTIFIER"] = "com.weeksalive.#{EXTENSION_NAME}"
    settings["PRODUCT_NAME"] = "$(TARGET_NAME)"
    settings["INFOPLIST_FILE"] = "#{EXTENSION_NAME}/Info.plist"
    settings["CODE_SIGN_ENTITLEMENTS"] = "#{EXTENSION_NAME}/#{EXTENSION_NAME}.entitlements"
    settings["CODE_SIGN_STYLE"] = "Automatic"
    settings["DEVELOPMENT_TEAM"] = DEVELOPMENT_TEAM
    settings["IPHONEOS_DEPLOYMENT_TARGET"] = DEPLOYMENT_TARGET
    settings["SWIFT_VERSION"] = "5.0"
    settings["TARGETED_DEVICE_FAMILY"] = "1,2"
    settings["SKIP_INSTALL"] = "YES"
    settings["GENERATE_INFOPLIST_FILE"] = "NO"
    settings["CURRENT_PROJECT_VERSION"] = "$(FLUTTER_BUILD_NUMBER)"
    settings["MARKETING_VERSION"] = "$(FLUTTER_BUILD_NAME)"
    settings["SDKROOT"] = "iphoneos"
    settings["SUPPORTED_PLATFORMS"] = "iphoneos iphonesimulator"
    settings["SUPPORTS_MACCATALYST"] = "NO"
    settings["LD_RUNPATH_SEARCH_PATHS"] = [
      "$(inherited)",
      "@executable_path/Frameworks",
      "@executable_path/../../Frameworks",
    ]
    settings["APPLICATION_EXTENSION_API_ONLY"] = "YES"
  end
end

def configure_as_extensionkit(extension_target)
  extension_target.product_type = EXTENSIONKIT_PRODUCT_TYPE
  product_ref = extension_target.product_reference
  product_ref.explicit_file_type = EXTENSIONKIT_FILE_TYPE if product_ref.respond_to?(:explicit_file_type=)
end

def remove_from_plugins_embed(runner_target, extension_target)
  runner_target.copy_files_build_phases.each do |phase|
    next unless phase.name == "Embed Foundation Extensions" || phase.dst_subfolder_spec.to_s == "13"

    phase.files.dup.each do |build_file|
      next unless build_file.file_ref == extension_target.product_reference

      phase.remove_build_file(build_file)
      puts "Removed #{EXTENSION_NAME}.appex from #{phase.name || 'PlugIns embed phase'}"
    end
  end
end

def ensure_extensionkit_embed(runner_target, extension_target)
  embed_phase = runner_target.copy_files_build_phases.find { |phase| phase.name == EMBED_PHASE_NAME }

  unless embed_phase
    embed_phase = runner_target.new_copy_files_build_phase(EMBED_PHASE_NAME)
    # Products Directory + $(EXTENSIONS_FOLDER_PATH) places the appex in
    # Runner.app/Extensions, which App Store validation requires for
    # ExtensionKit (EXAppExtension) bundles.
    embed_phase.dst_path = "$(EXTENSIONS_FOLDER_PATH)"
    embed_phase.dst_subfolder_spec = "16"

    phases = runner_target.build_phases
    foundation = phases.find { |phase| phase.respond_to?(:name) && phase.name == "Embed Foundation Extensions" }
    if foundation
      phases.delete(embed_phase)
      phases.insert(phases.index(foundation) + 1, embed_phase)
    end
    puts "Created #{EMBED_PHASE_NAME} build phase"
  end

  already_embedded = embed_phase.files.any? { |bf| bf.file_ref == extension_target.product_reference }
  unless already_embedded
    build_file = embed_phase.add_file_reference(extension_target.product_reference)
    build_file.settings = { "ATTRIBUTES" => ["RemoveHeadersOnCopy"] }
    puts "Embedded #{EXTENSION_NAME}.appex in #{EMBED_PHASE_NAME}"
  end
end

project = Xcodeproj::Project.open(PROJECT_PATH)
runner_target = project.targets.find { |t| t.name == "Runner" }
raise "Runner target not found" unless runner_target

runner_group = project.main_group.find_subpath("Runner", false)
runner_sources = runner_target.source_build_phase

REMOVE_FROM_RUNNER.each do |filename|
  ref = runner_group.files.find { |f| f.path == filename || f.display_name == filename }
  next unless ref

  runner_sources.files.each do |build_file|
    next unless build_file.file_ref == ref

    runner_sources.files.delete(build_file)
    puts "Removed #{filename} from Runner sources"
  end
  ref.remove_from_project
  puts "Removed #{filename} file reference from Runner group"
end

extension_target = project.targets.find { |t| t.name == EXTENSION_NAME }
if extension_target
  puts "Target #{EXTENSION_NAME} already exists; converting to ExtensionKit if needed."
else
  extension_target = project.new_target(
    :app_extension,
    EXTENSION_NAME,
    :ios,
    DEPLOYMENT_TARGET,
  )

  group = project.main_group.find_subpath(EXTENSION_NAME, true)
  group.set_source_tree("SOURCE_ROOT")

  swift_refs = SWIFT_FILES.map do |name|
    group.new_reference("#{EXTENSION_NAME}/#{name}")
  end
  group.new_reference("#{EXTENSION_NAME}/Info.plist")
  group.new_reference("#{EXTENSION_NAME}/#{EXTENSION_NAME}.entitlements")

  extension_target.add_file_references(swift_refs)

  apply_extension_build_settings(extension_target)

  xcconfig_group = project.main_group["Flutter"] || project.main_group
  xcconfig_ref = xcconfig_group.files.find { |f| f.path == "Flutter/#{EXTENSION_NAME}.xcconfig" }
  xcconfig_ref ||= xcconfig_group.new_file("Flutter/#{EXTENSION_NAME}.xcconfig")
  extension_target.build_configurations.each do |config|
    config.base_configuration_reference = xcconfig_ref
  end

  runner_target.add_dependency(extension_target)

  puts "Created target #{EXTENSION_NAME}."
end

configure_as_extensionkit(extension_target)
remove_from_plugins_embed(runner_target, extension_target)
ensure_extensionkit_embed(runner_target, extension_target)

project.save
puts "Saved #{PROJECT_PATH}"
