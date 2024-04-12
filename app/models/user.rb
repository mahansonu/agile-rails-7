class User < ApplicationRecord
  has_secure_password
  after_destroy :ensure_an_admin_remains

  class Error < StandardError
    
  end
  private
  def ensure_an_admin_remains
    if User.cout.zero?
      raise Error.new, 'can not delete last user'
    end
  end
end
