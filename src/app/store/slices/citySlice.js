// src/app/store/slices/citySlice.js
import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';

// Thunk for fetching cities
export const fetchCities = createAsyncThunk('cities/fetchCities', async () => {
  const response = await fetch('/api/cities'); // Adjust the API endpoint as needed
  if (!response.ok) {
    throw new Error('Failed to fetch cities');
  }
  return response.json(); // Assuming the API returns an array of city objects
});

// Create city slice
const citySlice = createSlice({
  name: 'cities',
  initialState: {
    cities: [],
    loading: false,
    error: null,
  },
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(fetchCities.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchCities.fulfilled, (state, action) => {
        state.loading = false;
        state.cities = action.payload; // Set cities to fetched data
      })
      .addCase(fetchCities.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message; // Capture error message
      });
  },
});

// Export the actions and reducer
export const selectCities = (state) => state.cities.cities;
export const selectCitiesLoading = (state) => state.cities.loading;
export const selectCitiesError = (state) => state.cities.error;

export default citySlice.reducer;
