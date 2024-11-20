// import { getTeacherById ,updateTeacherProfile} from '../../../../lib/teacherService';

// import {query} from '../../../../lib/db'

// export async function GET(req, { params }) {
//     const { id } = params;

//     if (!id) {
//         return new Response(JSON.stringify({ message: 'Teacher ID is required' }), {
//             status: 400,
//             headers: { 'Content-Type': 'application/json' },
//         });
//     }

//     try {
//         const teacher = await getTeacherById(id);

//         if (!teacher) {
//             return new Response(JSON.stringify({ message: 'Teacher not found' }), {
//                 status: 404,
//                 headers: { 'Content-Type': 'application/json' },
//             });
//         }

//         return new Response(JSON.stringify(teacher), {
//             status: 200,
//             headers: { 'Content-Type': 'application/json' },
//         });
//     } catch (error) {
//         return new Response(JSON.stringify({ message: 'Error fetching teacher profile', error: error.message }), {
//             status: 500,
//             headers: { 'Content-Type': 'application/json' },
//         });
//     }
// }
// export async function PATCH(req, res) {
//     const { id } = req.query;
//     const updates = await req.json();

//     if (!id) {
//         return res.status(400).json({ message: 'Teacher ID is required' });
//     }

//     try {
//         const updated = await updateTeacherProfile(id, updates);
//         return res.status(200).json(updated);
//     } catch (error) {
//         return res.status(500).json({ message: 'Error updating teacher profile', error: error.message });
//     }
// }
// export async function deleteTeacherProfile(teacherId) {
//     const text = `
//         DELETE FROM teachers
//         WHERE teacher_id = $1
//         RETURNING *`; // Optionally return the deleted row

//     const values = [teacherId];
//     const result = await query(text, values);

//     if (result.rowCount === 0) {
//         throw new Error('Teacher not found'); // Throw an error if no rows were deleted
//     }

//     return result.rows[0]; // Return the deleted row if needed
// }
