class TaskController < ApplicationController
  def create_task_kuaidi
    @message = params[:message].nil? ? "" : params[:message]
    unless account = is_login?
      redirect_to controller: :account, action: :sign_in, message: "请先登陆"
      return
    end
    @account = account
    @company = params[:company]
    @from = params[:from]
    @to = params[:to]
    @remark = params[:remark]
    @phone = params[:phone].nil? || params[:phone].empty? ? account.phone : params[:phone]
    @wx = params[:wx]
    @qq = params[:qq]
  end

  def create_task_daike
    @message = params[:message].nil? ? "" : params[:message]
    unless account = is_login?
      redirect_to controller: :account, action: :sign_in, message: "请先登陆"
      return
    end
    @account = account
    @remark = params[:remark]
    @phone = params[:phone].nil? || params[:phone].empty? ? account.phone : params[:phone]
    @wx = params[:wx]
    @qq = params[:qq]
  end

  def create_task_jianzhi
    @message = params[:message].nil? ? "" : params[:message]
    unless account = is_login?
      redirect_to controller: :account, action: :sign_in, message: "请先登陆"
      return
    end
    @account = account
    @remark = params[:remark]
    @phone = params[:phone].nil? || params[:phone].empty? ? account.phone : params[:phone]
    @wx = params[:wx]
    @qq = params[:qq]
    @content = params[:content]
    @place = params[:place]
    @work_time = params[:work_time]
    @price = params[:price]
  end

  def create_task_ershou
    @message = params[:message].nil? ? "" : params[:message]
    unless account = is_login?
      redirect_to controller: :account, action: :sign_in, message: "请先登陆"
      return
    end
    @account = account
    @content = params[:content]
    @price = params[:price]
    @detail = params[:detail]
    @remark = params[:remark]
    @phone = params[:phone].nil? || params[:phone].empty? ? account.phone : params[:phone]
    @wx = params[:wx]
    @qq = params[:qq]
    @token = Token.take
  end

  def create_task_other
    @message = params[:message].nil? ? "" : params[:message]
    unless account = is_login?
      redirect_to controller: :account, action: :sign_in, message: "请先登陆"
      return
    end
    @account = account
    @remark = params[:remark]
    @phone = params[:phone].nil? || params[:phone].empty? ? account.phone : params[:phone]
    @wx = params[:wx]
    @qq = params[:qq]
  end

  def do_create_task_kuaidi
    unless account = is_login?
      redirect_to controller: :account, action: :sign_in, message: "请先登陆"
      return
    end
    begin
      count = Task.where(created_user: account.id, status: [0,1]).count
      if(count >= 5)
        redirect_to action: :create_task_kuaidi, message: "单用户发布任务不得超过5条", company: params[:company], from: params[:from], to: params[:to], remark: params[:remark], phone: params[:phone], qq: params[:qq], wx: params[:wx]
        return
      end
      if(params[:phone].empty? && params[:qq].empty? && params[:wx].empty?)
        redirect_to action: :create_task_kuaidi, message: "请留一种联系方式", remark: params[:remark], phone: params[:phone], qq: params[:qq], wx: params[:wx]
        return
      end
      price = params[:price].to_i
      task = Task.new
      task.task_type = 1
      task.title = "代取快递 - 跑腿费#{price}元"
      task.subtitle = "#{params[:from]} 至 #{params[:to]}"
      task.price = price
      task.created_user = account.id
      task.transaction do
        task.save
        detail = TaskKuaidi.new
        detail.task_id = task.id
        detail.company = params[:company]
        detail.from = params[:from]
        detail.to = params[:to]
        detail.price = price
        detail.remark = params[:remark]
        detail.phone = params[:phone]
        detail.qq = params[:qq]
        detail.wx = params[:wx]
        detail.save
      end
      redirect_to action: :show, id: task.id
    rescue
      redirect_to action: :create_task_kuaidi, message: "创建任务失败", company: params[:company], from: params[:from], to: params[:to], remark: params[:remark], phone: params[:phone], qq: params[:qq], wx: params[:wx]
    end
  end

  def do_create_task_daike
    unless account = is_login?
      redirect_to controller: :account, action: :sign_in, message: "请先登陆"
      return
    end
    begin
      count = Task.where(created_user: account.id, status: [0,1]).count
      if(count >= 5)
        redirect_to action: :create_task_daike, message: "单用户发布任务不得超过5条", remark: params[:remark], phone: params[:phone], qq: params[:qq], wx: params[:wx]
        return
      end
      if(params[:phone].empty? && params[:qq].empty? && params[:wx].empty?)
        redirect_to action: :create_task_daike, message: "请留一种联系方式", remark: params[:remark], phone: params[:phone], qq: params[:qq], wx: params[:wx]
        return
      end
      price = params[:price].to_i
      task = Task.new
      task.task_type = 2
      task.title = "代课 - 代课费#{price}元"
      task.subtitle = "#{params[:class_date]} #{params[:class_time]}#{params[:class_count]} 要求：#{params[:gender]}"
      task.price = price
      task.created_user = account.id
      task.transaction do
        task.save
        detail = TaskDaike.new
        detail.task_id = task.id
        detail.price = price
        detail.gender = params[:gender] == "男" ? 1 : 2
        detail.class_date = params[:class_date]
        detail.class_time = params[:class_time]
        detail.class_count = params[:class_count]
        detail.remark = params[:remark]
        detail.phone = params[:phone]
        detail.qq = params[:qq]
        detail.wx = params[:wx]
        detail.save
      end
      redirect_to action: :show, id: task.id
    rescue
      redirect_to action: :create_task_daike, message: "创建任务失败",  remark: params[:remark], phone: params[:phone], qq: params[:qq], wx: params[:wx]
    end
  end

  def do_create_task_jianzhi
    unless account = is_login?
      redirect_to controller: :account, action: :sign_in, message: "请先登陆"
      return
    end
    begin
      count = Task.where(created_user: account.id, status: [0,1]).count
      if(count >= 5)
        redirect_to action: :create_task_jianzhi, message: "单用户发布任务不得超过5条", remark: params[:remark], phone: params[:phone], qq: params[:qq], wx: params[:wx], content: params[:content], place: params[:place], work_time: params[:work_time], price: params[:price]
        return
      end
      if(params[:phone].empty? && params[:qq].empty? && params[:wx].empty?)
        redirect_to action: :create_task_jianzhi, message: "请留至少一种联系方式", remark: params[:remark], phone: params[:phone], qq: params[:qq], wx: params[:wx], content: params[:content], place: params[:place], work_time: params[:work_time], price: params[:price]
        return
      end
      task = Task.new
      task.task_type = 3
      task.title = "#{params[:content]}"
      task.subtitle = "#{params[:place]} #{params[:work_time]} #{params[:price]} 要求：#{params[:gender]}"
      task.price = 0
      task.created_user = account.id
      task.transaction do
        task.save
        detail = TaskJianzhi.new
        detail.task_id = task.id
        detail.price = params[:price]
        detail.gender = params[:gender] == "不限" ? 0 : params[:gender] == "男" ?  1 : 2
        detail.content = params[:content]
        detail.place = params[:place]
        detail.work_time = params[:work_time]
        detail.remark = params[:remark]
        detail.phone = params[:phone]
        detail.qq = params[:qq]
        detail.wx = params[:wx]
        detail.save
      end
      redirect_to action: :show, id: task.id
    rescue
      redirect_to action: :create_task_jianzhi, message: "创建任务失败", remark: params[:remark], phone: params[:phone], qq: params[:qq], wx: params[:wx], content: params[:content], place: params[:place], work_time: params[:work_time], price: params[:price]
    end
  end

  def do_create_task_ershou
    unless account = is_login?
      redirect_to controller: :account, action: :sign_in, message: "请先登陆"
      return
    end
    begin
      count = Task.where(created_user: account.id, status: [0,1]).count
      if(count >= 5)
        redirect_to action: :create_task_ershou, message: "单用户发布任务不得超过5条", remark: params[:remark], phone: params[:phone], qq: params[:qq], wx: params[:wx], content: params[:content], place: params[:place], work_time: params[:work_time], price: params[:price]
        return
      end
      if(params[:phone].empty? && params[:qq].empty? && params[:wx].empty?)
        redirect_to action: :create_task_ershou, message: "请留至少一种联系方式", remark: params[:remark], phone: params[:phone], qq: params[:qq], wx: params[:wx], content: params[:content], place: params[:place], work_time: params[:work_time], price: params[:price]
        return
      end
      task = Task.new
      task.task_type = 4
      task.title = "#{params[:content]}"
      task.subtitle = "#{params[:price]} #{params[:detail]}"
      task.price = 0
      task.created_user = account.id
      task.transaction do
        task.save
        detail = TaskErshou.new
        detail.task_id = task.id
        detail.content = params[:content]
        detail.imgs = params[:imgs]
        detail.price = params[:price]
        detail.detail = params[:detail]
        detail.remark = params[:remark]
        detail.phone = params[:phone]
        detail.qq = params[:qq]
        detail.wx = params[:wx]
        detail.save
      end
      redirect_to action: :show, id: task.id
    rescue
      redirect_to action: :create_task_ershou, message: "创建任务失败", remark: params[:remark], phone: params[:phone], qq: params[:qq], wx: params[:wx], content: params[:content], price: params[:price], detail: params[:detail]
    end
  end

  def do_create_task_other
    unless account = is_login?
      redirect_to controller: :account, action: :sign_in, message: "请先登陆"
      return
    end
    begin
      count = Task.where(created_user: account.id, status: [0,1]).count
      if(count >= 5)
        redirect_to action: :create_task_other, message: "单用户发布任务不得超过5条", remark: params[:remark], phone: params[:phone], qq: params[:qq], wx: params[:wx], title: params[:title], subtitle: params[:subtitle]
        return
      end
      if(params[:phone].empty? && params[:qq].empty? && params[:wx].empty?)
        redirect_to action: :create_task_other, message: "请留至少一种联系方式", remark: params[:remark], phone: params[:phone], qq: params[:qq], wx: params[:wx], title: params[:title], subtitle: params[:subtitle]
        return
      end
      task = Task.new
      task.task_type = 99
      task.title = params[:title]
      task.subtitle = params[:subtitle]
      task.price = 0
      task.created_user = account.id
      task.transaction do
        task.save
        detail = TaskOther.new
        detail.task_id = task.id
        detail.title = params[:title]
        detail.subtitle = params[:subtitle]
        detail.remark = params[:remark]
        detail.phone = params[:phone]
        detail.qq = params[:qq]
        detail.wx = params[:wx]
        detail.save
      end
      redirect_to action: :show, id: task.id
    rescue
      redirect_to action: :create_task_other, message: "创建任务失败", remark: params[:remark], phone: params[:phone], qq: params[:qq], wx: params[:wx], title: params[:title], subtitle: params[:subtitle]
    end
  end

  def show
    @task = Task.where(id: params[:id].to_i).take
    not_found if @task.nil?
    @account = nil
    if account = is_login?
      @account = account
    end
    if @task.status == -1
      render :task_deleted
      return
    end
    if @task.task_type == 1
      @detail = TaskKuaidi.where(task_id: @task.id).take
      not_found if @detail.nil?
    elsif @task.task_type == 2
      @detail = TaskDaike.where(task_id: @task.id).take
      not_found if @detail.nil?
    elsif @task.task_type == 3
      @detail = TaskJianzhi.where(task_id: @task.id).take
      not_found if @detail.nil?
    elsif @task.task_type == 4
      @detail = TaskErshou.where(task_id: @task.id).take
      @img = @task.default_img
      imgs = @detail.imgs.split(',')
      if imgs.size > 0
        @img = "https://lgdpub.oss-cn-beijing.aliyuncs.com/#{imgs[0]}"
      end
      not_found if @detail.nil?
    elsif @task.task_type == 99
      @detail = TaskOther.where(task_id: @task.id).take
      not_found if @detail.nil?
    else
      not_found
    end
    @relation = TURelation.where(task_id: @task.id, status: 1).take
    @ruser = nil
    if @relation
      @ruser = Account.where(id: @relation.user_id).take
    end
    @tasks = Task.where(status: 0, task_type: @task.task_type).where.not(id: @task.id).select(:id, :title, :subtitle, :task_type, :created_at)
  end

  def task_list
    @account = nil
    if account = is_login?
      @account = account
    end
    @tasks = Task.where(status: 0).select(:id, :title, :subtitle, :task_type, :created_at).order("id desc").to_a
    @task_1 = @tasks.select{|t| t.task_type == 1}
    @task_2 = @tasks.select{|t| t.task_type == 2}
    @task_3 = @tasks.select{|t| t.task_type == 3}
    @task_4 = @tasks.select{|t| t.task_type == 4}
    @task_5 = @tasks.select{|t| t.task_type == 99}
    @tab = 2
  end

  def create
    @account = nil
    if account = is_login?
      @account = account
    end
    @tab = 3
  end

  def take
    @account = nil
    if account = is_login?
      @account = account
    else
      redirect_to "/account/sign_in/"
      return
    end
    task = Task.where(id: params[:id].to_i, status: 0).take
    not_found if task.nil?
    if TURelation.exists?(task_id: task.id, status: 1)
      redirect_to "/task/#{task.id}/"
      return
    end
    if task.created_user == @account.id
      redirect_to "/task/#{task.id}/"
      return
    end
    task.transaction do
      task.status = 1
      task.save
      r = TURelation.new
      r.task_id = task.id
      r.user_id = @account.id
      r.status = 1
      r.save
    end
    redirect_to "/task/#{task.id}/"
  end

  def delete
    @account = nil
    if account = is_login?
      @account = account
    else
      redirect_to "/account/sign_in/"
      return
    end
    task = Task.where(id: params[:id].to_i, status: [0,1]).take
    not_found if task.nil?
    if task.created_user != @account.id
      redirect_to "/task/#{task.id}/"
      return
    end
    task.status = -1
    task.save
    redirect_to "/task/#{task.id}/"
  end

  def confirm
    @account = nil
    if account = is_login?
      @account = account
    else
      redirect_to "/account/sign_in/"
      return
    end
    task = Task.where(id: params[:id].to_i, status: [0,1]).take
    not_found if task.nil?
    if task.created_user != @account.id
      redirect_to "/task/#{task.id}/"
      return
    end
    task.status = 2
    task.save
    redirect_to "/task/#{task.id}/"
  end
end
