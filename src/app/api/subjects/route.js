import { query } from '../../../../lib/db';

export async function GET(req) {
    try {
        // SQL query to get all subjects
        const text = 'SELECT * FROM subjects';
        const result = await query(text);

        // Return the subjects in JSON format
        return new Response(JSON.stringify(result.rows), {
            status: 200,
            headers: { 'Content-Type': 'application/json' }
        });
    } catch (error) {
        return new Response(JSON.stringify({ message: 'Error fetching subjects', error: error.message }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}
