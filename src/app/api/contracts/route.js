<<<<<<< HEAD
import { createContract, getContractById, updateContractStatus, deleteContract ,getAllContracts} from '../../../lib/contractService';
=======
import { createContract, getContractById, updateContractStatus, deleteContract,getAllContracts } from '../../../lib/contractService';
>>>>>>> a037386eaf962f711f7057bc8d237fc7d78aba1d

export async function POST(req) {
    const data = await req.json();
    const contract = await createContract(data);
    return new Response(JSON.stringify(contract), { status: 201 });
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