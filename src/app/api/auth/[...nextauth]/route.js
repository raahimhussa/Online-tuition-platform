import NextAuth from 'next-auth';
import CredentialsProvider from 'next-auth/providers/credentials';

export default NextAuth({
  providers: [
    CredentialsProvider({
      name: 'Credentials',
      credentials: {
        username: { label: "Username", type: "text" },
        password: { label: "Password", type: "password" }
      },
      authorize: async (credentials) => {
        // Replace with your logic to fetch user data from localStorage or an API
        const userRole = localStorage.getItem("userRole"); // Example, get from localStorage
        console.log("userRole AUTHORIZE", userRole);
        if (userRole) {
          return { id: 1, name: "User", role: userRole };
        }
        return null;
      }
    })
  ],
  callbacks: {
    async session({ session, token }) {
      session.user.role = token.role;
      return session;
    },
    async jwt({ token, user }) {
      if (user) {
        token.role = user.role;
      }
      return token;
    }
  },
  secret: process.env.NEXTAUTH_SECRET
});
