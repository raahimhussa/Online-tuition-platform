// src/app/api/teachers/update-teacher-profile/route.js
import { 
    updateTeacherProfile, 
    updateTeacherLanguages, 
    updateTeacherGradeLevels, 
    updateTeacherSubjects 
} from '../../../../lib/teacherService';

import { verifyToken } from '../../../../lib/auth';

export async function PUT(req) {
    try {
        // Extract the token from the request
        const token = req.headers.get('Authorization').split(' ')[1];
        const userId = verifyToken(token); // Extract user ID from the token

        if (!userId) {
            return new Response(JSON.stringify({ message: 'Invalid token' }), {
                status: 401,
                headers: { 'Content-Type': 'application/json' },
            });
        }

        // Extract the teacher-specific details from the request body
        const { 
            teaching_mode, 
            bio, 
            experience_years, 
            hourly_rate, 
            education, 
            languages, 
            grade_levels, 
            subjects, 
            duration_per_session 
        } = await req.json();

        console.log('Updating Values:', {
            user_id: userId.id,
            teaching_mode,
            bio,
            experience_years,
            hourly_rate,
            education,
            duration_per_session
        });

        // Update the teacher's main profile details
        const updatedTeacherProfile = await updateTeacherProfile({
            user_id: userId.id,
            teaching_mode,
            bio,
            experience_years,
            hourly_rate,
            education,
            duration_per_session
        });

        // Update languages, grade levels, and subjects
        await updateTeacherLanguages(updatedTeacherProfile.teacher_id, languages);
        // await updateTeacherGradeLevels(updatedTeacherProfile.teacher_id, grade_levels);
        // await updateTeacherSubjects(updatedTeacherProfile.teacher_id, subjects);

        return new Response(JSON.stringify({
            message: 'Teacher profile updated successfully',
            teacher: updatedTeacherProfile
        }), {
            status: 200,
            headers: { 'Content-Type': 'application/json' },
        });

    } catch (error) {
        console.error('Error:', error);
        return new Response(JSON.stringify({ message: 'Failed to update profile', error: error.message }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' },
        });
    }
}
