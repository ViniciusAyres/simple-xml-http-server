require 'nokogiri'
require 'webrick'

class RequestHandler < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    xml = load_xml(request.body)
    xsd = load_xsd('myXSD.xsd')
    response.status = 200
  end

  def do_POST(request, response)
    xml = load_xml(request.body)
    xsd = load_xsd('myXSD.xsd')
    puts request
    response.status = 200
  end

  def xml_validation(xml)
    doc.errors.length == 0
  end

  def xsd_validation(xml, xsd)
    xsd.validate(xml).length == 0
  end

  def load_xml(xml)
    Nokogiri::XML(xml)
  end

  def load_xsd(path)
    Nokogiri::XML::Schema(open(path))
  end

  private :xml_validation, :xsd_validation, :load_xml, :load_xsd
end

server = WEBrick::HTTPServer.new(:Port => 5656)
server.mount "/", RequestHandler 
trap "INT" do server.shutdown end
server.start