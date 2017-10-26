class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :project_id
end
