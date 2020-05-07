require 'rest-client'
require 'json'

def all_states
  begin
    JSON.parse(RestClient.get 'https://servicodados.ibge.gov.br/api/v1/localidades/estados')
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
