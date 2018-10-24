class Task < ApplicationRecord
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
