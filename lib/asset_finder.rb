module AssetFinder
  class << self
    
    def all_js
      dirs = [Rails.root.join("app", "assets", "javascripts"),
              Rails.root.join("lib", "assets", "javascripts"),
              Rails.root.join("vendor", "assets", "javascripts")]
      dirs.inject([]) {|js, dir| js += Dir.exists?(dir) ? js_files(dir) : [] }
    end
    
    def all_css
      dirs = [Rails.root.join("app", "assets", "stylesheets"),
              Rails.root.join("lib", "assets", "stylesheets"),
              Rails.root.join("vendor", "assets", "stylesheets")]
      dirs.inject([]) {|css, dir| css += Dir.exists?(dir) ? css_files(dir) : [] }
    end
    
    
    def js_files(dir, excludes = [])
      js = []
      Dir.chdir(dir) do
        js += Dir.glob(File.join("**", "*.js*")) - ['application.js'] - excludes
        js.collect! do |f|
          split_f = f.split('.')
          name = ""
          begin
            name += split_f.shift + "."
          end while split_f[0] != "js"
          "#{name}js"
        end
      end
      
      js
    end
    
    def css_files(dir, excludes = [])
      css = []
      Dir.chdir(dir) do
        css += Dir.glob(File.join("**", "*.css*")) - ['application.css'] - excludes
        css.collect! do |f| 
          split_f = f.split('.')
          name = ""
          begin
            name += split_f.shift + "."
          end while split_f[0] != "css"
          "#{name}css"
        end
      end
      
      css
    end
  end
end
