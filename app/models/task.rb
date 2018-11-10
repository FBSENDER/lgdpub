class Task < ApplicationRecord
  attr_accessor :img_url 
  self.table_name = 'lgd_tasks'
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

