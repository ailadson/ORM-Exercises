require_relative 'database_object'

class Question < DatabaseObject
  TABLE_NAME = "questions"

  def self.find_by_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id: user_id)
      SELECT
       *
      FROM
       questions
      WHERE
       user_id = :user_id
    SQL

    self.new_objects(data)
  end

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  attr_accessor :title, :body
  attr_reader :id

  def initialize(data)
    @id = data["id"]
    @title = data["title"]
    @body = data["body"]
    @user_id = data["user_id"]
  end

  def make_reply(user, body)
    Reply.new("user_id" => user.id, "body" => body, "question_id" => @id,
              "parent_reply_id" => 'NULL')
  end

  def author
    User.find_by_id(@user_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollow.followers_for_question(@id)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end
end
