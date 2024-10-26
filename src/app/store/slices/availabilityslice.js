import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';

export const saveAvailability = createAsyncThunk(
  'availability/saveAvailability',
  async (availabilityData, { rejectWithValue }) => {
    try {
      // Simulate API call to save availability data
      const response = await new Promise((resolve) =>
        setTimeout(() => resolve(availabilityData), 500)
      );
      return response;
    } catch (error) {
      return rejectWithValue(error.message);
    }
  }
);

const initialState = {
  availability: {
    Monday: { checked: true, slots: [{ start: '09:00 AM', end: '05:00 PM' }] },
    Tuesday: { checked: true, slots: [{ start: '09:00 AM', end: '05:00 PM' }] },
    Wednesday: { checked: true, slots: [{ start: '09:00 AM', end: '05:00 PM' }] },
    Thursday: { checked: true, slots: [{ start: '09:00 AM', end: '05:00 PM' }] },
    Friday: { checked: true, slots: [{ start: '09:00 AM', end: '05:00 PM' }] },
    Saturday: { checked: true, slots: [{ start: '09:00 AM', end: '05:00 PM' }] },
    Sunday: { checked: true, slots: [{ start: '09:00 AM', end: '05:00 PM' }] },
  },
  loading: false,
  error: null,
};

const availabilitySlice = createSlice({
  name: 'availability',
  initialState,
  reducers: {
    toggleDayAvailability: (state, action) => {
      const { day } = action.payload;
      const isChecked = state.availability[day].checked;
      state.availability[day].checked = !isChecked;
      state.availability[day].slots = isChecked ? [] : [{ start: '09:00 AM', end: '05:00 PM' }];
    },
    addSlot: (state, action) => {
      const { day } = action.payload;
      state.availability[day].slots.push({ start: '09:00 AM', end: '05:00 PM' });
    },
    removeSlot: (state, action) => {
      const { day, index } = action.payload;
      state.availability[day].slots.splice(index, 1);
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(saveAvailability.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(saveAvailability.fulfilled, (state, action) => {
        state.loading = false;
        state.availability = action.payload;
      })
      .addCase(saveAvailability.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload;
      });
  },
});

export const { toggleDayAvailability, addSlot, removeSlot } = availabilitySlice.actions;

export default availabilitySlice.reducer;
