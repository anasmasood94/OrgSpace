class PostsController < ApplicationController
  before_action :set_organization
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = @organization.posts.where("age_group_id = ? OR age_group_id IS NULL", current_user.age_group_id).order(created_at: :desc)
  end

  def show
    authorize @post
  end

  def new
    @post = @organization.posts.build
    authorize @post
  end

  def create
    @post = @organization.posts.build(post_params)
    @post.user = current_user
    authorize @post

    if @post.save
      redirect_to organization_path(@organization), notice: 'Post was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @post
  end

  def update
    authorize @post
    if @post.update(post_params)
      redirect_to organization_post_path(@organization, @post), notice: 'Post was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @post
    @post.destroy
    redirect_to organization_path(@organization), notice: 'Post was successfully deleted.'
  end

  private

  def set_organization
    @organization = Organization.find(params[:organization_id])
  end

  def set_post
    @post = @organization.posts.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :age_group_id)
  end
end 