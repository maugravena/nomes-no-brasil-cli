# Nomes no Brasil CLI

Ao ser iniciado o app apresenta uma lista com 3 opções, para escolher uma opção você deve navegar com as setas do teclado.

- A primeira e segunda opção fazem basicamente a mesma coisa porém a escolha dos estados é feita por uma lista com a mesma
  navegação por setas. Para as cidades é necessário digitar o nome de uma cidade válida, considerando acentos. Nessas opções o resuldado será 3 tabelas (Geral, Sexo feminino, Sexo masculino) com os nomes mais frenquentes em suas respectivas localizações(cidades ou estados).

- Na terceira opção, é necessário digitar um ou mais nomes (separados por vírgula),
  o resultado será uma tabela com a frenquência do(s) nome(s) ao longo das décadas.

- No final de cada operação é possível voltar ao menu principal

## Configuração

ruby 2.6.5

executar o comando `bundle install` para baixar as dependências

## Para executar a aplicação

`ruby bin/run.rb`

## GEMS utilizadas

- activerecord - para conectar as classes ao bando de dados
- sqlite3 - módulo para interface com banco de dados
- tty-prompt - fazer o menu, e receber input
- rest-client - consumo da API
- terminal-table - montar as tabelas com um layout costumizado
- standalone_migrations - ajudou na criação inicial do banco de dados
- require_all - uma forma simplicidada de carregar os arquivos
- byebug - debugging
