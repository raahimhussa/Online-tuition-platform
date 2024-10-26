// src/app/api/users/fetch-user/route.js
import { verifyToken } from '../../../lib/auth';
import {query} from '../../../lib/db';


export async function GET(req) {
    try {
        // Extract the token from the Authorization header
        const token = req.headers.get('Authorization')?.split(' ')[1];
        
        // Verify the token and extract the user ID
        const userId = verifyToken(token);
        if (!userId) {
            return new Response(JSON.stringify({ message: 'Invalid token' }), {
                status: 401,
                headers: { 'Content-Type': 'application/json' },
            });
        }

        // Fetch the user data from the database
        const result = await query('SELECT * FROM users WHERE user_id = $1', [userId.id]);
        if (result.rowCount === 0) {
            return new Response(JSON.stringify({ message: 'User not found' }), {
                status: 404,
                headers: { 'Content-Type': 'application/json' },
            });
        }

        // Extract only the relevant user data
        const user = result.rows[0];
        const filteredUserData = {
            user_id: user.user_id,
            email: user.email,
            name: user.name,
            phone_number: user.phone_number,
            gender: user.gender,
            role: user.role,
            city_id: user.city_id,
            area: user.area,
            created_at: user.created_at,
            updated_at: user.updated_at,
            dob: user.dob,
        };

        // Return the filtered user data
        return new Response(JSON.stringify(filteredUserData), {
            status: 200,
            headers: { 'Content-Type': 'application/json' },
        });

    } catch (error) {
        console.error('Error fetching user data:', error);
        return new Response(JSON.stringify({ message: 'Failed to fetch user data', error: error.message }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' },
        });
    }
}
export async function PUT(req) {
    try {
        // Extract the token from the Authorization header
        const token = req.headers.get('Authorization')?.split(' ')[1];

        // Verify the token and extract the user ID
        const userId = verifyToken(token);
        if (!userId) {
            return new Response(JSON.stringify({ message: 'Invalid token' }), {
                status: 401,
                headers: { 'Content-Type': 'application/json' },
            });
        }

        // Parse the request body to get updated user data
        const body = await req.json();
        
        // Validate the necessary fields
        const {
            email,
            name,
            phone_number,
            gender,
            city_id,
            area,
            dob,
            profile_picture,
        } = body;

        // Ensure required fields are present
        if (!email || !name || !phone_number || !gender || !city_id || !area || !dob) {
            return new Response(JSON.stringify({ message: 'Missing required fields' }), {
                status: 400,
                headers: { 'Content-Type': 'application/json' },
            });
        }

        // Update the user data in the database
        const result = await query(
            `UPDATE users 
            SET email = $1, name = $2, phone_number = $3, gender = $4, city_id = $5, area = $6, dob = $7, profile_picture = $8, updated_at = NOW() 
            WHERE user_id = $9 RETURNING *`,
            [email, name, phone_number, gender, city_id, area, dob, profile_picture, userId.id]
        );

        if (result.rowCount === 0) {
            return new Response(JSON.stringify({ message: 'User not found or not updated' }), {
                status: 404,
                headers: { 'Content-Type': 'application/json' },
            });
        }

        // Extract the updated user data
        const updatedUser = result.rows[0];

        // Return the updated user data
        return new Response(JSON.stringify(updatedUser), {
            status: 200,
            headers: { 'Content-Type': 'application/json' },
        });

    } catch (error) {
        console.error('Error updating user data:', error);
        return new Response(JSON.stringify({ message: 'Failed to update user data', error: error.message }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' },
        });
    }
}