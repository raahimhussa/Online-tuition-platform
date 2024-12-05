'use client';

import PropTypes from 'prop-types';
import * as Yup from 'yup';
import { useForm, Controller } from 'react-hook-form';
import { yupResolver } from '@hookform/resolvers/yup';
import { 
  Dialog, 
  DialogTitle, 
  DialogContent, 
  DialogActions, 
  TextField, 
  Typography, 
  Rating, 
  Divider, 
  Button 
} from '@mui/material';
import LoadingButton from '@mui/lab/LoadingButton';
import React, { useState } from 'react';

// ----------------------------------------------------------------------

export default function ReviewForm({ onSubmitReview, studentId, open, onClose }) {
  const [isLoading, setIsLoading] = useState(false);

  const ReviewSchema = Yup.object().shape({
    rating: Yup.number()
      .min(1, 'Minimum rating is 1')
      .max(5, 'Maximum rating is 5')
      .required('Rating is required'),
    reviewText: Yup.string().required('Review text is required'),
  });

  const methods = useForm({
    resolver: yupResolver(ReviewSchema),
    defaultValues: {
      rating: 0,
      reviewText: '',
    },
  });

  const { handleSubmit, control, formState: { errors } } = methods;

  const handleReviewSubmit = async (data) => {
    setIsLoading(true);

    const reviewData = { ...data, studentId };

    console.log('Submitting Review:', reviewData);
    if (onSubmitReview) onSubmitReview(reviewData);

    setTimeout(() => {
      setIsLoading(false);
      alert('Review submitted successfully!');
      onClose(); // Close the dialog on successful submission
    }, 1500);
  };

  return (
    <Dialog open={open} onClose={onClose} fullWidth maxWidth="sm">
      <DialogTitle>Submit a Review</DialogTitle>
      
      <DialogContent>
        <form onSubmit={handleSubmit(handleReviewSubmit)}>
          <Typography variant="h6" gutterBottom>
            Review Details
          </Typography>
          <Divider sx={{ mb: 2 }} />

          {/* Rating Field */}
          <Typography sx={{ mb: 1 }}>Rating</Typography>
          <Controller
            name="rating"
            control={control}
            render={({ field }) => (
              <Rating {...field} size="large" max={5} precision={0.5} />
            )}
          />
          {errors.rating && (
            <Typography variant="caption" color="error">
              {errors.rating.message}
            </Typography>
          )}

          {/* Review Text Field */}
          <TextField
            fullWidth
            multiline
            rows={4}
            label="Review"
            placeholder="Share your experience..."
            error={!!errors.reviewText}
            helperText={errors.reviewText?.message}
            {...methods.register('reviewText')}
            sx={{ mt: 2 }}
          />
        </form>
      </DialogContent>

      <DialogActions>
        <Button onClick={onClose} color="inherit">
          Cancel
        </Button>
        <LoadingButton
          type="submit"
          variant="contained"
          loading={isLoading}
          onClick={handleSubmit(handleReviewSubmit)}
        >
          Submit Review
        </LoadingButton>
      </DialogActions>
    </Dialog>
  );
}

ReviewForm.propTypes = {
  onSubmitReview: PropTypes.func,
  studentId: PropTypes.string.isRequired,
  open: PropTypes.bool.isRequired,
  onClose: PropTypes.func.isRequired,
};
