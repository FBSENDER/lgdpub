require 'zqaccount'
class ZqtaskController < ApplicationController
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

  def create_info
    @message = params[:message].nil? ? "" : params[:message]
    unless account = is_login?
      redirect_to controller: :zqaccount, action: :sign_in, message: "请先登陆"
      return
    end
    @account = account
    @name = params[:name]
    @phone = params[:phone]
    @tbid = params[:tbid]
    @pcode = params[:pcode]
    @place = params[:place]
    @tab = 1
    render "create_info", layout: "zq_application"
  end

  def batch_create_info
    @message = params[:message].nil? ? "" : params[:message]
    unless account = is_login?
      redirect_to controller: :zqaccount, action: :sign_in, message: "请先登陆"
      return
    end
    @account = account
    @tab = 1
    render "batch_create_info", layout: "zq_application"
  end

  def do_batch_create_info
    unless account = is_login?
      redirect_to controller: :zqaccount, action: :sign_in, message: "请先登陆"
      return
    end
    begin
      batch_text = params[:batch_text] || ""
      rows = batch_text.split("\n")
      if rows.size > 0 && rows.size <= 500
        redirect_to controller: :zqaccount, action: :my, message: "批量录入进行中，请耐心等待"
        rows.each do |row|
          r = row.split(',')
          task = ZqTask.new
          task.name = r[0].strip
          task.phone = r[1].strip
          task.pcode = r[2].strip
          task.tbid = r[3].strip
          task.place = r[4].strip
          task.created_user = account.id
          task.save
        end
      else
        if rows.size > 500
          redirect_to action: :batch_create_info, message: "批量录入失败，超过500行"
        else
          redirect_to action: :batch_create_info, message: "请输入数据"
        end
      end
    rescue
      redirect_to action: :batch_create_info, message: "批量录入失败"
    end
  end



  def do_create_info
    unless account = is_login?
      redirect_to controller: :zqaccount, action: :sign_in, message: "请先登陆"
      return
    end
    begin
      task = ZqTask.new
      task.name = params[:name] || ""
      task.phone = params[:phone] || ""
      task.pcode = params[:pcode] || ""
      task.tbid = params[:tbid] || ""
      task.place = params[:place] || ""
      task.created_user = account.id
      task.save
      redirect_to controller: :zqaccount, action: :my
    rescue
      redirect_to action: :create_info, message: "录入失败", name: params[:name], pcode: params[:pcode], place: params[:place], tbid: params[:tbid], phone: params[:phone]
    end
  end

  def get_init_infos
    begin
      infos = ZqTask.where(status: 1).select(:id, :name, :phone, :pcode, :tbid, :place, :status).order(:id).limit(10).to_a
      render json: {status: 1, data:infos}
    rescue
      render json: {status: 0}
    end
  end

  def update_infos
    begin
      t = ZqTask.where(id: params[:id].to_i).take
      t.status = params[:status].to_i
      t.reason = params[:reason].to_s.strip
      t.save
      render json: {status: 1}
    rescue
      render json: {status: 0}
    end
  end
end
