-- Create tables
CREATE TABLE IF NOT EXISTS genres (
  genre_id SERIAL PRIMARY KEY,
  genre_name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS movies (
  movie_id SERIAL PRIMARY KEY,
  movie_title TEXT NOT NULL,
  release_year INTEGER NOT NULL,
  genre_id INTEGER REFERENCES genres(genre_id) ON DELETE CASCADE,
  director_name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS customers (
  customer_id SERIAL PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone_number TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS rentals (
  rental_id SERIAL PRIMARY KEY,
  customer_id INTEGER REFERENCES customers(customer_id) ON DELETE CASCADE,
  movie_id INTEGER REFERENCES movies(movie_id) ON DELETE CASCADE,
  rental_date DATE NOT NULL,
  return_date DATE NOT NULL
);

-- Insert sample data
INSERT INTO genres (genre_name) VALUES 
    ('Crime'),
    ('Action'),
    ('Drama'),
    ('Fantasy');

INSERT INTO movies (movie_title, release_year, genre_id, director_name) VALUES 
    ('The Godfather', 1972, 1, 'Francis Ford Coppola'),
    ('The Dark Knight', 2008, 2, 'Christopher Nolan'),
    ('Schindler''s List', 1993, 3, 'Steven Spielberg'),
    ('Pulp Fiction', 1994, 1, 'Quentin Tarantino'),
    ('The Lord of the Rings: The Fellowship of the Ring', 2001, 4, 'Peter Jackson');

INSERT INTO customers (first_name, last_name, email, phone_number) VALUES
    ('John', 'Doe', 'john.doe@example.com', '123-456-7890'),
    ('Jane', 'Smith', 'jane.smith@example.com', '234-567-8901'),
    ('Mike', 'Johnson', 'mike.johnson@example.com', '345-678-9012'),
    ('Emily', 'Brown', 'emily.brown@example.com', '456-789-0123'),
    ('Chris', 'Lee', 'chris.lee@example.com', '567-890-1234');

INSERT INTO rentals (customer_id, movie_id, rental_date, return_date) VALUES 
    (1, 1, '2024-10-01', '2024-12-07'),
    (2, 2, '2024-10-02', '2024-10-08'),
    (3, 3, '2024-10-03', '2024-12-09'),
    (4, 4, '2024-10-04', '2024-10-10'),
    (5, 5, '2024-10-05', '2024-10-11'),
    (1, 2, '2024-10-06', '2024-11-12'),
    (2, 3, '2024-10-07', '2024-10-13'),
    (3, 4, '2024-10-08', '2024-12-14'),
    (4, 5, '2024-10-09', '2024-10-15'),
    (5, 1, '2024-10-10', '2024-10-16');

-- Queries to solve specific tasks
-- 1. Find all movies rented by a specific customer, given their email.
SELECT movies.movie_title, movies.release_year, movies.genre_id, movies.director_name
FROM movies
JOIN rentals ON movies.movie_id = rentals.movie_id
JOIN customers ON customers.customer_id = rentals.customer_id
WHERE customers.email = 'jane.smith@example.com';

-- 2. Given a movie title, list all customers who have rented the movie
SELECT customers.first_name, customers.last_name
FROM customers
JOIN rentals ON rentals.customer_id = customers.customer_id
JOIN movies ON rentals.movie_id = movies.movie_id 
WHERE movies.movie_title = 'The Godfather';  -- Added semicolon

-- 3. Get the rental history for a specific movie title
SELECT rentals.rental_id, movies.movie_title, customers.first_name, customers.last_name
FROM rentals
JOIN movies ON rentals.movie_id = movies.movie_id
JOIN customers ON customers.customer_id = rentals.customer_id
WHERE movies.movie_title = 'Pulp Fiction';

-- 4. For a specific movie director, find the customer name, rental date, and movie title for each rental
SELECT customers.first_name, customers.last_name, rentals.rental_date, movies.movie_title
FROM customers
JOIN rentals ON rentals.customer_id = customers.customer_id
JOIN movies ON rentals.movie_id = movies.movie_id
WHERE movies.director_name = 'Quentin Tarantino';

-- 5. List all currently rented out movies (movies whose return dates haven't been met)
SELECT movies.movie_title, rentals.rental_date, rentals.return_date
FROM movies
JOIN rentals ON rentals.movie_id = movies.movie_id
WHERE rentals.return_date > CURRENT_DATE;