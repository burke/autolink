module ActionView
  module Helpers
    module UrlHelper
      def url_for(options = {})
        options ||= {}
        url = case options
        when ActiveRecord::Base                                            # This method is the same as 2.3.8, 
          polymorphic_path(options.class.default_lineage(options))         # Except for the addition of these two lines.
        when String
          escape = true
          options
        when Hash
          options = { :only_path => options[:host].nil? }.update(options.symbolize_keys)
          escape  = options.key?(:escape) ? options.delete(:escape) : true
          @controller.send(:url_for, options)
        when :back
          escape = false
          @controller.request.env["HTTP_REFERER"] || 'javascript:history.back()'
        else
          escape = false
          polymorphic_path(options)
        end

        escape ? escape_once(url).html_safe : url
      end
    end 
  end 
end 
