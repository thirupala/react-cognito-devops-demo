import React, { createContext, useContext, useEffect, useState } from "react";

type Tokens = {
  accessToken: string;
  idToken: string;
  refreshToken?: string;
};

type AuthContextType = {
  tokens: Tokens | null;
  setTokens: (tokens: Tokens | null) => void;
};

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [tokens, setTokens] = useState<Tokens | null>(null);

  useEffect(() => {
    const stored = sessionStorage.getItem("cognitoTokens");
    if (stored) {
      setTokens(JSON.parse(stored));
    }
  }, []);

  useEffect(() => {
    if (tokens) {
      sessionStorage.setItem("cognitoTokens", JSON.stringify(tokens));
    } else {
      sessionStorage.removeItem("cognitoTokens");
    }
  }, [tokens]);

  return (
    <AuthContext.Provider value={{ tokens, setTokens }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = (): AuthContextType => {
  const ctx = useContext(AuthContext);
  if (!ctx) {
    throw new Error("useAuth must be used within AuthProvider");
  }
  return ctx;
};
