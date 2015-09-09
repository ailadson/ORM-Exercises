require_relative 'questions_database'

class DatabaseObject

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id: id).first
      SELECT
        *
      FROM
        #{self::TABLE_NAME}
      WHERE
       id = :id
    SQL
    self.new(data)
  end

  def self.new_objects(data)
    data.map{ |attributes| self.new(attributes) }
  end

  def save
    if @id
      QuestionsDatabase.instance.execute(<<-SQL, id: @id)
        UPDATE
          #{self.class::TABLE_NAME}
        SET
          #{update_statement}
        WHERE
          id = :id
      SQL
    else
      QuestionsDatabase.instance.execute(<<-SQL)
        INSERT INTO
          #{self.class::TABLE_NAME}#{insert_statement}
        VALUES
          #{value_statement}
      SQL
    end
    self
  end

  def update_statement
    values = []
    mapped_vars = instance_variables.map{ |var| var[1..-1].to_sym }
    mapped_vars.drop(1).each{ |var| values << "#{var} = '#{send(var)}'" }
    "#{values.join(", ")}"
  end

  def insert_statement
    mapped_vars = instance_variables.map{ |var| var.to_s[1..-1] }
    "(#{mapped_vars.drop(1).join(", ")})"
  end

  def value_statement
    values = []
    mapped_vars = instance_variables.map{ |var| var[1..-1].to_sym }
    mapped_vars.drop(1).each{ |var| values << "'#{send(var)}'" }
    "(#{values.join(", ")})"
  end
end

require_relative 'reply'
require_relative 'user'
require_relative 'question'
require_relative 'question_follow'
require_relative 'question_like'
