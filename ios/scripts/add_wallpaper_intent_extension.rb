#!/usr/bin/env ruby
# Adds the WeeksAliveWallpaperIntent App Intents extension and removes the
# intent sources from the Runner target (they must not run inside Flutter).
# Idempotent.

require "xcodeproj"

PROJECT_PATH = File.expand_path("../Runner.xcodeproj", __dir__)
EXTENSION_NAME = "WeeksAliveWallpaperIntent"
APP_GROUP = "group.com.weeksalive"
DEVELOPMENT_TEAM = "XA8VKF93HG"
DEPLOYMENT_TARGET = "16.6"

SWIFT_FILES = %w[
  WeeksAliveWallpaperIntent.swift
  GetWallpaperIntent.swift
  WeeksAliveShortcuts.swift
].freeze

REMOVE_FROM_RUNNER = %w[
  GetWallpaperIntent.swift
  WeeksAliveShortcuts.swift
].freeze

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

existing = project.targets.find { |t| t.name == EXTENSION_NAME }
if existing
  puts "Target #{EXTENSION_NAME} already exists; skipping creation."
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

  xcconfig_group = project.main_group["Flutter"] || project.main_group
  xcconfig_ref = xcconfig_group.files.find { |f| f.path == "Flutter/#{EXTENSION_NAME}.xcconfig" }
  xcconfig_ref ||= xcconfig_group.new_file("Flutter/#{EXTENSION_NAME}.xcconfig")
  extension_target.build_configurations.each do |config|
    config.base_configuration_reference = xcconfig_ref
  end

  embed_phase = runner_target.build_phases.find do |phase|
    phase.respond_to?(:symbol_dst_subfolder_spec) &&
      phase.symbol_dst_subfolder_spec == :plug_ins &&
      phase.display_name == "Embed Foundation Extensions"
  end

  unless embed_phase
    embed_phase = runner_target.new_copy_files_build_phase("Embed Foundation Extensions")
    embed_phase.symbol_dst_subfolder_spec = :plug_ins
  end

  build_file = embed_phase.add_file_reference(extension_target.product_reference)
  build_file.settings = { "ATTRIBUTES" => ["RemoveHeadersOnCopy"] }

  runner_target.add_dependency(extension_target)

  puts "Created target #{EXTENSION_NAME} and embedded it into Runner."
end

project.save
puts "Saved #{PROJECT_PATH}"
