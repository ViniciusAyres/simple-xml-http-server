require 'nokogiri'
require 'webrick'

class RequestHandler < WEBrick::HTTPServlet::AbstractServlet
    def do_GET(request, response)
        xml = load_xml(request.body)
        xsd = load_xsd('methodCall.xsd')

        
        if not xml_validation(xml)
            return_value = '-1'
        
        elsif not xsd_validation(xml, xsd)
            return_value = '-2'
        
        elsif xml.xpath('//methodCall/methodName').text != 'consultarStatus'
            return_value = '-1'

        else 
            cpf = xml.xpath('//methodCall/params/param/cpf').text
            return_value = get_status(cpf)
        end

        response.status = 200
        response.content_type = 'text/xml'
        response.body =
        '<?xml version="1.0"?>
        <methodReturn>
            <methodName>consultarStatus</methodName>
            <value>' + return_value + '</value>
        </methodReturn>'

    end

    def do_POST(request, response)
        xml = load_xml(request.body)
        xsd = load_xsd('methodCall.xsd')

        return_value = '3'
        
        if xml_validation(xml)
            if xsd_validation(xml, xsd)
                return_value = '0'
            else
                return_value = '1'
            end
        else
            return_value = '2'
        end

        response.status = 200
        response.content_type = 'text/xml'
        response.body =
        '<?xml version="1.0"?>
        <methodReturn>
            <methodName>consultarStatus</methodName>
            <value>' + return_value + '</value>
        </methodReturn>'

    end

    def xml_validation(xml)
        xml.errors.length == 0
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

    def get_status(cpf)
        if cpf == '00000000001'
            '1'
        elsif cpf == '00000000002'
            '2'
        elsif cpf == '00000000003'
            '3'
        elsif cpf == '00000000004'
            '4'
        else
            '0'
        end
    end  

    private :xml_validation, :xsd_validation, :load_xml, :load_xsd, :get_status
end

#server = WEBrick::HTTPServer.new(:Port => 5656)
#server.mount "/", RequestHandler 
#trap "INT" do server.shutdown end
#server.start