require 'test_helper'

# Test the Asset the Gem Provides

describe "jsstrings-templates.js integration" do
  let(:config) { Dummy::Application.config.jsstrings_templates }

  it "serves jsstrings-templates.js on the pipeline" do
    visit '/assets/jsstrings-templates.js'
    page.source.must_include %Q{"#{config.object_name}".}
  end

  it "includes a comment with the gem name and version" do
    visit '/assets/jsstrings-templates.js'
    page.source.must_include %Q{// JS Strings Templates #{JsStringsTemplates::VERSION}}
  end

  it "includes a comment describing the ignore_prefix" do
    visit '/assets/jsstrings-templates.js'
    page.source.must_include %Q{// jsstrings_templates.ignore_prefix: #{config.ignore_prefix}}
  end

  it "includes a comment describing the availible markups" do
    visit '/assets/jsstrings-templates.js'
    page.source.must_include %Q{// jsstrings_templates.markups: #{config.markups}}
  end
end
