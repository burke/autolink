# This is a really bad idea. There's a reason this isn't supported out of the box.
# ...but I don't want to refactor thousands of specs.
module Spec
  module Mocks
    class Mock
      def antimock(*methods)
        methods.each do |method|
          __mock_proxy.instance_eval <<-CODE
            def @target.#{method}
              syms = __mock_proxy.instance_variable_get("@stubs").map(&:sym)
              @__sub = #{self.class}.new
              syms.each do |sym|
                # Define this method to call the same method on @target.
                that = self
                (class << @__sub; self; end).send(:define_method, sym) do 
                  that.send(sym)
                end 
              end 
              @__sub.#{method}
            end
          CODE
        end 
        self
      end 
    end 
  end 
end 

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
    
    module Mocks
      
      def __post_mock_model(model_class, mock)
        mock.antimock(:default_lineage)
      end 
      
      alias __mock_model mock_model
      def mock_model(model_class, options_and_stubs = {})
        mock = __mock_model(model_class, options_and_stubs)
        __post_mock_model(model_class, mock)
      end 
    end 

  end
end 
