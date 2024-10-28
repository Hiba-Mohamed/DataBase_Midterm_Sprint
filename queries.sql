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
    