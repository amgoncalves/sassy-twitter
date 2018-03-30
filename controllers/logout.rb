post '/logout' do
  session.clear
  cookies.clear
  flash[:notice] = 'You have been signed out.  Goodbye!'
  redirect '/'
end

