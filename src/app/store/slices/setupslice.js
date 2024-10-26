import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';

export const saveUser = createAsyncThunk(
  'user/saveUser',
  async (userData, { rejectWithValue }) => {
    try {
      // Simulate API call to save user data
      const response = await new Promise((resolve) => setTimeout(() => resolve(userData), 500));
      return response;
    } catch (error) {
      return rejectWithValue(error.message);
    }
  }
);

const initialState = {
  education: '',
  experience_years: '',
  bio: '',
  teachingMode: 'online', // Default value for teaching mode
  loading: false,
  error: null,
};

const userSlice = createSlice({
  name: 'user',
  initialState,
  reducers: {
    setEducation: (state, action) => {
      state.education = action.payload;
    },
    setExperienceYears: (state, action) => {
      state.experience_years = action.payload;
    },
    setBio: (state, action) => {
      state.bio = action.payload;
    },
    setTeachingMode: (state, action) => {
      state.teachingMode = action.payload;
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(saveUser.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(saveUser.fulfilled, (state, action) => {
        state.loading = false;
        Object.assign(state, action.payload); // Update state with saved user data
      })
      .addCase(saveUser.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload;
      });
  },
});

export const {
  setEducation,
  setExperienceYears,
  setBio,
  setTeachingMode,
} = userSlice.actions;

export default userSlice.reducer;
