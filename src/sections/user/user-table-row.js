import PropTypes from 'prop-types';
// @mui
import Button from '@mui/material/Button';
import Avatar from '@mui/material/Avatar';
import Tooltip from '@mui/material/Tooltip';
import TableRow from '@mui/material/TableRow';
import TableCell from '@mui/material/TableCell';
import ListItemText from '@mui/material/ListItemText';
import { useState } from 'react';
// MUI Icons
import CheckCircleOutlineIcon from '@mui/icons-material/CheckCircleOutline';
import DoNotDisturbOnOutlinedIcon from '@mui/icons-material/DoNotDisturbOnOutlined';
import CancelOutlinedIcon from '@mui/icons-material/CancelOutlined';
// hooks
import { useBoolean } from 'src/hooks/use-boolean';
// components
import Label from 'src/components/label';
import { ConfirmDialog } from 'src/components/custom-dialog';
import ReviewForm from 'src/sections/five/review-form';
import { useAuthContext } from 'src/auth/hooks';

import { View403 } from 'src/sections/error';

export default function UserTableRow({ row, selected }) {
  const {
    teacher_name,
    teacher_profile_picture,
    student_profile_picture,
    start_date,
    end_date,
    status,
    email,
    subjects,
  } = row;

  const confirm = useBoolean();
  const [isReviewDialogOpen, setReviewDialogOpen] = useState(false);
  const { user } = useAuthContext();
  const role = user?.role;

  const handleOpenReviewDialog = () => setReviewDialogOpen(true);
  const handleCloseReviewDialog = () => setReviewDialogOpen(false);

  const handleSubmitReview = (data) => {
    console.log('Review Submitted:', data);
    handleCloseReviewDialog();
  };

  return (
    <>
      <TableRow hover selected={selected}>
        <TableCell padding="checkbox">
          {/* <Checkbox checked={selected} onClick={onSelectRow} /> */}
        </TableCell>

        <TableCell sx={{ display: 'flex', alignItems: 'center' }}>
        {role === 'student' && (
          <Avatar alt={teacher_name} src={teacher_profile_picture} sx={{ mr: 2 }} />
        )}
         {role === 'teacher' && (
          <Avatar alt={teacher_name} src={student_profile_picture} sx={{ mr: 2 }} />
        )}
          <ListItemText
            primary={teacher_name}
            secondary={email}
            primaryTypographyProps={{ typography: 'body2' }}
            secondaryTypographyProps={{
              component: 'span',
              color: 'text.disabled',
            }}
          />
        </TableCell>

        <TableCell sx={{ whiteSpace: 'nowrap' }}>
          {subjects?.map((subject) => subject.subject_name).join(', ')}
        </TableCell>

        <TableCell sx={{ whiteSpace: 'nowrap' }}>
          {new Date(start_date).toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'short',
            day: 'numeric',
          })}
        </TableCell>

        <TableCell sx={{ whiteSpace: 'nowrap' }}>
          {new Date(end_date).toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'short',
            day: 'numeric',
          })}
        </TableCell>

        <TableCell>
          <Label
            variant="soft"
            color={
              (status === 'active' && 'success') ||
              (status === 'pending' && 'warning') ||
              (status === 'banned' && 'error') ||
              'default'
            }
          >
            {status}
          </Label>
        </TableCell>

        <TableCell
          align="right"
          sx={{
            px: 1,
            display: 'flex',
            gap: 1,
            justifyContent: 'flex-end',
            whiteSpace: 'nowrap',
            alignItems: 'center', 
            position: 'relative',
            top: '-11px', 
          }}
        >
        {role === 'teacher' && status === 'pending' && (
  <>
    <Button
      variant="outlined"
      color="primary"
      size="small"
      onClick={() => console.log('Approve action')}
    >
      Approve
    </Button>
    <Button
      variant="outlined"
      color="primary"
      size="small"
      onClick={() => console.log('Reject action')}
    >
      Reject
    </Button>
  </>
)}
{role === 'student' && status === 'active' && (
    
            <Button
              variant="outlined"
              color="primary"
              size="small"
              onClick={() => {
                confirm.onTrue();
              }}
            >
              Cancel
            </Button>
          )}
        {role === 'student' && status === 'completed' && (
        
            <Button
              variant="outlined"
              color="primary"
              size="small"
              onClick={handleOpenReviewDialog}
            >
              Add a Review
            </Button>
          )}
           {role === 'student' && status === 'accepted' && (
        
            <Button
              variant="outlined"
              color="primary"
              size="small"
              onClick={() => console.log('Pay now action')}
            >
              Pay now
            </Button>
          )}
        </TableCell>
      </TableRow>

      {/* Review Dialog */}
      {isReviewDialogOpen && (
        <ReviewForm
          open={isReviewDialogOpen}
          onClose={handleCloseReviewDialog}
          onSubmitReview={handleSubmitReview}
          studentId={row.student_profile_picture}
        />
      )}

      <ConfirmDialog
        open={confirm.value}
        onClose={confirm.onFalse}
        title="Cancel"
        content="Are you sure want to cancel?"
        action={
          <Button
            variant="contained"
            color="error"
            onClick={() => {
              console.log('Cancelled');
              confirm.onFalse();
            }}
          >
            Confirm
          </Button>
        }
      />
    </>
  );
}

UserTableRow.propTypes = {
  row: PropTypes.object,
  selected: PropTypes.bool,
};
