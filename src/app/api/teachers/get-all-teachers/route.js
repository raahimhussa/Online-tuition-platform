import { getAllTeachers } from '../../../../lib/teacherService';

export async function GET(req) {
    try {
        const teachers = await getAllTeachers();
        return new Response(JSON.stringify(teachers), {
            status: 200,
            headers: { 'Content-Type': 'application/json' }
        });
    } catch (error) {
        console.error('Error fetching teachers:', error); // Log the error for debugging
        return new Response(JSON.stringify({ message: 'Error fetching teachers', error: error.message }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}
