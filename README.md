# TopicosTelematica
Proyecto de la materia Tópicos Telemática
by Marcos Sierra - msierr37@eafit.edu.co

## 1. Creating the Article Application
  rails new Articles
  
## 2. Starting up the WebApp Server
 
  rails server
 
 * Open browser: http://localhost:3000
 
## 3. Main page: "Hello World"
 
   rails generate controller Welcome index
 
   edit:
   app/views/welcome/index.html.erb
   config/routes.rb
   
## 4. Editing routes
  =begin
    get "/articles" index
    post "/articles" create
    delete "/articles/:id" destroy
    get "/articles/:id" show
    get "/articles/new" new
    get "/articles/:id/edit" edit
    patch "/articles/:id" update
    put "/articles/:id" update
 =end
 
## 5. Generate controller for Articles
   rails generate controller Articles
  
## 6. Create a FORM HTML for new articles
   app/views/articles/new.html.erb:
   
     <%= form_for(@article) do |f|%>
            <% @article.errors.full_messages.each do |message| %>
                <div class= "be-red white">
                    * <%= message%>
                </div>
            <%end%>
            <div class="field">
            <h5> Disponibilidad de la foto: </h5><%= f.select :disponible, options_for_select([["Público"],["Privado"],                                                         ["Compartido"]])%>
            </div>
            <div class="field">
                <%= f.text_field :title, placeholder: "Título de la foto", class:"form-control"%>
            </div>
                <div class="field">
                <%= f.text_field :tamano, placeholder: "Tamaño de la foto", class:"form-control"%>
            </div>
            <div class="field">
                <%= f.text_area :body, placeholder: "Descripción", style:"height:250px;", class:"form-control"%>
            </div>
            <div class="field">
                <%= f.submit "Subir", class:"btnSubmit be-red white"%>
            </div>
        <%end%>

## 7. Creating the Article model
   rails generate model Article title:string body:string disponible:string
   visits_count:integer tamano:string
   
 class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.integer :visits_count
      t.string :disponible
      t.string :tamano
    end
   end
  end


## 8. Running a migration
   rails db:migrate
   ## include postgresql in test and production environment:
   test:
  database: instatopicos
  adapter: postgresql
  pool: 5
  username: msierr37
  password: cplJQV42
  host: localhost
  port: 5432

production:
  database: instatopicos
  adapter: postgresql
  pool: 5
  username: msierr37
  password: cplJQV42
  host: localhost
  port: 5432

## 9. Saving data in the controller
  #POST /articles
  def create
        @article = current_user.articles.new(title: params[:article][:title], 
                                body: params[:article][:body],disponible: params[:article][:disponible], tamano:                                               params[:article][:tamano])
        if  @article.save
            redirect_to @article
        else
            render :new
        end
    end
    
## 10. Showing articles
  #GET /articles/:id
  
  
   def show
        @article = Article.find(params[:id])
        @article.update_visits_count  
    end
    
    
    app/views/articles/show.html.erb
    
   <h1><%= @article.title %></h1>
   <div>
     <p>Tamaño: <%= @article.tamano %></p>
   </div>
   <div>
    <%= @article.body %> -  <% if @article.user_id == current_user.id%>
    <%= link_to "Editar", edit_article_path(@article), class:"btn be-red"%>
    <%end%>
   </div>
   
