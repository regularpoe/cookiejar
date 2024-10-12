# cookiejar

## Setup

```bash
docker compose up -d
```

## Components

1. Ruby Sinatra apps:

    - cookiejar
    - strings

2. nginx

3. elasticsearch

4. kibana

### ElasticSearch

After starting Elastic, run

```bash
curl -X POST "http://localhost:9200/_security/user/kibana_system/_password" -H 'Content-Type: application/json' -d '{"password": "<new_password>"}' -u elastic:<YOUR_ELASTIC_PASSWORD>
```

Create API key for application

```bash
curl -X POST "https://hollow.localhost/elasticsearch/_security/api_key" -H "Content-Type: application/json" -u elastic:changeme -d '{"name": "cookiejar_app_key", "role_descriptors": {"cookiejar_app_role": {"cluster": ["all"], "index": [{"names": ["cookiejar-logs"], "privileges": ["read", "write", "create_index"]}]}}}' -k

-k is for self-signed cert
```

### Kibana

## Misc

SSL certs are self-signed with:

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout hollow.localhost.key -out hollow.localhost.crt -subj "/CN=hollow.localhost"
```

Edit /etc/hosts

```
127.0.0.1     hollow.localhost
```



