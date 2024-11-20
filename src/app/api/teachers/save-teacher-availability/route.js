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
        const teacherId = await getTeacherIdByUserId(userId.id);

        // Create an array to hold all the save operations
        const availabilityPromises = [];

        // Iterate over availability and prepare promises for each slot
        Object.entries(availability).forEach(([day, { checked, slots }]) => {
            if (checked) {
                slots.forEach((slot) => {
                    availabilityPromises.push(
                        saveTeacherAvailability({
                            teacher_id: teacherId,
                            day,
                            start_time: slot.start,
                            end_time: slot.end,
                        })
                    );
                });
            }
        });

        // Execute all save operations concurrently
        await Promise.all(availabilityPromises);

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
