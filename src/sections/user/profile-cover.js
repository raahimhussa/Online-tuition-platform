import React, { useState } from 'react';
import PropTypes from 'prop-types';
// @mui
import Box from '@mui/material/Box';
import Stack from '@mui/material/Stack';
import Avatar from '@mui/material/Avatar';
import ListItemText from '@mui/material/ListItemText';
import { useTheme, alpha } from '@mui/material/styles';
import Typography from '@mui/material/Typography';
import { bgGradient } from 'src/theme/css';
import Button from '@mui/material/Button';
// icons
import WhatsAppIcon from '@mui/icons-material/WhatsApp';

// Helper function to convert phone number to international format
const convertToInternationalFormat = (phoneNumber) => {
  if (!phoneNumber.startsWith('+92') && phoneNumber.startsWith('0')) {
    return phoneNumber.replace(/^0/, '+92');
  }
  return phoneNumber;
};

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

  // Function to handle WhatsApp click
  const handleWhatsAppClick = () => {
    if (phone_number) {
      const formattedPhoneNumber = convertToInternationalFormat(phone_number);
      const whatsappUrl = `https://wa.me/${formattedPhoneNumber}`;
      window.open(whatsappUrl, '_blank');
    }
  };

  return (
    <Box
    sx={{
      ...bgGradient({
        color: alpha(theme.palette.primary.darker, 0.8),
  
      }),
      height: 1,
      color: 'common.white',
    }}
    >
      <Stack
        direction={{ xs: 'column', md: 'row' }}
        alignItems="center"
        sx={{
          pt: { xs: 4, md: 6 },
          px: 3,
          pb: 2,
          textAlign: { xs: 'center', md: 'left' },
        }}
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
                <Typography variant="subtitle1" sx={{ mt: 0.5, color: alpha(theme.palette.common.white, 0.9) }}>
                  {role}
                </Typography>
              )}
              {phone_number && (
                <Box
                  onClick={handleWhatsAppClick}
                  sx={{
                    display: 'flex',
                    alignItems: 'center',
                    cursor: 'pointer',
                    mt: 0.5,
                    opacity: 0.7,
                    '&:hover': { opacity: 1 },
                  }}
                >
                  <WhatsAppIcon sx={{ mr: 0.5, color: 'common.white' }} />
                  <Typography variant="body2" sx={{ color: 'common.white' }}>
                    {phone_number}
                  </Typography>
                </Box>
              )}
              {email && (
                <Typography
                  variant="body2"
                  sx={{
                    mt: 0.5,
                    opacity: 0.7,
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
                    opacity: 0.7,
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
          sx={{ ml: { md: 3 } }}
        />
      </Stack>

      <Box
        sx={{
          position: 'absolute',
          bottom: 16,
          right: 16,
        }}
      >
        <Button variant="contained" color="primary">
          Book Now
        </Button>
      </Box>
    </Box>
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
