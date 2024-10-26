import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';

export const saveService = createAsyncThunk(
  'service/saveService',
  async (serviceData, { rejectWithValue }) => {
    try {
      // Simulate API call to save service data
      const response = await new Promise((resolve) =>
        setTimeout(() => resolve(serviceData), 500)
      );
      return response;
    } catch (error) {
      return rejectWithValue(error.message);
    }
  }
);

const initialState = {
  subject: '',
  domain: '',
  subLevel: '',
  duration: '',
  fees: '',
  discount: '',
  loading: false,
  error: null,
};

const serviceSlice = createSlice({
  name: 'service',
  initialState,
  reducers: {
    setSubject: (state, action) => {
      state.subject = action.payload;
    },
    setDomain: (state, action) => {
      state.domain = action.payload;
    },
    setSubLevel: (state, action) => {
      state.subLevel = action.payload;
    },
    setDuration: (state, action) => {
      state.duration = action.payload;
    },
    setFees: (state, action) => {
      state.fees = action.payload;
    },
    setDiscount: (state, action) => {
      state.discount = action.payload;
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(saveService.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(saveService.fulfilled, (state, action) => {
        state.loading = false;
        Object.assign(state, action.payload); // Update state with saved service data
      })
      .addCase(saveService.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload;
      });
  },
});

export const {
  setSubject,
  setDomain,
  setSubLevel,
  setDuration,
  setFees,
  setDiscount,
} = serviceSlice.actions;

export default serviceSlice.reducer;
