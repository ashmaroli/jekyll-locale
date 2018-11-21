SimpleCov.start do
  track_files "lib/**/*.rb"
  add_filter %r!features/|spec/|version!
end

SimpleCov.at_exit do
  SimpleCov.result.format!
end
