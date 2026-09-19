import { useState } from "react";
import type { FormEvent } from "react";
import { Link, useNavigate } from "react-router-dom";
import { login, register } from "../api/authApi";
import { useAuth } from "../../../app/providers/AuthProvider";
import { ROUTES } from "../../../shared/config/routes";
import { ApiError } from "../../../shared/api/http";
import "./auth.css";

type Props = { mode: "login" | "register" };

export function AuthPage({ mode }: Props) {
  const isLogin = mode === "login";
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const { setToken } = useAuth();
  const navigate = useNavigate();

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setError("");
    setIsSubmitting(true);
    try {
      const response = await (isLogin
        ? login({ email, password })
        : register({ email, password }));
      setToken(response.token);
      navigate(ROUTES.tasks, { replace: true });
    } catch (caught) {
      setError(
        caught instanceof ApiError
          ? caught.message
          : "Impossible de joindre le serveur.",
      );
    } finally {
      setIsSubmitting(false);
    }
  }

  return (
    <main className="auth-layout">
      <section className="auth-aside">
        <div className="brand">
          <span className="brand-mark">✓</span> Taskflow
        </div>
        <div className="aside-copy">
          <p className="eyebrow">ORGANISEZ L’ESSENTIEL</p>
          <h1>Chaque journée mérite un plan clair.</h1>
          <p>
            Centralisez vos priorités et avancez sereinement, où que vous soyez.
          </p>
        </div>
        <div className="aside-card">
          <span>✦</span>
          <p>
            « Une interface simple qui me permet de rester concentré sur ce qui
            compte. »
          </p>
          <small>— Dongmo Noumedem, FullStack Developer</small>
        </div>
      </section>
      <section className="auth-panel">
        <div className="auth-card">
          <div className="mobile-brand">
            <span className="brand-mark">✓</span> Taskflow
          </div>
          <p className="eyebrow teal">BIENVENUE{isLogin ? " À NOUVEAU" : ""}</p>
          <h2>
            {isLogin ? "Connectez-vous à votre espace" : "Créez votre espace"}
          </h2>
          <p className="auth-intro">
            {isLogin
              ? "Ravi de vous revoir. Vos tâches vous attendent."
              : "Commencez à organiser vos tâches en quelques secondes."}
          </p>
          <form onSubmit={submit} noValidate>
            <label>
              Adresse e-mail
              <input
                type="email"
                autoComplete="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="vous@exemple.com"
                required
              />
            </label>
            <label>
              Mot de passe
              <div className="password-field">
                <input
                  type={showPassword ? "text" : "password"}
                  autoComplete={isLogin ? "current-password" : "new-password"}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder={
                    isLogin ? "Votre mot de passe" : "8 caractères minimum"
                  }
                  minLength={8}
                  required
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  aria-label="Afficher ou masquer le mot de passe"
                >
                  {showPassword ? "Masquer" : "Afficher"}
                </button>
              </div>
            </label>
            {!isLogin && (
              <p className="field-hint">Utilisez au moins 8 caractères.</p>
            )}
            {error && (
              <p className="form-error" role="alert">
                {error}
              </p>
            )}
            <button className="primary-button" disabled={isSubmitting}>
              {isSubmitting
                ? "Veuillez patienter…"
                : isLogin
                  ? "Se connecter"
                  : "Créer mon compte"}{" "}
              <span>→</span>
            </button>
          </form>
          <p className="auth-switch">
            {isLogin ? "Pas encore de compte ?" : "Vous avez déjà un compte ?"}{" "}
            <Link to={isLogin ? ROUTES.register : ROUTES.login}>
              {isLogin ? "Créer un compte" : "Se connecter"}
            </Link>
          </p>
        </div>
      </section>
    </main>
  );
}
