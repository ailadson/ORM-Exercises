require_relative 'database_object'

class QuestionFollow < DatabaseObject
  TABLE_NAME = 'question_follows'

  def self.followers_for_question(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id)
      SELECT
        users.*
      FROM
        users
      JOIN
        question_follows AS qf ON qf.user_id = users.id
      WHERE
        qf.question_id = :question_id
    SQL
    User.new_objects(data)
  end

  def self.followed_question_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id: user_id)
      SELECT
        questions.*
      FROM
        questions
      JOIN
       question_follows AS qf ON qf.question_id = questions.id
      WHERE
        :user_id = qf.user_id
    SQL
    Question.new_objects(data)
  end

  def self.most_followed_questions(n)
    data = QuestionsDatabase.instance.execute(<<-SQL, n: n)
      SELECT
        questions.*
      FROM
        questions
      JOIN
       question_follows AS qf ON qf.question_id = questions.id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(questions.id) DESC
      LIMIT
        :n
    SQL
    Question.new_objects(data)
  end

  # def initialize
  #
  # end

end
