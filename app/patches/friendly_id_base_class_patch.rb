module FriendlyIdBaseClassPatch
  # ugly hack for friendly_id to work with citier subclasses:
  #
  # return this class for friendly_id slug uniqueness check in 
  # .../friendly_id/slug_generator.rb method conflicts
  # return the superclass for everyone else
  #
  # this must only be used in citier subclasses one level below
  # a non-abstract citier root class
  #
  # see http://apidock.com/rails/ActiveRecord/Inheritance/ClassMethods/base_class
  def base_class
    if caller[0][/`([^']*)'/, 1] == 'conflicts'
      self
    else
      self.superclass
    end
  end
end