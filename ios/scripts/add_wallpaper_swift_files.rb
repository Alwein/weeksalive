#!/usr/bin/env ruby
# Adds wallpaper-related Swift sources to the Runner target in Runner.xcodeproj.
# Idempotent: running twice will not create duplicate references.

require "xcodeproj"
require "securerandom"

PROJECT_PATH = File.expand_path("../Runner.xcodeproj", __dir__)
RUNNER_TARGET_NAME = "Runner"
SWIFT_FILES = %w[
  WallpaperPlugin.swift
  GetWallpaperIntent.swift
  WeeksAliveShortcuts.swift
].freeze

def uuid
  SecureRandom.hex(12).upcase
end

project = Xcodeproj::Project.open(PROJECT_PATH)
runner_target = project.targets.find { |t| t.name == RUNNER_TARGET_NAME }
raise "Runner target not found" unless runner_target

runner_group = project.main_group.find_subpath("Runner", false)
raise "Runner group not found" unless runner_group

sources_phase = runner_target.source_build_phase

SWIFT_FILES.each do |filename|
  existing_ref = runner_group.files.find { |f| f.path == filename || f.display_name == filename }
  if existing_ref
    puts "Already referenced: #{filename}"
    next
  end

  file_ref = runner_group.new_file(filename)
  build_file = sources_phase.add_file_reference(file_ref)
  puts "Added #{filename} (#{file_ref.uuid}, #{build_file.uuid})"
end

project.save
puts "Saved #{PROJECT_PATH}"
