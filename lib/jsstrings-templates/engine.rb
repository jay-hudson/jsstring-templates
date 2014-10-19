require 'tilt'

module JsStringsTemplates
  class Engine < ::Rails::Engine
    config.jsstrings_templates = ActiveSupport::OrderedOptions.new
    config.jsstrings_templates.object_name   = 'templates'
    config.jsstrings_templates.ignore_prefix  = ['templates/']
    config.jsstrings_templates.markups        = []
    config.jsstrings_templates.htmlcompressor = false

    config.before_configuration do |app|
      # try loading common markups
      %w(erb haml liquid md radius slim str textile wiki).
      each do |ext|
        begin
          silence_warnings do
            config.jsstrings_templates.markups << ext if Tilt[ext]
          end
        rescue LoadError
          # They don't have the required library required. Oh well.
        end
      end
    end


    initializer 'jsstrings-templates' do |app|
      if app.config.assets
        require 'sprockets'
        require 'sprockets/engines' # load sprockets for Rails 3

        if app.config.jsstrings_templates.htmlcompressor
          require 'htmlcompressor/compressor'
          unless app.config.jsstrings_templates.htmlcompressor.is_a? Hash
            app.config.jsstrings_templates.htmlcompressor = {remove_intertag_spaces: true}
          end
        end

        # These engines render markup as HTML
        app.config.jsstrings_templates.markups.each do |ext|
          # Processed haml/slim templates have a mime-type of text/html.
          # If sprockets sees a `foo.html.haml` it will process the haml
          # and stop, because the haml output is html. Our html engine won't get run.
          mimeless_engine = Class.new(Tilt[ext]) do
            def self.default_mime_type
              nil
            end
          end

          app.assets.register_engine ".#{ext}", mimeless_engine
        end

        # This engine wraps the HTML into JS
        app.assets.register_engine '.html', JsStringsTemplates::Template
      end

      # Sprockets Cache Busting
      # If ART's version or settings change, expire and recompile all assets
      app.config.assets.version = [
        app.config.assets.version,
        'ART',
        Digest::MD5.hexdigest("#{VERSION}-#{app.config.jsstrings_templates}")
      ].join '-'
    end


    config.after_initialize do |app|
      # Ensure ignore_prefix can be passed as a String or Array
      if app.config.jsstrings_templates.ignore_prefix.is_a? String
        app.config.jsstrings_templates.ignore_prefix = Array(app.config.jsstrings_templates.ignore_prefix)
      end
    end
  end
end
