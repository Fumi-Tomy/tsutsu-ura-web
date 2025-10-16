class CommentsController < ApplicationController
  before_action :authenticate_admin!, except: [:create] # ログイン済み管理者のみ許可
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)

    if @comment.save
      redirect_to post_path(@post), notice: 'コメントが投稿されました。'
    else
      # エラーハンドリング（例: showページを再描画してエラーを表示）
      flash[:alert] = 'コメントの投稿に失敗しました。'
      redirect_to post_path(@post)
    end
  end

  def destroy
    # 管理者のみ削除できるようにする場合は、ここで認証を追加
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    redirect_to post_path(@post), notice: 'コメントを削除しました。'
  end

  private

  def comment_params
    params.require(:comment).permit(:name, :body) 
  end
end