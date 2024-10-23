import { query } from '../../../../lib/db';

export async function POST(req) {
    try {
        const { name } = await req.json();
        const result = await query('INSERT INTO languages (name) VALUES ($1) RETURNING *', [name]);
        return new Response(JSON.stringify(result.rows[0]), {
            status: 201,
            headers: { 'Content-Type': 'application/json' },
        });
    } catch (error) {
        return new Response(JSON.stringify({ message: 'Error adding language', error: error.message }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' },
        });
    }
}

export async function PUT(req) {
    try {
        const { language_id, name } = await req.json();
        const result = await query('UPDATE languages SET name = $1 WHERE language_id = $2 RETURNING *', [name, language_id]);
        return new Response(JSON.stringify(result.rows[0]), {
            status: 200,
            headers: { 'Content-Type': 'application/json' },
        });
    } catch (error) {
        return new Response(JSON.stringify({ message: 'Error updating language', error: error.message }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' },
        });
    }
}

export async function DELETE(req) {
    try {
        const { language_id } = await req.json();
        await query('DELETE FROM languages WHERE language_id = $1', [language_id]);
        return new Response(JSON.stringify({ message: 'Language deleted' }), {
            status: 200,
            headers: { 'Content-Type': 'application/json' },
        });
    } catch (error) {
        return new Response(JSON.stringify({ message: 'Error deleting language', error: error.message }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' },
        });
    }
}