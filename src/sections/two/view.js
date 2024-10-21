'use client';

import {
  Box,
  Button,
  Container,
  Grid,
  Typography,
  Checkbox,
  IconButton,
  TextField,
  FormControlLabel,
} from '@mui/material';
import { Icon } from '@iconify/react';
// import addCircleOutline from '@iconify/icons-mdi/add-circle-outline';
// import arrowBack from '@iconify/icons-mdi/arrow-back';
import Stack from '@mui/material/Stack';
import LoadingButton from '@mui/lab/LoadingButton';
// components
import { useSettingsContext } from 'src/components/settings';

const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

export default function AvailabilityView() {
  const settings = useSettingsContext();

  return (
    <Container maxWidth={settings.themeStretch ? false : 'lg'}>
      {/* Header */}
      <Typography variant="h4" sx={{ mb: 3 }}>
        Availability
      </Typography>

      {/* Availability Form */}
      <Grid container spacing={3}>
        <Grid item xs={12}>
          <Grid container spacing={2}>
            <Grid item xs={2}>
              <Typography variant="subtitle1">Day</Typography>
            </Grid>
            <Grid item xs={4}>
              <Typography variant="subtitle1">Start Time</Typography>
            </Grid>
            <Grid item xs={4}>
              <Typography variant="subtitle1">End Time</Typography>
            </Grid>
          </Grid>

          {/* Days with Time Inputs */}
          {days.map((day) => (
            <Grid container spacing={2} alignItems="center" sx={{ mb: 2 }} key={day}>
              <Grid item xs={2}>
                <FormControlLabel control={<Checkbox defaultChecked />} label={day} />
              </Grid>
              <Grid item xs={2}>
                <TextField
                  fullWidth
                  defaultValue="09"
                  InputProps={{ sx: { textAlign: 'center' }, inputMode: 'numeric' }}
                />
              </Grid>
              <Grid item xs={1}>
                <TextField
                  fullWidth
                  defaultValue="00"
                  InputProps={{ sx: { textAlign: 'center' }, inputMode: 'numeric' }}
                />
              </Grid>
              <Grid item xs={1}>
                <TextField
                  fullWidth
                  defaultValue="AM"
                  InputProps={{ sx: { textAlign: 'center' } }}
                />
              </Grid>
              <Grid item xs={2}>
                <TextField
                  fullWidth
                  defaultValue="05"
                  InputProps={{ sx: { textAlign: 'center' }, inputMode: 'numeric' }}
                />
              </Grid>
              <Grid item xs={1}>
                <TextField
                  fullWidth
                  defaultValue="00"
                  InputProps={{ sx: { textAlign: 'center' }, inputMode: 'numeric' }}
                />
              </Grid>
              <Grid item xs={1}>
                <TextField
                  fullWidth
                  defaultValue="PM"
                  InputProps={{ sx: { textAlign: 'center' } }}
                />
              </Grid>
              <Grid item xs={1}>
                <IconButton color="primary">
                  <iconify-icon icon="ion:add-circle-outline" />
                </IconButton>
              </Grid>
            </Grid>
          ))}
        </Grid>
      </Grid>

      {/* Actions */}
      <Box sx={{ mt: 3, display: 'flex', justifyContent: 'space-between' }}>
        <Button variant="outlined" startIcon={<iconify-icon icon="typcn:arrow-back" />}>
          Back
        </Button>
        <Stack alignItems="flex-end" sx={{ mt: 3 }}>
          <LoadingButton type="submit" variant="contained">
            Save
          </LoadingButton>
        </Stack>
      </Box>
    </Container>
  );
}
