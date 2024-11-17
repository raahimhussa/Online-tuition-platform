import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';

// Thunk for fetching teacher data
export const fetchTeachers = createAsyncThunk('teachers/fetchTeachers', async () => {
  const response = await fetch('/api/teachers/get-all-teachers/');
  console.log(response) // Adjust the API endpoint if needed
  if (!response.ok) {
    throw new Error('Failed to fetch teachers');
  }
  return response.json(); // The API response is an array of teacher objects
});

// Teacher slice
const teacherSlice = createSlice({
  name: 'teachers',
  initialState: {
    teachers: [], // List of teachers
    loading: false, // Loading state
    error: null, // Error state
  },
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(fetchTeachers.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchTeachers.fulfilled, (state, action) => {
        state.loading = false;
        state.teachers = action.payload; // Store the fetched teacher data
      })
      .addCase(fetchTeachers.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message; // Store any error message
      });
  },
});

// Selectors
export const selectTeachers = (state) => state.teachers.teachers;
export const selectTeachersLoading = (state) => state.teachers.loading;
export const selectTeachersError = (state) => state.teachers.error;

// Export the reducer
export default teacherSlice.reducer;
