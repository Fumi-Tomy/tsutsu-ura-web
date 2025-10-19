class PostsController < ApplicationController
  before_action :authenticate_admin!, except: [:index, :show] # ログイン済み管理者のみ許可
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    posts_scope = Post.order(created_at: :desc)
    add_breadcrumb "Top", root_path
    add_breadcrumb "Posts", posts_path
    # もしURLに tag_id パラメータが存在すれば、そのタグで絞り込む
    if params[:tag_id].present?
      # .joins(:tags) でpostsテーブルとtagsテーブルを結合
      # .where(tags: { id: params[:tag_id] }) で指定されたタグIDを持つ投稿を絞り込む
      @posts = posts_scope.joins(:tags).where(tags: { id: params[:tag_id] })
    else
      # tag_id がなければ、すべての投稿を表示
      @posts = posts_scope
    end

    # ドロップダウンに表示するための全てのタグリストを取得
    @tags = Tag.all
  end

  # GET /posts/1 or /posts/1.json
  def show
    @comment = Comment.new # コメント投稿フォーム用    
    add_breadcrumb "Top", root_path
    add_breadcrumb "Posts", posts_path
    add_breadcrumb "Post", @post
  end

  # GET /posts/new
  def new
    add_breadcrumb "Top", root_path
    @post = current_admin.posts.build # ログイン中のAdminに紐付けてPostを作成
  end

  # GET /posts/1/edit
  def edit
    add_breadcrumb "Top", root_path
  end

  # POST /posts or /posts.json
  def create
    @post = current_admin.posts.build(post_params) # ログイン中のAdminに紐付けてPostを作成

    respond_to do |format|
      if @post.save
        # タグの保存処理
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_path, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :body, :admin_id, tag_ids: [])
    end
end
