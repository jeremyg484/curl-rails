require 'test_helper'
require 'generators/curl/helpers'
require 'generators/curl/install/install_generator'

class InstallGeneratorTest < Rails::Generators::TestCase

	tests Curl::Generators::InstallGenerator

  # Include custom helpers
  include Curl::Generators::Helpers

	# Generator output directory ('Rails.root')
  destination File.expand_path("../../tmp", __FILE__)

  # Erase destination directory
  def setup 
    :prepare_destination
    @app = Dummy::Application

    path = File.join destination_root, javascript_path
    if !@app.assets.paths.include?(path)
      @app.assets.append_path(path)
    end
  end

  test "run.js.erb file is created" do
  	run_generator
    assert_file "#{javascript_path}/run.js.erb" do |content|
    	assert_match(/baseUrl: '\/assets'/, content)
      assert_match(/curl\(config, \['main'\]\);\n/, content)
    end
  end

  test "run.js asset contains config for foo derived from package.json" do
    run_generator
    assert_not_nil @app.assets["run.js"]
    content = @app.assets["run.js"].to_s
    assert_match(/\{name: 'foo', location: 'foo', main: 'foo'\}/, content)
  end

  test "run.js asset contains config for bar derived from package.json" do
    run_generator
    assert_not_nil @app.assets["run.js"]
    content = @app.assets["run.js"].to_s
    assert_match(/\{name: 'bar', location: 'bar', main: 'main'\}/, content)
  end

  test "run.js asset contains config for zoo derived from component.json" do
    run_generator
    assert_not_nil @app.assets["run.js"]
    content = @app.assets["run.js"].to_s
    assert_match(/\{name: 'zoo', location: 'zoo', main: 'zoo'\}/, content)
  end

  test "run.js asset contains config for baz derived from component.json" do
    run_generator
    assert_not_nil @app.assets["run.js"]
    content = @app.assets["run.js"].to_s
    assert_match(/\{name: 'baz', location: 'baz', main: 'main'\}/, content)
  end

  test "run.js asset contains config for zip derived from component.json array" do
    run_generator
    assert_not_nil @app.assets["run.js"]
    content = @app.assets["run.js"].to_s
    assert_match(/\{name: 'zip', location: 'zip', main: 'zip'\}/, content)
  end

  test "run.js asset contains config for fiz derived from component.json when package.json also exists" do
    run_generator
    assert_not_nil @app.assets["run.js"]
    content = @app.assets["run.js"].to_s
    assert_match(/\{name: 'fiz', location: 'fiz', main: 'fiz'\}/, content)
  end

  test "run.js asset contains config for fiz derived from package.json when component.json has no main" do
    run_generator
    assert_not_nil @app.assets["run.js"]
    content = @app.assets["run.js"].to_s
    assert_match(/\{name: 'nib', location: 'nib', main: 'nib'\}/, content)
  end

  test "main.js file is created" do
  	run_generator
  	assert_file "#{javascript_path}/main.js" do |content|
      assert_match(/define\(/, content)
    end
  end
  	
  test "required paths added to the default manifest" do
  	copy_manifest
    run_generator
    assert_file "#{javascript_path}/application.js" do |content|
      assert_manifest_content(content)
    end
  end

  test "required paths added to an empty manifest" do
    create_empty_manifest
    run_generator
    assert_file "#{javascript_path}/application.js" do |content|
      assert_manifest_content(content)
    end
  end

  private

  def assert_manifest_content(content)
    assert_match(/require curl\n/, content)
    assert_match(/require run\n/, content)
    assert_no_match(/require_tree \.\n/, content)
  end

  def copy_manifest
    manifest = File.expand_path("../../dummy/app/assets/javascripts/application.js", __FILE__)
    destination = File.join destination_root, javascript_path
    FileUtils.mkdir_p destination
    FileUtils.cp manifest, destination
  end

  def create_empty_manifest
    destination = File.join destination_root, javascript_path
    manifest = File.join destination, 'application.js'
    FileUtils.mkdir_p destination
    FileUtils.touch manifest
  end

end