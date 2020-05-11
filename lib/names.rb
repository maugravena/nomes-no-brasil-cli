# Talvez eu poderia de criado apenas uma tabela chamada Localização,
# com as cidades e estados

# Obrigatório enviar nomes com acento, não encontrei um solução para buscar sem
# considerar acentos no bando de dados

# O que difere cidades e estado são os código, poderia ter apenas um método para
# localização e outro para trazer por gênero

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

    def by_state(state_initials)
      state = State.find_by(initials: state_initials.upcase)
      return 'Estado não encontrado' if state.blank?

      state_id = state['id']
      url = "#{ranking_url}#{locality_filter}#{state_id}"
      get_data(url)
    end

    def by_city(city_name)
      city = City.where('lower(name) = ?', city_name.downcase)
      return 'Cidade não encontrada' if city.blank?

      city_id = city[0]['id']
      get_data("#{ranking_url}#{locality_filter}#{city_id}")
    end

    def by_state_and_gender(state_initials, gender)
      state = State.find_by(initials: state_initials.upcase)
      return 'Estado não encontrado' if state.blank?

      state_id = state['id']
      url = "#{ranking_url}#{locality_filter}#{state_id}#{gender_filter}#{gender}"
      get_data(url)
    end

    def by_city_and_gender(city_name, gender)
      city = City.where('lower(name) = ?', city_name.downcase)
      return 'Cidade não encontrada' if city.blank?

      city_id = city[0]['id']
      url = "#{ranking_url}#{locality_filter}#{city_id}#{gender_filter}#{gender}"
      get_data(url)
    end

    def name_frequency_for_decades(name)
      get_data("#{names_url}/#{name}")
    end

    private

    def get_data(url)
      begin
        JSON.parse(RestClient.get url)
      rescue RestClient::ExceptionWithResponse => e
        puts e.response
      end
    end
  end
end
