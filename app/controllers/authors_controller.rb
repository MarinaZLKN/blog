class AuthorsController < ApplicationController
  before_action :set_author, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_author!, only: [:edit, :update, :destroy]

  def index
    @authors = Author.all
  end

  def show
    @author = Author.find(params[:id])
  end

  def new
    @author = Author.new
  end

  def edit
    unless current_author == @author
      redirect_to authors_path, alert: "You cannot edit this author."
    end
  end

  def create
    @author = Author.new(author_params)

    if @author.save
      redirect_to @autho
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    unless current_author == @author
      redirect_to authors_path, alert: "You cannot update this author."
      return
    end

    if @author.update(author_params)
      redirect_to @author, notice: "Author was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    unless current_author == @author
      redirect_to authors_path, alert: "You cannot delete this author."
      return
    end

    @author.destroy
    redirect_to authors_path, notice: "Author was successfully deleted."
  end

  private
    def set_author
      @author = Author.find(params[:id])
    end

    def author_params
      params.require(:author).permit(:first_name, :last_name, :email)
    end
end
