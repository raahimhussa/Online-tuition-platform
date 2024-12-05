// src/app/store/slices/contractSlice.js
import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';

// Thunk for creating a contract
export const createContract = createAsyncThunk(
  'contracts/createContract',
  async (contractData, { rejectWithValue }) => {
    try {
      const response = await fetch('/api/contracts', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${localStorage.getItem('accessToken')}`,
        },
        body: JSON.stringify(contractData),
      });

      // Check if response is successful
      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || 'Failed to create contract');
      }

      // Parse and return response if successful
      return await response.json();
    } catch (error) {
      console.error('Error creating contract:', error);
      return rejectWithValue(error.message);
    }
  }
);


// Thunk for fetching all contracts
export const fetchAllContracts = createAsyncThunk(
  'contracts/fetchAllContracts',
  async (_, { rejectWithValue }) => {
    try {
      const response = await fetch('/api/contracts', {
        headers: {
          Authorization: `Bearer ${localStorage.getItem('accessToken')}`,
        },
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || 'Failed to fetch contracts');
      }

      return await response.json(); // Assuming API returns a list of contracts
    } catch (error) {
      return rejectWithValue(error.message);
    }
  }
);
// Thunk for updating contract status
// Thunk for updating contract status
export const updateContractStatus = createAsyncThunk(
  'contracts/updateContractStatus',
  async (contractId, { rejectWithValue }) => {
    try {
      const response = await fetch(`/api/contracts/${contractId}`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${localStorage.getItem('accessToken')}`,
        },
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || 'Failed to update contract status');
      }

      // Only contract_id is returned in the response
      return contractId; // Return the contract_id to update the Redux state
    } catch (error) {
      return rejectWithValue(error.message);
    }
  }
);


// Contract slice
const contractSlice = createSlice({
  name: 'contracts',
  initialState: {
    contracts: [],
    contract: null,
    loading: false,
    error: null,
  },
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(createContract.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(createContract.fulfilled, (state, action) => {
        state.loading = false;
        state.contract = action.payload;
        state.contracts.push(action.payload);
      })
      .addCase(createContract.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload || 'Failed to create contract';
      })
      .addCase(fetchAllContracts.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchAllContracts.fulfilled, (state, action) => {
        state.loading = false;
        state.contracts = action.payload;
      })
      .addCase(fetchAllContracts.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload || 'Failed to fetch contracts';
      })
      .addCase(updateContractStatus.pending, (state) => {
          state.loading = true;
          state.error = null;
        })
        .addCase(updateContractStatus.fulfilled, (state, action) => {
          state.loading = false;
          state.contract = action.payload;
          state.contracts.push(action.payload);
        })
        .addCase(updateContractStatus.rejected, (state, action) => {
          state.loading = false;
          state.error = action.payload || 'Failed to create contract';
      });
  },
});

// Selectors
export const selectContracts = (state) => state.contracts.contracts;
export const selectSingleContract = (state) => state.contracts.contract;
export const selectContractsLoading = (state) => state.contracts.loading;
export const selectContractsError = (state) => state.contracts.error;

// Export the reducer
export default contractSlice.reducer;
