'use client';

// @mui
import Container from '@mui/material/Container';
// routes
import { paths } from 'src/routes/paths';
// components
import { useSettingsContext } from 'src/components/settings';
import CustomBreadcrumbs from 'src/components/custom-breadcrumbs';
//
import UserEditForm from '../user-edit-form';

// ----------------------------------------------------------------------

export default function UserCompleteView() {
  const settings = useSettingsContext();

  return (
    <Container maxWidth={settings.themeStretch ? false : 'lg'}>
      <CustomBreadcrumbs
        heading="Complete your teaching profile"
        links={[
          {
            name: 'Dashboard',
            href: paths.dashboard.root,
          },
          { name: 'Complete user' },
        ]}
        sx={{
          mb: { xs: 3, md: 5 },
        }}
      />

      <UserEditForm />
    </Container>
  );
}
