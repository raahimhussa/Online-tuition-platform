import PropTypes from 'prop-types';
// @mui
import Button from '@mui/material/Button';
import Avatar from '@mui/material/Avatar';
import Tooltip from '@mui/material/Tooltip';
import MenuItem from '@mui/material/MenuItem';
import TableRow from '@mui/material/TableRow';
import Checkbox from '@mui/material/Checkbox';
import TableCell from '@mui/material/TableCell';
import IconButton from '@mui/material/IconButton';
import ListItemText from '@mui/material/ListItemText';
// hooks
import { useBoolean } from 'src/hooks/use-boolean';
// components
import Label from 'src/components/label';
import Iconify from 'src/components/iconify';
import CustomPopover, { usePopover } from 'src/components/custom-popover';
import { ConfirmDialog } from 'src/components/custom-dialog';
//
// import UserQuickEditForm from './user-quick-edit-form';

// ----------------------------------------------------------------------

export default function UserTableRow({ row, selected}) {
  const { teacher_name, teacher_profile_picture,student_profile_picture,start_date , end_date, status, email, subjects } = row;

  const confirm = useBoolean();

  const quickEdit = useBoolean();

  const popover = usePopover();

  return (
    <>
      <TableRow hover selected={selected}>
        <TableCell padding="checkbox">
          {/* <Checkbox checked={selected} onClick={onSelectRow} /> */}
        </TableCell>

        <TableCell sx={{ display: 'flex', alignItems: 'center' }}>
          <Avatar alt={teacher_name} src={teacher_profile_picture} sx={{ mr: 2 }} />

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
  {subjects.map((subject) => subject.subject_name).join(', ')}
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

   

<TableCell align="right" sx={{ px: 1, display: 'flex', gap: 1, justifyContent: 'flex-end', whiteSpace: 'nowrap' }}>
  {status === 'pending' && (
    <>
      <Tooltip title="Approve" placement="top" arrow>
        <IconButton color="success" onClick={() => console.log('Approve action')}>
          <Iconify icon="mdi:check-circle" />
        </IconButton>
      </Tooltip>
      <Tooltip title="Reject" placement="top" arrow>
        <IconButton color="error" onClick={() => console.log('Reject action')}  sx={{ ml:2.5}}>
          <Iconify icon="mdi:close-circle" />
        </IconButton>
      </Tooltip>
    </>
  )}

  {status === 'active' && (
    <Tooltip title="Cancel" placement="top" arrow>
      <IconButton 
        color="default" 
        onClick={() => {
          confirm.onTrue();
          popover.onClose();
        }}
        sx={{ ml:4.5 }}
      >
        
        <Iconify icon="ooui:cancel" />
      </IconButton>
    </Tooltip>
  )}

  {status === 'completed' && (
   <Tooltip title="Add a Review" placement="top" arrow>
   <Button
     variant="outlined" // Provides a cleaner, professional look
     color="primary" // Keeps a professional tone
     onClick={quickEdit.onTrue}
   >
     Add a Review
   </Button>
 </Tooltip>
  )}
  {status === 'accepted' && (
   <Tooltip title="Pay now" placement="top" arrow>
   <Button
     variant="outlined" // Provides a cleaner, professional look
     color="primary" // Keeps a professional tone
     onClick={quickEdit.onTrue}
   >
     Pay now
   </Button>
 </Tooltip>
  )}
</TableCell>



      </TableRow>



      <ConfirmDialog
        open={confirm.value}
        onClose={confirm.onFalse}
        title="Cancel"
        content="Are you sure want to cancel ?"
        action={
          <Button variant="contained" color="error" >
            Cancel
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
