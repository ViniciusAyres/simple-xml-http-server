require_relative 'RequestHandler'

class Server 
    def initialize(port)
        server = WEBrick::HTTPServer.new(:Port => port)
        server.mount "/", RequestHandler
        trap "INT" do server.shutdown end
        server.start
    end
end


