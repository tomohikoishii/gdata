class GdatasController < ApplicationController
  def index
  end

  def redirect
    client = Signet::OAuth2::Client.new(
      :authorization_uri => 'https://accounts.google.com/o/oauth2/auth',
      :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
      :client_id => Rails.application.secrets.client_id,
      :client_secret => Rails.application.secrets.client_secret,
      :scope => 'https://www.googleapis.com/auth/analytics.readonly https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/webmasters.readonly',
      :redirect_uri => url_for(:action => :callback)
    )
    
    redirect_to client.authorization_uri(:approval_prompt => 'force', :access_type => 'offline').to_s
    
  end
  
  def callback
    client = Signet::OAuth2::Client.new({
      :client_id  => Rails.application.secrets.client_id,
      :client_secret  => Rails.application.secrets.client_secret,
      :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
      :scope => 'https://www.googleapis.com/auth/analytics.readonly https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/webmasters.readonly',
      :redirect_uri => url_for(:action => :callback),
      :code => params[:code]
    })
    
    response = client.fetch_access_token!
    
    session[:access_token] = response['access_token']
    session[:refresh_token] = response['refresh_token']
    
    redirect_to url_for(:action => :analytics)
  end
  
  def analytics
  
    # @client = Signet::OAuth2::Client.new(access_token: session[:access_token],refresh_token: session[:refresh_token])
    
    api = Google::APIClient.new
    api.authorization.update_token!({"access_token"=> session[:access_token], "token_type"=>"Bearer", "expires_in"=>3600, "refresh_token"=>session[:refresh_token]})
    
    @service = api.discovered_api('analytics', 'v3')
    
    # service.oauth_token = client.access_token
    
    # @account_summaries = service.list_account_summaries
  end
  
  def searchconsole
  end

end
