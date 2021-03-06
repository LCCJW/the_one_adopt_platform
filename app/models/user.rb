class User < ApplicationRecord
  after_commit :update_animal_area_pkid, if: :is_sender?

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  devise :omniauthable, omniauth_providers: %i[google_oauth2 facebook]
  has_many :animals
  has_many :favorites
  has_many :reservations
  has_many :sent_messages, :class_name => "Message", :foreign_key => "from_id"
  has_many :received_messages, :class_name => "Message", :foreign_key => "to_id"
  has_many :sender_reservations, :class_name => "Reservation", :foreign_key => "sender_id"
  has_many :receiver_reservations, :class_name => "Reservation", :foreign_key => "receiver_id"

  has_many :authored_conversations, class_name: "Conversation", foreign_key: "author_id"
  has_many :received_conversations, class_name: "Conversation", foreign_key: "received_id"
  has_many :personal_messages, dependent: :destroy
  has_many :notifications, foreign_key: :recipient_id
  has_one :lucky_animal
  has_rich_text :readme
  has_many :notifications, foreign_key: "recipient_id"
  # @user.sent_messages
  # @user.received_messages
  validates :name, presence: true
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      user.my_skip_confirmation!
      user.skip_confirmation!
    end
  end

  def my_skip_confirmation!
    self.confirmed_at = Time.now
  end

  store_accessor :available_time, :days, :w0, :w1, :w2, :w3, :w4, :w5, :w6

  private

  def update_animal_area_pkid
    if self.animals.present?
      self.animals.update_all(animal_area_pkid: self.sender_add.slice(0..2))
      if self.latitude.present? && self.longitude.present?
        self.animals.update_all(latitude: self.latitude, longitude: self.longitude)
      end
    end
  end
end
