module Api::V1
  class UsersController < ApiController
    ensure_authenticated_user_for :index
    ensure_authenticated_user_for :create, :scopes => [:write]

    respond_to :json

    def index
      respond_with User.recent
    end

    def create
      respond_with 'api_v1', User.create!(params[:user])
    end
  end
end
