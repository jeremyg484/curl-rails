require 'rails'
require 'generators/curl/helpers'
#require 'curl-rails/module_resolver'

module CurlRails
  class Engine < Rails::Engine
  	initializer "curl_rails.define_curl_paths", :after => :append_asset_paths  do |app|

  		app.assets.context_class.class_eval do
			include Curl::Generators::Helpers
		end

		app.assets.append_path "#{root}/vendor/assets/javascripts/curl/src"
  	end
  end
end
