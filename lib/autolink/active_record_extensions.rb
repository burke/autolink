class ActiveRecord::Base
  def default_lineage
    if self.class.respond_to?(:default_lineage)
      self.class.default_lineage(self)
    else
      raise "default_lineage() has not been implemented for this class"
    end
  end
end 
