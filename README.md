# Task Manager

Ce dépôt contient une API Spring Boot, une application web React/Vite et une application mobile Flutter.

## Prérequis

Installez Java 17, Node.js 20 ou supérieur, Flutter et Docker Desktop. Exécutez les commandes depuis la racine du dépôt, sauf indication contraire.

## Développement local

### Backend

```bash
cd backend/taskmanager
./mvnw spring-boot:run
./mvnw test
```

Sous Windows, remplacez `./mvnw` par `mvnw.cmd`. L'API écoute sur `http://localhost:8080` et nécessite une instance MySQL nommée `taskmanager`.

### Frontend

```bash
cd frontend/frontend_task-manager
npm ci
npm run dev
npm run build
```

Le serveur de développement est accessible à l'adresse indiquée par Vite. Utilisez `VITE_API_URL` pour définir une URL d'API différente de `http://localhost:8080`.

### Mobile

```bash
cd mobile/mobile_task_manager
flutter pub get
flutter run
flutter test
```

Pour Android, transmettez l'URL de l'API au lancement :

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080/api
```

Depuis un téléphone physique, utilisez l'adresse IP locale de la machine hôte à la place de `10.0.2.2`.

## Docker

Docker Compose démarre MySQL, le backend et le frontend :

```bash
docker compose up --build
```

Les services sont disponibles sur `http://localhost:8080` (API) et `http://localhost:5173` (web). Pour arrêter les services, utilisez `docker compose down`. Ajoutez `-v` seulement si vous souhaitez aussi supprimer les données MySQL.

Vous pouvez aussi construire les images séparément :

```bash
docker build -t task-manager-backend ./backend/taskmanager
docker build -t task-manager-frontend ./frontend/frontend_task-manager
```

## Déploiement

1. Publiez les images Docker dans un registre privé ou public.
2. Déployez le backend avec une base MySQL gérée, des identifiants stockés dans des secrets et une valeur `jwt.secret` propre à l'environnement.
3. Déployez le frontend derrière un serveur HTTP ou un CDN ; définissez `VITE_API_URL` pendant sa construction avec l'URL publique de l'API.
4. Autorisez le domaine du frontend dans la configuration CORS du backend et configurez la même URL d'API dans l'application mobile.
5. Activez HTTPS, les sauvegardes de la base de données et la supervision des services.

Chaque push et chaque pull request lancent les tests Maven du backend et le build du frontend avec GitHub Actions.
