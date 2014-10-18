require 'jsstring-templates/compact_javascript_escape'

module JsStringTemplates
  class Template < ::Tilt::Template
    include CompactJavaScriptEscape
    JsStringTemplateWrapper = Tilt::ERBTemplate.new "#{File.dirname __FILE__}/javascript_templates.js.erb"
    @@compressor = nil

    def self.default_mime_type
      'application/javascript'
    end

    # this method is mandatory on Tilt::Template subclasses
    def prepare
      if configuration.htmlcompressor
        @data = compress data
      end
    end

    def evaluate(scope, locals, &block)
      locals[:html] = escape_javascript data.chomp
      locals[:jsstring_template_name] = logical_template_path(scope)
      locals[:source_file] = "#{scope.pathname}".sub(/^#{Rails.root}\//,'')
      locals[:jsstring_object] = configuration.object_name

      JsStringTemplateWrapper.render(scope, locals)
    end

    private

    def logical_template_path(scope)
      path = scope.logical_path.sub /^(#{configuration.ignore_prefix.join('|')})/, ''
      "#{path}"
    end

    def configuration
      ::Rails.configuration.jsstring_templates
    end

    def compress html
      unless @@compressor
        @@compressor = HtmlCompressor::Compressor.new configuration.htmlcompressor
      end
      @@compressor.compress(html)
    end
  end
end

