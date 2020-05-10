class State < ActiveRecord::Base
  def self.all_states
    begin
      state_data = JSON.parse(RestClient.get 'https://servicodados.ibge.gov.br/api/v1/localidades/estados')
    rescue RestClient::ExceptionWithResponse => e
      puts e.response
    end

    state_data.each do |state|
      self.create(id: state['id'], name: state['nome'], initials: state['sigla'])
    end
  end
end
