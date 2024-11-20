import { query } from './db';

// Create teacher profile
export async function createTeacherProfile({
  user_id,
  teaching_mode,
  bio,
  experience_years,
  hourly_rate,
  education,
  duration_per_session,
}) {
  const text = `
    INSERT INTO teachers (user_id, teaching_mode, bio, experience_years, hourly_rate, education, duration_per_session)
    VALUES ($1, $2, $3, $4, $5, $6, $7)
    RETURNING *`;
  const values = [
    user_id,
    teaching_mode,
    bio,
    experience_years,
    hourly_rate,
    education,
    duration_per_session,
  ];
  const result = await query(text, values);
  return result.rows[0];
}

export async function updateTeacherProfile({
  user_id,
  teaching_mode,
  bio,
  experience_years,
  hourly_rate,
  education,
  duration_per_session,
}) {
  const text = `
    UPDATE teachers
    SET 
      teaching_mode = $1,
      bio = $2,
      experience_years = $3,
      hourly_rate = $4,
      education = $5,
      duration_per_session = $6,
      updated_at = NOW()  -- optional timestamp for record keeping
    WHERE user_id = $7
    RETURNING *;
  `;

  const values = [
    teaching_mode,
    bio,
    experience_years,
    hourly_rate,
    education,
    duration_per_session,
    user_id,
  ];

  const result = await query(text, values);
  return result.rows[0];
}

// Get all teachers
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
      t.is_verified,  
      t.experience_years, 
      t.education, 
      t.rating, 
      t.hourly_rate,
      t.duration_per_session,
      array_agg(DISTINCT lang.name) AS languages,
      array_agg(DISTINCT gl.sub_level) AS grade_levels,
      array_agg(DISTINCT s.name) AS subjects 
    FROM teachers t
    JOIN users u ON t.user_id = u.user_id
    LEFT JOIN cities c ON u.city_id = c.city_id
    LEFT JOIN teacher_languages tl ON tl.teacher_id = t.teacher_id
    LEFT JOIN languages lang ON tl.language_id = lang.language_id
    LEFT JOIN teacher_grade_levels tgl ON tgl.teacher_id = t.teacher_id
    LEFT JOIN grade_levels gl ON tgl.grade_level_id = gl.grade_level_id
    LEFT JOIN teacher_subjects ts ON ts.teacher_id = t.teacher_id
    LEFT JOIN subjects s ON ts.subject_id = s.subject_id
    GROUP BY t.teacher_id, u.user_id, c.city_name;
  `;
  const result = await query(text);
  return result.rows;
}

// Update teacher languages
export async function updateTeacherLanguages(teacherId, languageIds) {
  await clearTeacherLanguages(teacherId);

  const languagePromises = languageIds.map(languageId => 
    addTeacherLanguages(teacherId, languageId)
  );
  
  await Promise.all(languagePromises);
}

// Update teacher grade levels
export async function updateTeacherGradeLevels(teacherId, gradeLevelIds) {
  await clearTeacherGradeLevels(teacherId);

  const gradeLevelPromises = gradeLevelIds.map(gradeLevelId => 
    addTeacherGradeLevels(teacherId, gradeLevelId)
  );

  await Promise.all(gradeLevelPromises);
}

// Update teacher subjects
export async function updateTeacherSubjects(teacherId, subjectIds) {
  await clearTeacherSubjects(teacherId);

  const subjectPromises = subjectIds.map(subjectId => 
    addTeacherSubjects(teacherId, subjectId)
  );

  await Promise.all(subjectPromises);
}
