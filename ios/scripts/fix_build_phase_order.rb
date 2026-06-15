#!/usr/bin/env ruby
# Moves the "Embed Foundation Extensions" copy-files phase above the Flutter
# "Thin Binary" run-script phase on the Runner target. This breaks the
# "Cycle inside Runner" build error that occurs when an app extension is
# embedded after the Thin Binary phase. Idempotent.

require "xcodeproj"

PROJECT_PATH = File.expand_path("../Runner.xcodeproj", __dir__)

project = Xcodeproj::Project.open(PROJECT_PATH)
runner = project.targets.find { |t| t.name == "Runner" }
raise "Runner target not found" unless runner

phases = runner.build_phases

embed_index = phases.index do |p|
  p.display_name == "Embed Foundation Extensions"
end
thin_index = phases.index do |p|
  p.respond_to?(:name) && p.name == "Thin Binary"
end

raise "Embed Foundation Extensions phase not found" unless embed_index
raise "Thin Binary phase not found" unless thin_index

if embed_index > thin_index
  embed_phase = phases.delete_at(embed_index)
  # Recompute Thin Binary index after deletion, then insert just before it.
  thin_index = phases.index { |p| p.respond_to?(:name) && p.name == "Thin Binary" }
  phases.insert(thin_index, embed_phase)
  project.save
  puts "Moved 'Embed Foundation Extensions' above 'Thin Binary'."
else
  puts "'Embed Foundation Extensions' already precedes 'Thin Binary'; nothing to do."
end
