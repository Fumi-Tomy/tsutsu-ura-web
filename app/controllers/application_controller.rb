class ApplicationController < ActionController::Base
  # before_actionを記述
  before_action :basic_auth, if: :use_basic_auth?
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def use_basic_auth?
    devise_controller?
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |user, password|
      # credentialsから認証情報を読み込む
      user == Rails.application.credentials.dig(:basic_auth, :user) &&
      password == Rails.application.credentials.dig(:basic_auth, :password)
    end
  end
end
