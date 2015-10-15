class OauthsController < ApplicationController

  skip_before_filter :require_login

  # sends the user on a trip to the provider,
  # and after authorizing there back to the callback url.
  def oauth
    login_at(params[:provider])
  end

  def callback
    add_provider_to_user(params[:provider])
    auth = current_user.authentications.find_by_provider(params[:provider])
    if auth
      auth.oauth_token = @access_token.token
      auth.oauth_secret = @access_token.secret
      flash[:notice] = "Linked up with Twitter!"
    end
    redirect_to user_path(current_user)
    # if @user = login_from(provider)
    #   redirect_to root_path, :notice => "Logged in from #{provider.titleize}!"
    # else
    #   begin
    #     @user = create_from(provider)
    #     reset_session # protect from session fixation attack
    #     auto_login(@user)
    #     redirect_to root_path, :notice => "Logged in from #{provider.titleize}!"
    #   rescue
    #     redirect_to root_path, :alert => "Failed to login from #{provider.titleize}!"
    #   end
    # end
  end

  private

  def auth_params
    params.permit(:code, :provider)
  end

end
