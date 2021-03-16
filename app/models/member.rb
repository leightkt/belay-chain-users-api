class Member < ApplicationRecord
    has_secure_password
    belongs_to :gym

    # validates :first_name, :last_name, :email, :password, presence: true
    # validates :email, uniqueness: { message: "should be unique and %{value} is taken."}
    # validates :password, length: { in: 6..20 }
    # validates :password, format: {with: /[\d]/, message: "password must include at least 1 number"}
    # validates :password, format: {with: /[A-Z]/, message: "password must include at least 1 uppdercase letter"}
    # validates :email, format: {with: /[@]/, message: "must be a valid email"}
end
