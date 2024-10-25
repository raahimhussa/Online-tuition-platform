import PropTypes from 'prop-types';
import * as Yup from 'yup';
import { useCallback, useMemo } from 'react';
import { useForm, Controller } from 'react-hook-form';
import { yupResolver } from '@hookform/resolvers/yup';
// @mui
import Box from '@mui/material/Box';
import Card from '@mui/material/Card';
import { MenuItem, Select, InputLabel, FormControl } from '@mui/material';
import Stack from '@mui/material/Stack';
import LoadingButton from '@mui/lab/LoadingButton';
import Button from '@mui/material/Button';
import Switch from '@mui/material/Switch';
import Grid from '@mui/material/Unstable_Grid2';
import Typography from '@mui/material/Typography';
import FormControlLabel from '@mui/material/FormControlLabel';
// utils
import { fData } from 'src/utils/format-number';
// routes
import { paths } from 'src/routes/paths';
import { useRouter } from 'src/routes/hooks';
// assets
import { countries } from 'src/assets/data';
// components
import Label from 'src/components/label';

import { RHFSelect } from 'src/components/hook-form/rhf-select';
import Iconify from 'src/components/iconify';
import { useSnackbar } from 'src/components/snackbar';
import FormProvider, {
  RHFSwitch,
  RHFTextField,
  RHFUploadAvatar,
  RHFAutocomplete,
} from 'src/components/hook-form';

// ----------------------------------------------------------------------

