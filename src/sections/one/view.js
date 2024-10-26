'use client';

import React, { useState } from 'react';
import { alpha } from '@mui/material/styles';
import Box from '@mui/material/Box';
import Container from '@mui/material/Container';
import Typography from '@mui/material/Typography';
import Card from '@mui/material/Card';
import CardContent from '@mui/material/CardContent';
import FormControlLabel from '@mui/material/FormControlLabel';
import Checkbox from '@mui/material/Checkbox';
import Stack from '@mui/material/Stack';
import LoadingButton from '@mui/lab/LoadingButton';
import Button from '@mui/material/Button';
import Link from '@mui/material/Link';
import Snackbar from '@mui/material/Snackbar'; 
import Alert from '@mui/material/Alert'; 
import { paths } from 'src/routes/paths';
import { useRouter } from 'src/routes/hooks';

// components
import { useSettingsContext } from 'src/components/settings';

// ----------------------------------------------------------------------

export default function TermsAndConditionsView() {
  const router = useRouter();
  const settings = useSettingsContext();
  const [checkedStates, setCheckedStates] = useState([false, false, false, false]);
  const [snackbarOpen, setSnackbarOpen] = useState(false);

  const handleSnackbarClose = (event, reason) => {
    if (reason === 'clickaway') {
      return;
    }
    setSnackbarOpen(false);
  };
  const handleNextClick = () => {
    router.push(paths.dashboard.two);

    const allChecked = checkedStates.every(Boolean);
    if (!allChecked) {
      setSnackbarOpen(true);
    } else {
      console.log('All conditions met. Proceeding to the next step.');
    }
  };

  const handleCheckboxChange = (index) => (event) => {
    const newCheckedStates = [...checkedStates];
    newCheckedStates[index] = event.target.checked;
    setCheckedStates(newCheckedStates);
  };

  return (
    <Container maxWidth={settings.themeStretch ? false : 'md'}>
      <Typography variant="h4" sx={{ mb: 3 }}>
        Terms & Conditions
      </Typography>

      <Card sx={{ borderRadius: 2, boxShadow: 3 }}>
        <CardContent>
          <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
            <FormControlLabel
              control={<Checkbox
                checked={checkedStates[0]}
                onChange={handleCheckboxChange(0)}
              />}
              label={
                <Typography variant="body2">
                  You agree to the{' '}
                  <Link href="#" underline="hover">
                    Tutor Contract, Terms & Conditions, Privacy Policy & Disclaimer
                  </Link>
                  .
                </Typography>
              }
            />
            <FormControlLabel
              control={<Checkbox
                checked={checkedStates[1]}
                onChange={handleCheckboxChange(1)}
              />}
              label="You agree to stay on the Tutorly.pk platform while tutoring learners you've connected with."
            />
            <FormControlLabel
              control={ <Checkbox
                checked={checkedStates[2]}
                onChange={handleCheckboxChange(2)}
              />}
              label="You agree that the platform may obtain information about you from a third-party consumer reporting agency."
            />
            <FormControlLabel
              control={<Checkbox
                checked={checkedStates[3]}
                onChange={handleCheckboxChange(3)}
              />}
              label=" Tutorly.pk charges a sliding commission rate between 10%-15% on sessions conducted and materials sold via the platform."
            />
          </Box>
        </CardContent>
      </Card>
      {/* 
      <Box sx={{ mt: 3, textAlign: 'right' }}>
        <Button variant="contained" color="primary" sx={{ borderRadius: 2 }}>
          Save & Continue
        </Button>
      </Box> */}
     <Stack alignItems="flex-end" sx={{ mt: 3 }}>
        <LoadingButton 
          type="button" 
          variant="contained" 
          onClick={handleNextClick} 
        >
          Next
        </LoadingButton>
      </Stack>

      <Snackbar
        open={snackbarOpen}
        autoHideDuration={10000}
        onClose={handleSnackbarClose}
        anchorOrigin={{ vertical: 'top', horizontal: 'right' }}
      >
        <Alert onClose={handleSnackbarClose} severity="warning">
          Please select all the options before proceeding.
        </Alert>
      </Snackbar>
    </Container>
  );
}
