// src/app/api/teachers/availability/route.js
import { verifyToken } from '../../../../lib/auth';
import { getTeacherAvailabilityByTeacherId, getTeacherIdByUserId } from '../../../../lib/teacherService';

export async function GET(req) {
    try {
        // Extract token from headers and verify
        const token = req.headers.get('Authorization')?.split(' ')[1];
        const userId = verifyToken(token);

        if (!userId) {
            return new Response(JSON.stringify({ message: 'Invalid token' }), {
                status: 401,
                headers: { 'Content-Type': 'application/json' },
            });
        }

        // Get teacher ID using the user ID extracted from the token
        const teacherId = await getTeacherIdByUserId(userId.id);

        // Retrieve availability for the teacher
        const availability = await getTeacherAvailabilityByTeacherId(teacherId);

        return new Response(JSON.stringify(availability), {
            status: 200,
            headers: { 'Content-Type': 'application/json' },
        });
    } catch (error) {
        console.error('Error retrieving availability:', error);
        return new Response(JSON.stringify({ message: 'Failed to retrieve availability', error: error.message }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' },
        });
    }
}
