import {
  createContext,
  useCallback,
  useContext,
  useMemo,
  useState,
} from "react";
import type { PropsWithChildren } from "react";
import { STORAGE_KEYS } from "../../shared/constants/storage";

type AuthContextValue = {
  token: string | null;
  isAuthenticated: boolean;
  setToken: (token: string) => void;
  logout: () => void;
};

const AuthContext = createContext<AuthContextValue | null>(null);

function getStoredToken(): string | null {
  return localStorage.getItem(STORAGE_KEYS.accessToken);
}

export function AuthProvider({ children }: PropsWithChildren) {
  const [token, setCurrentToken] = useState<string | null>(getStoredToken);

  const setToken = useCallback((nextToken: string) => {
    localStorage.setItem(STORAGE_KEYS.accessToken, nextToken);
    setCurrentToken(nextToken);
  }, []);

  const logout = useCallback(() => {
    localStorage.removeItem(STORAGE_KEYS.accessToken);
    setCurrentToken(null);
  }, []);

  const value = useMemo(
    () => ({
      token,
      isAuthenticated: Boolean(token),
      setToken,
      logout,
    }),
    [token, setToken, logout],
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth(): AuthContextValue {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error("useAuth doit être utilisé dans AuthProvider.");
  }
  return context;
}
