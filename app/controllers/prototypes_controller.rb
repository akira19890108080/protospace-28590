class PrototypesController < ApplicationController

  before_action :authenticate_user!, expect: [:show, :index]
  before_action :contributor_confirmation, only: [:edit, :update, :destroy]

  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path(@prototype)
    else
      render :new
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    if prototype.destroy
      render :index
    end
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    if Prototype.update(prototype_params)
      redirect_to prototype_path
    else
      render :edit
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments
  end

  private
  def prototype_params
    params.require(:prototype).permit(:image, :title, :catch_copy, :concept).merge(user_id: current_user.id)
  end

  def contributor_confirmation
    @prototype = Prototype.find(params[:id])
    redirect_to root_path unless current_user == @prototype.user
  end
end
