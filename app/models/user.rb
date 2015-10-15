class User < ActiveRecord::Base

  require 'google/api_client'

  authenticates_with_sorcery!

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes["password"] }
  validates :password, confirmation: true, if: -> { new_record? || changes["password"] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes["password"] }

  validates :email, uniqueness: true

  has_many :authentications, dependent: :destroy

  def twitter_authentication
    authentications.find_by_provider("twitter")
  end

  def google_authentication
    authentications.find_by_provider("google")
  end  

  def twitter_client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.secrets.twitter_consumer_key
      config.consumer_secret     = Rails.application.secrets.twitter_consumer_secret
      config.access_token        = twitter_authentication.access_token
      config.access_token_secret = twitter_authentication.access_token_secret
    end   
  end

  def twitter_followers
    twitter_client.followers
  end

  def google_client
    google_api_client = Google::APIClient.new({
      application_name: 'fgelsomini'
    })
    google_api_client.authorization = Signet::OAuth2::Client.new({
      client_id: Rails.application.secrets.google_consumer_key,
      client_secret: Rails.application.secrets.google_consumer_secret,
      access_token: google_authentication.access_token
    })
    return google_api_client    
  end

  def gmail_threads
    client = google_client
    gmail_api = client.discovered_api('gmail', 'v1')
    results = client.execute!(
      :api_method => gmail_api.users.threads.list,
      :parameters => { :userId => 'me' }) 
    threads = results.data.threads
  end

end
