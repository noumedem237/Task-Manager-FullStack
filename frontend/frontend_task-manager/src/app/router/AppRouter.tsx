import {
  BrowserRouter,
  Navigate,
  Outlet,
  Route,
  Routes,
} from "react-router-dom";
import { LoginPage } from "../../features/auth/pages/LoginPage";
import { RegisterPage } from "../../features/auth/pages/RegisterPage";
import { TasksPage } from "../../features/tasks/pages/TasksPage";
import { ROUTES } from "../../shared/config/routes";
import { useAuth } from "../providers/AuthProvider";

const Protected = () =>
  useAuth().isAuthenticated ? (
    <Outlet />
  ) : (
    <Navigate to={ROUTES.login} replace />
  );

const Public = () =>
  useAuth().isAuthenticated ? (
    <Navigate to={ROUTES.tasks} replace />
  ) : (
    <Outlet />
  );

export function AppRouter() {
  return (
    <BrowserRouter>
      <Routes>
        <Route element={<Public />}>
          <Route path={ROUTES.login} element={<LoginPage />} />
          <Route path={ROUTES.register} element={<RegisterPage />} />
        </Route>
        <Route element={<Protected />}>
          <Route path={ROUTES.tasks} element={<TasksPage />} />
        </Route>
        <Route path="*" element={<Navigate to={ROUTES.login} replace />} />
      </Routes>
    </BrowserRouter>
  );
}
