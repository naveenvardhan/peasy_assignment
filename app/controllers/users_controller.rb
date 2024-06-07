class UsersController < ApplicationController
  
  def index
    @total_count = User.count
    @users = User.order(id: :desc)
    @users = @users.filter_by_name(params[:name]) if params[:name].present?
    @users = @users.limit(10)
  end

  def destroy
    user = User.find_by(id: params[:id])
    user.destroy
    redirect_to root_path, notice: 'User was successfully deleted.'
  end

  private

  def render_liquid(template_path, locals: {})
    template = Liquid::Template.parse(File.read(Rails.root.join('app', 'views', "#{template_path}.liquid")))
    render html: template.render(locals).html_safe
  end

end
