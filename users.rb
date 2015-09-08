load 'questions_database.rb'
load 'database_object.rb'

class Users < DatabaseObject
  TABLE_NAME = 'users'

  def self.table_name
    TABLE_NAME
  end

  attr_accessor :fname, :lname

  def initialize(data)
    @id = data["id"]
    @fname = data["fname"]
    @lname = data["lname"]
  end
end
