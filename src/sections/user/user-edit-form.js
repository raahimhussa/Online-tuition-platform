import PropTypes from 'prop-types';
import * as Yup from 'yup';
import { useMemo } from 'react';
import { useForm, Controller } from 'react-hook-form';
import { yupResolver } from '@hookform/resolvers/yup';
// @mui
import Card from '@mui/material/Card';
import Box from '@mui/material/Box';
import { MenuItem, Select, InputLabel, FormControl } from '@mui/material';
import Stack from '@mui/material/Stack';
import LoadingButton from '@mui/lab/LoadingButton';
// components
import FormProvider, { RHFTextField } from 'src/components/hook-form';
import { useDispatch, useSelector } from 'react-redux';
import { saveUser } from 'src/app/store/slices/setupslice';

// ----------------------------------------------------------------------

export default function UserEditForm({ currentUser }) {
  const dispatch = useDispatch();
  const setupData = useSelector((state) => state.setup);

  const NewUserSchema = Yup.object().shape({
    experience_years: Yup.number()
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

  const { handleSubmit, control, formState: { isSubmitting } } = methods;

  const onSubmit = async (data) => {
    try {
      dispatch(saveUser(data));
      // await new Promise((resolve) => setTimeout(resolve, 500));
      alert('Form submitted successfully!');
      console.info('DATA', data);
      alert('Form submitted successfully!');
    } catch (error) {
      console.error(error);
    }
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
            <LoadingButton type="button" variant="contained">
              Back
            </LoadingButton>
          </Stack>
          <Stack alignItems="flex-end" sx={{ mt: 2 }}>
            <LoadingButton type="submit" variant="contained" >
              Next
            </LoadingButton>
          </Stack>
        </Box>
    </FormProvider>
  );
}

UserEditForm.propTypes = {
  currentUser: PropTypes.object,
};
