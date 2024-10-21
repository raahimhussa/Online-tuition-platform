'use client';

import * as Yup from 'yup';

import { useForm, Controller } from 'react-hook-form';
import { useState } from 'react';
import { yupResolver } from '@hookform/resolvers/yup';
// @mui
import LoadingButton from '@mui/lab/LoadingButton';
import Link from '@mui/material/Link';
import Alert from '@mui/material/Alert';
import { Stack, TextField, FormControl, InputLabel, Select, MenuItem } from '@mui/material';

import IconButton from '@mui/material/IconButton';
import Typography from '@mui/material/Typography';
import InputAdornment from '@mui/material/InputAdornment';
import Checkbox from '@mui/material/Checkbox';
import FormControlLabel from '@mui/material/FormControlLabel';

// hooks
import { useBoolean } from 'src/hooks/use-boolean';
// routes
import { paths } from 'src/routes/paths';
import { RouterLink } from 'src/routes/components';
import { useSearchParams, useRouter } from 'src/routes/hooks';
// config
import { PATH_AFTER_LOGIN } from 'src/config-global';
// auth
import { useAuthContext } from 'src/auth/hooks';
// components
import Iconify from 'src/components/iconify';
import { RHFSelect } from 'src/components/hook-form/rhf-select';
import FormProvider from 'src/components/hook-form/form-provider';
import { RHFTextField } from 'src/components/hook-form';

// ----------------------------------------------------------------------

export default function JwtRegisterView() {
  const { control, watch, setValue } = useForm();
  const { register } = useAuthContext();

  const router = useRouter();

  const [errorMsg, setErrorMsg] = useState('');

  const searchParams = useSearchParams();

  const returnTo = searchParams.get('returnTo');

  const password = useBoolean();

  // Updated validation schema to include new fields
  const RegisterSchema = Yup.object().shape({
    firstName: Yup.string().required('First name required'),
    lastName: Yup.string().required('Last name required'),
    email: Yup.string().required('Email is required').email('Email must be a valid email address'),
    password: Yup.string().required('Password is required'),
    phoneNumber: Yup.string()
      .required('Phone number is required')
      .matches(/^\d+$/, 'Must be a valid phone number'),
    gender: Yup.string().required('Gender is required'),
    age: Yup.number()
      .required('Age is required')
      .min(1, 'Age must be at least 1')
      .max(120, 'Age must be valid'),
    city_id: Yup.string().required('City is required'),
    area: Yup.string().required('Area is required'),
    isLearner: Yup.boolean(),
    role: Yup.string().required('Role is required'),
    isTutor: Yup.boolean(),
  });

  const defaultValues = {
    firstName: '',
    lastName: '',
    email: '',
    password: '',
    phoneNumber: '',
    gender: '',
    age: '',
    city_id: '',
    area: '',
    isLearner: false,
    isTutor: false,
  };

  const methods = useForm({
    resolver: yupResolver(RegisterSchema),
    defaultValues,
  });
  const handleRoleChange = (event, role) => {
    setValue('role', event.target.checked ? role : '');
  };
  const {
    reset,
    handleSubmit,
    formState: { isSubmitting },
  } = methods;

  const onSubmit = handleSubmit(async (data) => {
    try {
      await register?.(
        data.email,
        data.password,
        data.firstName,
        data.lastName,
        data.phoneNumber,
        data.gender,
        data.age,
        data.city_id,
        data.area,
        data.isLearner,
        data.isTutor
      );

      router.push(returnTo || PATH_AFTER_LOGIN);
    } catch (error) {
      console.error(error);
      reset();
      setErrorMsg(typeof error === 'string' ? error : error.message);
    }
  });

  const renderHead = (
    <Stack spacing={2} sx={{ mb: 5, position: 'relative' }}>
      <Typography variant="h4">Get started absolutely free</Typography>

      <Stack direction="row" spacing={0.5}>
        <Typography variant="body2"> Already have an account? </Typography>

        <Link href={paths.auth.jwt.login} component={RouterLink} variant="subtitle2">
          Sign in
        </Link>
      </Stack>
    </Stack>
  );

  const renderTerms = (
    <Typography
      component="div"
      sx={{
        color: 'text.secondary',
        mt: 2.5,
        typography: 'caption',
        textAlign: 'center',
      }}
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
  );

  const renderForm = (
    <FormProvider methods={methods} onSubmit={onSubmit}>
      <Stack spacing={2.5}>
        {!!errorMsg && <Alert severity="error">{errorMsg}</Alert>}

        <Stack direction={{ xs: 'column', sm: 'row' }} spacing={2}>
          <RHFTextField name="firstName" label="First name" />
          <RHFTextField name="lastName" label="Last name" />
        </Stack>

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

        {/* New fields */}
        <Stack direction="row" spacing={2}>
          <RHFTextField name="phoneNumber" label="Phone number" />
          <RHFSelect name="gender" label="Gender">
            <MenuItem value="male">Male</MenuItem>
            <MenuItem value="female">Female</MenuItem>
          </RHFSelect>
        </Stack>
        <Stack direction="row" spacing={2} alignItems="center">
          {/* Day */}
          <RHFTextField name="day" label="Day" type="number" control={control} />
          {/* Month */}
          <FormControl fullWidth>
            <InputLabel>Month</InputLabel>
            <Controller
              name="month"
              control={control}
              defaultValue=""
              render={({ field }) => (
                <Select {...field} label="Month">
                  <MenuItem value={1}>January</MenuItem>
                  <MenuItem value={2}>February</MenuItem>
                  <MenuItem value={3}>March</MenuItem>
                  <MenuItem value={4}>April</MenuItem>
                  <MenuItem value={5}>May</MenuItem>
                  <MenuItem value={6}>June</MenuItem>
                  <MenuItem value={7}>July</MenuItem>
                  <MenuItem value={8}>August</MenuItem>
                  <MenuItem value={9}>September</MenuItem>
                  <MenuItem value={10}>October</MenuItem>
                  <MenuItem value={11}>November</MenuItem>
                  <MenuItem value={12}>December</MenuItem>
                </Select>
              )}
            />
          </FormControl>
          {/* Year */}
          <RHFTextField name="year" label="Year" type="number" control={control} />
        </Stack>
        <RHFTextField name="city_id" label="City" />
        <RHFTextField name="area" label="Area" />

        {/* Adding checkboxes for role selection */}
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
  );

  return (
    <>
      {renderHead}

      {renderForm}

      {renderTerms}
    </>
  );
}
