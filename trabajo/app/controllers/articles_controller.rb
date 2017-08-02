class ArticlesController < ApplicationController
    #GET /articles
    def index
        palabra = "%#{params[:keyword]}%"
        if palabra != nil
            @articles = Article.where("title LIKE ? OR body LIKE?",palabra,palabra)
        else
            @articles = Article.all
        end
    end
    #GET /articles/:id
    def show
        @article = Article.find(params[:id])
        @article.update_visits_count
      
    end
    #GET /articles/new
    def new
        @article = Article.new
    end
    #POST /articles
    def create
        @article = current_user.articles.new(title: params[:article][:title], 
                                body: params[:article][:body],disponible: params[:article][:disponible], tamano: params[:article][:tamano])
        if  @article.save
            redirect_to @article
        else
            render :new
        end
    end

    def destroy
        @article = Article.find(params[:id])
        @article.destroy #Destroy elimina la foto de la BD
        redirect_to articles_path
    end
    def edit
        @article = Article.find(params[:id])
    end
    #PUT /articles/:id
    def update
        @article = Article.find(params[:id])
        if @article.update_attributes(title: params[:article][:title], 
                                body: params[:article][:body],disponible: params[:article][:disponible], tamano: params[:article][:tamano])
            redirect_to @article
        else
            render :edit
        end

    end
end