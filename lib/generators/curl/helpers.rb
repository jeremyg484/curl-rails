require 'multi_json'

module Curl
  module Generators
    module Helpers

      def package_defs
        env = self.environment
        packages = {}
        env.paths.select {|path| path =~ /javascripts$/}.each do |js_path|
          env.each_entry js_path do |entry|
            if entry.to_s =~ /component.json$|package.json$/ && entry.parent.parent.basename.to_s == "javascripts"
              pkg = entry.dirname.basename.to_s
              if !pkg.eql?("curl") && !packages.has_key?(pkg)
                package_def = MultiJson.load(entry.read)
                case package_def['main']
                when String
                  fn = package_def['main']
                  if (File.extname(fn) != "")
                    fn[".js"] = ""
                  end
                  main = entry.dirname.join(fn)
                  packages[pkg] = {:name => main.parent.basename.to_s,
                                   :location => main.parent.basename.to_s,
                                   :main => main.basename.to_s}
                when Array
                  extname = ".js"
                  package_def['main'].each do |fn|
                    if extname == File.extname(fn)
                      fn[".js"] = ""
                      main = entry.dirname.join(fn)
                      packages[pkg] = {:name => main.parent.basename.to_s,
                                       :location => main.parent.basename.to_s,
                                       :main => main.basename.to_s}
                    end
                  end
                end
              end
            end
          end
        end
        return packages
      end

      def package_def
        return "{name: 'foo', location: 'foo', main: 'foo'}"
      end

      def asset_path
        File.join('app', 'assets')
      end

      def javascript_path
        File.join(asset_path, 'javascripts')
      end

      def app_filename
        rails_app_name.underscore
      end

      def rails_app_name
        Rails.application.class.name.split('::').first
      end

    end
  end
end