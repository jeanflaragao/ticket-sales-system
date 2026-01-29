# Comprehensive fix for GlobalID and Rails compatibility issues with Ruby 3.2.2

# Fix 1: Initialize CGI class variables
begin
  require 'cgi'

  # Initialize CGI class variables if not already set
  unless CGI.class_variable_defined?(:@@accept_charset)
    CGI.class_variable_set(:@@accept_charset, 'UTF-8')
  end

  # Also set other CGI class variables that might be needed
  CGI.class_variable_set(:@@escape_table, {}) unless CGI.class_variable_defined?(:@@escape_table)

  unless CGI.class_variable_defined?(:@@unescape_table)
    CGI.class_variable_set(:@@unescape_table, {})
  end
rescue NameError, StandardError => e
  # If this fails, log the error
  puts "Warning: GlobalID CGI fix failed: #{e.message}"
end

# Fix 2: Monkey patch to prevent frozen array modification in Rails engines
module Rails
  class Engine
    class Configuration
      def paths
        @paths ||= begin
          paths = Rails::Paths::Root.new(@root)
          paths.add 'app',                 eager_load: true,
                                           glob: '{*,*/concerns}',
                                           exclude: %w[assets javascripts stylesheets]
          paths.add 'app/assets',          glob: '*'
          paths.add 'app/controllers',     eager_load: true
          paths.add 'app/channels',        eager_load: true, glob: '**/*_channel.rb'
          paths.add 'app/helpers',         eager_load: true
          paths.add 'app/models',          eager_load: true
          paths.add 'app/mailers',         eager_load: true
          paths.add 'lib',                 load_path: true
          paths.add 'lib/assets',          glob: '*'
          paths.add 'config'
          paths.add 'config/environments', glob: Rails.env + '.rb'
          paths.add 'config/initializers', glob: '**/*.rb'
          paths.add 'config/locales',      glob: '*.{rb,yml}'
          paths.add 'config/routes.rb'
          paths.add 'db'
          paths.add 'db/migrate'
          paths.add 'db/seeds.rb'
          paths.add 'vendor',              load_path: true
          paths.add 'vendor/assets',       glob: '*'

          paths
        end
      end
    end
  end
end
