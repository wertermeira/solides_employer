# Solides Emplyer

## Description
Ruby on rails Application demo to study tests and swagger docs

## Install Gems
```sh
bundle install
```
## Create Database and migrate
```sh
rails db:create db:migrate
```
## Run test, rubocop and generate swagger docs
```sh
bundle exec rspec
bundle exec rubocop
bundle exec rails rswag
```
## Run app
```sh
bundle exec rails s -p 3000
```
## Features
Application http://localhost:3000\
Swagger documentation http://localhost:3000/api-docs


### Bonus

Generate diagram to models and controllers
```sh
rails diagram:all_with_engines
```
Open the doc folder to see the documents

[Controllers brief](/doc/controllers_brief.svg)
[Controllers complete](/doc/controllers_complete.svg)
[Models bried](/doc/models_brief.svg)
[Models complete](/doc/models_complete.svg)
