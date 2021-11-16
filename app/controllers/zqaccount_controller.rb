require 'zqaccount'
class ZqaccountController < ApplicationController

  def is_login?
    account = ZqAccount.where(id: cookies[:user_id].to_i, token: cookies[:token]).take
    if account.nil?
      return false
    end
    if Time.now.to_i > account.token_date.to_i
      return false
    end
    return account
  end

  def login_success
    redirect_to "/zqaccount/my"
  end

  def sign_in
    @message = params[:message].nil? ? "" : params[:message]
    if account = is_login?
      login_success
      return
    end
    render "sign_in", layout: "zq_application"
  end

  def do_sign_in
    begin
      account = ZqAccount.where(phone: params[:phone], password: lgdmd5(params[:password])).take
      if account.nil?
        redirect_to action: :sign_in, message: "用户名或密码不正确"
        return
      end
      token = lgdmd5(Time.now.to_i)
      account.token = token
      account.token_date = params[:remember] ? (Time.now + 60 * 24 * 60 * 60) : (Time.now + 24 * 60 * 60)
      account.save
      cookies[:user_id] = {
        value: account.id,
        expires: params[:remember] ? 60.day.from_now : 1.day.from_now
      }
      cookies[:token] = {
        value: token,
        expires: params[:remember] ? 60.day.from_now : 1.day.from_now
      }
      login_success
    rescue
      redirect_to action: :sign_in, message: "登陆失败"
    end
  end

  def sign_up
    if account = is_login?
      login_success
      return
    end
    @message = params[:message].nil? ? "" : params[:message]
    render "sign_up", layout: "zq_application"
  end

  def do_sign_up
    phone = params[:phone].strip 
    password = params[:password].strip
    unless phone =~ /^(14[0-9]|13[0-9]|15[0-9]|16[0-9]|17[0-9]|18[0-9])\d{8}$$/
      redirect_to action: :sign_up, message: "手机号格式不正确"
      return
    end
    if password.size < 6 || password.size > 12
      redirect_to action: :sign_up, message: "密码长度应为6-12位"
      return
    end
    if ZqAccount.exists?(phone: phone)
      redirect_to action: :sign_up, message: "该手机号已注册"
      return
    end
    account = ZqAccount.new
    account.phone = phone
    account.password = lgdmd5(password)
    account.token = ""
    account.token_date = Time.now
    account.save
    redirect_to action: :sign_in, message: "注册成功，请登陆"
  end

  def password_new
    unless account = is_login?
      redirect_to action: :sign_in
      return
    end
    @account = account
    @message = params[:message].nil? ? "" : params[:message]
    render "password_new", layout: "zq_application"
  end

  def do_password_new
    unless account = is_login?
      redirect_to action: :sign_in
      return
    end
    phone = params[:phone].strip
    password = params[:password].strip
    if account.phone != phone
      redirect_to action: :password_new, message: "与注册手机号不一致"
      return
    end
    if password.size < 6 || password.size > 12
      redirect_to action: :password_new, message: "密码长度应为6-12位"
      return
    end
    account.password = lgdmd5(password)
    account.save
    redirect_to action: :my, message: "密码重置成功"
  end

  def send_code
    begin
      phone = params[:phone].strip 
      code = params[:code].strip
      unless phone =~ /^(14[0-9]|13[0-9]|15[0-9]|16[0-9]|17[0-9]|18[0-9])\d{8}$$/
        render json: {status: 0}
        return
      end
      s = SendCode.where(phone: phone).take || SendCode.new
      s.phone = phone
      s.code = code
      s.status = 0
      s.save
      render json: {status: 1}
    rescue
      logger.info "sendcode error: #{params[:phone]} #{params[:code]} "
      render json: {status: 0}
    end
  end

  def my
    unless account = is_login?
      redirect_to action: :sign_in
      return
    end
    @page = params[:page].to_i || 0
    @account = account
    @message = params[:message].nil? ? "" : params[:message]
    @infos = ZqTask.where(created_user: @account.id).select(:id, :name, :phone, :pcode, :tbid, :place, :status, :reason).order("id desc").offset(50 * @page).limit(50)
    @tab = 2
    render "my", layout: "zq_application"
  end

  def sign_out
    unless account = is_login?
      redirect_to action: :sign_in
      return
    end
    cookies.delete :user_id
    cookies.delete :token
    redirect_to "/zqaccount/sign_in"
  end

end
