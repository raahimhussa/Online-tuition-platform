import { query } from './db';  // Import the query function

// Create a new user in the 'users' table
// Function to create a new user in the users table
// Create user function
// Create user function with role
export async function createUser({ email, hashedPassword, name, phone_number, gender, age, city_id, area, role }) {
    const text = `INSERT INTO users (email, password_hash, name, phone_number, gender, age, city_id, area, role)
                  VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *`;
    const values = [email, hashedPassword, name, phone_number, gender, age, city_id, area, role];
    const result = await query(text, values);
    return result.rows[0];
  }
  // Function to get user by ID

// get all users
export async function getAllUsers() {
    const result = await query(`SELECT * FROM users`);
    return result.rows;
}
