import PropTypes from 'prop-types';
import React, { useState } from 'react';
// @mui
import Box from '@mui/material/Box';
import Stack from '@mui/material/Stack'; 
//
import UserCard from './user-card';
import UserFilter from './user-filter';

// ----------------------------------------------------------------------

export default function UserCardList({ users }) {
  const [filters, setFilters] = useState({});

  const handleFilterChange = (newFilters) => {
    setFilters(newFilters);
    console.log('Filters:', newFilters); 
  };
  return (
    <Stack spacing={4}>
      <UserFilter onFilterChange={handleFilterChange} />

    <Box
      gap={3}
      display="grid"
      gridTemplateColumns={{
        xs: 'repeat(1, 1fr)',
        sm: 'repeat(2, 1fr)',
        md: 'repeat(3, 1fr)',
      }}
    >
      {users.map((user) => (
        <UserCard key={user.id} user={user} />
      ))}
    </Box>
  </Stack>
  );
}

UserCardList.propTypes = {
  users: PropTypes.array,
};
