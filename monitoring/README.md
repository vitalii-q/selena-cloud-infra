# Local monitoring

The monitoring stack uses Prometheus and Grafana in Docker Compose. Start the
application services first so Compose creates the shared `selena-dev_app_network`.
The Grafana password is read from a local, git-ignored `.env` file.

## Configure the local Grafana password

From the repository root:

```sh
cp -n infrastructure/monitoring/.env.example infrastructure/monitoring/.env
```

Generate a password with `openssl rand -base64 32`, then put the generated value
in `infrastructure/monitoring/.env` as `GRAFANA_ADMIN_PASSWORD=<value>`. Do not
commit this file.

## Start and stop

Start the local application services (the override selects the bookings dev
profile, which listens on port 9066):

```sh
docker compose -f docker-compose.yml -f docker-compose.override.yml up -d users-service bookings-service hotels-service
```

Start monitoring:

```sh
docker compose --env-file infrastructure/monitoring/.env -f infrastructure/monitoring/docker-compose.yml up -d
```

Prometheus is available at <http://localhost:9090>; Grafana is at
<http://localhost:3000> with username `admin` and the password configured above.

Stop monitoring without deleting its stored data:

```sh
docker compose --env-file infrastructure/monitoring/.env -f infrastructure/monitoring/docker-compose.yml down
```

Prometheus and Grafana data are stored in the named Docker volumes
`selena-dev_prometheus_data` and `selena-dev_grafana_data`. They survive
container recreation and `docker compose down`. Prometheus retains at most 15
days of samples and applies a 2 GB TSDB size limit. `docker compose down -v`
deletes these volumes and permanently removes their data.

Grafana reads `GF_SECURITY_ADMIN_PASSWORD` when it initializes its data volume.
Changing the environment value after initialization does not rotate the
existing Grafana account password; change it through Grafana's account settings.

`payments-service` is not part of the root Compose stack. Its target appears as
down until it is started separately and attached to `selena-dev_app_network`.
