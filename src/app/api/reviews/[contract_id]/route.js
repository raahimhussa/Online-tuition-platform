// src/app/api/reviews/[contractId]/route.js

import { verifyToken } from "src/lib/auth";
import { query } from "src/lib/db";


export async function POST(req, { params }) {
  try {
    const { contractId } = params;

    if (!contractId) {
      return new Response(
        JSON.stringify({ message: 'Contract ID is required' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Extract the token from the headers
    const token = req.headers.get('Authorization')?.split(' ')[1];
    if (!token) {
      return new Response(
        JSON.stringify({ message: 'Unauthorized: No token provided' }),
        { status: 401, headers: { 'Content-Type': 'application/json' } }
      );
    }

    const userId = verifyToken(token)?.id;
    if (!userId) {
      return new Response(
        JSON.stringify({ message: 'Unauthorized: Invalid token' }),
        { status: 401, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Parse the review data from the request body
    const { rating, comment } = await req.json();

    // Validate the rating
    if (!rating || rating < 1 || rating > 5) {
      return new Response(
        JSON.stringify({ message: 'Rating must be between 1 and 5' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Insert the review into the database
    const insertReviewQuery = `
      INSERT INTO reviews (contract_id, user_id, rating, comment, created_at)
      VALUES ($1, $2, $3, $4, NOW())
      RETURNING *;
    `;
    const { rows: reviewRows } = await query(insertReviewQuery, [
      contractId,
      userId,
      rating,
      comment,
    ]);

    return new Response(JSON.stringify(reviewRows[0]), {
      status: 201,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Error creating review:', error);
    return new Response(
      JSON.stringify({ message: 'Failed to create review', error: error.message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
}  

export async function GET(req, { params }) {
  try {
    const { contractId } = params;

    if (!contractId) {
      return new Response(
        JSON.stringify({ message: 'Contract ID is required' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Fetch reviews for the specific contract
    const fetchReviewsQuery = `
      SELECT * 
      FROM reviews 
      WHERE contract_id = $1
      ORDER BY created_at DESC;
    `;
    const { rows: reviews } = await query(fetchReviewsQuery, [contractId]);

    if (reviews.length === 0) {
      return new Response(
        JSON.stringify({ message: 'No reviews found for this contract' }),
        { status: 404, headers: { 'Content-Type': 'application/json' } }
      );
    }

    return new Response(JSON.stringify(reviews), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Error fetching reviews:', error);
    return new Response(
      JSON.stringify({ message: 'Failed to fetch reviews', error: error.message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
}
