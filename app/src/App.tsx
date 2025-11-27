import React from "react";
import { BrowserRouter, Navigate, Route, Routes } from "react-router-dom";
import { AuthProvider, useAuth } from "./AuthContext";
import LoginButton from "./LoginButton";
import LogoutButton from "./LogoutButton";
import Callback from "./Callback";
import ProtectedPage from "./ProtectedPage";

const ProtectedRoute: React.FC<{ children: React.ReactElement }> = ({ children }) => {
  const { tokens } = useAuth();
  if (!tokens) {
    return <Navigate to="/" replace />;
  }
  return children;
};

const AppRoutes: React.FC = () => {
  const { tokens } = useAuth();

  return (
    <Routes>
      <Route
        path="/"
        element={
          <div style={{ padding: "1rem" }}>
            <h1>Cognito React Demo</h1>
            {tokens ? (
              <>
                <p>Logged in!</p>
                <LogoutButton />
              </>
            ) : (
              <>
                <p>You are not logged in.</p>
                <LoginButton />
              </>
            )}
            <hr />
            <a href="/protected">Go to protected page</a>
          </div>
        }
      />
      <Route path="/callback" element={<Callback />} />
      <Route
        path="/protected"
        element={
          <ProtectedRoute>
            <ProtectedPage />
          </ProtectedRoute>
        }
      />
    </Routes>
  );
};

const App: React.FC = () => (
  <AuthProvider>
    <BrowserRouter>
      <AppRoutes />
    </BrowserRouter>
  </AuthProvider>
);

export default App;
