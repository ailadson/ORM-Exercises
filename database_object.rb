require_relative 'questions_database'

class DatabaseObject

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id: id).first
      SELECT
        *
      FROM
        #{table_name}
      WHERE
       id = :id
    SQL

    self.new(data)
  end
end
