class CLI
  class << self
    def run
      State.all_states
      City.all_cities
      main_menu
    end

    def prompt_instance
      TTY::Prompt.new
    end

    def names_state_option
      prompt = prompt_instance
      states = State.all.as_json
      state_names = []
      states.each{|s| state_names << s['name']}
      choice = prompt.select('Escolha um estado', state_names)
      state_id = states.select {|s| s['name'].eql? choice}[0]['id']
      Name.state_tables(state_id)
      exit
    end

    def names_city_option
      prompt = prompt_instance
      puts 'É obrigatório o uso de acento'
      # BUG: erro quando uma cidade é digitada com espaço no começo ou fim
      city_name = prompt.ask('Digite uma cidade:')
      Name.city_tables(city_name)
      exit
    end

    def name_frequency_option
      prompt = prompt_instance
      puts 'Você pode pesquisar um ou mais nomes (serarados por vírgula)'
      # BUG: erro quando os nomes são digitados com espaços sem vígulas
      names = prompt.ask('Digite o(s) nome(s):') do |r|
        r.convert -> (input) { input.split(/,\s*/) }
      end
      Name.frequency_table(names)
      exit
    end

    def exit
      prompt = prompt_instance
      prompt.select('') do |menu|
        menu.choice 'Voltar para o menu pricipal', -> {main_menu}
      end
    end

    def main_menu
      system 'clear'
      prompt = prompt_instance
      prompt.select('Escolha uma opção') do |menu|
        menu.choice 'Nomes mais comuns por UF', -> {names_state_option}
        menu.choice 'Nomes mais comuns por cidade',  -> {names_city_option}
        menu.choice 'Frequência do uso de um nome ao longo dos anos',  -> {name_frequency_option}
        menu.choice 'Sair',  -> {system "exit"}
      end
    end
  end
end
