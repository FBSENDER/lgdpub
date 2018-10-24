require 'account'
require 'digest/md5'
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def lgdmd5(text)
    Digest::MD5.hexdigest("lgdpub#{text}lgdpub")
  end

  def is_login?
    account = Account.where(id: cookies[:user_id].to_i, token: cookies[:token]).take
    p account
    if account.nil?
      return false
    end
    if Time.now.to_i > account.token_date.to_i
      return false
    end
    account.detail = AccountDetail.where(user_id: account.id).take
    return account
  end

  def login_success
    redirect_to "/task/"
  end

  def not_found
    raise ActionController::RoutingError.new('NOT FOUND')
  end

end
