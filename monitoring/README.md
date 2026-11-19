# Local monitoring

Prometheus and Grafana run in Docker Compose. The Compose project creates the
`selena-monitoring` network for the monitoring services. Application
microservices are launched independently and are not started by this Compose
file.

## Configure Grafana

From the repository root, create the local environment file:

```sh
cp -n infrastructure/monitoring/.env.example infrastructure/monitoring/.env
```

Generate a local password with `openssl rand -hex 32` and set it as
`GRAFANA_ADMIN_PASSWORD` in `infrastructure/monitoring/.env`. This file is
ignored by Git; never commit it.

## Start and stop monitoring

```sh
docker compose --env-file infrastructure/monitoring/.env -f infrastructure/monitoring/docker-compose.yml up -d
```

Prometheus is available at <http://localhost:9090>; Grafana is at
<http://localhost:3000> with username `admin` and the configured password.

Stop the monitoring containers without deleting stored data:

```sh
docker compose --env-file infrastructure/monitoring/.env -f infrastructure/monitoring/docker-compose.yml down
```

## Connect an independently launched service

The monitoring stack creates the `selena-monitoring` Docker network. A service
container can join it at launch using `--network selena-monitoring` and a
network alias matching its Prometheus target (for example,
`--network-alias bookings-service`). An already-running container can be
connected with `docker network connect --alias bookings-service
selena-monitoring <container-name>`. A process running directly on the host
needs a Prometheus target address reachable from the Prometheus container.

## Persistence and retention

Prometheus and Grafana store data in the named Docker volumes
`selena-dev_prometheus_data` and `selena-dev_grafana_data`. They survive
container recreation and `docker compose down`. Prometheus retains at most 15
days of samples and applies a 2 GB TSDB size limit. Running `docker compose down
-v` deletes these volumes and their data.

Grafana reads `GF_SECURITY_ADMIN_PASSWORD` when its data volume is initialized.
Changing the environment value later does not change the existing Grafana
account password; change it through Grafana's account settings.
