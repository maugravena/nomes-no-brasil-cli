# Talvez eu poderia de criado apenas uma tabela chamada Localização,
# com as cidades e estados

# Obrigatório enviar nomes com acento, não encontrei um solução para buscar sem
# considerar acentos no bando de dados

# O que difere cidades e estado são os código, poderia ter apenas um método para
# localização e outro para trazer por gênero
require 'csv'

class Name
  class << self
    # attr_accessor :name, :locale, :gender, :period, :frequency

    def endpoint
      'https://servicodados.ibge.gov.br'
    end

    def api_version
      'v2'
    end

    def ibge_url
      "#{endpoint}/api/#{api_version}/censos"
    end

    def names_url
      "#{ibge_url}/nomes"
    end

    def ranking_url
      "#{names_url}/ranking"
    end

    def locality_filter
      '?localidade='
    end

    def gender_filter
      '&sexo='
    end

    # 1 - le o arvivo CSV
    # 2 - busca localidade pelo código
    # 3 - pega numero da população
    # 4 - calcular percentual baseado no numero de pessoas por nome

    def by_state(state_id)
      url = "#{ranking_url}#{locality_filter}#{state_id}"
      get_data(url)
    end

    def by_city(city)
      city_id = city[0]['id']
      get_data("#{ranking_url}#{locality_filter}#{city_id}")
    end

    def by_state_and_gender(state_id, gender)
      url = "#{ranking_url}#{locality_filter}#{state_id}#{gender_filter}#{gender}"
      get_data(url)
    end

    def by_city_and_gender(city, gender)
      city_id = city[0]['id']
      url = "#{ranking_url}#{locality_filter}#{city_id}#{gender_filter}#{gender}"
      get_data(url)
    end

    def name_frequency_for_decades(name)
      get_data("#{names_url}/#{name}")
    end

    # Primeira opção - ranking de nomes por estado
    def state_tables(state_id)
      location_csv = find_location(state_id.to_s)
      population = population(location_csv)

      name_frequencies_general = name_frequencies(rows(by_state(state_id)))
      name_frequencies_female= name_frequencies(rows(by_state_and_gender(state_id, 'f')))
      name_frequencies_male = name_frequencies(rows(by_state_and_gender(state_id, 'm')))

      percentage_names_general = []
      percentage_names_female = []
      percentage_names_male = []

      name_frequencies_general.each do |n|
        percentage_names_general << percentage_of_population(n, population)
      end

      name_frequencies_female.each do |n|
        percentage_names_female<< percentage_of_population(n, population)
      end

      name_frequencies_male.each do |n|
        percentage_names_male << percentage_of_population(n, population)
      end

      general_rows = rows(by_state(state_id)).each_with_index{|item, index| item << percentage_names_general[index]}
      female_rows = rows(by_state_and_gender(state_id, 'f')).each_with_index{|item, index| item << percentage_names_female[index]}
      male_rows = rows(by_state_and_gender(state_id, 'm')).each_with_index{|item, index| item << percentage_names_male[index]}

      puts table('Geral', general_rows)
      puts table('Sexo feminino', female_rows)
      puts table('Sexo masculino', male_rows)
    end

    # Segunda opção - ranking de nomes por cidade
    def city_tables(city_name)
      city = City.where('lower(name) = ?', city_name.downcase)
      return p 'Cidade não encontrada' if city.blank?

      city_cod = city[0]['id'].to_s

      location_csv = find_location(city_cod)
      population = population(location_csv)
      name_frequencies_general = name_frequencies(rows(by_city(city)))
      name_frequencies_female= name_frequencies(rows(by_city_and_gender(city, 'f')))
      name_frequencies_male = name_frequencies(rows(by_city_and_gender(city, 'm')))

      percentage_names_general = []
      percentage_names_female = []
      percentage_names_male = []

      name_frequencies_general.each do |n|
        percentage_names_general << percentage_of_population(n, population)
      end

      name_frequencies_female.each do |n|
        percentage_names_female<< percentage_of_population(n, population)
      end

      name_frequencies_male.each do |n|
        percentage_names_male << percentage_of_population(n, population)
      end

      general_rows = rows(by_city(city)).each_with_index{|item, index| item << percentage_names_general[index]}
      female_rows = rows(by_city_and_gender(city, 'f')).each_with_index{|item, index| item << percentage_names_female[index]}
      male_rows = rows(by_city_and_gender(city, 'm')).each_with_index{|item, index| item << percentage_names_male[index]}

      puts table('Geral', general_rows)
      puts table('Sexo feminino', female_rows)
      puts table('Sexo masculino', male_rows)
    end

    # Terceira opção - ranking de um nome específico ao longo de décadas
    # Recebe um array como parâmetro
    def frequency_table(names)
      period = ['1930', '1930-1940', '1940-1950', '1950-1960', '1960-1970', '1970-1980', '1980-1990', '1990-2000', '2000-2010']
      title = 'Frequencia ao longo dos anos'
      data_names = []

      names.each do |name|
        # bugfix - Fazer tratamento quando é retornado um array vazio (nome não localizado)
        data = remove_strings rows(name_frequency_for_decades(name))
        data_names << data
      end
      data_names.unshift(period)

      # BUG: alguns nomes não incluem todas a decadas (normalmente são 9) isso gera um
      # erro quando usado o metodo transpose, os arrays precisam ser do mesmo tamanho
      rows_names = data_names.transpose
      return puts Terminal::Table.new :title => title, :headings => ['Periodo'] + names, :rows => rows_names
    end

    private

    def get_data(url)
      begin
        JSON.parse(RestClient.get url)
      rescue RestClient::ExceptionWithResponse => e
        puts e.response
      end
    end

    def hash_to_array_values(arr)
      res_arr = []
      arr.each do |i|
        res_arr << i.values
      end
      res_arr
    end

    # Monta as linhas para a tabela baseado no dados
    def rows(data)
      result = data[0]['res']
      hash_to_array_values(result)
    end

    # Para limpar dados vindos de um nome específico
    def remove_strings(arr)
      new_arr = []
      arr.each do |i|
        new_arr << i.delete_if { |obj| (obj.is_a? String) }
      end
      new_arr.flatten
    end

    def read_csv
      CSV.read('db/populacao_2019.csv', liberal_parsing: true)
    end

    def find_location(cod)
      locations = read_csv
      locations.each do |l|
        return l if l.include? cod
      end
    end

    def population(location)
      location[-1].to_i
    end

    def percentage_of_population(name_frequency, population)
      result = name_frequency.to_f / population.to_f * 100.0
      result.round(1)
    end

    def name_frequencies(data)
      frequencies = []
      data.each { |n| frequencies << n[1] }
      frequencies
    end

    # Tabela para usar nas opções de estados e cidades
    def table(title, rows)
      Terminal::Table.new :title => title, :headings => ['Nome', 'Frequencia', 'Ranking', 'Percentual'], :rows => rows
    end
  end
end
