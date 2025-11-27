import React, { useEffect } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import { cognitoConfig } from "./authConfig";
import { useAuth } from "./AuthContext";

const Callback: React.FC = () => {
  const location = useLocation();
  const navigate = useNavigate();
  const { setTokens } = useAuth();

  useEffect(() => {
    const query = new URLSearchParams(location.search);
    const code = query.get("code");
    const error = query.get("error");

    if (error) {
      console.error("Cognito error:", error);
      return;
    }
    if (!code) return;

    const verifier = sessionStorage.getItem("pkce_verifier");
    if (!verifier) {
      console.error("Missing PKCE verifier");
      return;
    }

    (async () => {
      const tokenUrl = `https://${cognitoConfig.domain}/oauth2/token`;

      const body = new URLSearchParams();
      body.append("grant_type", "authorization_code");
      body.append("client_id", cognitoConfig.clientId);
      body.append("code", code);
      body.append("redirect_uri", cognitoConfig.redirectUri);
      body.append("code_verifier", verifier);

      const resp = await fetch(tokenUrl, {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: body.toString(),
      });

      if (!resp.ok) {
        console.error("Failed to exchange code", await resp.text());
        return;
      }

      const data = await resp.json();
      setTokens({
        accessToken: data.access_token,
        idToken: data.id_token,
        refreshToken: data.refresh_token,
      });

      sessionStorage.removeItem("pkce_verifier");
      navigate("/", { replace: true });
    })();
  }, [location.search, navigate, setTokens]);

  return <div>Processing login...</div>;
};

export default Callback;
