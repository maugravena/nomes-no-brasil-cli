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

    def exit
      prompt = prompt_instance
      prompt.select('') do |menu|
        menu.choice 'Voltar para o menu pricipal', -> {main_menu}
      end
    end

    def main_menu
      system 'clear'
      prompt = prompt_instance
      prompt.select('Escolha um opção') do |menu|
        menu.choice 'Nomes mais comuns por UF', -> {names_state_option}
        menu.choice 'Nomes mais comuns por cidade',  -> {}
        menu.choice 'Frequência do uso de um nome ao longo dos anos',  -> {}
        menu.choice 'Sair',  -> {system "exit"}
      end
    end
  end
end
