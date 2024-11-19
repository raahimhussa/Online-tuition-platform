'use client'

import PropTypes from 'prop-types';
import { useRouter } from 'src/routes/hooks'; // Import useRouter from Next.js
import { useTheme } from '@mui/material/styles';
import Box from '@mui/material/Box';
import Card from '@mui/material/Card';
import Stack from '@mui/material/Stack';
import Avatar from '@mui/material/Avatar';
import { paths } from 'src/routes/paths';
import Divider from '@mui/material/Divider';
import Typography from '@mui/material/Typography';
import Button from '@mui/material/Button';
import Chip from '@mui/material/Chip';

export default function UserCard({ user }) {
  const theme = useTheme();
  const router = useRouter(); // Initialize Next.js router

  const {
    name,
    experience,
    students,
    avatarUrl,
    languages = [],
    grades = [],
    subjects = [],
    price,
    bio,
  } = user;

  // Function to handle navigation to profile page
  const handleViewProfile = () => {
    router.push(paths.dashboard.user.root); 
    
 
  };
  

  return (
    <Card sx={{ textAlign: 'left', padding: 2, maxWidth: 320, boxShadow: 3 }}>
      <Stack direction="row" alignItems="center" spacing={2}>
        <Avatar
          alt={name}
          src={avatarUrl}
          sx={{
            width: 64,
            height: 64,
          }}
        />
        <Box>
          {/* Add onClick to the name */}
          <Typography
            variant="h6"
            sx={{
              cursor: 'pointer',
              color: theme.palette.primary.main,
              '&:hover': { textDecoration: 'underline' },
            }}
            onClick={handleViewProfile} // Call handleViewProfile on click
          >
            {name}
          </Typography>
          <Typography variant="body2" color="text.secondary">
            {experience} yr. experience | {students} students
          </Typography>
        </Box>
      </Stack>

      <Typography variant="body1" sx={{ mt: 2, mb: 2 }}>
        {bio}
      </Typography>

      <Divider sx={{ my: 2 }} />

      <Stack direction="column" spacing={1}>
        <Typography variant="subtitle2" color="text.secondary">
          Languages
        </Typography>
        <Stack direction="row" spacing={1}>
          {languages.map((curr, index) => (
            <Chip key={index} label={curr} size="small" color="primary" variant="outlined" />
          ))}
        </Stack>

        <Typography variant="subtitle2" color="text.secondary" sx={{ mt: 2 }}>
          Grades
        </Typography>
        <Stack direction="row" spacing={1}>
          {grades.map((grade, index) => (
            <Chip key={index} label={grade} size="small" variant="outlined" />
          ))}
        </Stack>

        <Typography variant="subtitle2" color="text.secondary" sx={{ mt: 2 }}>
          Subjects
        </Typography>
        <Stack direction="row" spacing={1}>
          {subjects.map((subject, index) => (
            <Chip key={index} label={subject} size="small" color="secondary" variant="outlined" />
          ))}
        </Stack>
      </Stack>

      <Divider sx={{ my: 2 }} />

      <Stack direction="row" justifyContent="space-between" alignItems="center">
        <Typography variant="subtitle1" color="text.primary" sx={{ fontWeight: 'bold' }}>
          ${price} /session
        </Typography>
        <Button variant="contained" color="primary">
          Book Now
        </Button>
      </Stack>
    </Card>
  );
}

UserCard.propTypes = {
  user: PropTypes.shape({
    name: PropTypes.string.isRequired,
    experience: PropTypes.string.isRequired,
    students: PropTypes.number.isRequired,
    avatarUrl: PropTypes.string.isRequired,
    bio: PropTypes.string.isRequired,
  
    languages: PropTypes.arrayOf(PropTypes.string),
    grades: PropTypes.arrayOf(PropTypes.string),
    subjects: PropTypes.arrayOf(PropTypes.string),
    price: PropTypes.number,
  }).isRequired,
};
