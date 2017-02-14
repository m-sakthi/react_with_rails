# react_with_rails
Boiler Plate - Rails-Postgres-React-Material App.

## Clone
Clone from the repository

```sh
git clone https://github.com/msv300/react_with_rails
```

## Features

* Rails application with react_on_rails integration
* ... more yet to come


## Setup

Edit the following files in the `config/` folder as per your settings.
copy `config/*.yml.sample` to `config/*.yml`
* `cp /config/dalli.yml.sample /config/dalli.yml`
* `cp /config/database.yml.sample /config/database.yml`
* `cp /config/sblog.yml.sample /config/sblog.yml`

Once you are done with the settings do the following,

* install the dependent gems - `bundle install`
* create database with `rails db:create`
* generate swagger json files with `rails swagger:docs`
* start the server with `rails s`
* navigate to `localhost:3030` to see the swagger documentation


## License
MIT License (MIT).