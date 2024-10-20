# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :avatar do |attachable|
    attachable.variant :resize_avatar, resize_to_limit: [100, 100]
  end
  validates :avatar, content_type: { in: ['image/png', 'image/jpg', 'image/gif'], message: :content_type }
end
