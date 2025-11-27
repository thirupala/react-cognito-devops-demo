import React from "react";
import { useAuth } from "./AuthContext";

const ProtectedPage: React.FC = () => {
  const { tokens } = useAuth();

  if (!tokens) {
    return <div>You are not authorized.</div>;
  }

  return (
    <div>
      <h2>Protected Content</h2>
      <pre>{JSON.stringify(tokens, null, 2)}</pre>
    </div>
  );
};

export default ProtectedPage;
