class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  validates :email, presence: true, if: :is_allowed_domain?

  def is_allowed_domain?
    unless %w(northwestern.edu gpeal.com kalail.com nuctecs.com coursecoda.com).include?(email[email.index('@')+1..-1] )
      errors.add(:email, "Currently only @northwestern accounts are currently allowed.")
    end
  end
end
