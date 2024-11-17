// src/app/api/teachers/complete-profile/route.js
import { createTeacherProfile,addTeacherGradeLevels,addTeacherLanguages,addTeacherSubjects} from '../../../../lib/teacherService';

// import { getUserById } from '../../../../lib/userService';

import { verifyToken } from '../../../../lib/auth';

export async function POST(req) {
    try {
        // Extract the token and payload (Assuming you are using JWT)
        const token = req.headers.get('Authorization').split(' ')[1];
        const userId = verifyToken(token);  // Extract user ID from the token
        console.log(userId)
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

        // Log the received values for debugging
        console.log('Received Values:', {
            user_id: userId.id,
            teaching_mode,
            bio,
            experience_years,
            hourly_rate,
            education,
            duration_per_session
        });

        // Create the teacher's profile
        const newTeacherProfile = await createTeacherProfile({
            user_id: userId.id,
            teaching_mode,
            bio,
            experience_years,
            hourly_rate,
            education,
            duration_per_session
        });

        // Handle multiple languages
        // eslint-disable-next-line no-restricted-syntax
        for (const languageId of languages) {
            // eslint-disable-next-line no-await-in-loop
            await addTeacherLanguages(newTeacherProfile.teacher_id, languageId);
        }

        // Handle multiple grade levels
        // eslint-disable-next-line no-restricted-syntax
        for (const gradeLevelId of grade_levels) {
            // eslint-disable-next-line no-await-in-loop
            await addTeacherGradeLevels(newTeacherProfile.teacher_id, gradeLevelId);
        }

        // Handle multiple subjects
        // eslint-disable-next-line no-restricted-syntax
        for (const subjectId of subjects) {
            // eslint-disable-next-line no-await-in-loop
            await addTeacherSubjects(newTeacherProfile.teacher_id, subjectId);
        }

        return new Response(JSON.stringify({
            message: 'Teacher profile created successfully',
            teacher: newTeacherProfile
        }), {
            status: 201,
            headers: { 'Content-Type': 'application/json' },
        });

    } catch (error) {
        console.error('Error:', error);
        return new Response(JSON.stringify({ message: 'Failed to create profile', error: error.message }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' },
        });
    }
}