## 11. Listing the articles
  #GET /articles
  
  
    def index
        palabra = "%#{params[:keyword]}%"
        if palabra != nil
            @articles = Article.where("title LIKE ? OR body LIKE?",palabra,palabra)
        else
            @articles = Article.all
        end
    end
    
    app/views/articles/index.html.erb
      
      <% @articles.each do |article| %>
            <% if article.disponible == "Privado" and article.user == current_user %>

            <h1><%= link_to article.title, article %></h1>
            <div>
                Visitas: <%= article.visits_count %>
            </div>
            <% if article.user == current_user%>
                <div>
                    <%= article.body %>
                </div>
                <div>
                    <p>Tamaño: <%= article.tamano %></p>
                </div>
                <p>
                 <%= link_to "Eliminar", article, method: :delete, class:"btn be-red"%> 
                </p>
            <%end%>
            <%elsif article.disponible == "Compartido" and user_signed_in? or article.disponible == "Público" and user_signed_in?%>
            <h1><%= link_to article.title, article %></h1>
            <div>
                Visitas: <%= article.visits_count %>
            </div>
            <% if article.user == current_user%>
            <div>
                <%= article.body %> 
            </div>
            <div>
                <p>Tamaño: <%= article.tamano %></p>
            </div>
            <p>
            <%= link_to "Eliminar", article, method: :delete, class:"btn be-red"%> 
            </p>
            <%end%>
            <%elsif article.disponible == "Público" and not user_signed_in? %>
            <h1><%= link_to article.title, article %></h1>
            <div>
                Visitas: <%= article.visits_count %>
            </div>
            <% if article.user == current_user%>
            <div>
                <%= article.body %> 
            </div>
            <div>
                <p>Tamaño: <%= article.tamano %></p>
            </div>
            <p>
            
            <%end%>
        <%end%>
        <%end%>
        
        
 ## 12. Updating Articles
 
  #PUT /articles/:id
  
  
    def update
        @article = Article.find(params[:id])
        if @article.update_attributes(title: params[:article][:title], 
                                body: params[:article][:body],disponible: params[:article][:disponible], tamano:                                               params[:article][:tamano])
            redirect_to @article
        else
            render :edit
        end
    end
    
    
## 13. Deleting Articles
  delete "/articles/:id" destroy
  
   def destroy
        @article = Article.find(params[:id])
        @article.destroy #Destroy elimina la foto de la BD
        redirect_to articles_path
    end
    
## Deployment on Heroku

  *heroku login
  
  *heroku create
  
  *git add .
  
  *git commit -am "Deploy on Heroku"
  
  *git push heroku master
  
## Deployment on DCA

