
import { configureStore } from '@reduxjs/toolkit';
import userReducer from './slices/usersliice';
import cityReducer from './slices/citySlice'; // Import the city slice reducer
import availabiltyReducer from './slices/availabilityslice'
import serviceReducer from './slices/serviceslice';
import setupReducer from './slices/setupslice';

const store = configureStore({
  reducer: {
    user: userReducer,
    cities:cityReducer,
    availability: availabiltyReducer,
    service: serviceReducer,
    setup: setupReducer
  },
});

export default store;

