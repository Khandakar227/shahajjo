## Build and Run with Docker:
### Secret credentials in .env
Make sure you have these added in `.env`:
```bash
MONGO_INITDB_ROOT_USERNAME=YOUR_MONGO_ROOT_USERNAME
MONGO_INITDB_ROOT_PASSWORD=YOUR_MONGO_ROOT_PASSWORD
```
### Build the image:
```bash
docker build -t node-mongo-app .
```

Run the container:
```bash
docker-compose up
```

**Rebuild After Changes:** Every time you modify the Dockerfile or application files, rebuild the Docker image:

```bash
docker-compose down
docker-compose up --build
```