# 1. Deploy the Article Web App on Linux Centos 7.x (test)
 
 ## Install ruby and rails
 
 * references:
 
      https://www.digitalocean.com/community/tutorials/how-to-use-postgresql-with-your-ruby-on-rails-application-on-centos-7
 
 
 * Connect remote server: (user1 is a sudo user)
 
      local$ ssh user1@10.131.137.229
      Password: *****
 
      user1@test$
 
 * verify and install rvm, ruby, rails, postgres and nginx
 
 * install rvm (https://rvm.io/rvm/install)
 
      user1@test$ gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
 
      user1@test$ \curl -sSL https://get.rvm.io | bash
 
 * reopen terminal app:
 
      user1@test$ exit
 
      local$ ssh user1@10.131.137.229
      Password: *****
 
 * install ruby 2.4.1
 
      user1@test$ rvm list known
      user1@test$ rvm install 2.4.1
 
 * install rails
 
      user1@test$ gem install rails
 
 ## install postgres:
 
   msierr37@test$ sudo yum install -y postgresql-server postgresql-contrib postgresql-devel
   Password: *****
 
   msierr37@test$ sudo postgresql-setup initdb
 
   msierr37@test$ sudo vi /var/lib/pgsql/data/pg_hba.conf
 
   original:
 
         host    all             all             127.0.0.1/32            ident
         host    all             all             ::1/128                 ident
 
         updated:
 
         host    all             all             127.0.0.1/32            md5
         host    all             all             ::1/128                 md5
 
 * run postgres:
 
         msierr37@test$ sudo systemctl start postgresql
         msierr37@test$ sudo systemctl enable postgresql
 
 * Create Database User:
 
         msierr37@test$ sudo su - postgres
 
         msierr37@test$ createuser -s pguser
 
         msierr37@test$ psql
 
         postgres=# \password pguser
         Enter new password: changeme
 
         postgres=# \q
 
         msierr37@test$ exit
 
 ## Setup RAILS_ENV and PORT (3000 for dev, 4000 for testing or 5000 for production)
 
         msierr37@test$ export RAILS_ENV=test
         msierr37@test$ export PORT=3001
 
 ## open PORT on firewalld service:
 
         msierr37@test$ sudo firewall-cmd --zone=public --add-port=4000/tcp --permanent
         msierr37@test$ sudo firewall-cmd --reload
 
 ## clone de git repo, install and run:
 
         msierr37@test$ cd Documents
         msierr37@test$ git clone https://github.com/st0263eafit/rubyArticulosEM.git
         msierr37@test$ cd TopicosTelematica
         msierr37@test$ cd trabajo
         msierr37@test$ bundle install
         msierr37@test$ rake db:drop db:create db:migrate
         msierr37@test$ export RAILS_ENV=test
         msierr37@test$ export PORT=3001 
         msierr37@test$ rails server
 
 
   Prefix    Verb   URI Pattern                                Controller#Action
 +                               GET "/articles" index                welcome#index
                                 POST "/articles" create              articles#create
                                 DELETE "/articles/:id" destroy       articles#destroy
                                 GET "/articles/:id" show             articles#show
                                 GET "/articles/new" new              articles#new
                                 GET "/articles/:id/edit" edit        articles#edit
                                 PATCH "/articles/:id" update         articles#update
                                 PUT "/articles/:id" update           articles#update
 +                    root       GET  welcome/index                   welcome#index
 
# 2. SETUP Centos 7.1 in production With Apache Web Server and Passenger.
## Install Apache Web Server

              
       msierr37@prod$ sudo yum install httpd
       msierr37@prod$ sudo systemctl enable httpd
       msierr37@prod$ sudo systemctl start httpd

       test in a browser: http://10.131.137.236

## Install YARN (https://yarnpkg.com/en/docs/install) (for rake assets:precompile):

##  Install module Passenger for Rails in HTTPD (https://www.phusionpassenger.com/library/install/apache/install/oss/el7/):

jsanch81@prod$ gem install passenger

             msierr37@prod$ passenger-install-apache2-module
             when finish the install module, add to /etc/http/conf/httpd.conf:

               LoadModule passenger_module /home/msierr37/.rvm/gems/ruby-2.4.1/gems/passenger-5.1.7/buildout/apache2/mod_passenger.so
               <IfModule mod_passenger.c>
                 PassengerRoot /home/msierr37/.rvm/gems/ruby-2.4.1/gems/passenger-5.1.7
                 PassengerDefaultRuby /home/msierr37/.rvm/gems/ruby-2.4.1/wrappers/ruby
               </IfModule>
## Configure the ruby rails app to use passenger (https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/ownserver/apache/oss/el7/deploy_app.html):

### Summary:
  - clone the repo to /var/www/myapp/rubyArticulosEM

             msierr37@prod$ cd /var/www/myapp/rubyArticulosEM

             msierr37@prod$ bundle install --deployment --without development test

             - Configure database.yml and secrets.yml:

             msierr37@prod$ bundle exec rake secret
             msierr37@prod$ vim config/secrets.yml
             
### Production:
               secret_key_base: the value that you copied from 'rake secret'

             msierr37@prod$ bundle exec rake assets:precompile db:migrate RAILS_ENV=production
           add articles.conf to /etc/httpd/conf.d/myapp.conf:

             <VirtualHost *:81>
                 ServerName 10.131.137.229

               # Tell Apache and Passenger where your app's 'public' directory is
                 DocumentRoot /var/www/instatopicos/code/trabajo/public

                 PassengerRuby /home/msierr37/.rvm/gems/ruby-2.4.1/wrappers/ruby

                 # Relax Apache security settings
                 <Directory /var/www/instatopicos/code/trabajo/public>
                     Allow from all
                     Options -MultiViews
                     #Uncomment this if you're on Apache >= 2.4:
                     #Require all granted
                 </Directory>
             </VirtualHost>
           restart httpd

             msierr37@prod$ sudo systemctl restart httpd

             test: http://10.131.137.239
