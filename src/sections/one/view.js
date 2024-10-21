'use client';

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

// components
import { useSettingsContext } from 'src/components/settings';

// ----------------------------------------------------------------------

export default function TermsAndConditionsView() {
  const settings = useSettingsContext();

  return (
    <Container maxWidth={settings.themeStretch ? false : 'md'}>
      <Typography variant="h4" sx={{ mb: 3 }}>
        Terms & Conditions
      </Typography>

      <Card sx={{ borderRadius: 2, boxShadow: 3 }}>
        <CardContent>
          <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
            <FormControlLabel
              control={<Checkbox defaultChecked />}
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
              control={<Checkbox defaultChecked />}
              label="You agree to stay on the TheTutor.Me platform while tutoring learners you've connected with."
            />
            <FormControlLabel
              control={<Checkbox defaultChecked />}
              label="You agree that the platform may obtain information about you from a third-party consumer reporting agency."
            />
            <FormControlLabel
              control={<Checkbox defaultChecked />}
              label="TheTutor.Me charges a sliding commission rate between 10%-15% on sessions conducted and materials sold via the platform."
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
        <LoadingButton type="submit" variant="contained">
          Save
        </LoadingButton>
      </Stack>
    </Container>
  );
}
