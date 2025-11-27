import React from "react";
import { cognitoConfig } from "./authConfig";
import { generateCodeChallenge, generateCodeVerifier } from "./pkce";

const LoginButton: React.FC = () => {
  const handleLogin = async () => {
    const verifier = await generateCodeVerifier();
    const challenge = await generateCodeChallenge(verifier);

    sessionStorage.setItem("pkce_verifier", verifier);

    const url = new URL(`https://${cognitoConfig.domain}/oauth2/authorize`);
    url.searchParams.append("client_id", cognitoConfig.clientId);
    url.searchParams.append("response_type", "code");
    url.searchParams.append("redirect_uri", cognitoConfig.redirectUri);
    url.searchParams.append("scope", cognitoConfig.scopes.join(" "));
    url.searchParams.append("code_challenge_method", "S256");
    url.searchParams.append("code_challenge", challenge);

    window.location.assign(url.toString());
  };

  return <button onClick={handleLogin}>Login with Cognito</button>;
};

export default LoginButton;
