import PropTypes from 'prop-types';
import { useDispatch, useSelector } from 'react-redux';
import { useEffect } from 'react';
import { fetchTeacherByUserId, selectTeacher, selectTeachersLoading, selectTeachersError } from '../../app/store/slices/teacherslice'; // Adjust path if needed
import ProfileHome from    './profile-home'



// The component will use the teacher data from Redux state
export default function TeacherProfile({ id }) {
  const dispatch = useDispatch();
  const teacher = useSelector(selectTeacher);
  const loading = useSelector(selectTeachersLoading);
  const error = useSelector(selectTeachersError);

  useEffect(() => {
    if (id) {
      dispatch(fetchTeacherByUserId(id)); // Fetch the teacher data based on ID
    }
  }, [id, dispatch]);

  // If data is loading
  if (loading) {
    return <p>Loading...</p>;
  }

  // If there's an error fetching the data
  if (error) {
    return <p>Error: {error}</p>;
  }

  // If teacher data is not found
  if (!teacher) {
    return <p>Teacher not found!</p>;
  }

  return (
    <div>
      {/* Pass the teacher data as a prop to ProfileHome */}
      <ProfileHome info={teacher} posts={[]} />
    </div>
  );
}

// Optional: Add PropTypes for better type checking
TeacherProfile.propTypes = {
  id: PropTypes.string.isRequired,
};

// Fetch teacher id from URL in getServerSideProps to pass as prop
export async function getServerSideProps(context) {
  const { id } = context.params; // Get teacher id from the URL

  return {
    props: {
      id, // Pass the teacher ID as a prop
    },
  };
}
