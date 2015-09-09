require_relative 'database_object'

class Reply < DatabaseObject
  TABLE_NAME = "replies"

  def self.find_by_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id: user_id)
      SELECT
       *
      FROM
       replies
      WHERE
       user_id = :user_id
    SQL
    self.new_objects(data)
  end

  def self.find_by_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = :question_id
    SQL
    self.new_objects(data)
  end

  attr_accessor :body

  def initialize(data)
    @id = data["id"]
    @body = data["body"]
    @user_id = data["user_id"]
    @parent_reply_id = data["parent_reply_id"]
    @question_id = data["question_id"]
  end

  def make_reply(user, body)
    Reply.new("user_id" => user.id, "body" => body, "question_id" => @question_id,
              "parent_reply_id" => @id)
  end

  def author
    User.find_by_id(@user_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    Reply.find_by_id(@parent_reply_id)
  end

  def child_replies
    data = QuestionsDatabase.instance.execute(<<-SQL, id: @id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_reply_id = :id
    SQL
    Reply.new_objects(data)
  end
end
