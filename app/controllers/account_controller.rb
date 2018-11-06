class AccountController < ApplicationController

  def sign_in
    @message = params[:message].nil? ? "" : params[:message]
    if account = is_login?
      login_success
      return
    end
  end

  def do_sign_in
    begin
      account = Account.where(phone: params[:phone], password: lgdmd5(params[:password])).take
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
  end

  def do_sign_up
    phone = params[:phone].strip 
    password = params[:password].strip
    unless phone =~ /^(14[0-9]|13[0-9]|15[0-9]|17[0-9]|18[0-9])\d{8}$$/
      redirect_to action: :sign_up, message: "手机号格式不正确"
      return
    end
    if password.size < 6 || password.size > 12
      redirect_to action: :sign_up, message: "密码长度应为6-12位"
      return
    end
    if Account.exists?(phone: phone)
      redirect_to action: :sign_up, message: "该手机号已注册"
      return
    end
    account = Account.new
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
      unless phone =~ /^(14[0-9]|13[0-9]|15[0-9]|17[0-9]|18[0-9])\d{8}$$/
        render json: {status: 0}
        return
      end
      `python ~/dysms_python/lgd_sms_send.py #{phone} #{code} >> lgd_sms.log`
      render json: {status: 1}
    rescue
      logger.info "sendcode error: #{params[:phone]} #{params[:code]} "
      render json: {status: 0}
    end
  end

  def profile
    unless account = is_login?
      redirect_to action: :sign_in
      return
    end
    @account = account
    @message = params[:message].nil? ? "" : params[:message]
  end

  def update_profile
    unless account = is_login?
      redirect_to action: :sign_in
      return
    end
    begin
      if account.detail.nil?
        account.detail = AccountDetail.new
        account.detail.user_id = account.id
      end
      account.detail.user_name = params[:user_name].strip
      account.detail.real_name = params[:real_name].strip
      account.detail.degree = params[:degree] == '本科' ? 1 : params[:degree] == '研究生' ? 2 : 0
      account.detail.grade = params[:grade].to_i > 2000 ? params[:grade].to_i : 0
      account.detail.college = params[:college] != "选择学院" ? params[:college] : ""
      account.detail.save
      redirect_to action: :my, message: "更新资料成功"
    rescue
      redirect_to action: :profile, message: "更新资料失败"
    end
  end

  def my
    unless account = is_login?
      redirect_to action: :sign_in
      return
    end
    @account = account
    @message = params[:message].nil? ? "" : params[:message]
    @my_published_tasks = Task.where(created_user: account.id).select(:id, :title, :subtitle).order("id desc")

    taked_ids = TURelation.where(user_id: @account.id).pluck(:task_id)
    @my_taked_tasks = Task.where(id: taked_ids).select(:id, :title, :subtitle).order("id desc")
  end

  def sign_out
    unless account = is_login?
      redirect_to action: :sign_in
      return
    end
    cookies.delete :user_id
    cookies.delete :token
    redirect_to "/task/"
  end

  def feedback
    unless account = is_login?
      redirect_to action: :sign_in, message: "请先登陆"
      return
    end
    @account = account
    @message = params[:message].nil? ? "" : params[:message]
  end

  def do_feedback
    unless account = is_login?
      redirect_to action: :sign_in, message: "请先登陆"
      return
    end
    begin
      feedback = Feedback.new
      feedback.user_id = account.id
      feedback.content = params[:content]
      feedback.save
      redirect_to action: :feedback, message: "反馈成功"
    rescue
      redirect_to action: :feedback, message: "反馈信息提交失败"
    end
  end

end
