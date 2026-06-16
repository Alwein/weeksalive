#!/usr/bin/env ruby
# Ensures the WeeksAliveWallpaperIntent extension can build for device and
# simulator, and wires Flutter build variables into its Info.plist. Idempotent.

require "xcodeproj"

PROJECT_PATH = File.expand_path("../Runner.xcodeproj", __dir__)
EXTENSION_NAME = "WeeksAliveWallpaperIntent"

project = Xcodeproj::Project.open(PROJECT_PATH)
extension = project.targets.find { |t| t.name == EXTENSION_NAME }
raise "#{EXTENSION_NAME} target not found" unless extension

extension.build_configurations.each do |config|
  config.build_settings["SDKROOT"] = "iphoneos"
  config.build_settings["SUPPORTED_PLATFORMS"] = "iphoneos iphonesimulator"
  config.build_settings["SUPPORTS_MACCATALYST"] = "NO"
  config.build_settings.delete("VALID_ARCHS")
end

xcconfig_group = project.main_group["Flutter"] || project.main_group
xcconfig_ref = xcconfig_group.files.find do |f|
  f.path == "Flutter/#{EXTENSION_NAME}.xcconfig"
end
xcconfig_ref ||= xcconfig_group.new_file("Flutter/#{EXTENSION_NAME}.xcconfig")

extension.build_configurations.each do |config|
  config.base_configuration_reference = xcconfig_ref
end

project.save
puts "Updated #{EXTENSION_NAME}: SUPPORTED_PLATFORMS + Flutter xcconfig."
