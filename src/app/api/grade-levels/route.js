import { query } from '../../../lib/db';

export async function GET() {
    try {
        // Step 1: Query the database for grade levels
        const text = 'SELECT grade_level_id, domain, sub_level FROM grade_levels';
        const result = await query(text);
        const gradeLevels = result.rows;

        // Step 2: Return the grade levels
        return new Response(JSON.stringify(gradeLevels), {
            status: 200,
            headers: { 'Content-Type': 'application/json' }
        });

    } catch (error) {
        // Step 3: Handle errors
        console.error('Error fetching grade levels:', error.message);
        return new Response(JSON.stringify({ message: 'Internal server error', error: error.message }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}
// POST - Create a new grade level
export async function POST(req) {
    try {
        const { domain, sub_level } = await req.json();
        const result = await query(
            'INSERT INTO grade_levels (domain, sub_level) VALUES ($1, $2) RETURNING *',
            [domain, sub_level]
        );
        return new Response(JSON.stringify(result.rows[0]), {
            status: 201,
            headers: { 'Content-Type': 'application/json' }
        });
    } catch (error) {
        return new Response(JSON.stringify({ message: 'Error adding grade level', error: error.message }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}

// PUT - Update a grade level
export async function PUT(req) {
    try {
        const { grade_level_id, domain, sub_level } = await req.json();
        const result = await query(
            'UPDATE grade_levels SET domain = $1, sub_level = $2 WHERE grade_level_id = $3 RETURNING *',
            [domain, sub_level, grade_level_id]
        );
        return new Response(JSON.stringify(result.rows[0]), {
            status: 200,
            headers: { 'Content-Type': 'application/json' }
        });
    } catch (error) {
        return new Response(JSON.stringify({ message: 'Error updating grade level', error: error.message }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}

// DELETE - Remove a grade level
export async function DELETE(req) {
    try {
        const { grade_level_id } = await req.json();
        await query('DELETE FROM grade_levels WHERE grade_level_id = $1', [grade_level_id]);
        return new Response(JSON.stringify({ message: 'Grade level deleted' }), {
            status: 200,
            headers: { 'Content-Type': 'application/json' }
        });
    } catch (error) {
        return new Response(JSON.stringify({ message: 'Error deleting grade level', error: error.message }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}