'use client';

import * as Yup from 'yup';
import Radio from '@mui/material/Radio';
import { useForm, Controller } from 'react-hook-form';
import { useState } from 'react';
import { yupResolver } from '@hookform/resolvers/yup';
// @mui components
import LoadingButton from '@mui/lab/LoadingButton';
import Link from '@mui/material/Link';
import Alert from '@mui/material/Alert';
import {
  Stack,
  TextField,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Checkbox,
  FormControlLabel,
} from '@mui/material';
import IconButton from '@mui/material/IconButton';
import Typography from '@mui/material/Typography';
import InputAdornment from '@mui/material/InputAdornment';
// hooks and other imports
import { useBoolean } from 'src/hooks/use-boolean';
import { paths } from 'src/routes/paths';
import { RouterLink } from 'src/routes/components';
import { useSearchParams, useRouter } from 'src/routes/hooks';
import { PATH_AFTER_LOGIN } from 'src/config-global';
import { useAuthContext } from 'src/auth/hooks';
import Iconify from 'src/components/iconify';
import { RHFSelect } from 'src/components/hook-form/rhf-select';
import FormProvider from 'src/components/hook-form/form-provider';
import { RHFTextField } from 'src/components/hook-form';

export default function JwtRegisterView() {
  const { control, watch, setValue } = useForm();
  const { register } = useAuthContext();
  const router = useRouter();
  const [errorMsg, setErrorMsg] = useState('');
  const searchParams = useSearchParams();
  const returnTo = searchParams.get('returnTo');
  const password = useBoolean();

  // Validation schema
  const RegisterSchema = Yup.object().shape({
    firstName: Yup.string().required('First name is required'),
    lastName: Yup.string().required('Last name is required'),
    email: Yup.string().required('Email is required').email('Email must be a valid email address'),
    password: Yup.string().required('Password is required'),
    phoneNumber: Yup.string().required('Phone number is required'),
    gender: Yup.string().required('gender is required'),
    dob: Yup.date().required('Date of birth is required'),

    city_name: Yup.string().required('City is required'),
    region: Yup.string().required('region is required'),
    area: Yup.string().required('area code is required'),
    // role: Yup.string().required('role code is required'),
  });

  const defaultValues = {
    firstName: '',
    lastName: '',
    email: '',
    password: '',
    phoneNumber: '',
    gender: '',
    year: '',
    city_name: '',
    region: '',
    area: '',
    role: 'tutor',
    dob: null, // Add dob to the default values
  };

  const methods = useForm({
    resolver: yupResolver(RegisterSchema),
    defaultValues,
  });
  const handleRoleChange = (event, role) => {
    console.log(' event.target.checked ', role);
    setValue('role', role);
  };

  const {
    handleSubmit,
    formState: { isSubmitting },
    reset,
  } = methods;

  const onSubmit = async (data) => {
    console.info('Form submitted with data:', data);
    // Validate day, month, year before combining into dob
    const { day, month, year } = data;
    if (!day || !month || !year) {
      setErrorMsg('Please provide a valid date of birth.');
      return;
    }

    const dob = `${year}-${month}-${day}`;

    // Proceed with registration
    const formData = { ...data, dob };
    try {
      console.info('Submitting registration for:', formData);
      await register(formData); // Handle registration logic
      reset();
      setErrorMsg('');
      router.push(returnTo || PATH_AFTER_LOGIN);
    } catch (error) {
      console.error('Registration error:', error);
      setErrorMsg(typeof error === 'string' ? error : error.message);
      reset();
    }
  };

  return (
    <>
      {/* Header */}
      <Stack spacing={2} sx={{ mb: 5, position: 'relative' }}>
        <Typography variant="h4">Get started absolutely free</Typography>
        <Stack direction="row" spacing={0.5}>
          <Typography variant="body2"> Already have an account? </Typography>
          <Link href={paths.auth.jwt.login} component={RouterLink} variant="subtitle2">
            Sign in
          </Link>
        </Stack>
      </Stack>

      {/* Form */}
      <FormProvider methods={methods} onSubmit={handleSubmit(onSubmit)}>
        <Stack spacing={2.5}>
          {!!errorMsg && <Alert severity="error">{errorMsg}</Alert>}

          {/* First Name and Last Name */}
          <Stack direction={{ xs: 'column', sm: 'row' }} spacing={2}>
            <RHFTextField name="firstName" label="First name" />
            <RHFTextField name="lastName" label="Last name" />
          </Stack>

          {/* Email and Password */}
          <RHFTextField name="email" label="Email address" />
          <RHFTextField
            name="password"
            label="Password"
            type={password.value ? 'text' : 'password'}
            InputProps={{
              endAdornment: (
                <InputAdornment position="end">
                  <IconButton onClick={password.onToggle} edge="end">
                    <Iconify icon={password.value ? 'solar:eye-bold' : 'solar:eye-closed-bold'} />
                  </IconButton>
                </InputAdornment>
              ),
            }}
          />

          {/* Phone Number and Gender */}
          <Stack direction="row" spacing={2}>
            <RHFTextField name="phoneNumber" label="Phone number" />
            <RHFSelect name="gender" label="Gender">
              <MenuItem value="male">Male</MenuItem>
              <MenuItem value="female">Female</MenuItem>
            </RHFSelect>
          </Stack>

          {/* Date of Birth Fields */}
          <RHFTextField name="dob" label="Date of Birth" type="date" />

          {/* City, Region, Area */}
          <RHFTextField name="city_name" label="City" />
          <RHFTextField name="region" label="Region" />
          <RHFTextField name="area" label="Area" />

          {/* Role Checkboxes */}

          <Stack direction="row" spacing={2}>
            <FormControlLabel
              control={
                <Checkbox
                  checked={watch('role') === 'learner'}
                  onChange={(e) => handleRoleChange(e, 'learner')}
                />
              }
              label="Sign up as Learner"
            />
            <FormControlLabel
              control={
                <Checkbox
                  checked={watch('role') === 'tutor'}
                  onChange={(e) => handleRoleChange(e, 'tutor')}
                />
              }
              label="Sign up as Tutor"
            />
          </Stack>
          {/* Submit Button */}
          <LoadingButton
            fullWidth
            color="inherit"
            size="large"
            type="submit"
            variant="contained"
            loading={isSubmitting}
          >
            Create account
          </LoadingButton>
        </Stack>
      </FormProvider>

      {/* Terms and Conditions */}
      <Typography
        component="div"
        sx={{ color: 'text.secondary', mt: 2.5, typography: 'caption', textAlign: 'center' }}
      >
        {'By signing up, I agree to '}
        <Link underline="always" color="text.primary">
          Terms of Service
        </Link>
        {' and '}
        <Link underline="always" color="text.primary">
          Privacy Policy
        </Link>
        .
      </Typography>
    </>
  );
}
