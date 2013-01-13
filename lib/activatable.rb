module Activatable

  def self.included(base)
    base.validates :active,
      inclusion: { in: [true, false] }
    
    base.after_initialize do
      if self.new_record?
        deactivate!
      end
    end
  end

  def activate!
    self.active = true
  end

  def deactivate!
    self.active = false
  end
end