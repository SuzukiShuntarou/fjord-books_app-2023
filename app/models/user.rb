# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true
  validates :profile, length: { maximum: 160 }
  validates :postal_code, allow_blank: true, format: { with: /\A\d{3}-\d{4}\z/ }
end
