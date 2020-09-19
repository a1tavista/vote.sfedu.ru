class Admin::UsersController < Admin::BaseController
  load_and_authorize_resource

  def index
    @users = paginate_entries(@users).order(id: :asc)
    @users = @users.where(kind_type: params[:kind].classify) if params[:kind].present?
    @users = @users.where(role: params[:role]) if params[:role].present?
  end

  def show
  end
end
