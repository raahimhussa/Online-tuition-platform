// src/app/api/teachers/availability/route.js
import { verifyToken } from '../../../../lib/auth';
import { saveTeacherAvailability, getTeacherIdByUserId } from '../../../../lib/teacherService';

export async function POST(req) {
    try {
        const token = req.headers.get('Authorization').split(' ')[1];
        const userId = verifyToken(token);

        if (!userId) {
            return new Response(JSON.stringify({ message: 'Invalid token' }), {
                status: 401,
                headers: { 'Content-Type': 'application/json' },
            });
        }

        const { availability } = await req.json();

        // Get the teacher_id from the user ID
        const teacherId = await getTeacherIdByUserId(userId.id);

        // Insert new availability based on request data
        for (const [day, { checked, slots }] of Object.entries(availability)) {
            if (checked) {
                for (const slot of slots) {
                    await saveTeacherAvailability({
                        teacher_id: teacherId,
                        day,
                        start_time: slot.start,
                        end_time: slot.end,
                    });
                }
            }
        }

        return new Response(JSON.stringify({ message: 'Teacher availability added successfully' }), {
            status: 201,
            headers: { 'Content-Type': 'application/json' },
        });
    } catch (error) {
        console.error('Error adding availability:', error);
        return new Response(JSON.stringify({ message: 'Failed to add availability', error: error.message }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' },
        });
    }
}
