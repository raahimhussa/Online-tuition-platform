import { query } from '../../../lib/db';

export async function GET() {
    try {
        // Step 1: Query the database for cities
        const text = 'SELECT city_id, city_name, region FROM cities';
        const result = await query(text);
        const cities = result.rows;

        // Step 2: Return the cities
        return new Response(JSON.stringify(cities), {
            status: 200,
            headers: { 'Content-Type': 'application/json' }
        });

    } catch (error) {
        // Step 3: Handle errors
        console.error('Error fetching cities:', error.message);
        return new Response(JSON.stringify({ message: 'Internal server error', error: error.message }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}
// POST - Create a new city
export async function POST(req) {
    try {
        const { city_name, region } = await req.json();
        const result = await query(
            'INSERT INTO cities (city_name, region) VALUES ($1, $2) RETURNING *',
            [city_name, region]
        );
        return new Response(JSON.stringify(result.rows[0]), {
            status: 201,
            headers: { 'Content-Type': 'application/json' }
        });
    } catch (error) {
        return new Response(JSON.stringify({ message: 'Error adding city', error: error.message }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}

// PUT - Update a city
export async function PUT(req) {
    try {
        const { city_id, city_name, region } = await req.json();
        const result = await query(
            'UPDATE cities SET city_name = $1, region = $2 WHERE city_id = $3 RETURNING *',
            [city_name, region, city_id]
        );
        return new Response(JSON.stringify(result.rows[0]), {
            status: 200,
            headers: { 'Content-Type': 'application/json' }
        });
    } catch (error) {
        return new Response(JSON.stringify({ message: 'Error updating city', error: error.message }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}

// DELETE - Remove a city
export async function DELETE(req) {
    try {
        const { city_id } = await req.json();
        await query('DELETE FROM cities WHERE city_id = $1', [city_id]);
        return new Response(JSON.stringify({ message: 'City deleted' }), {
            status: 200,
            headers: { 'Content-Type': 'application/json' }
        });
    } catch (error) {
        return new Response(JSON.stringify({ message: 'Error deleting city', error: error.message }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}
