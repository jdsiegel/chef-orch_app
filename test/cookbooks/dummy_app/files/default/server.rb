require 'webrick'

server = WEBrick::HTTPServer.new :Port => 8000, :DocumentRoot => '~/app/current/public'

trap 'INT' do 
  server.shutdown 
end

trap 'TERM' do 
  server.shutdown 
end

server.mount_proc '/' do |req, res|
  res.body = "dummy app is running\n"
end

server.start
