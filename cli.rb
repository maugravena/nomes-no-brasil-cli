require 'rest-client'
require 'json'
require 'uri'

def all_states
  begin
    JSON.parse(RestClient.get 'https://servicodados.ibge.gov.br/api/v1/localidades/estados')
  rescue RestClient::ExceptionWithResponse => e
    puts e.response
  end
end

def all_cities
  begin
    JSON.parse(RestClient.get 'https://servicodados.ibge.gov.br/api/v1/localidades/municipios')
  rescue RestClient::ExceptionWithResponse => e
    puts e.response
  end
end

def ranking_by_state(id)
  state_id = all_states.select { |state| state['id'] == id }
  begin
    JSON.parse(RestClient.get "https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=#{id}")
  rescue RestClient::ExceptionWithResponse => e
    puts e.response
  end
end

def ranking_by_state_male(id)
  state_id = all_states.select { |state| state['id'] == id }
  begin
    JSON.parse(RestClient.get "https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=#{id}&sexo=m")
  rescue RestClient::ExceptionWithResponse => e
    puts e.response
  end
end

def ranking_by_state_female(id)
  state_id = all_states.select { |state| state['id'] == id }
  begin
    JSON.parse(RestClient.get "https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=#{id}&sexo=f")
  rescue RestClient::ExceptionWithResponse => e
    puts e.response
  end
end


def ranking_by_city(id)
  city_id = all_cities.select { |city|  city['id'] == id }
  begin
    JSON.parse(RestClient.get "https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=#{id}")
  rescue RestClient::ExceptionWithResponse => e
    puts e.response
  end
end

def ranking_by_city_male(id)
  city_id = all_cities.select { |city| city['id'] == id }
  begin
    JSON.parse(RestClient.get "https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=#{id}&sexo=m")
  rescue RestClient::ExceptionWithResponse => e
    puts e.response
  end
end

def ranking_by_city_female(id)
  city_id = all_cities.select { |city| city['id'] == id }
  begin
    JSON.parse(RestClient.get "https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=#{id}&sexo=f")
  rescue RestClient::ExceptionWithResponse => e
    puts e.response
  end
end

def name_frequency(name1, name2='')
  uri = URI.encode_www_form_component("#{name1}|#{name2}")
  url = "https://servicodados.ibge.gov.br/api/v2/censos/nomes/#{uri}"
  begin
    JSON.parse(RestClient.get url)
  rescue RestClient::ExceptionWithResponse => e
    puts e.response
  end
end
