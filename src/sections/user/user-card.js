import PropTypes from 'prop-types';
// @mui
import { alpha, useTheme } from '@mui/material/styles';
import Box from '@mui/material/Box';
import Card from '@mui/material/Card';
import Stack from '@mui/material/Stack';
import Avatar from '@mui/material/Avatar';
import Divider from '@mui/material/Divider';
import Typography from '@mui/material/Typography';
import Button from '@mui/material/Button';
import Chip from '@mui/material/Chip';

// ----------------------------------------------------------------------

export default function UserCard({ user }) {
  const theme = useTheme();

  const { name,
    experience,
    students,
    avatarUrl,
    languages = [],   
    grades = [],       
    subjects = [],     
    price,
    freeTrial, } = user;

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
          <Typography variant="h6">{name}</Typography>
          <Typography variant="body2" color="text.secondary">
            {experience} yr. experience | {students} students
          </Typography>
        </Box>
      </Stack>

      <Typography variant="body1" sx={{ mt: 2, mb: 2 }}>
        Hi, I am {name}. I have....
      </Typography>

      <Divider sx={{ my: 2 }} />

      <Stack direction="column" spacing={1}>
        <Typography variant="subtitle2" color="text.secondary">Languages</Typography>
        <Stack direction="row" spacing={1}>
          {languages.map((curr, index) => (
            <Chip key={index} label={curr} size="small" color="primary" variant="outlined" />
          ))}
        </Stack>

        <Typography variant="subtitle2" color="text.secondary" sx={{ mt: 2 }}>Grades</Typography>
        <Stack direction="row" spacing={1}>
          {grades.map((grade, index) => (
            <Chip key={index} label={grade} size="small" variant="outlined" />
          ))}
        </Stack>

        <Typography variant="subtitle2" color="text.secondary" sx={{ mt: 2 }}>Subjects</Typography>
        <Stack direction="row" spacing={1}>
          {subjects.map((subject, index) => (
            <Chip key={index} label={subject} size="small" color="secondary" variant="outlined" />
          ))}
        </Stack>
      </Stack>

      <Divider sx={{ my: 2 }} />

      <Stack direction="row" justifyContent="space-between" alignItems="center">
        {freeTrial ? (
          <Button variant="contained" color="success" sx={{ fontWeight: 'bold' }}>
            Free Trial
          </Button>
        ) : (
          <Typography variant="subtitle1" color="text.primary" sx={{ fontWeight: 'bold' }}>
            ${price} /session
          </Typography>
        )}
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
    languages: PropTypes.arrayOf(PropTypes.string),
    grades: PropTypes.arrayOf(PropTypes.string),
    subjects: PropTypes.arrayOf(PropTypes.string),
    price: PropTypes.number,
    freeTrial: PropTypes.bool,
  }),
};