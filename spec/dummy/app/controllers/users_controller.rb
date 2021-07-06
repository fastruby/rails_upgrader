class UsersController < ApplicationController
  before_filter :index
  after_filter :index
  skip_before_filter :index
  skip_after_filter :index
  
  def index
    @users = User.all
  end
end
