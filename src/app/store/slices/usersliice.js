import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';

// Thunks for asynchronous actions, e.g., saving or updating user data
export const saveUser = createAsyncThunk('user/saveUser', async (userData, { rejectWithValue }) => {
  try {
    // Simulate API call to save user data
    const response = await new Promise((resolve) => setTimeout(() => resolve(userData), 500));
    return response;
  } catch (error) {
    return rejectWithValue(error.message);
  }
});

const initialState = {
  firstName: '',
  lastName: '',
  email: '',
  phoneNumber: '',
  gender: '',
  area: '',
  city: '',
  region: '',
  dob: '',
  avatarUrl: null,
  isVerified: true,
  status: 'active', // Assume status can be active or banned
  loading: false,
  error: null,
  
};

const userSlice = createSlice({
  name: 'user',
  initialState,
  reducers: {
    // Synchronous actions to handle each field update
    setFirstName: (state, action) => {
      state.firstName = action.payload;
    },
    setLastName: (state, action) => {
      state.lastName = action.payload;
    },
    setEmail: (state, action) => {
      state.email = action.payload;
    },
    setPhoneNumber: (state, action) => {
      state.phoneNumber = action.payload;
    },
    setGender: (state, action) => {
      state.gender = action.payload;
    },
    setArea: (state, action) => {
      state.area = action.payload;
    },
    setCity: (state, action) => {
      state.city = action.payload;
    },
    setRegion: (state, action) => {
      state.region = action.payload;
    },
    setDob: (state, action) => {
      state.dob = action.payload;
    },
    setAvatarUrl: (state, action) => {
      state.avatarUrl = action.payload;
    },
    setIsVerified: (state, action) => {
      state.isVerified = action.payload;
    },
    setStatus: (state, action) => {
      state.status = action.payload;
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

// Export actions for use in the form component
export const {
  setFirstName,
  setLastName,
  setEmail,
  setPhoneNumber,
  setGender,
  setArea,
  setCity,
  setRegion,
  setDob,
  setAvatarUrl,
  setIsVerified,
  setStatus,
} = userSlice.actions;

// Export the reducer to configure in store
export default userSlice.reducer;
