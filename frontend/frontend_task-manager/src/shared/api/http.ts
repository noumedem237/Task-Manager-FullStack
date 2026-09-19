import { API_BASE_URL } from "../config/env";
import toast from "react-hot-toast";

type ApiErrorPayload = {
  message?: string;
};

export class ApiError extends Error {
  public readonly status: number;

  constructor(message: string, status: number) {
    super(message);
    this.status = status;
  }
}

export async function apiRequest<T>(
  path: string,
  options: RequestInit = {},
): Promise<T> {
  let response: Response;

  try {
    response = await fetch(`${API_BASE_URL}${path}`, {
      ...options,
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
        ...options.headers,
      },
    });
  } catch {
    const error = new ApiError(
      "Connexion au serveur impossible. Vérifiez votre réseau.",
      0,
    );
    toast.error(error.message);
    throw error;
  }

  if (!response.ok) {
    const payload = (await response
      .json()
      .catch(() => ({}))) as ApiErrorPayload;
    const message =
      response.status === 401
        ? "Votre session a expiré. Veuillez vous reconnecter."
        : response.status >= 500
          ? "Le serveur rencontre un problème. Réessayez dans un instant."
          : payload.message || "Une erreur est survenue. Réessayez.";
    const error = new ApiError(message, response.status);
    toast.error(error.message);
    throw error;
  }

  if (response.status === 204) return undefined as T;
  return response.json() as Promise<T>;
}
