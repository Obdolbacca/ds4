SET search_path TO first, public;
--- Table creation
CREATE TABLE first.films (
  id serial PRIMARY KEY,
  title text NOT NULL,
  country varchar(256),
  box_office bigint,
  release_year timestamp
);

CREATE TABLE first.persons (
  id serial PRIMARY KEY,
  fio text
);

CREATE TABLE first.persons2content (
  films_id integer references first.films(id),
  persons_id integer references first.persons(id),
  person_type varchar(256)
);

CREATE UNIQUE INDEX title_country_uniqueness ON first.films (title, country);
CREATE UNIQUE INDEX persons_fio_uniqueness ON first.persons (fio);
--- Insertions
INSERT INTO films (title, country, box_office, release_year) VALUES ('Test film1', 'Russia', 114344555, to_timestamp('2009-01-01 00:00:00', 'YYYY-MM-DD hh24:mi:ss')::timestamp),
                                                                          ('Test film2', 'Brazil', 1144555, to_timestamp('2015-01-01 00:00:00', 'YYYY-MM-DD hh24:mi:ss')::timestamp),
                                                                          ('Test film3', 'Canada', 1144334555, to_timestamp('2011-01-01 00:00:00', 'YYYY-MM-DD hh24:mi:ss')::timestamp),
                                                                          ('Test film4', 'Republic of Moldova', 11444555, to_timestamp('2015-01-01 00:00:00', 'YYYY-MM-DD hh24:mi:ss')::timestamp),
                                                                          ('Test film5', 'USA', 114444555, to_timestamp('2015-01-01 00:00:00', 'YYYY-MM-DD hh24:mi:ss')::timestamp);

INSERT INTO persons (fio) VALUES ('Какой-то мужик1'), ('Какой-то мужик2'), ('Какой-то мужик3'), ('Какая-то тётка1'), ('Какой-то мужик4');

INSERT INTO persons2content VALUES (1,1,'Свет держал'), (2,2,'"Мотор" кричал'), (3,3,'Площадку охранял'), (4,4,'Кофе подавала'), (5,5,'Инспектор постельных сцен');

--- Tables from slides 15, 17

CREATE SCHEMA first_2;

SET search_path TO first_2, public;

CREATE TABLE first_2.films_15 (
  title text,
  editor varchar(256),
  has_oscar boolean NOT NULL,
  IMDB_rating integer CONSTRAINT is_IMDB_rating CHECK ( IMDB_rating >0 AND IMDB_rating < 11 ),
  PRIMARY KEY (title, editor)
);

CREATE TABLE first_2.films17 (
  title text PRIMARY KEY,
  has_oscar boolean NOT NULL,
  country varchar(256)
);
