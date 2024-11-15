## Build and Run with Docker:

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