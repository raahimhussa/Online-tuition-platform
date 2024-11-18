import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';

// Thunk for fetching teacher data
// Thunk for fetching teacher data
export const fetchTeachers = createAsyncThunk('teachers/fetchTeachers', async () => {
  // eslint-disable-next-line no-useless-catch
  try {
    const response = await fetch('http://localhost:3009/api/teachers/get-all-teachers/');
    if (!response.ok) {
      throw new Error('Failed to fetch teachers');
    }
    const data = await response.json(); // The API response is an array of teacher objects
    return data;
  } catch (error) {
    // If an error occurs, throw it to be caught in the rejected case of the thunk
    throw error;
  }
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
        state.error = action.error.message || 'Failed to fetch teachers'; // Store any error message
      });
  },
});

// Selectors
export const selectTeachers = (state) => state.teachers.teachers;
export const selectTeachersLoading = (state) => state.teachers.loading;
export const selectTeachersError = (state) => state.teachers.error;

// Export the reducer
export default teacherSlice.reducer;
