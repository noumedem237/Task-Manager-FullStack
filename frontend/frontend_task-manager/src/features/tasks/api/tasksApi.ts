import { apiRequest } from "../../../shared/api/http";
import type { Task, TaskPayload } from "../types/task";
const auth = (token: string) => ({ Authorization: `Bearer ${token}` });
export const getTasks = (token: string) =>
  apiRequest<Task[]>("/api/tasks", { headers: auth(token) });
export const createTask = (token: string, data: TaskPayload) =>
  apiRequest<Task>("/api/tasks", {
    method: "POST",
    headers: auth(token),
    body: JSON.stringify(data),
  });
export const updateTask = (token: string, id: number, data: TaskPayload) =>
  apiRequest<Task>(`/api/tasks/${id}`, {
    method: "PUT",
    headers: auth(token),
    body: JSON.stringify(data),
  });
export const deleteTask = (token: string, id: number) =>
  apiRequest<void>(`/api/tasks/${id}`, {
    method: "DELETE",
    headers: auth(token),
  });
