import React, { useState } from 'react';
import PropTypes from 'prop-types';
// @mui
import Box from '@mui/material/Box';
import Stack from '@mui/material/Stack';
import Avatar from '@mui/material/Avatar';
import ListItemText from '@mui/material/ListItemText';
import { useTheme, alpha } from '@mui/material/styles';
import Typography from '@mui/material/Typography';
import Button from '@mui/material/Button';
import Card from '@mui/material/Card'; // Import the Card component
import CardContent from '@mui/material/CardContent'; // Import CardContent
import { bgGradient } from 'src/theme/css';
import BookSessionDialog from './BookSessionDialog'; // Import the dialog component

// ----------------------------------------------------------------------

export default function ProfileCover({
  name,
  role,
  phone_number,
  email,
  city_name,
  profile_picture,
}) {
  const theme = useTheme();

  // State for controlling the dialog
  const [open, setOpen] = useState(false);

  const handleOpen = () => setOpen(true);
  const handleClose = () => setOpen(false);

  return (
    <>
      <Card
        sx={{
          width: '100%',
          height: '100%',
          minHeight: 280,
          background: bgGradient({
            color: alpha(theme.palette.primary.main, 0.9),
          }),
          color: 'common.white',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          position: 'relative',
          mb : 4,
        }}
      >
        <CardContent sx={{ width: '100%' }}>
          <Stack
            direction={{ xs: 'column', md: 'row' }}
            alignItems="center"
            spacing={2}
            sx={{ textAlign: { xs: 'center', md: 'left' } }}
          >
            <Avatar
              src={profile_picture}
              alt={name}
              sx={{
                width: { xs: 80, md: 128 },
                height: { xs: 80, md: 128 },
                border: `3px solid ${theme.palette.common.white}`,
              }}
            />

            <ListItemText
              primary={name}
              secondary={
                <>
                  {role && (
                    <Typography
                      variant="subtitle1"
                      sx={{
                        mt: 0.5,
                        color: alpha(theme.palette.common.white, 0.9),
                      }}
                    >
                      {role}
                    </Typography>
                  )}
                  {phone_number && (
                    <Typography
                      variant="body2"
                      sx={{
                        mt: 0.5,
                        color: alpha(theme.palette.common.white, 0.8),
                      }}
                    >
                      📞 {phone_number}
                    </Typography>
                  )}
                  {email && (
                    <Typography
                      variant="body2"
                      sx={{
                        mt: 0.5,
                        color: alpha(theme.palette.common.white, 0.8),
                      }}
                    >
                      ✉️ {email}
                    </Typography>
                  )}
                  {city_name && (
                    <Typography
                      variant="body2"
                      sx={{
                        mt: 0.5,
                        color: alpha(theme.palette.common.white, 0.8),
                      }}
                    >
                      📍 {city_name}
                    </Typography>
                  )}
                </>
              }
              primaryTypographyProps={{
                typography: 'h4',
                fontWeight: 'bold',
              }}
            />
          </Stack>

          <Box sx={{ position: 'absolute', bottom: 16, right: 16 }}>
            <Button variant="contained" color="primary" onClick={handleOpen}>
              Book Now
            </Button>
          </Box>
        </CardContent>
      </Card>

      {/* Book Session Dialog */}
      <BookSessionDialog open={open} onClose={handleClose} />
    </>
  );
}

ProfileCover.propTypes = {
  name: PropTypes.string.isRequired,
  role: PropTypes.string,
  phone_number: PropTypes.string,
  email: PropTypes.string,
  city_name: PropTypes.string,
  profile_picture: PropTypes.string.isRequired,
};
