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
  parent_reply_id INTEGER REFERENCES replies(id) NOT NULL,
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
  ('Robert', 'Baratheon');
