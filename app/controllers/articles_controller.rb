class ArticlesController < ApplicationController
  before_action :authenticate_author!, only: [:new, :create]
  def index
    @articles = Article.order(created_at: :desc)
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = current_author.articles.build
  end

  def create
    @article = current_author.articles.build(article_params)

    if @article.save
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @article = Article.find_by(id: params[:id])
    unless @article
      redirect_to root_path, alert: 'Article not found'
      return
    end

    if current_author != @article.author
      redirect_to @article, alert: 'You can edit only your own articles. :)'
    end
  end

  def update
    @article = Article.find_by(id: params[:id])
    unless @article
      redirect_to root_path, alert: 'Article not found'
      return
    end

    if current_author != @article.author
      redirect_to @article, alert: 'You can edit only your own articles. :)'
      return
    end

    if @article.update(article_params)
      redirect_to @article, notice: "Article successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    @article = Article.find_by(id: params[:id])
    unless @article
      redirect_to root_path, alert: 'Article not found'
      return
    end

    if current_author != @article.author
      redirect_to @article, alert: 'You can delete only articles that belong to you.'
      return
    end

    @article.destroy
    redirect_to root_path, notice: "Article successfully deleted!"
  end

  private
  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :body, :status)
  end
end
