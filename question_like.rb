require_relative 'database_object'

class QuestionLike
  TABLE_NAME = "question_likes"

  def self.likers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id)
      SELECT
        users.*
      FROM
        users
      JOIN
        question_likes AS ql ON ql.user_id = users.id
      WHERE
        ql.question_id = :question_id
    SQL

    User.new_objects(data)
  end

  def self.num_likes_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id).first
      SELECT
        COUNT(ql.id) AS count
      FROM
        question_likes AS ql
      WHERE
        ql.question_id = :question_id
    SQL

    data["count"]
  end

  def self.liked_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id: user_id)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_likes AS ql ON ql.question_id = questions.id
      WHERE
        ql.user_id = :user_id
    SQL

    Question.new_objects(data)
  end

  def self.most_liked_questions(n)
    data = QuestionsDatabase.instance.execute(<<-SQL, n: n)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_likes AS ql ON ql.question_id = questions.id
      GROUP BY
        ql.question_id
      ORDER BY
        COUNT(ql.user_id) DESC
      LIMIT
        :n
    SQL

    Question.new_objects(data)
  end
end
