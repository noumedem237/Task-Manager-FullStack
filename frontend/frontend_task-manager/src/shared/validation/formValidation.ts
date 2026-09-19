export class FormValidationError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "FormValidationError";
  }
}

export function validateEmail(email: string): string | null {
  const value = email.trim();

  if (!value) return "L’adresse e-mail est requise.";
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
    return "Saisissez une adresse e-mail valide.";
  }

  return null;
}

export function validatePassword(password: string): string | null {
  if (!password) return "Le mot de passe est requis.";
  if (password.length < 8) return "Le mot de passe doit contenir au moins 8 caractères.";

  return null;
}

export function validateTask(title: string, description: string): string | null {
  const normalizedTitle = title.trim();

  if (!normalizedTitle) return "Le titre de la tâche est requis.";
  if (normalizedTitle.length > 150) return "Le titre ne peut pas dépasser 150 caractères.";
  if (description.length > 1_000) return "La description ne peut pas dépasser 1 000 caractères.";

  return null;
}