export default function UserNewEditForm({ currentUser }) {
  const router = useRouter();

  const { enqueueSnackbar } = useSnackbar();

  const NewUserSchema = Yup.object().shape({
    firstName: Yup.string().required('First Name is required'),
    lastName: Yup.string().required('Last Name is required'),
    email: Yup.string().required('Email is required').email('Email must be a valid email address'),
    phoneNumber: Yup.string().required('Phone number is required'),
    // address: Yup.string().required('Address is required'),
    gender: Yup.string().required('gender is required'),
    // company: Yup.string().required('Company is required'),
    // state: Yup.string().required('State is required'),
    city: Yup.string().required('City is required'),
    dob: Yup.date()
      .nullable()
      .required('Date of birth is required')
      .typeError('Must be a valid date')
      .max(new Date(), 'Date of birth cannot be in the future'),

    // experience_years: Yup.number()
    //   .nullable()
    //   .min(0, 'Experience years must be 0 or more')
    //   .max(100, 'Experience years must be realistic'),
    // education: Yup.string().max(100, 'Education details must not exceed 100 characters').nullable(),
    region: Yup.string().required('region is required'),
    area: Yup.string().required('area code is required'),
    // bio: Yup.string().max(500, 'Bio must not exceed 500 characters').nullable(), // Allow empty strings for optional fields
    avatarUrl: Yup.mixed().nullable().required('Avatar is required'),
    // not required

    isVerified: Yup.boolean(),
  });

  const defaultValues = useMemo(
    () => ({
      firstName: currentUser?.firstName || '',
      lastName: currentUser?.lastName || '',
      city: currentUser?.city || '',
      region: currentUser?.region || '',
      email: currentUser?.email || '',
      // state: currentUser?.state || '',

      // address: currentUser?.address || '',
      gender: currentUser?.gender || '',
      dob: currentUser?.dob || '',
      area: currentUser?.area || '',
      // education: currentUser?.education || '',
      // company: currentUser?.company || '',
      avatarUrl: currentUser?.avatarUrl || null,
      phoneNumber: currentUser?.phoneNumber || '',
      // experience_years: currentUser?.experience_years || '',
      // bio: currentUser?.bio || '',
      isVerified: currentUser?.isVerified || true,
    }),
    [currentUser]
  );

  const methods = useForm({
    resolver: yupResolver(NewUserSchema),
    defaultValues,
  });

  const {
    reset,
    watch,
    control,
    setValue,
    handleSubmit,
    formState: { isSubmitting },
  } = methods;

  const values = watch();

  const onSubmit = handleSubmit(async (data) => {
    try {
      await new Promise((resolve) => setTimeout(resolve, 500));
      reset();
      enqueueSnackbar(currentUser ? 'Update success!' : 'Create success!');
      router.push(paths.dashboard.one);
      console.info('DATA', data);
    } catch (error) {
      console.error(error);
    }
  });

  const handleDrop = useCallback(
    (acceptedFiles) => {
      const file = acceptedFiles[0];

      const newFile = Object.assign(file, {
        preview: URL.createObjectURL(file),
      });

      if (file) {
        setValue('avatarUrl', newFile, { shouldValidate: true });
      }
    },
    [setValue]
  );

  return (
    <FormProvider methods={methods} onSubmit={onSubmit}>
      <Grid container spacing={3}>
        <Grid xs={12} md={4}>
          <Card sx={{ pt: 10, pb: 5, px: 3 }}>
            {currentUser && (
              <Label
                color={
                  (values.status === 'active' && 'success') ||
                  (values.status === 'banned' && 'error') ||
                  'warning'
                }
                sx={{ position: 'absolute', top: 24, right: 24 }}
              >
                {values.status}
              </Label>
            )}

            <Box sx={{ mb: 5 }}>
              <RHFUploadAvatar
                name="avatarUrl"
                maxSize={3145728}
                onDrop={handleDrop}
                helperText={
                  <Typography
                    variant="caption"
                    sx={{
                      mt: 3,
                      mx: 'auto',
                      display: 'block',
                      textAlign: 'center',
                      color: 'text.disabled',
                    }}
                  >
                    Allowed *.jpeg, *.jpg, *.png, *.gif
                    <br /> max size of {fData(3145728)}
                  </Typography>
                }
              />
            </Box>

            {currentUser && (
              <FormControlLabel
                labelPlacement="start"
                control={
                  <Controller
                    name="status"
                    control={control}
                    render={({ field }) => (
                      <Switch
                        {...field}
                        checked={field.value !== 'active'}
                        onChange={(event) =>
                          field.onChange(event.target.checked ? 'banned' : 'active')
                        }
                      />
                    )}
                  />
                }
                label={
                  <>
                    <Typography variant="subtitle2" sx={{ mb: 0.5 }}>
                      Banned
                    </Typography>
                    <Typography variant="body2" sx={{ color: 'text.secondary' }}>
                      Apply disable account
                    </Typography>
                  </>
                }
                sx={{ mx: 0, mb: 3, width: 1, justifyContent: 'space-between' }}
              />
            )}

            {currentUser && (
              <Stack justifyContent="center" alignItems="center" sx={{ mt: 3 }}>
                <Button variant="soft" color="error">
                  Delete User
                </Button>
              </Stack>
            )}
          </Card>
        </Grid>

        <Grid xs={12} md={8}>
          <Card sx={{ p: 3 }}>
            <Box
              rowGap={3}
              columnGap={2}
              display="grid"
              gridTemplateColumns={{
                xs: 'repeat(1, 1fr)',
                sm: 'repeat(2, 1fr)',
              }}
            >
              <RHFTextField name="firstName" label="First Name" />
              <RHFTextField name="lastName" label="Last Name" />
              <RHFTextField name="email" label="Email Address" />
              <RHFTextField name="phoneNumber" label="Phone Number" />
              <RHFSelect name="gender" label="Gender">
                <MenuItem value="male">Male</MenuItem>
                <MenuItem value="female">Female</MenuItem>
              </RHFSelect>

              <RHFTextField name="area" label="area" />
              <RHFTextField name="city" label="City" />
              {/* <RHFTextField name="education" label="education" /> */}
              <RHFTextField name="region" label="region" />
              <RHFTextField
            name="dob"
            label="Date of Birth"
            type="date"
            InputLabelProps={{
              shrink: true,
            }}
            sx={{ '& .MuiInputLabel-root': { top: '5px' } }} // Custom styling
          />
              {/* <RHFTextField name="company" label="Company" /> */}
              {/* <RHFTextField name="region" label="region" /> */}
              {/* <RHFTextField
                name="experience_years"
                label="Years of Experience"
                type="number"
                InputProps={{
                  inputProps: { min: 0, max: 100 }, // set min and max attributes for the input
                }}
              /> */}
            </Box>
          </Card>

          {/* New Card for Bio */}
          {/* <Card sx={{ p: 3, mt: 3 }}>
            <Typography sx={{ mb: 2 }} variant="h6">
              Bio
            </Typography>
            <Box display="grid" gridTemplateColumns={{ xs: 'repeat(1, 1fr)' }}>
              <RHFTextField name="bio" label="Bio" multiline rows={4} />
            </Box>
          </Card> */}
          <Stack alignItems="flex-end" sx={{ mt: 3 }}>
            <LoadingButton type="submit" variant="contained" loading={isSubmitting}>
              Next
            </LoadingButton>
          </Stack>
        </Grid>
      </Grid>
    </FormProvider>
  );
}

UserNewEditForm.propTypes = {
  currentUser: PropTypes.object,
};
