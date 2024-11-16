import NextAuth from 'next-auth';
import CredentialsProvider from 'next-auth/providers/credentials';

export const authOptions = {
  providers: [
    CredentialsProvider({
      name: 'Credentials',
      credentials: {
        username: { label: "Username", type: "text" },
        password: { label: "Password", type: "password" }
      },
      authorize: async (credentials) => {
        const { username, password } = credentials;

        // Mocked authentication logic (replace with real logic)
        let userRole = null;
        if (username === "admin" && password === "password123") {
          userRole = "admin";
        } else if (username === "user" && password === "userpass") {
          userRole = "user";
        }

        if (userRole) {
          return { id: 1, name: username, role: userRole };
        }

        // Return null if authentication fails
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
};

export default NextAuth(authOptions);
