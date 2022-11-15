# LEARN

To learn about this sandbox and for instructions on how to run it please head over
to the [Envoy docs](https://www.envoyproxy.io/docs/envoy/latest/start/sandboxes/lua.html).

## TEST

Change upstream cluster in `envoy.yaml` to your authentication endpoint.

```bash
docker-compose up --build -d

# get request - empty body
for x in {1..30}; do curl -v -H "Authorization: Bearer ${TOKEN}" localhost:8000/ 2>&1; done

# post request
for x in {1..30}; do curl -v -H "Authorization: Bearer ${TOKEN}" -H "Content-Type: application/json" -d '{"productId": 12345", "quantity": 100}' localhost:8000/ 2>&1; done
```
