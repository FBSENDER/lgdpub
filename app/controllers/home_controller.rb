class HomeController < ApplicationController
  def index
    @account = nil
    if account = is_login?
      @account = account
    end
  end
end
