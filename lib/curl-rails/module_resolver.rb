require 'active_support/core_ext/module/aliasing'
require 'sprockets/base'
require 'multi_json'

module Curl
	module ModuleResolver
		Sprockets::Base.class_eval do

			def resolve_with_js_modules(logical_path, options={}, &block)
				#puts (logical_path)
				result = resolve_without_js_modules(logical_path, options, &block)
				if !result && block_given?
					pathname = logical_path.is_a?(Pathname) ? logical_path : Pathname.new(logical_path.to_s)
					attrs = attributes_for(pathname)
					path_without_extensions = attrs.extensions.inject(pathname) { |p, ext| p.sub(ext, '') }
					if !path_without_extensions.to_s.index('/')
						paths = [path_without_extensions.join("component.json").to_s, 
										 path_without_extensions.join("package.json").to_s]
        		paths = paths + [options]
        		trail.find(*paths) do |path|
        			json_path = Pathname.new(path)
        			component = MultiJson.load(json_path.read)
	            case component['main']
	            when String
	            	fn = component['main']
	            	if (File.extname(fn) == "")
	            		fn += File.extname(logical_path)
	            	end
	            	yield json_path.dirname.join(fn)
	            when Array
	              extname = File.extname(logical_path)
	              component['main'].each do |fn|
	                if extname == "" || extname == File.extname(fn)
	                  yield json_path.dirname.join(fn)
	                end
	              end
	            end
        		end
        	end
        end
				return result
			end

			alias_method_chain :resolve, :js_modules

		end 
	end
end