# Task Manager — API backend

L’API Spring Boot écoute sur `http://localhost:8080`. Créez d’abord la base MySQL `taskmanager`, puis démarrez le projet depuis `backend/taskmanager`.

```sql
CREATE DATABASE taskmanager;
```

## Authentification

### Créer un compte

```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"motdepasse123"}'
```

La réponse contient un jeton :

```json
{"token":"eyJ..."}
```

### Se connecter

```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"motdepasse123"}'
```

Enregistrez le jeton renvoyé dans une variable :

```bash
TOKEN="collez_le_jwt_ici"
```

## Tâches

Toutes les routes ci-dessous exigent `Authorization: Bearer <JWT>`.

### Lister ses tâches

```bash
curl http://localhost:8080/api/tasks \
  -H "Authorization: Bearer $TOKEN"
```

### Créer une tâche

```bash
curl -X POST http://localhost:8080/api/tasks \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"Préparer la démo","description":"Finaliser les slides","status":"TODO"}'
```

Les statuts acceptés sont `TODO`, `IN_PROGRESS` et `DONE`.

### Modifier une tâche

Remplacez `1` par l’identifiant de la tâche.

```bash
curl -X PUT http://localhost:8080/api/tasks/1 \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"Préparer la démo","description":"Slides finalisées","status":"IN_PROGRESS"}'
```

### Supprimer une tâche

```bash
curl -X DELETE http://localhost:8080/api/tasks/1 \
  -H "Authorization: Bearer $TOKEN"
```

La suppression réussie retourne `204 No Content`. Un utilisateur ne peut lister ou modifier que ses propres tâches.

## Erreurs JSON

L’API retourne un objet JSON uniforme pour les erreurs `400`, `401`, `403`, `404` et `500` :

```json
{
  "timestamp": "2026-09-19T12:00:00Z",
  "status": 400,
  "error": "Bad Request",
  "message": "Données de requête invalides",
  "path": "/api/tasks",
  "validationErrors": {
    "title": "must not be blank"
  }
}
```
