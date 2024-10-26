import { query } from './db';  // Import the query function

// Create a new user in the 'users' table
// Function to create a new user in the users table
// Create user function
// Create user function with role
export async function createUser({ email, hashedPassword, name, phone_number, gender, dob, city_id, area, role, profile_picture }) {
  const text = `INSERT INTO users (email, password_hash, name, phone_number, gender, role, profile_picture, city_id, area, dob)
                VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING *;`;
  const values = [email, hashedPassword, name, phone_number, gender, role, profile_picture, city_id, area, dob];
  const result = await query(text, values);
  return result.rows[0];
}

  // Function to get user by ID

// get all users
export async function getAllUsers() {
    const result = await query(`SELECT * FROM users`);
    return result.rows;
}

