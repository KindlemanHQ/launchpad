def source_paths
  [__dir__]
end

def setup
  insert_into_file  ".gitignore", ".DS_Store"
  git :init
  git add: '.'
  git commit: "-a -m 'Initial commit'"
end

def add_my_gems
  # utility
  gem 'dartsass-rails'
  gem 'annotaterb'
  gem 'ransack'
  gem 'name_of_person'  
  gem 'github-markup'
  gem 'commonmarker'
  # seo
  gem 'friendly_id'
  gem 'sitemap_generator'
  gem "meta-tags"
  gem 'breadcrumbs_on_rails'
  
  # views
  gem 'bootstrap', git: 'https://github.com/twbs/bootstrap-rubygem', :branch => 'main'
  gem "simple_form"  
  gem 'pagy'
  gem 'bootstrap_views_generator', github: 'asecondwill/bootstrap_views_generator', :branch => 'main'

  # authentication
  gem 'devise' 
  gem "devise-bootstrap-views", github: 'asecondwill/devise-bootstrap-views'  
  gem "pretender"
  # authorization
  gem "pundit"
  # admin
  gem "houston_cms", github: "KindlemanHQ/HoustonCMS", tag: "v0.1.16"
  gem "marksmith"

  gem_group :development do
    gem 'hirb'
    gem 'rails-erd'
    gem 'letter_opener'
    gem 'dotenv-rails'
  end
  
  git add: '.'
  git commit: "-a -m 'add gems'"
end

def run_generators_for_seo   
  generate "friendly_id"
  generate "meta_tags:install"
  rails_command "sitemap:install"
  git add: '.'
  git commit: "-a -m 'run generators'"
end

def setup_js
  #run "bin/importmap pin highlight.js"

  #git add: '.'
  #git commit: "-a -m 'pin  highlight.js '"

  insert_into_file "config/importmap.rb", "pin_all_from 'app/javascript/custom', under: 'custom'
  \n"      
  copy_file "app/javascript/custom/sprinkles.js"
  insert_into_file "app/javascript/application.js", "import \"custom/sprinkles\"
  \n" 
  git add: '.'
  git commit: "-a -m 'custom js'"
end

def add_storage_and_rich_text
  rails_command "active_storage:install"
  rails_command "action_text:install"

 
  environment "config.active_storage.service = :aws", env: 'production'  
  copy_file "config/storage.yml" , force: true

  insert_into_file ".gitignore", 
  "
\n  
/public/storagepublic
  \n
/public/storeagepublic/*  
  \n" 

  git add: '.'
  git commit: "-a -m 'add storage and text'"
end

def bootstrap

  #run "bin/importmap pin bootstrap"
  insert_into_file "config/importmap.rb", "pin 'bootstrap', to: 'bootstrap.min.js'
  \n"      
  insert_into_file "config/importmap.rb", "pin 'popper', to: 'popper.js'
  \n"      

  insert_into_file "app/javascript/application.js", "import  'popper' 
  \n"
  insert_into_file "app/javascript/application.js", "import  'bootstrap' 
  \n"
  git add: '.'
  git commit: "-a -m 'Bootstrap js'"

end

def dart_sass
  run "./bin/rails dartsass:install"  
  run "rm app/assets/stylesheets/application.css"

  initializer 'dartsass.rb', <<-CODE
  Rails.application.config.dartsass.builds = {
    "application.scss"        => "application.css",
    "site.scss"       => "site.css",
    "admin.scss" => "admin.css"
  }
  CODE

  git add: '.'
  git commit: "-a -m 'add dartsass config'"
end

def devise
  
  generate "devise:install"  
  generate :devise, "User", "first_name", "last_name", "site_admin:boolean", "time_zone:string", "debug:boolean"
  #route "  devise_for :users "
  git add: '.'
  git commit: "-a -m 'setup devise '"

  run "bin/importmap pin stimulus-password-visibility"
  insert_into_file "app/javascript/controllers/index.js", "import PasswordVisibility from 'stimulus-password-visibility'
  \n"            
  insert_into_file "app/javascript/controllers/index.js", "application.register('password-visibility', PasswordVisibility)
  \n"        

  git add: '.'
  git commit: "-a -m 'password visibility '"
end

def user_settings
  route "get 'settings', to: 'users#settings'"
  route "patch 'settings', to: 'users#update_settings'"
  route "get 'change_password', to: 'users#password'"
  route "patch 'change_password', to: 'users#update_password'"
  git add: '.'
  git commit: "-a -m 'add user settings routes'"
end

def email
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }",
              env: 'development'
  environment "config.action_mailer.delivery_method = :letter_opener",
              env: 'development'  
  environment "config.action_mailer.perform_deliveries = true",
              env: 'development'  

  environment "config.action_mailer.smtp_settings = {
    :user_name => ENV['POSTMARK_API_KEY'],
    :password => ENV['POSTMARK_API_KEY'],
    :domain => 'example.com',
    :address => 'smtp.postmarkapp.com',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
  }", env: 'production'     
  git add: '.'
  git commit: "-a -m 'email setup'"       
end

def simple_form 
  generate "simple_form:install --bootstrap"  
  # Use Thor's uncomment_lines method to uncomment the line
  uncomment_lines("config/initializers/simple_form_bootstrap.rb", 
                  /#{Regexp.escape("Dir[Rails.root.join('lib/components/**/*.rb')].each { |f| require f }")}/)  
  git add: '.'
  git commit: "-a -m 'add simple_form and components'"

  lib 'components/input_group_component.rb', <<-CODE
  # custom component requires input group wrapper
  module InputGroup
    def prepend(wrapper_options = nil)
      template.content_tag(:span, options[:prepend], class: "input-group-text")
    end

    def append(wrapper_options = nil)
      template.content_tag(:span, options[:append], class: "input-group-text")
    end
  end

  # Register the component in Simple Form.
  SimpleForm.include_component(InputGroup)
  CODE

  git add: '.'
  git commit: "-a -m 'add inputgroup component '"
