<<<<<<< HEAD
import { createContract, getContractById, updateContractStatus, deleteContract ,getAllContracts} from '../../../lib/contractService';
=======
import { createContract, getContractById, updateContractStatus, deleteContract,getAllContracts } from '../../../lib/contractService';
>>>>>>> a037386eaf962f711f7057bc8d237fc7d78aba1d

export async function POST(req) {
  const client = await query.connect(); // Start a client connection for transaction control
  try {
    const body = await req.json();
    const { student_id, teacher_id, start_date, end_date, mode, payment_terms, status, subjects } = body;

    await client.query('BEGIN'); // Start transaction

    // Insert into `hiring_contracts` table
    const insertContractQuery = `
      INSERT INTO hiring_contracts (student_id, teacher_id, start_date, end_date, mode, payment_terms, status)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      RETURNING *;
    `;
    const contractValues = [student_id, teacher_id, start_date, end_date, mode, payment_terms, status];
    const { rows: contractRows } = await client.query(insertContractQuery, contractValues);
    const newContract = contractRows[0];

    // Insert into `contract_subjects` table for each subject
    const insertSubjectQuery = `
      INSERT INTO contract_subjects (contract_id, subject_id)
      VALUES ($1, $2);
    `;

    for (const subjectId of subjects) {
      await client.query(insertSubjectQuery, [newContract.contract_id, subjectId]);
    }

    await client.query('COMMIT'); // Commit transaction

    return new Response(JSON.stringify(newContract), { status: 201 });
  } catch (error) {
    await client.query('ROLLBACK'); // Rollback transaction on error
    console.error('Error creating contract:', error);
    return new Response(
      JSON.stringify({ message: 'Failed to create contract', error: error.message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  } finally {
    client.release(); // Release client
  }
}


export async function GET(req) {
    try {
      const url = new URL(req.url);
<<<<<<< HEAD
      const contractId = url.searchParams.get('contract_id'); // Get contract_id from query parameters
  
      if (contractId) {
        const contract = await getContractById(contractId);
        if (!contract) {
          return new Response(
            JSON.stringify({ message: 'Contract not found' }),
            {
              status: 404,
              headers: { 'Content-Type': 'application/json' },
            }
          );
=======
      const contractId = url.searchParams.get('contract_id'); // Get `contract_id` from query parameters
  
      if (contractId) {
        // Fetch contract by ID
        const contract = await getContractById(contractId);
        if (!contract) {
          return new Response(JSON.stringify({ message: 'Contract not found' }), {
            status: 404,
            headers: { 'Content-Type': 'application/json' },
          });
>>>>>>> a037386eaf962f711f7057bc8d237fc7d78aba1d
        }
        return new Response(JSON.stringify(contract), {
          status: 200,
          headers: { 'Content-Type': 'application/json' },
        });
<<<<<<< HEAD
      }
  
      const contracts = await getAllContracts();
      return new Response(JSON.stringify(contracts), {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      });
    } catch (error) {
      console.error('Error fetching contracts:', error);
      return new Response(
        JSON.stringify({
          message: 'Failed to fetch contracts',
          error: error.message,
        }),
        {
          status: 500,
          headers: { 'Content-Type': 'application/json' },
        }
      );
=======
      } else {
        // Fetch all contracts if no ID is provided
        const contracts = await getAllContracts();
        return new Response(JSON.stringify(contracts), {
          status: 200,
          headers: { 'Content-Type': 'application/json' },
        });
      }
    } catch (error) {
      console.error('Error fetching contract(s):', error);
      return new Response(JSON.stringify({ message: 'Failed to fetch contracts', error: error.message }), {
        status: 500,
        headers: { 'Content-Type': 'application/json' },
      });
>>>>>>> a037386eaf962f711f7057bc8d237fc7d78aba1d
    }
  }

export async function PUT(req) {
    const { contract_id, status } = await req.json();
    const updatedContract = await updateContractStatus(contract_id, status);
    return new Response(JSON.stringify(updatedContract), { status: 200 });
}

export async function DELETE(req) {
    const { contract_id } = await req.json();
    await deleteContract(contract_id);
    return new Response(JSON.stringify({ message: 'Contract deleted' }), { status: 200 });
}