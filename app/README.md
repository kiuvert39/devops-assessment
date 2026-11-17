# Cloud Storage Demo

This deliberately small PHP application uploads validated documents to Google Cloud Storage and saves their metadata in MySQL. The home page shows the application environment, dependency status, an upload form, and the latest 50 document records.

## Architecture and request flow

Nginx is the public web server, listening on Cloud Run's `PORT` (default `8080`). It serves static files and forwards PHP requests over `127.0.0.1:9000` to PHP-FPM. PHP uses PDO's MySQL driver for document metadata and the official `google/cloud-storage` library for objects.

For a `POST /upload`, Nginx passes the multipart request to PHP-FPM. `public/upload.php` checks the upload error, size, and detected MIME type, generates a random object name, uploads the temporary file to GCS, then inserts metadata with a prepared statement. PHP's temporary upload file is removed by PHP after the request; it is never used as permanent application storage. In Cloud Run, the GCS library uses Application Default Credentials from the revision's service account—there are no key files in the image.

`GET /health` is a liveness endpoint: it always returns HTTP 200 if PHP can answer, while reporting dependency state. `GET /ready` returns HTTP 503 when MySQL or storage is unavailable, so a platform can make a separate readiness decision.

## Source files

- `public/index.php` renders the status, form, and document list.
- `public/upload.php` handles uploads and redirects back to the homepage.
- `public/health.php` and `public/ready.php` expose liveness and readiness JSON.
- `src/Config.php` reads and validates environment variables.
- `src/Database.php` creates PDO connections and executes document queries.
- `src/Storage.php` uploads to GCS; its `local` option is only for local Compose use.
- `src/Upload.php` contains upload validation and safe object-name generation.
- `database/schema.sql` creates the `documents` table.
- `nginx.conf`, `Dockerfile`, and `docker-entrypoint.sh` package Nginx and PHP-FPM in one Cloud Run container.

## Configuration

Copy `.env.example` to `.env` for local development. Do not commit `.env`.

| Variable | Purpose |
| --- | --- |
| `APP_NAME`, `APP_ENV` | Display name and environment label. |
| `PORT` | HTTP port; Cloud Run normally injects `8080`. |
| `DB_HOST`, `DB_PORT`, `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD` | MySQL TCP connection settings. |
| `MYSQL_ROOT_PASSWORD` | Local Compose MySQL root password only; not used by the application. |
| `DB_SOCKET` | Optional Cloud SQL Unix socket path, e.g. `/cloudsql/project:region:instance`; overrides host/port. |
| `GCS_BUCKET` | Production Cloud Storage bucket name. |
| `STORAGE_DRIVER` | `gcs` in production; `local` only for local Compose. |
| `LOCAL_STORAGE_PATH` | Local adapter target; a Compose-mounted development directory. |
| `MAX_UPLOAD_BYTES` | Maximum file size, default 10 MiB. |

The Cloud Run service account needs permission to create objects in `GCS_BUCKET` (typically `roles/storage.objectCreator`; viewing bucket health may additionally require bucket/object read permission). The Cloud Run revision also needs Cloud SQL connectivity and database credentials supplied through environment variables or a secret manager.

## Run locally

```sh
cd app
cp .env.example .env
docker compose up --build
curl http://localhost:8080/health
curl -F 'document=@./example.pdf' http://localhost:8080/upload -i
```

Compose overrides storage to `local` and persists those development objects in `app/local-storage`; production uses GCS. MySQL initializes the schema only the first time its named volume is created. To reinitialize local data intentionally, run `docker compose down -v` and start again.

To check PHP syntax and the minimal validation check after dependencies are installed:

```sh
find src public -name '*.php' -print0 | xargs -0 -n1 php -l
php tests/upload_validation.php
```

For production, build from `app/` with `docker build -t cloud-storage-demo .`, set `STORAGE_DRIVER=gcs`, provide the required database variables and `GCS_BUCKET`, and attach a Cloud Run service account. A real GCP upload requires deployed credentials and permissions; it is not simulated by this repository.

### Run without Docker

Install PHP 8.3 with the `pdo_mysql` and `fileinfo` extensions, Composer, and MySQL 8 locally. Create the database/user values in `.env`, then initialize the table and start PHP's development server:

```sh
cd app
cp .env.example .env
# Edit .env: set DB_HOST=127.0.0.1 and your local DB_PASSWORD.
composer install
mysql -h 127.0.0.1 -u cloud_demo -p cloud_demo < database/schema.sql
STORAGE_DRIVER=local LOCAL_STORAGE_PATH="$(pwd)/local-storage" php -S localhost:8080 -t public public/router.php
```

Open `http://localhost:8080`, or test `curl http://localhost:8080/health`. The built-in PHP server is for development only; it does not exercise the Nginx/PHP-FPM production setup. `STORAGE_DRIVER=local` stores development uploads in the directory named by `LOCAL_STORAGE_PATH`; set it to a writable path on your machine, for example `./local-storage`.
