import React from "react";
import { cognitoConfig } from "./authConfig";
import { useAuth } from "./AuthContext";

const LogoutButton: React.FC = () => {
  const { setTokens } = useAuth();

  const handleLogout = () => {
    setTokens(null);

    const logoutUrl = new URL(`https://${cognitoConfig.domain}/logout`);
    logoutUrl.searchParams.append("client_id", cognitoConfig.clientId);
    logoutUrl.searchParams.append("logout_uri", cognitoConfig.logoutRedirectUri);

    window.location.assign(logoutUrl.toString());
  };

  return <button onClick={handleLogout}>Logout</button>;
};

export default LogoutButton;
