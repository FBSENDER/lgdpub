class Account < ApplicationRecord
  attr_accessor :detail
  self.table_name = 'lgd_accounts'
end

class AccountDetail < ApplicationRecord
  self.table_name = 'lgd_account_details'
end

class Feedback < ApplicationRecord
  self.table_name = 'lgd_feedbacks'
end

class SendCode < ApplicationRecord
  self.table_name = 'lgd_send_code'
end

class Token < ApplicationRecord
  self.table_name = 'lgd_tokens'
end

class Student < ApplicationRecord
  self.table_name = 'lgd_students'
end
