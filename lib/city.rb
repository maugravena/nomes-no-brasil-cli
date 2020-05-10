class City < ActiveRecord::Base
  def self.all_cities
    begin
      data_city = JSON.parse(RestClient.get 'https://servicodados.ibge.gov.br/api/v1/localidades/municipios')
    rescue RestClient::ExceptionWithResponse => e
      puts e.response
    end

    data_city.each do |city|
      self.create(id: city['id'], name: city['nome'])
    end
  end
end
