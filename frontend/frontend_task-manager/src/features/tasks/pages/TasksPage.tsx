import { useCallback, useEffect, useMemo, useState } from "react";
import type { FormEvent } from "react";
import { ApiError } from "../../../shared/api/http";
import { useAuth } from "../../../app/providers/AuthProvider";
import { createTask, deleteTask, getTasks, updateTask } from "../api/tasksApi";
import type { Task, TaskPayload, TaskStatus } from "../types/task";
import "./tasks.css";

const labels: Record<TaskStatus, string> = {
  TODO: "À faire",
  IN_PROGRESS: "En cours",
  DONE: "Terminée",
};
const blank: TaskPayload = { title: "", description: "", status: "TODO" };

export function TasksPage() {
  const { token, logout } = useAuth();
  const [tasks, setTasks] = useState<Task[]>([]);
  const [query, setQuery] = useState("");
  const [filter, setFilter] = useState<"ALL" | TaskStatus>("ALL");
  const [draft, setDraft] = useState<TaskPayload>(blank);
  const [editing, setEditing] = useState<Task | null>(null);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(true);
  const load = useCallback(async () => {
    if (!token) return;
    setLoading(true);
    try {
      setTasks(await getTasks(token));
    } catch (e) {
      setError(
        e instanceof ApiError ? e.message : "Impossible de charger les tâches.",
      );
    } finally {
      setLoading(false);
    }
  }, [token]);
  useEffect(() => {
    const timeoutId = window.setTimeout(() => void load(), 0);
    return () => window.clearTimeout(timeoutId);
  }, [load]);
  const visible = useMemo(
    () =>
      tasks.filter(
        (t) =>
          (filter === "ALL" || t.status === filter) &&
          `${t.title} ${t.description ?? ""}`
            .toLowerCase()
            .includes(query.toLowerCase()),
      ),
    [tasks, filter, query],
  );
  async function save(e: FormEvent) {
    e.preventDefault();
    if (!token || !draft.title.trim()) return;
    setError("");
    try {
      if (editing) {
        const task = await updateTask(token, editing.id, draft);
        setTasks((all) => all.map((t) => (t.id === task.id ? task : t)));
      } else {
        const task = await createTask(token, draft);
        setTasks((all) => [task, ...all]);
      }
      setDraft(blank);
      setEditing(null);
    } catch (caught) {
      setError(
        caught instanceof ApiError
          ? caught.message
          : "Enregistrement impossible.",
      );
    }
  }
  const edit = (task: Task) => {
    setEditing(task);
    setDraft({
      title: task.title,
      description: task.description ?? "",
      status: task.status,
    });
    window.scrollTo({ top: 0, behavior: "smooth" });
  };
  const remove = async (id: number) => {
    if (!token || !window.confirm("Supprimer cette tâche ?")) return;
    try {
      await deleteTask(token, id);
      setTasks((all) => all.filter((t) => t.id !== id));
    } catch {
      setError("La suppression a échoué.");
    }
  };
  return (
    <main className="tasks-page">
      <header className="tasks-header">
        <div className="task-brand">
          <span>✓</span> Taskflow
        </div>
        <button className="logout" onClick={logout}>
          Se déconnecter
        </button>
      </header>
      <div className="tasks-content">
        <section className="tasks-hero">
          <div>
            <p className="eyebrow teal">MON ESPACE</p>
            <h1>Mes tâches</h1>
            <p>Gérez vos priorités et progressez, une tâche à la fois.</p>
          </div>
          <div className="task-count">
            <strong>{tasks.filter((t) => t.status !== "DONE").length}</strong>
            <span>à terminer</span>
          </div>
        </section>
        <section className="task-editor">
          <h2>{editing ? "Modifier la tâche" : "Ajouter une tâche"}</h2>
          <form onSubmit={save}>
            <input
              value={draft.title}
              onChange={(e) => setDraft({ ...draft, title: e.target.value })}
              placeholder="Que devez-vous faire ?"
              maxLength={150}
              required
            />
            <input
              value={draft.description ?? ""}
              onChange={(e) =>
                setDraft({ ...draft, description: e.target.value })
              }
              placeholder="Ajouter une note (facultatif)"
              maxLength={5000}
            />
            <select
              value={draft.status}
              onChange={(e) =>
                setDraft({ ...draft, status: e.target.value as TaskStatus })
              }
            >
              {Object.entries(labels).map(([value, label]) => (
                <option key={value} value={value}>
                  {label}
                </option>
              ))}
            </select>
            <button className="primary-button">
              {editing ? "Enregistrer" : "Ajouter"} <span>+</span>
            </button>
            {editing && (
              <button
                type="button"
                className="cancel"
                onClick={() => {
                  setEditing(null);
                  setDraft(blank);
                }}
              >
                Annuler
              </button>
            )}
          </form>
        </section>
        <section className="task-toolbar">
          <input
            aria-label="Rechercher une tâche"
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder="⌕  Rechercher une tâche"
          />
          <div>
            {(["ALL", "TODO", "IN_PROGRESS", "DONE"] as const).map((status) => (
              <button
                key={status}
                className={filter === status ? "active" : ""}
                onClick={() => setFilter(status)}
              >
                {status === "ALL" ? "Toutes" : labels[status]}
              </button>
            ))}
          </div>
        </section>
        {error && <p className="form-error">{error}</p>}
        <section className="task-list">
          {loading ? (
            <p>Chargement de vos tâches…</p>
          ) : visible.length ? (
            visible.map((task) => (
              <article className="task-item" key={task.id}>
                <button
                  className={`status-dot ${task.status}`}
                  onClick={() =>
                    void updateTask(token!, task.id, {
                      title: task.title,
                      description: task.description ?? "",
                      status: task.status === "DONE" ? "TODO" : "DONE",
                    }).then((updated) =>
                      setTasks((all) =>
                        all.map((t) => (t.id === updated.id ? updated : t)),
                      ),
                    )
                  }
                  aria-label="Changer le statut"
                >
                  {task.status === "DONE" ? "✓" : ""}
                </button>
                <div>
                  <h3 className={task.status === "DONE" ? "done" : ""}>
                    {task.title}
                  </h3>
                  {task.description && <p>{task.description}</p>}
                  <small>{labels[task.status]}</small>
                </div>
                <div className="task-actions">
                  <button onClick={() => edit(task)}>Modifier</button>
                  <button
                    className="danger"
                    onClick={() => void remove(task.id)}
                  >
                    Supprimer
                  </button>
                </div>
              </article>
            ))
          ) : (
            <div className="empty-state">
              <span>✓</span>
              <h3>Aucune tâche ici</h3>
              <p>Ajoutez votre prochaine priorité ci-dessus.</p>
            </div>
          )}
        </section>
      </div>
    </main>
  );
}
