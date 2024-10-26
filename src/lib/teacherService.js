// lib/teacherService.js
import { query } from './db';

// create teacher
export async function createTeacherProfile({ user_id, teaching_mode, bio, experience_years, hourly_rate, education, duration_per_session }) {
    const text = `
        INSERT INTO teachers (user_id, teaching_mode, bio, experience_years, hourly_rate, education, duration_per_session)
        VALUES ($1, $2, $3, $4, $5, $6, $7)
        RETURNING *`;
    const values = [user_id, teaching_mode, bio, experience_years, hourly_rate, education, duration_per_session];
    const result = await query(text, values);
    return result.rows[0];
}
// get all
export async function getAllTeachers() {
    const text = `
      SELECT 
        t.teacher_id, 
        u.name, 
        u.email, 
        u.phone_number, 
        u.gender, 
        u.dob, 
        u.profile_picture, 
        u.area, 
        c.city_name, 
        t.teaching_mode, 
        t.bio, 
        t.is_verified,  -- Updated field name
        t.experience_years, 
        t.education, 
        t.rating, 
        t.hourly_rate,
        t.duration_per_session,  -- Added duration_per_session
        array_agg(DISTINCT lang.name) AS languages,  -- Aggregate languages
        array_agg(DISTINCT gl.sub_level) AS grade_levels,  -- Aggregate grade levels
        array_agg(DISTINCT s.name) AS subjects  -- Aggregate subjects
      FROM teachers t
      JOIN users u ON t.user_id = u.user_id
      LEFT JOIN cities c ON u.city_id = c.city_id
      LEFT JOIN teacher_languages tl ON tl.teacher_id = t.teacher_id
      LEFT JOIN languages lang ON tl.language_id = lang.language_id
      LEFT JOIN teacher_grade_levels tgl ON tgl.teacher_id = t.teacher_id
      LEFT JOIN grade_levels gl ON tgl.grade_level_id = gl.grade_level_id
      LEFT JOIN teacher_subjects ts ON ts.teacher_id = t.teacher_id
      LEFT JOIN subjects s ON ts.subject_id = s.subject_id
      GROUP BY t.teacher_id, u.user_id, c.city_name;  -- Group by to avoid aggregation errors
    `;
    const result = await query(text);
    return result.rows;
}

// get by id
export async function getTeacherById(id) {
    const result = await query(`
        SELECT 
            u.user_id, 
            u.email, 
            u.name, 
            u.phone_number, 
            u.gender, 
            u.dob, 
            u.city_id, 
            u.area, 
            t.teaching_mode, 
            t.bio, 
            t.is_verified,  -- Updated field name
            t.experience_years, 
            t.education, 
            t.rating, 
            t.hourly_rate,
            t.duration_per_session,  -- Added duration_per_session
            c.city_name, 
            c.region,
            array_agg(DISTINCT lang.name) AS languages,  -- Aggregate languages
            array_agg(DISTINCT gl.sub_level) AS grade_levels,  -- Aggregate grade levels
            array_agg(DISTINCT s.name) AS subjects  -- Aggregate subjects
        FROM teachers t
        JOIN users u ON u.user_id = t.user_id
        LEFT JOIN cities c ON u.city_id = c.city_id
        LEFT JOIN teacher_languages tl ON tl.teacher_id = t.teacher_id
        LEFT JOIN languages lang ON tl.language_id = lang.language_id
        LEFT JOIN teacher_grade_levels tgl ON tgl.teacher_id = t.teacher_id
        LEFT JOIN grade_levels gl ON tgl.grade_level_id = gl.grade_level_id
        LEFT JOIN teacher_subjects ts ON ts.teacher_id = t.teacher_id
        LEFT JOIN subjects s ON ts.subject_id = s.subject_id
        WHERE t.user_id = $1
        GROUP BY u.user_id, t.teacher_id, c.city_name, c.region
    `, [id]);

    return result.rows[0];  // Return the first row of the result
}

// Update teacher profile
export async function updateTeacherProfile(user_id, updates) {
    const { name, phone_number, gender, dob, city_id, area, teaching_mode, bio, experience_years, education, hourly_rate } = updates;

    // Start a transaction
    await query('BEGIN');

    try {
        // Update the users table
        await query(`
            UPDATE users
            SET name = $1, phone_number = $2, gender = $3, dob = $4, city_id = $5, area = $6, updated_at = NOW()
            WHERE user_id = $7
        `, [name, phone_number, gender, dob, city_id, area, user_id]);

        // Update the teachers table
        await query(`
            UPDATE teachers
            SET teaching_mode = $1, bio = $2, experience_years = $3, education = $4, hourly_rate = $5, updated_at = NOW()
            WHERE user_id = $6
        `, [teaching_mode, bio, experience_years, education, hourly_rate, user_id]);

        // Commit the transaction
        await query('COMMIT');
        return { message: 'Teacher profile updated successfully' };
    } catch (err) {
        // Rollback if there's an error
        await query('ROLLBACK');
        throw new Error('Failed to update teacher profile');
    }
}

// Delete teacher profile
export async function deleteTeacherProfile(user_id) {
    const result = await query('DELETE FROM users WHERE user_id = $1 RETURNING *', [user_id]);
    return result.rowCount;
}
export async function addTeacherGradeLevels(teacherId, gradeLevelId) {
    const text = `
        INSERT INTO teacher_grade_levels (teacher_id, grade_level_id)
        VALUES ($1, $2)
        RETURNING *`;
    
    const values = [teacherId, gradeLevelId];
    const result = await query(text, values); // Use the imported query function
    return result.rows[0]; // Return the newly created row
}
export async function addTeacherSubjects(teacherId, subjectId) {
    const text = `
        INSERT INTO teacher_subjects (teacher_id, subject_id)
        VALUES ($1, $2)
        RETURNING *`;
    
    const values = [teacherId, subjectId];
    const result = await query(text, values); // Use the imported query function
    return result.rows[0]; // Return the newly created row
}

export async function addTeacherLanguages(teacherId, languageId) {
    const text = `
        INSERT INTO teacher_languages (teacher_id, language_id)
        VALUES ($1, $2)
        RETURNING *`;
    const values = [teacherId, languageId];
    const result = await query(text, values); // Use the imported query function
    return result.rows[0]; // Return the newly created row
}
