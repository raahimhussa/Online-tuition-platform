import { query } from '../../../../lib/db';

// GET a single subject by ID
export async function GET(req, { params }) {
    try {
        const { id } = params;
        const text = 'SELECT * FROM subjects WHERE subject_id = $1';
        const result = await query(text, [id]);

        if (result.rows.length === 0) {
            return new Response(JSON.stringify({ message: 'Subject not found' }), {
                status: 404,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        return new Response(JSON.stringify(result.rows[0]), {
            status: 200,
            headers: { 'Content-Type': 'application/json' }
        });
    } catch (error) {
        return new Response(JSON.stringify({ message: 'Error fetching subject', error: error.message }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}

// PUT (Update) a subject by ID
export async function PUT(req, { params }) {
    try {
        const { id } = params;
        const { name, description } = await req.json();

        // Validation
        if (!name || !description) {
            return new Response(JSON.stringify({ message: 'Name and description are required' }), {
                status: 400,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        const text = `
            UPDATE subjects
            SET name = $1, description = $2
            WHERE subject_id = $3
            RETURNING *`;
        const values = [name, description, id];
        const result = await query(text, values);

        if (result.rows.length === 0) {
            return new Response(JSON.stringify({ message: 'Subject not found' }), {
                status: 404,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        return new Response(JSON.stringify(result.rows[0]), {
            status: 200,
            headers: { 'Content-Type': 'application/json' }
        });
    } catch (error) {
        return new Response(JSON.stringify({ message: 'Error updating subject', error: error.message }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}

// DELETE a subject by ID
export async function DELETE(req, { params }) {
    try {
        const { id } = params;
        const text = 'DELETE FROM subjects WHERE subject_id = $1 RETURNING *';
        const result = await query(text, [id]);

        if (result.rows.length === 0) {
            return new Response(JSON.stringify({ message: 'Subject not found' }), {
                status: 404,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        return new Response(JSON.stringify({ message: 'Subject deleted successfully' }), {
            status: 200,
            headers: { 'Content-Type': 'application/json' }
        });
    } catch (error) {
        return new Response(JSON.stringify({ message: 'Error deleting subject', error: error.message }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}