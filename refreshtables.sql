DROP TABLE videos;
CREATE TABLE videos (
  id SERIAL8,
  title VARCHAR(140),
  description VARCHAR(500),
  genre VARCHAR(30)
);