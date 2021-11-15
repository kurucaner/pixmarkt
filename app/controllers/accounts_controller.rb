class AccountsController < ApplicationController
  before_action :authenticate_account!
  before_action :set_account, only: [:profile, :following, :followers]

  def index
    # user dashboard - post feed
    followers_ids = Follower.where(follower_id: current_account.id).pluck(:following_id)
    followers_ids << current_account.id

    if followers_ids.size > 1
      @posts = Post.includes(:account).where(account_id: followers_ids).active.order(created_at: :desc).limit(5)
    else
      @posts = Post.includes(:account).active.order(created_at: :desc).limit(5)
    end

    @comment = Comment.new

    following_ids = Follower.where(follower_id: current_account.id).pluck(:following_id)
    following_ids << current_account.id
    @follower_suggestions = Account.where.not(id: following_ids).limit(3)

    @banner_feed_top = Banner.image_path("feed-top")
    @banner_sidebars = Banner.image_path("feed-sidebar", 1)
  end

  def load_posts
    # load new posts for inserting into feed
  end

  def search
    if params[:search]
      @accounts = Account.select(:id, :first_name, :last_name, :username, :image).where('username LIKE ?', "%#{params[:search]}%").limit(5)
    else
      # get most active accounts
      @accounts = Account.order(sign_in_count: :desc).limit(5)
    end

    respond_to do |format|
      format.js {
        render partial: "accounts/search"
      }
    end
  end

  def profile
    # user profile
    @is_follower = account_signed_in? ? Follower.where(follower_id: current_account.id, following_id: @account.id).any? : false
    @posts = @account.posts.active
  end

  def follow_account
    if Follower.create(follower_id: current_account.id, following_id: params[:follow_id])
      flash[:success] = "Now following user"
    else
      flash[:danger] = "Unable to add follower"
    end

    redirect_to dashboard_path
  end

  def unfollow_account
    connection = Follower.where(follower_id: current_account.id, following_id: params[:account_id])

    if connection.size > 0 && connection.first.destroy
      flash[:success] = "You are no longer following this user"
    else
      flash[:danger] = "Unable to unfollow this user"
    end

    redirect_to dashboard_path
  end

  def following
    ids = Follower.where(follower_id: @account.id).pluck(:following_id)
    @accounts = Account.where(id: ids)
  end

  def followers
    # get ids of users that logged in user is following
    @following_ids = account_signed_in? ? Follower.where(follower_id: current_account.id).pluck(:following_id) : []

    ids = Follower.where(following_id: @account.id).pluck(:follower_id)
    @accounts = Account.where(id: ids)
  end

  private

  def set_account
    @account = Account.find_by_username(params[:username])
  end
end
