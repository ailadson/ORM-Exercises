require_relative 'database_object'



#User
def user(n)
  User.find_by_id(n)
end

#question
def q(n)
  Question.find_by_id(n)
end

#replies
def reply(n)
  Reply.find_by_id(n)
end
