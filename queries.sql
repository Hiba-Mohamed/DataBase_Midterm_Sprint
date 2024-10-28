-- Provide PostgreSQL queries to create the tables
CREATE TABLE IF NOT EXISTS movies (
    movie_id SERIAL PRIMARY KEY,
    movie_title TEXT NOT NULL,
    release_year INTEGER NOT NULL,
    movie_genre TEXT NOT NULL,
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

-- Provide queries to insert sample data into the tables. Insert at least:
-- 5 movies
INSERT INTO movies (movie_title, release_year, movie_genre, director_name) VALUES 
    ('The Godfather', 1972, 'Crime', 'Francis Ford Coppola'),
    ('The Dark Knight', 2008, 'Action', 'Christopher Nolan'),
    ('Schindler''s List', 1993, 'Drama', 'Steven Spielberg'),
    ('Pulp Fiction', 1994, 'Crime', 'Quentin Tarantino'),
    ('The Lord of the Rings: The Fellowship of the Ring', 2001, 'Fantasy', 'Peter Jackson')
RETURNING *;

-- 5 customers
INSERT INTO customers (first_name, last_name, email, phone_number) VALUES
    ('John', 'Doe', 'john.doe@example.com', '123-456-7890'),
    ('Jane', 'Smith', 'jane.smith@example.com', '234-567-8901'),
    ('Mike', 'Johnson', 'mike.johnson@example.com', '345-678-9012'),
    ('Emily', 'Brown', 'emily.brown@example.com', '456-789-0123'),
    ('Chris', 'Lee', 'chris.lee@example.com', '567-890-1234')
RETURNING *;

-- 10 rentals
INSERT INTO rentals (customer_id, movie_id, rental_date, return_date) VALUES 
    (1, 1, '2024-10-01', '2024-10-07'),
    (2, 2, '2024-10-02', '2024-10-08'),
    (3, 3, '2024-10-03', '2024-10-09'),
    (4, 4, '2024-10-04', '2024-10-10'),
    (5, 5, '2024-10-05', '2024-10-11'),
    (1, 2, '2024-10-06', '2024-10-12'),
    (2, 3, '2024-10-07', '2024-10-13'),
    (3, 4, '2024-10-08', '2024-10-14'),
    (4, 5, '2024-10-09', '2024-10-15'),
    (5, 1, '2024-10-10', '2024-10-16')
RETURNING *;

-- Provide PostgreSQL queries to solve the following:
-- 1- Find all movies rented by a specific customer, given their email.

-- 2- Given a movie title, list all customers who have rented the movie

-- 3- Get the rental history for a specific movie title

-- 4- For a specific movie director:
--    Find the name of the customer, the date of the rental and title of the movie, each time a movie by that director was rented

-- 5- List all currently rented out movies (movies who's return dates haven't been met)