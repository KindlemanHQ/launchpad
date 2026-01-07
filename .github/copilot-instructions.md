# Guidance for AI coding agents working on LaunchPad

This repo is a Rails application template and sample app. The instructions below capture the project's architecture, developer workflows, patterns, and integration points an AI agent should know to be immediately productive.

## Big picture
- Purpose: a Rails app template (`template.rb`) that scaffolds a ready-to-run app (auth, CMS, JS/CSS setup, pagination, search).
- Major pieces:
  - `template.rb`: orchestration script that installs gems, generators, and post-bundle tasks. Treat it as the canonical setup sequence.
  - `app/`: standard Rails MVC (note layouts: `site` and `application`).
  - `lib/`: small helpers (e.g. `lib/bootstrap_five_breadcrumbs.rb` implements breadcrumb rendering).
  - `config/`: `storage.yml`, `importmap.rb` pins, and environment-specific initializers are important for integrations.

## Key integrations & environment variables
- Authentication: `devise` (User model configured in `app/models/user.rb`).
- Authorization: `pundit` (application rescues `Pundit::NotAuthorizedError`).
- Pagination: `pagy` (controllers include `Pagy::Backend` and should follow the pattern `@pagy, @records = pagy(scope, items: n)`).
- Search: `ransack` (README and controllers use `@q = Model.ransack(params[:q])`).
- CMS: `houston_cms` installed via generator in the template.
- Storage: ActiveStorage configured in `config/storage.yml`. The app sometimes reads `ENV['PUBLIC_STORAGE_SERVICE']` to pick the service for public avatars.
- Email: `postmark` credentials expected via `POSTMARK_API_KEY`; dev uses `letter_opener`.
- JS/CSS: uses `importmap` (pins in `config/importmap.rb`), `stimulus` controllers (`app/javascript/controllers`), and `dartsass-rails` (initializer configured in the template).

## Developer workflows (explicit commands / sequences)
- Create a new app from this template (illustrated in `README.md`):
  - `rails new MyNewApp -a propshaft -d sqlite3 -m ../launchpad/template.rb`
  - `cd MyNewApp && bundle install && rails db:create db:migrate`
- When working inside this repo (to run the sample app):
  - `bundle install` then `rails db:create db:migrate`
  - `bin/rails importmap:install` and `bin/rails stimulus:install` may be required if JS packages are missing.
  - CSS build: `./bin/rails dartsass:install` (template wires up `dartsass` builds).
  - Run server: `rails server` (dev emails open with `letter_opener`).
  - Refresh sitemap: `rake sitemap:refresh` (README note).

## Project-specific patterns & conventions
- Breadcrumbs: add breadcrumbs in controllers using `add_breadcrumb` and rely on `lib/bootstrap_five_breadcrumbs.rb` for rendering.
  - Example: `add_breadcrumb "Users", :users_path` in `UsersController`.
- Pagination + Search combo: prefer `@q = Model.ransack(params[:q])`, then `@pagy, @records = pagy(@q.result(distinct: true), items: 5)`.
- Timezones: `ApplicationController` uses `around_action :set_time_zone, if: :current_user` and `User` stores `time_zone`. Update user time zone via settings routes.
- Devise + User model conventions:
  - `User` defines `has_person_name`, `has_one_attached :avatar` with `PUBLIC_STORAGE_SERVICE` usage, and a `password_complexity` validator.
- JS / Importmap: JS files in `app/javascript/custom` are pinned via `config/importmap.rb`; Stimulus controllers are registered in `app/javascript/controllers/index.js`.
- Stylesheets: constructed using SCSS under `app/assets/stylesheets` and mapped in the `dartsass` initializer (see template's `dartsass.rb` initializer content).
- SimpleForm components: `lib/components/input_group_component.rb` is registered by the template; follow its APIs for prepend/append input groups.

## Files to inspect when reasoning about changes
- Template and setup: `template.rb`
- Controllers & auth flow: `app/controllers/application_controller.rb`, `app/controllers/users_controller.rb`
- User model and validations: `app/models/user.rb`
- Storage and services: `config/storage.yml`
- Breadcrumbs renderer: `lib/bootstrap_five_breadcrumbs.rb`
- Time formats: `initializers/time_formats.rb`
- JS entrypoints: `app/javascript/application.js` and `app/javascript/custom/sprinkles.js`

## What NOT to change without care
- Do not alter `template.rb` unless updating the scaffolding behavior intentionally — many setup choices (generators, pins, initializers) are encoded there.
- Changing `config/storage.yml` or `PUBLIC_STORAGE_SERVICE` handling affects attachments across environments; coordinate S3/bucket changes with devops.

## Quick examples an agent can use
- Pagination in a controller:
  - `@pagy, @boats = pagy(Boat.all, items: 5)`
- Combined search + pagination (from README):
  - `@q = Bike.ransack(params[:q])`
  - `@boats = @q.result(distinct: true)`
  - `@pagy, @boats = pagy(@boats, items: 5)`
- Time zone handling (see `ApplicationController`):
  - `around_action :set_time_zone, if: :current_user`

If any of these sections are unclear or you'd like more examples (e.g., common refactors, tests, or a code-mod for a generator), tell me which area to expand. I'll iterate.
