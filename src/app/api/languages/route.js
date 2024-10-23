import { query } from '../../../lib/db';

export async function GET() {   
    try {
        // Step 1: Query the database for languages
        const text = 'SELECT language_id, name FROM languages';
        const result = await query(text);
        const languages = result.rows;

        // Step 2: Return the languages
        return new Response(JSON.stringify(languages), {
            status: 200,
            headers: { 'Content-Type': 'application/json' }
        });

    } catch (error) {
        // Step 3: Handle errors
        console.error('Error fetching languages:', error.message);
        return new Response(JSON.stringify({ message: 'Internal server error', error: error.message }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}