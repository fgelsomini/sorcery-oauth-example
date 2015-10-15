class RenameOauthColumnsInAuthentications < ActiveRecord::Migration
  def change
    rename_column :authentications, :oauth_token, :access_token
    rename_column :authentications, :oauth_secret, :access_token_secret
  end
end
