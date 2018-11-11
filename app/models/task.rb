class Task < ApplicationRecord
  self.table_name = 'lgd_tasks'
  def default_img
    case self.task_type
    when 1 
      return "http://lgdpub.oss-cn-beijing.aliyuncs.com/task/task_kuaidi.png"
    when 2 
      return "http://lgdpub.oss-cn-beijing.aliyuncs.com/task/task_daike.png"
    when 3 
      return "http://lgdpub.oss-cn-beijing.aliyuncs.com/task/task_jianzhi.png"
    when 4 
      return "http://lgdpub.oss-cn-beijing.aliyuncs.com/task/task_ershou.png"
    else
      return "http://lgdpub.oss-cn-beijing.aliyuncs.com/task/task_zidingyi.png"
    end
  end
end

class TURelation < ApplicationRecord
  self.table_name = 'lgd_task_user_relations'
end

class TaskKuaidi < ApplicationRecord
  self.table_name = 'lgd_task_kuaidi'
end

class TaskDaike < ApplicationRecord
  self.table_name = 'lgd_task_daike'
end

class TaskJianzhi < ApplicationRecord
  self.table_name = 'lgd_task_jianzhi'
end

class TaskErshou < ApplicationRecord
  self.table_name = 'lgd_task_ershou'
end

class TaskOther < ApplicationRecord
  self.table_name = 'lgd_task_other'
end

