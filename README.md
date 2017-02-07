# Habits

[ ![Codeship Status for stevegrossi/habits](https://codeship.com/projects/4f089590-12d6-0134-4498-76fd620179ca/status?branch=master)](https://codeship.com/projects/157431)
[![Ebert](https://ebertapp.io/github/stevegrossi/habits.svg)](https://ebertapp.io/github/stevegrossi/habits)

An Elixir/Phoenix application for tracking daily habits.

<img src="https://raw.githubusercontent.com/stevegrossi/habits/master/screenshot.png" alt="in-app screenshot" width="320" />

## Development Setup

- Clone this repository with `git clone git@github.com:stevegrossi/habits.git`
- Open that directory with `cd habits`
- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Install Node.js dependencies with `npm install`
- Start Phoenix with `mix phoenix.server`

You should now see the app by visiting [`localhost:4000`](http://localhost:4000) from your browser.

## Deploy

Want your own copy of Habits on Heroku?

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/stevegrossi/habits)

Once you deploy to Heroku, you’ll be redirected to the registration page to create your Habits account. Habits allows only one account, so once you sign up, no one else will be able to. This is intentional: Heroku’s free database plan is limited to 10,000 habits and check-ins, which you’ll probably want all to yourself.
