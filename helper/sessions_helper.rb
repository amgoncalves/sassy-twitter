require 'sinatra/base'

module Sinatra
  module SessionsHelper
    
    def log_in(user)
      session[:user] = user
    end
  end

  helpers SessionsHelper
end
