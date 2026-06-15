#!/usr/bin/env ruby
# Ensures the WeeksAliveWidget extension can build for both device and
# simulator SDKs. Without this, a hardcoded SDKROOT=iphoneos makes simulator
# builds produce a malformed Runner.app (missing bundle). Idempotent.

require "xcodeproj"

PROJECT_PATH = File.expand_path("../Runner.xcodeproj", __dir__)

project = Xcodeproj::Project.open(PROJECT_PATH)
widget = project.targets.find { |t| t.name == "WeeksAliveWidget" }
raise "WeeksAliveWidget target not found" unless widget

widget.build_configurations.each do |config|
  config.build_settings["SDKROOT"] = "iphoneos"
  config.build_settings["SUPPORTED_PLATFORMS"] = "iphoneos iphonesimulator"
  config.build_settings["SUPPORTS_MACCATALYST"] = "NO"
  # Let Xcode pick architectures per active SDK instead of pinning them.
  config.build_settings.delete("VALID_ARCHS")
end

# Wire the extension to Flutter's generated build variables so its Info.plist
# can resolve FLUTTER_BUILD_NAME / FLUTTER_BUILD_NUMBER. Without a base
# configuration, CFBundleShortVersionString / CFBundleVersion ship empty and
# the install fails with "Invalid placeholder attributes".
xcconfig_group = project.main_group["Flutter"] || project.main_group
xcconfig_ref = xcconfig_group.files.find do |f|
  f.path == "Flutter/WeeksAliveWidget.xcconfig"
end
xcconfig_ref ||= xcconfig_group.new_file("Flutter/WeeksAliveWidget.xcconfig")
widget.build_configurations.each do |config|
  config.base_configuration_reference = xcconfig_ref
end

project.save
puts "Updated WeeksAliveWidget SUPPORTED_PLATFORMS for device + simulator."
