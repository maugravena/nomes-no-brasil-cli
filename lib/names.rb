# Talvez eu poderia de criado apenas uma tabela chamada Localização,
# com as cidades e estados

class Name
  class << self
    # attr_accessor :name, :locale, :gender, :period, :frequency

    def endpoint
      'https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking'
    end

    def locality_url
      "#{endpoint}?localidade="
    end

    def state_id(state_initials)
     state = State.find_by(initials: state_initials.upcase)

      if state.blank?
        return 'Estado não encontrado'
      else
        return state['id'].to_s
      end
    end

    def city_id(city_name)
      # Usuário é obrigado a enviar nomes com acento
      city = City.where('lower(name) = ?', city_name.downcase)
      if city.blank?
        return 'Cidade não encontrada'
      else
        return city[0]['id'].to_s
      end
    end

    def by_state(state_initials, gender='null')
      id = state_id(state_initials)

      # Entender melhor como posso lidar com os erros
      # achei estranho ter que retorna id, já que na verdade essa é uma mensagem de erro
      if id.include? 'não'
        id
      else
        get_data(id, gender)
      end
    end

    def by_city(city_name, gender='null')
      id = city_id(city_name)
      if id.include? 'não'
        id
      else
        get_data(id, gender)
      end
    end

    def by_state_and_gender(id, gender)
      by_state(id, gender)
    end

    def by_city_and_gender(id, gender)

    end

    private

    def get_data(id, gender)
      begin
        JSON.parse(RestClient.get "#{locality_url}#{id}&sexo=#{gender}")
      rescue RestClient::ExceptionWithResponse => e
        puts e.response
      end
    end
  end
end
