require 'json'
require 'terminal-table'

class CLI
  def self.run
    State.all_states
    City.all_cities
  end
end

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
