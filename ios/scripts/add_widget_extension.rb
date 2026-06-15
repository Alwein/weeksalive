#!/usr/bin/env ruby
# Adds the WeeksAliveWidget WidgetKit extension target to Runner.xcodeproj and
# enables the shared App Group on the Runner app target. Idempotent: running it
# twice will not create duplicate targets.

require "xcodeproj"

PROJECT_PATH = File.expand_path("../Runner.xcodeproj", __dir__)
WIDGET_NAME = "WeeksAliveWidget"
APP_GROUP = "group.com.weeksalive"
DEVELOPMENT_TEAM = "XA8VKF93HG"
DEPLOYMENT_TARGET = "16.6"

project = Xcodeproj::Project.open(PROJECT_PATH)

runner_target = project.targets.find { |t| t.name == "Runner" }
raise "Runner target not found" unless runner_target

# --- Runner: App Group entitlement + CODE_SIGN_ENTITLEMENTS ---
runner_target.build_configurations.each do |config|
  config.build_settings["CODE_SIGN_ENTITLEMENTS"] = "Runner/Runner.entitlements"
end

# --- Widget extension target ---
existing = project.targets.find { |t| t.name == WIDGET_NAME }
if existing
  puts "Target #{WIDGET_NAME} already exists; skipping creation."
else
  widget_target = project.new_target(
    :app_extension,
    WIDGET_NAME,
    :ios,
    DEPLOYMENT_TARGET,
  )

  # Group + file references for the extension sources.
  group = project.main_group.find_subpath(WIDGET_NAME, true)
  group.set_source_tree("SOURCE_ROOT")

  swift_ref = group.new_reference("#{WIDGET_NAME}/#{WIDGET_NAME}.swift")
  info_ref = group.new_reference("#{WIDGET_NAME}/Info.plist")
  group.new_reference("#{WIDGET_NAME}/#{WIDGET_NAME}.entitlements")

  widget_target.add_file_references([swift_ref])

  widget_target.build_configurations.each do |config|
    settings = config.build_settings
    settings["PRODUCT_BUNDLE_IDENTIFIER"] = "com.weeksalive.#{WIDGET_NAME}"
    settings["PRODUCT_NAME"] = "$(TARGET_NAME)"
    settings["INFOPLIST_FILE"] = "#{WIDGET_NAME}/Info.plist"
    settings["CODE_SIGN_ENTITLEMENTS"] = "#{WIDGET_NAME}/#{WIDGET_NAME}.entitlements"
    settings["CODE_SIGN_STYLE"] = "Automatic"
    settings["DEVELOPMENT_TEAM"] = DEVELOPMENT_TEAM
    settings["IPHONEOS_DEPLOYMENT_TARGET"] = DEPLOYMENT_TARGET
    settings["SWIFT_VERSION"] = "5.0"
    settings["TARGETED_DEVICE_FAMILY"] = "1,2"
    settings["SKIP_INSTALL"] = "YES"
    settings["GENERATE_INFOPLIST_FILE"] = "NO"
    settings["CURRENT_PROJECT_VERSION"] = "$(FLUTTER_BUILD_NUMBER)"
    settings["MARKETING_VERSION"] = "$(FLUTTER_BUILD_NAME)"
    settings["LD_RUNPATH_SEARCH_PATHS"] = [
      "$(inherited)",
      "@executable_path/Frameworks",
      "@executable_path/../../Frameworks",
    ]
    settings["ASSETCATALOG_COMPILER_GENERATE_ASSET_SYMBOLS"] = "NO"
  end

  # Embed the extension into the Runner app.
  embed_phase = runner_target.build_phases.find do |phase|
    phase.respond_to?(:symbol_dst_subfolder_spec) &&
      phase.symbol_dst_subfolder_spec == :plug_ins &&
      phase.display_name == "Embed Foundation Extensions"
  end

  unless embed_phase
    embed_phase = runner_target.new_copy_files_build_phase("Embed Foundation Extensions")
    embed_phase.symbol_dst_subfolder_spec = :plug_ins
  end

  build_file = embed_phase.add_file_reference(widget_target.product_reference)
  build_file.settings = { "ATTRIBUTES" => ["RemoveHeadersOnCopy"] }

  runner_target.add_dependency(widget_target)

  puts "Created target #{WIDGET_NAME} and embedded it into Runner."
end

project.save
puts "Saved #{PROJECT_PATH}"
