DROP TABLE IF EXISTS users;

CREATE TABLE users
(
  id INTEGER PRIMARY KEY NOT NULL,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions
(
  id INTEGER PRIMARY KEY NOT NULL,
  title VARCHAR(255) NOT NULL,
  body TEXT,
  user_id INTEGER REFERENCES users(id) NOT NULL
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows
(
  id INTEGER PRIMARY KEY NOT NULL,
  question_id INTEGER REFERENCES questions(id) NOT NULL,
  user_id INTEGER REFERENCES users(id) NOT NULL
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies
(
  id INTEGER PRIMARY KEY NOT NULL,
  question_id INTEGER REFERENCES questions(id) NOT NULL,
  parent_reply_id INTEGER REFERENCES replies(id),
  user_id INTEGER REFERENCES users(id) NOT NULL,
  body TEXT
);


DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes
(
  id INTEGER PRIMARY KEY NOT NULL,
  question_id INTEGER REFERENCES questions(id) NOT NULL,
  user_id INTEGER REFERENCES users(id) NOT NULL
);

INSERT INTO
  users(fname, lname)
VALUES
  ('Eddard', 'Stark'),
  ('Robert', 'Baratheon'),
  ('Person1', 'Ditto'),
  ('Person2', 'Ditto');

INSERT INTO
  questions(title, body, user_id)
VALUES
  ('I Am King', 'Who sits the Iron Throne?', 2),
  ('Dummy Title', "I'm a person!", 3),
  ('Winter', 'Is it coming?', 1);

INSERT INTO
  replies(question_id, parent_reply_id, user_id, body)
VALUES
  (1, NULL, 1, 'Robert, First of His Name'),
  (1, 1, 3, 'Of House Ditto!!!!!!one1!'),
  (1, 2, 2, "THATS NOT HIS HOUSE"),
  (2, NULL, 2, 'YES IT IS');

INSERT INTO
  question_follows(question_id, user_id)
VALUES
  (1, 1),
  (1, 2),
  (2, 3),
  (2, 4),
  (2, 2);

INSERT INTO
  question_likes(user_id, question_id)
VALUES
  (1, 1),
  (2, 1),
  (3, 1),
  (2, 3);
