SimpleCov.start do
  track_files "lib/**/*.rb"
  add_filter %r!spec|version!
end

SimpleCov.at_exit do
  SimpleCov.result.format!
end
