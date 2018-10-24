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
