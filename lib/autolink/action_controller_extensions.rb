module ActionController #:nodoc:
  class Base

    def autolink(obj)
      polymorphic_url(obj.class.default_lineage(obj)) 
    end 

    def url_for(options = {})
      puts options.inspect
      options ||= {}
      case options
      when ActiveRecord::Base                   # +
        $x = @url                               # +
        autolink(options)                       # +
      when String
        options
      when Hash
        @url = $x unless @url                   # +
        @url.rewrite(rewrite_options(options))
      else
        polymorphic_url(options)
      end
    end

  end 
end 
    
