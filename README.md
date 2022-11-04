# Viewing Party

This is the base repo for the [Viewing Party Lite project](https://backend.turing.io/module3/projects/viewing_party_lite) used for Turing's Backend Module 3.

### About this Project

Viewing Part Lite is an application in which users can explore movie options and create a viewing party event for themselves and other users of the application.

# Table of Contents

- [Requirements](https://github.com/aleish-m/viewing_party_lite/blob/main/README.md#requirements)
- [Installation](https://github.com/aleish-m/viewing_party_lite/blob/main/README.md#installation)
- [Deployment](https://github.com/aleish-m/viewing_party_lite/blob/main/README.md#deployment)
- [Contributors](https://github.com/aleish-m/viewing_party_lite/blob/main/README.md#contributors)

## Requirements

- Ruby 2.7.4

- Rails 5.2.X

## Installation

To get started, clone the repo in your terminal by entering the following:
```
git clone git@github.com:aleish-m/viewing_party_lite.git
```

Once cloned, run the following commands:
```
- bundle install
- rails db:create
- rails db:migrate
- Install Figaro
  - `bundle exec figaro install`
- Update the `application.yml` file with `ENV` variables storing API keys for The Movie DB API: https://developers.themoviedb.org/3/getting-started/introduction
```

## Deployment

Viewing Party is deployed remotely on Herkou.

Base URL: https://viewing-party-2207.herokuapp.com/

## Contributors
- **Aleisha Mork** - *Turing Student* - [GitHub](https://github.com/aleish-m)
- **Nicole Esquer** - *Turing Student* - [GitHub](https://github.com/nicole-esquer)

