require 'test_helper'

class CurlRailsTest < ActiveSupport::TestCase
  
  def setup
    @app = Dummy::Application
  end

  test "truth" do
    assert_kind_of Module, CurlRails
  end

  test "curl.js is found as an asset" do
  	assert_not_nil @app.assets["curl"]
  end

  # test "foo's package.json specified foo.js main file is found as an asset" do
  # 	assert_not_nil @app.assets["foo"]
  # end

  # test "bar's package.json specified main.js main file is found as an asset" do
  # 	assert_not_nil @app.assets["bar"]
  # end

  # test "zoo's component.json specified zoo.js main file is found as an asset" do
  # 	assert_not_nil @app.assets["zoo"]
  # end

  # test "baz's component.json specified main.js main file is found as an asset" do
  # 	assert_not_nil @app.assets["baz"]
  # end

  # test "zip's component.json specified zoo.js main file from array def is found as an asset" do
  # 	assert_not_nil @app.assets["zip.js"]
  # end

  # test "fiz's component.json and package.json specified fiz.js main file is found as an asset" do
  # 	assert_not_nil @app.assets["fiz"]
  # end

  test "js files in nested curl paths can be found as assets" do
  	assert_not_nil @app.assets["curl/domReady"]
  end

end
