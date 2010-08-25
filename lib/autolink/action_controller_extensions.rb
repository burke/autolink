module ActionController #:nodoc:
  class Base

    def autolink(obj)
      polymorphic_url(obj.default_lineage) 
    end 

    def url_for(options = {})
      options ||= {}
      case options
      when ActiveRecord::Base                   # +
        @@__url = @url                          # +
        autolink(options)                       # +
      when String
        options
      when Hash
        @url = @@__url unless @url              # +
        @url.rewrite(rewrite_options(options))
      else
        polymorphic_url(options)
      end
    end

  end 
end 
    
