# Weather App [![Build Status](https://github.com/jayywolff/weather-app/actions/workflows/ci.yml/badge.svg)](https://github.com/jayywolff/weather-app/actions)
Simple Weather App to search for forecasts.
Built with Ruby on Rails 8, Bootstrap 5, Bootstrap Icons, RSpec, Capybara.  
Powered by [WeatherAPI](https://www.weatherapi.com/docs/)

## Dev Dependencies
 - Ruby version 3.3.x or 3.4.x
 - git
 - postgresql (might remove this dependency since the db isn't really needed at this time)
 - create an account with [WeatherAPI](https://www.weatherapi.com/docs/) to obtain an API key

## Installation
 - Install Ruby version 3.3.x or 3.4.x with your package manager of choice (system, rvm, rbenv, homebrew, aptitude, etc.)

```bash
$ gem install bundler # install bundler (ruby app gem manager)
$ git clone https://github.com/jayywolff/weather-app.git # download the project with git clone
$ cd ./weather-app # set your working directory to the project root
$ bundle install # install ruby gem dependencies
$ bundle exec rails db:create # create dev/test databases
$ bundle exec rails dartsass:build # compile stylesheets (scss)
$ export WEATHER_API_KEY=mysecretkey # SET a local ENV var with your personal API key obtained from WeatherAPI
```

### Add your WeatherAPI API key to the Rails dev/test credentials (optional) 
###### optional if you dont want to set the WEATHER_API_KEY ENV var everytime you run the app/tests in a new terminal
```bash
# add your WeatherAPI key in the rails credentials
# entry should be in yml format, for example: `weather_api_key: mysecretkey`
$ bundle exec rails credentials:edit --environment development
```

```bash
# add a WeatherAPI key in the rails credentials for the test env
# entry should be in yml format, for example: `weather_api_key: mysecretkey`
# tests don't actually hit the api, so this can be any string value
$ bundle exec rails credentials:edit --environment test
```

## Running the development environment application
```bash
$ bundle exec rails server # start up the dev server
```
Open [localhost:3000](http://localhost:3000) in your browser

## Running Tests
#### App has been tested against ruby 3.3.6 and 3.4.1
```bash
$ bundle exec rspec
```
