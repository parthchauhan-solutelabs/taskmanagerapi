class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  attr_accessor :invite_token

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :organization

  has_many :projects_users, dependent: :destroy
  has_many :projects, through: :projects_users, dependent: :destroy
  has_many :tasks, through: :projects_users

  validates :name, presence: true, on: :update
  validates :contact, presence: true, on: :update

  def generate_jwt
    JWT.encode({id: id, exp: 60.days.from_now.to_i}, Rails.application.secrets.secret_key_base)
  end
end
