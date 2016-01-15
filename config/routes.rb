Rails.application.routes.draw do
  root 'gdatas#redirect'
  match 'oauth2callback' => 'gdatas#callback', :via => :get
  match 'analytics' => 'gdatas#analytics', :via => :get
  match 'searchconsole' => 'gdatas#searchconsole', :via => :get

end
