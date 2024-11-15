import { createContract, getContractById, updateContractStatus, deleteContract } from '../../../../lib/contractService';

export async function POST(req) {
    const data = await req.json();
    const contract = await createContract(data);
    return new Response(JSON.stringify(contract), { status: 201 });
}

export async function GET(req) {
    const contractId = req.query.contract_id;
    const contract = await getContractById(contractId);
    return new Response(JSON.stringify(contract), { status: 200 });
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