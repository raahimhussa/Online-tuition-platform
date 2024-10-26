
import { configureStore } from '@reduxjs/toolkit';
import userReducer from './slices/usersliice';
import cityReducer from './slices/citySlice'; // Import the city slice reducer

const store = configureStore({
  reducer: {
    user: userReducer,
    cities:cityReducer,
  },
});

export default store;
