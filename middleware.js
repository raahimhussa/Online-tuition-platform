import { getToken } from 'next-auth/jwt';
import { NextResponse } from 'next/server';

export async function middleware(req) {
  const token = await getToken({ req, secret: process.env.NEXTAUTH_SECRET });
  const { pathname } = req.nextUrl;

  // Check if user is trying to access a teacher-only path
  if (pathname.startsWith('/dashboard') && (!token || token.role !== 'teacher')) {
    const url = req.nextUrl.clone();
    url.pathname = '/404'; // Redirect to NotFound page
    return NextResponse.rewrite(url);
  }

  return NextResponse.next();
}
