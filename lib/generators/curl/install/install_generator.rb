require "generators/curl/helpers"

module Curl
	module Generators
		class InstallGenerator < Rails::Generators::Base
			include Curl::Generators::Helpers

			source_root File.expand_path("../templates", __FILE__)

      desc "Sets up curl.js as the AMD module loader for the application."

      def create_run_file
      	copy_file "run.js.erb", "#{javascript_path}/run.js.erb"
      end

      def create_main_file
      	copy_file "main.js", "#{javascript_path}/main.js"
      end
      	
      def inject_curl
      	manifest = File.join(javascript_path, "application.js")

        out = "//= require curl\n//= require run\n"

        in_root do
          create_file(manifest) unless File.exists?(manifest)
          if File.open(manifest).read().include?('//= require_tree')
            gsub_file(manifest, /\/\/= require_tree \.\s*/, "")
          end
          append_file(manifest, out)
        end
      end
    end
  end
end