class PostsController < ApplicationController
  def index
  end

  def new
    user = User.includes(:posts).find(current_user)
    @post = user.posts.build
  end

  def create
    @post = current_user.posts.build(white_list_params)
    if @post.save
      flash[:success] = ["Post has been created successfully"]
      redirect_to new_post_path
    else
      flash.now[:danger] = @post.errors.full_messages
      render :new
    end
  end

  def destroy
    post = Post.find(params[:id])
    if post.destroy
      flash[:success] = ["Post has been deleted successfully"]
    else
      flash[:danger] = ["Post can not be deleted"]
    end
    redirect_to new_post_path
  end

  def like
    post = Post.find_by_id(params[:id])
    Like.create(likeable: post, user: current_user, like: params[:like])
    flash[:success] = ["Like Counted!"]
    redirect_to :back
  end


  private
    def white_list_params
      params.require(:post).permit(:body)
    end
end