module Spec
  module Rails
    module Matchers

      class RedirectTo 
        
        def expected_url
          case @expected
          when ActiveRecord::Base
            ActionController::Base.new.autolink(@expected)
          when Hash
            return ActionController::UrlRewriter.new(@request, {}).rewrite(@expected)
          when :back
            return @request.env['HTTP_REFERER']
          when %r{^\w+://.*}
            return @expected
          else
            return "http://#{@request.host}" + (@expected.split('')[0] == '/' ? '' : '/') + @expected
          end
        end

      end 
    end 
  end
end 
