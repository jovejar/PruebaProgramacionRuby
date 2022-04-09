require 'uri'
require 'net/http'
require 'json'

#Metodo Cosumo de api
def request url_requested, api_key
    #capturad de url
    url = URI(url_requested+"sol=1000&camera=fhaz&api_key=#{api_key}")    
    #Seguridad de conexion
    https = Net::HTTP.new(url.host, url.port);    
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_PEER
    #Configuracion de tipo de request
    request = Net::HTTP::Get.new(url)        
    #Captura de respuesta
    response = https.request(request)
    #Vista de respuesta
    return JSON.parse(response.read_body)
end
#Metodo Construccion de Html y exportar Index
def buid_web_page list_hash
    #Captura de hash
    response = list_hash
    #construccion de html
    result = "\r<html>\n\r\t<head>\n\r\t</head>\n\r\t<body>\n\r\t\t<ul>"
    #Iteracion de hashes y busqueda de fotos
    response['photos'].count.times do |i|        
        result += "\n\r\t\t\t<li><img src='#{response['photos'][i]['img_src']}'></li>"        
    end
    #construccion de html
    result += "\n\r\t\t</ul>\n\r\t</body>\n\r</html>"
    #Exportar html a un archivo
    File.write("index.html",result)
end
#Metodo bonus
def photos_count list_hash
    response = list_hash
    result = {}
    result[:nombre_de_camara] = response['photos'][0]['camera']['full_name']
    result[:cantidad_de_fotos] = response['photos'].count
    result    
end
#key de prueba
#api_key = "DEMO_KEY"
#key personal en caso que se hagan mas de 50 consultas a la api en 24 horas
api_key = "xfZ3vtvveUj0tkuBBz5rQu312e1FaPw5XRRdPrBd"
buid_web_page(request("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?",api_key))
print photos_count(request("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?",api_key))

