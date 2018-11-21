# frozen_string_literal: true

Given "I have a fixture site" do
  Paths.setup_sandbox
end

Given "I have a {string} directory" do |dirname|
  Paths.mk_dir(dirname)
end

Given %r!I have an? "(.*?)" file with content:! do |file, text|
  Paths.create_file(file, text)
end

Given %r!I have an? "(.*?)" page with content:! do |file, text|
  content = <<~TEXT
    ---
    layout: none
    ---

    #{text}
  TEXT
  Paths.create_file(file, content.lstrip)
end

Given "I have a {string} locale content directory" do |dirname|
  Paths.mk_locale_dir(dirname)
end

Given "I have a {string} locale fixture" do |path|
  Paths.locale_fixture(path)
end

Given "I have the following {string} configuration:" do |key, table|
  Paths.configure(key, table.hashes)
end

When %r!I run jekyll (.*)! do |args|
  Runner.run(args)
end

Then "I should get a zero exit status" do
  expect(Runner.exit_status).to eql(0)
end

Then %r!the "(.*?)" (?:file|directory) should (not )?exist! do |name, negative|
  if negative.nil?
    expect(Paths.path(name)).to exist
  else
    expect(Paths.path(name)).to_not exist
  end
end

Then "I should see {string} in {string}" do |text, path|
  expect(Paths.content(path)).to include(text)
end
