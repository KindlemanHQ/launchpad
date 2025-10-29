# ITS LEAP
Kick off a project like:
````bash
rails new MyNewApp -a propshaft  -d sqlite3  -m ../leap/template.rb
rails db:create & rails db:migrate 
````
or for real projects
````bash
rails new appy24 -a propshaft  -d postgres  -m ../leap/template.rb
````

## Bootstrap Views
use like: 
````bash
rails g bootstrap:install  --simpleform --pagination 
````
So now you can do Scafold for your Crud like a bootstrap boss:
````ruby
rails generate scaffold boats  name:string title:string content:text
````
If you want pagination tho, you need to change the controller index to:
````ruby
 @pagy, @boats = pagy(Boat.all, items: 5)
````

..and if you want Ransack too:

````ruby
  @q = Bike.ransack(params[:q])
  @boats = @q.result(distinct: true)
  @pagy, @boats = pagy(@boats, items: 5)
````

For bootstrap pagination, You need to download this:
````ruby
cd config/initializers 
wget https://ddnexus.github.io/pagy/lib/config/pagy.rb
````
and uncomment

```` require 'pagy/extras/bootstrap' ``

TODO:  just do that in code?

# Time
use time_formats.rb and en.rb to configure your formats and then use like this: 
````ruby
<%=  boat.created_at.to_formatted_s(:full)   %>
<%=  l(boat.created_at, format: :pirate)   %>
````
More docs here: https://api.rubyonrails.org/cl  asses/Time.html#method-i-to_formatted_s


# Use github flavour markup in your views like: 
````ruby
 md("**Hello** there")
````

or
````ruby
markdown_filter do |block|
# Hi There
end
````
note, no indentation

alternatively, use https://github.com/zarqman/markdown_views

## Breadcrumbs
Add breadcrumbs with [breadcrumbs_on_rails](https://github.com/weppos/breadcrumbs_on_rails) in your controller:
````ruby
  add_breadcrumb "home", :root_path
  add_breadcrumb "Boats", :boats_path

  def show
    add_breadcrumb @boat.name, boat_path(@boat)
  end
````
Or views, eg for devise views - copy them over from the views gem and add:
````ruby
<% add_breadcrumb "Edit #{@boat.name}", edit_boat_path(@boat) %>
````


# TTD:
delayed jobs, but as simple as possible, ie use the default rails one
https://github.com/bensheldon/good_job#readme

acts_as_list	

gem "chartkick" and analytics?
error pages? gaffe?




postmark-rails

deployment ready on hatchbox

https://github.com/javan/whenever
breadcrumbs 


run to refresh sitemap: `rake sitemap:refresh`


add pagy to controller? 


pretender, but, teams? keep it secure. 

