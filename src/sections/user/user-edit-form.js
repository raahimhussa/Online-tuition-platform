import PropTypes from 'prop-types';
import * as Yup from 'yup';
import { useForm, Controller } from 'react-hook-form';
import { yupResolver } from '@hookform/resolvers/yup';
import Card from '@mui/material/Card';
import Box from '@mui/material/Box';
import { MenuItem, Select, InputLabel, FormControl } from '@mui/material';
import Stack from '@mui/material/Stack';
import LoadingButton from '@mui/lab/LoadingButton';
import FormProvider, { RHFTextField } from 'src/components/hook-form';
import { useDispatch } from 'react-redux';
import { saveUser } from 'src/app/store/slices/setupslice';
import { useRouter } from 'src/routes/hooks';
import { paths } from 'src/routes/paths';
import { useSnackbar } from 'src/components/snackbar';

import React, { useState, useMemo } from 'react';

export default function UserEditForm({ currentUser }) {
  const dispatch = useDispatch();
  const router = useRouter();
  const [isBackLoading, setIsBackLoading] = useState(false);
  const [isNextLoading, setIsNextLoading] = useState(false);
  const { enqueueSnackbar } = useSnackbar();

  const NewUserSchema = Yup.object().shape({
    experience_years: Yup.number()
      .typeError('Experience years are required')
      .required('Experience years are required')
      .min(0, 'Experience years must be 1 or more')
      .max(100, 'Experience years must be realistic'),
    education: Yup.string()
      .required('Education is required')
      .max(100, 'Education details must not exceed 100 characters'),
    bio: Yup.string()
      .required('Bio is required')
      .max(500, 'Bio must not exceed 500 characters'),
    teachingMode: Yup.string()
      .oneOf(['online', 'physical', 'hybrid'], 'Teaching mode must be online, physical, or hybrid')
      .required('Teaching mode is required'),
  });

  const defaultValues = useMemo(
    () => ({
      education: currentUser?.education || '',
      experience_years: currentUser?.experience_years || '',
      bio: currentUser?.bio || '',
      teachingMode: currentUser?.teachingMode || 'online',
    }),
    [currentUser]
  );

  const methods = useForm({
    resolver: yupResolver(NewUserSchema),
    defaultValues,
  });

  const { handleSubmit, control } = methods;

  const onSubmit = (data) => {
    console.log('Form Data:', data);
    dispatch(saveUser(data));
    alert('Form submitted successfully!');
  };

  const handleNextClick = () => {
    const formValues = methods.getValues();
    const allFieldsFilled = Object.keys(formValues).every((field) => formValues[field] !== '' && formValues[field] !== null);
  
    if (allFieldsFilled) {
      setIsNextLoading(true);
      setTimeout(() => {
        router.push(paths.dashboard.one);
        setIsNextLoading(false);
      }, 1000);
    } else {
      enqueueSnackbar('Please fill in all required fields before proceeding.', { variant: 'warning' });
    }
  };
  
  const handleBackClick = () => {
    setIsBackLoading(true);
    setTimeout(() => {
      router.push(paths.dashboard.user.new);
      setIsBackLoading(false);
    }, 1000); 
  };

  return (
    <FormProvider methods={methods} onSubmit={handleSubmit(onSubmit)}>
      {/* First Card */}
      <Card sx={{ p: 3, mb: 3 }}>
        <Box
          display="grid"
          gridTemplateColumns={{ xs: 'repeat(1, 1fr)', sm: 'repeat(2, 1fr)' }}
          gap={2}
        >
          <RHFTextField name="education" label="Education" />
          <RHFTextField name="experience_years" label="Years of Experience" type="number" />
          
          <FormControl fullWidth>
            <InputLabel>Teaching Mode</InputLabel>
            <Controller
              name="teaching_mode"
              control={control}
              render={({ field }) => (
                <Select {...field} label="Teaching Mode">
                  <MenuItem value="online">Online</MenuItem>
                  <MenuItem value="physical">Physical</MenuItem>
                  <MenuItem value="hybrid">Hybrid</MenuItem>
                </Select>
              )}
            />
          </FormControl>
        </Box>
      </Card>

      <Card sx={{ p: 3 }}>
        <Box display="grid" gridTemplateColumns={{ xs: '1fr' }}>
          <RHFTextField name="bio" label="Bio" multiline rows={4} />
        </Box>
      </Card>

      <Box sx={{ mt: 4, display: 'flex', justifyContent: 'space-between' }}>
        <Stack sx={{ mt: 2 }}>
          <LoadingButton type="button" variant="contained" onClick={handleBackClick} loading={isBackLoading}>
            Back
          </LoadingButton>
        </Stack>
        <Stack alignItems="flex-end" sx={{ mt: 2 }}>
          <LoadingButton type="submit" variant="contained" onClick={handleNextClick} loading={isNextLoading}>
            Submit
          </LoadingButton>
        </Stack>
      </Box>
    </FormProvider>
  );
}

UserEditForm.propTypes = {
  currentUser: PropTypes.object,
};
