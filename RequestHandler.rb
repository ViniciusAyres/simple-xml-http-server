require 'nokogiri'
require 'webrick'

class RequestHandler < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    puts request
    response.status = 200
  end
  
  def do_POST(request, response)
    puts request
    response.status = 200
  end

  def xml_validation(xml)
    doc = Nokogiri::XML(xml)
    doc.errors.length == 0
  end

  def xsd_validation(xml)
    doc = Nokogiri::XML(xml)
    xsd = Nokogiri::XML::Schema(open('myXSD.xsd'))
    xsd.validate(doc).length == 0
end

server = WEBrick::HTTPServer.new(:Port => 5656)
server.mount "/", RequestsHandler 
trap "INT" do server.shutdown end
server.start