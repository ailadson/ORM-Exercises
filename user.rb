require_relative 'database_object'

class User < DatabaseObject
  TABLE_NAME = 'users'

  def self.find_by_name(fname, lname)
    data = QuestionsDatabase.instance.execute(<<-SQL, fname: fname, lname: lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = :fname AND lname = :lname
    SQL
    self.new_objects(data)
  end

  attr_accessor :fname, :lname
  attr_reader :id

  def initialize(data)
    @id = data["id"]
    @fname = data["fname"]
    @lname = data["lname"]
  end

  def ask_question(title, body)
    Question.new("title" => title, "body" => body, "user_id" => @id)
  end

  def reply_to(post, body)
    post.make_reply(self, body)
  end

  def authored_questions
    Question.find_by_user_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollow.followed_question_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    data = QuestionsDatabase.instance.execute(<<-SQL).first
      SELECT
        (COALESCE(COUNT(ql.question_id), 0) /
        CAST( COUNT(DISTINCT questions.id) AS FLOAT)) AS avg
      FROM
        questions
      LEFT OUTER JOIN
        question_likes AS ql ON ql.question_id = questions.id
      WHERE
        questions.user_id = #{@id}
    SQL
    data['avg']
  end
end
