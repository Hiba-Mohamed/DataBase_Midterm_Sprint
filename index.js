const { Pool } = require("pg");
require("dotenv").config();

const config = {
  user: process.env.DB_USER,
  host: "localhost",
  database: process.env.DB_DATABASE,
  password: process.env.DB_PASSWORD,
  port: 5432,
};
// PostgreSQL connection
const pool = new Pool(config);

/**
 * Creates the database tables, if they do not already exist.
 */
async function createTable() {
  // TODO: Add code to create Movies, Customers, and Rentals tables

  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS movies (
        movie_id SERIAL PRIMARY KEY,
        movie_title TEXT NOT NULL,
        release_year INTEGER NOT NULL,
        movie_genre TEXT NOT NULL,
        director_name TEXT NOT NULL
      );
    `);

    await pool.query(`
      CREATE TABLE IF NOT EXISTS customers (
        customer_id SERIAL PRIMARY KEY,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone_number TEXT NOT NULL
      );
    `);

    await pool.query(`
      CREATE TABLE IF NOT EXISTS rentals (
        rental_id SERIAL PRIMARY KEY,
        customer_id INTEGER REFERENCES customers(customer_id) ON DELETE CASCADE,
        movie_id INTEGER REFERENCES movies(movie_id) ON DELETE CASCADE,
        rental_date DATE NOT NULL,
        return_date DATE NOT NULL
      );
    `);
    console.log(
      "---------------------------------------------------------------------"
    );
    console.log(
      "| OK    Movies, Customers, and Rentals tables created successfully! |"
    );
    console.log(
      "---------------------------------------------------------------------"
    );
  } catch (error) {
    console.log(
      "---------------------------------------------------------------------"
    );
    console.log(
      "| X    Error happened while creating tables:                        |"
    );
    console.log(
      "---------------------------------------------------------------------"
    );
    console.error(error);
  }
}

/**
 * Inserts a new movie into the Movies table.
 *
 * @param {string} title Title of the movie
 * @param {number} year Year the movie was released
 * @param {string} genre Genre of the movie
 * @param {string} director Director of the movie
 */
async function insertMovie(title, year, genre, director) {
  // TODO: Add code to insert a new movie into the Movies table
  const query =
    "INSERT INTO movies (movie_title, release_year, movie_genre, director_name) VALUES ($1,$2,$3,$4) RETURNING *";
  const result = await pool.query(query, [title, year, genre, director]);
  console.log(
    `Added movie: ${result.rows[0].movie_title} by ${result.rows[0].director_name}`
  );
}

async function insertCustomer(first, last, email, phone) {
  const query =
    "INSERT INTO customers (first_name, last_name, email, phone_number) VALUES ($1,$2,$3,$4) RETURNING *";
  const result = await pool.query(query, [first, last, email, phone]);
  console.log(
    `Added customer: ${result.rows[0].first_name} ${result.rows[0].last_name}"," ${result.rows[0].phone_number}`
  );
}

async function insertRental(customer_id, movie_id, rental_date, return_date) {
  const query =
    "INSERT INTO rentals (customer_id, movie_id, rental_date, return_date) VALUES ($1,$2,$3,$4) RETURNING *";
  const result = await pool.query(query, [
    customer_id,
    movie_id,
    rental_date,
    return_date,
  ]);
  console.log(
    `Added rental: ${result.rows[0].rental_id}", Customer: " ${result.rows[0].customer_id}", Movie:" ${result.rows[0].movie_id}`
  );
}
/**
 * Prints all movies in the database to the console
 */
async function displayMovies() {
  // TODO: Add code to retrieve and print all movies from the Movies table
  const query = "SELECT * FROM movies";
  const result = await pool.query(query);
  result.rows.forEach((movie) => {
    console.log(
      "Movie: ",
      movie.movie_title,
      "| ",
      "Director: ",
      movie.director_name
    );
  });
}

/**
 * Updates a customer's email address.
 *
 * @param {number} customerId ID of the customer
 * @param {string} newEmail New email address of the customer
 */
async function updateCustomerEmail(customerId, newEmail) {
  // TODO: Add code to update a customer's email address
}

/**
 * Removes a customer from the database along with their rental history.
 *
 * @param {number} customerId ID of the customer to remove
 */
async function removeCustomer(customerId) {
  // TODO: Add code to remove a customer and their rental history
}

/**
 * Prints a help message to the console
 */
function printHelp() {
  console.log("Usage:");
  console.log("  insert <title> <year> <genre> <director> - Insert a movie");
  console.log("  show - Show all movies");
  console.log("  update <customer_id> <new_email> - Update a customer's email");
  console.log("  remove <customer_id> - Remove a customer from the database");
}

async function hasMovies() {
  const result = await pool.query("SELECT * FROM movies");
  console.log(result.rows.length);
  const rows = result.rows;
  if (rows.length > 0) {
    return true;
  } else {
    return false;
  }
}
/**
 * Runs our CLI app to manage the movie rentals database
 */
async function runCLI() {
  await createTable();

  const check = await hasMovies();

  if (!check) {
    await insertSampleData();
  }

  const args = process.argv.slice(2);
  switch (args[0]) {
    case "insert":
      if (args.length !== 5) {
        printHelp();
        return;
      }
      await insertMovie(args[1], parseInt(args[2]), args[3], args[4]);
      break;
    case "show":
      await displayMovies();
      break;
    case "update":
      if (args.length !== 3) {
        printHelp();
        return;
      }
      await updateCustomerEmail(parseInt(args[1]), args[2]);
      break;
    case "remove":
      if (args.length !== 2) {
        printHelp();
        return;
      }
      await removeCustomer(parseInt(args[1]));
      break;
    default:
      printHelp();
      break;
  }
}

async function insertSampleData() {
  await insertMovie("The Godfather", 1972, "Crime", "Francis Ford Coppola");
  await insertMovie("The Dark Knight", 2008, "Action", "Christopher Nolan");
  await insertMovie("Schindler's List", 1993, "Drama", "Steven Spielberg");
  await insertMovie("Pulp Fiction", 1994, "Crime", "Quentin Tarantino");
  await insertMovie(
    "The Lord of the Rings: The Fellowship of the Ring",
    2001,
    "Fantasy",
    "Peter Jackson"
  );

  await insertCustomer("John", "Doe", "john.doe@example.com", "123-456-7890");
  await insertCustomer(
    "Jane",
    "Smith",
    "jane.smith@example.com",
    "234-567-8901"
  );
  await insertCustomer(
    "Mike",
    "Johnson",
    "mike.johnson@example.com",
    "345-678-9012"
  );
  await insertCustomer(
    "Emily",
    "Brown",
    "emily.brown@example.com",
    "456-789-0123"
  );
  await insertCustomer("Chris", "Lee", "chris.lee@example.com", "567-890-1234");

  await insertRental(1, 1, "2024-10-01", "2024-10-07");
  await insertRental(2, 2, "2024-10-02", "2024-10-08");
  await insertRental(3, 3, "2024-10-03", "2024-10-09");
  await insertRental(4, 4, "2024-10-04", "2024-10-10");
  await insertRental(5, 5, "2024-10-05", "2024-10-11");
  await insertRental(1, 2, "2024-10-06", "2024-10-12");
  await insertRental(2, 3, "2024-10-07", "2024-10-13");
  await insertRental(3, 4, "2024-10-08", "2024-10-14");
  await insertRental(4, 5, "2024-10-09", "2024-10-15");
  await insertRental(5, 1, "2024-10-10", "2024-10-16");
}

runCLI();