end

def copy_files_from_template
  # TODO: NB: this needs to be last, it stops the process for some reason.
  run "rm README.md"
  copy_file "README.md"
  #insert_into_file "README.md", "run to refresh sitemap: `rake sitemap:refresh`"  

  directory "app", force: true

  git add: '.'
  git commit: "-a -m 'copy app dir & other files'"  

  copy_file "lib/bootstrap_five_breadcrumbs.rb"
  git add: '.'
  git commit: "-a -m 'add breadcrumbs '"
  
  copy_file "locales/en.rb"
  copy_file "config/initializers/time_formats.rb"
  copy_file "config/initializers/houston_cms.rb"
  git add: '.'
  git commit: "-a -m 'add time formats '"

  copy_file ".env"
  git add: '.'
  git commit: "-a -m 'copy .env '"

end


def routes_for_home_and_dash
  route "root to: 'landings#home'"  
  route "get 'dash' => 'dashboards#home', as: :user_root "
  git add: '.'
  git commit: "-a -m 'assorted routes'"  
end

def staging 
  environment "host = ENV['IS_STAGING'] ? 'example-staging.herokuapp.com' : 'example.com'", env: 'production'  
  git add: '.'
  git commit: "-a -m 'add staging config code'"
end

def impersonation
  content = <<~RUBY
    resources :users, only: [:index] do
      post :impersonate, on: :member
      post :stop_impersonating, on: :collection
    end
  RUBY
  insert_into_file "config/routes.rb", "#{content}\n", after: "Rails.application.routes.draw do\n"
  git add: '.'
  git commit: "-a -m 'set up impersonation'"
end

def advanced_select
  insert_into_file "config/importmap.rb", "pin \"tom-select\", to: \"https://cdn.jsdelivr.net/npm/tom-select@2.4.3/dist/js/tom-select.complete.min.js\"
  \n"
  content = <<~RUBY
    import  'tom-select'
    addEventListener("turbo:load", (event) => {
      console.log('page loaded');
      document.querySelectorAll('.select-advanced').forEach((el)=>{
        let settings = {};
        new TomSelect(el,settings);
      });
    })  
  RUBY
  insert_into_file "app/javascript/application.js", "#{content}
  \n" 
  git add: '.'
  git commit: "-a -m 'set up advanced_select'"
end

def solid_queue_setup
  puts "solid queue being done"
  generate "solid_queue:install"
  environment "config.active_job.queue_adapter = :solid_queue", env: 'development' 
  environment "config.active_job.queue_adapter = :solid_queue", env: 'production' 
  git add: '.'
  git commit: "-a -m 'set up solid queue'"
end

def do_pundit
  generate "pundit:install"
end

def do_annotate
  generate "annotate_rb:install"
end

def install_importmap
  rails_command "importmap:install"
end

def install_stimulus
  rails_command "stimulus:install"  
end

def houston_setup  
  say "Installing houston...", :green
  generate "houston_cms:install"
  git add: '.'
  git commit: "-a -m 'install houston cms'"
  say "Houston installed!", :green
end

def after_bundle_stuff
  puts "AFTER_BUNDLE STUFF EXECUTED"
  # bin stubs created before this, so can do bundle stuff. 
  puts "About to call houston_setup..."
  houston_setup
  puts "Finished houston_setup, moving to staging..."
  staging
  email
  routes_for_home_and_dash
  install_importmap
  install_stimulus  
  run_generators_for_seo
  setup_js
  add_storage_and_rich_text  
  dart_sass
  bootstrap
  advanced_select
  simple_form
  devise    
  user_settings
  impersonation
  puts "ready for solid queue being done"
  solid_queue_setup
  do_pundit
  do_annotate
  copy_files_from_template
  
end

setup
add_my_gems
say "Installing dependencies..."
run "bundle install"

say "Running post-install tasks..."
after_bundle_stuff


after_bundle do
  
 # after_bundle_stuff
  
    

  

  #ttd:   scafold templates.  - ideally, have block or table ones, admin ones. 
  #       Devise screens
  #       restrict users area as a demo
  #       create a user
  #       simpleform extras 
  #       standard page templates. layouts:  site, app.  header, footer and menu.   
  #       CMS features
  #       copy  stuff from previous sites
  #       extract things to gems?
end
