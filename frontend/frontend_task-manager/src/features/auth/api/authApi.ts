import { apiRequest } from "../../../shared/api/http";
import type { AuthResponse, Credentials } from "../types/auth";

export const login = (data: Credentials) =>
  apiRequest<AuthResponse>("/api/auth/login", {
    method: "POST",
    body: JSON.stringify(data),
  });
export const register = (data: Credentials) =>
  apiRequest<AuthResponse>("/api/auth/register", {
    method: "POST",
    body: JSON.stringify(data),
  });
