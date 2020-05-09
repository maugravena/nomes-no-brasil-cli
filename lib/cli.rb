require 'rest-client'
require 'json'
require 'uri'
require 'terminal-table'

def hash_to_array_values(arr)
  res_arr = []
  arr.each do |i|
    res_arr << i.values
  end
  res_arr
end

def rows(data)
  result = data[0]['res']
  hash_to_array_values(result)
end

def remove_strings(arr)
  new_arr = []
  arr.each do |i|
    new_arr << i.delete_if { |obj| (obj.is_a? String) }
  end
  new_arr.flatten
end

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

def name_frequency(name)
  # uri = URI.encode_www_form_component("#{name1}|#{name2}")
  # url = "https://servicodados.ibge.gov.br/api/v2/censos/nomes/#{uri}"
  begin
    JSON.parse(RestClient.get "https://servicodados.ibge.gov.br/api/v2/censos/nomes/#{name}")
  rescue RestClient::ExceptionWithResponse => e
    puts e.response
  end
end

def table(title, rows)
  Terminal::Table.new :title => title, :headings => ['Nome', 'Frequencia', 'Ranking'], :rows => rows
end

def state_tables(id)
  puts general_table = table('Geral', rows(ranking_by_state(id)))
  puts female_table = table('Sexo feminino', rows(ranking_by_state_female(id)))
  puts male_table = table('Sexo masculino', rows(ranking_by_state_male(id)))
end

def city_tables(id)
  puts general_table = table('Geral', rows(ranking_by_city(id)))
  puts female_table = table('Sexo feminino', rows(ranking_by_city_female(id)))
  puts male_table = table('Sexo masculino', rows(ranking_by_city_male(id)))
end

def frequency_table(names)
  period = ['1930', '1930-1940', '1940-1950', '1950-1960', '1960-1970', '1970-1980', '1980-1990', '1990-2000', '2000-2010']
  title = 'Frequencia ao longo dos anos'
  rows_name1 = remove_strings rows(name_frequency(names[0]))
  if names.length > 1
    rows_name2 = remove_strings rows(name_frequency(names[1]))
    rows_names = period.zip(rows_name1, rows_name2)
    return Terminal::Table.new :title => title, :headings => ['Periodo', names[0], names[1]], :rows => rows_names
  end
  rows = period.zip(rows_name1)
  return Terminal::Table.new :title => title, :headings => ['Periodo', names[0]], :rows => rows
end
