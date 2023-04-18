class User < ApplicationRecord 
    validates :email, :session_token, uniqueness: true, presence: true  
    validates :password_digest, presence: true 
    validates :password, length: {minimum: 6}, allow_nil: true 

    before_validation :ensure_session_token

    attr_reader :password 

    def password=(password)
        @password = password 
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        password_obj = BCrypt::Password.new(self.password_digest)
        password_obj.is_password?(password)
    end

    def self.find_by_credentials(email, password)
        user = User.find_by(email: email)
        if user && user.is_password?(password)
            user 
        else
            nil 
        end
    end

    def reset_session_token
        self.session_token = SecureRandom::urlsafe_base64
        self.save!
    end
    private 
    def generate_unique_session_token
        token = SecureRandom::urlsafe_base64
        while User.find_by(session_token: token)
            token = SecureRandom::urlsafe_base64
        end
    end

    def ensure_session_token
        self.session_token ||= SecureRandom::urlsafe_base64 
    end
end