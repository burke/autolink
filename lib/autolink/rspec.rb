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

        mock.__send__(:__mock_proxy).instance_eval <<-CODE
          def @target.default_lineage
            # self == @target
            syms = __mock_proxy.instance_variable_get("@stubs").map(&:sym)
            @__sub = #{model_class}.new
            syms.each do |sym|
              # Define this method to call the same method on @target.
              that = self
              (class << @__sub; self; end).send(:define_method, sym) do 
                that.send(sym)
              end 
            end 
            @__sub.default_lineage
          end
        CODE

        mock
      end 
      
      alias __mock_model mock_model
      def mock_model(model_class, options_and_stubs = {})
        mock = __mock_model(model_class, options_and_stubs)
        __post_mock_model(model_class, mock)
      end 
    end 

  end
end 
