# Welcome to Kong PlayGround

## Setting up Konga Connection
<br>

After all containers are up, we should configure Kong loopback and make sure the admin api is protected.

Konga will be listening on `http://localhost:1337`.
In the first access, you'll need to setup a new user.

Then, you'll need to create a new connection, to Konga.

At first, use a `Default` connection mode. Kong Admin Api will be accessible in `http://kong:8001`. (See docker-compose file)<br><br><br>


### Setup kong loopback and protect Admin Api
<br>

> You should never use `Default` mode in production, but you can use it while configuring a `jwt` connection. For this, you need to execute the next steps.

<br>


**Create admin-api service**

``` bash

curl --location --request POST 'http://localhost:8001/services/' \
--header 'Content-Type: application/json' \
--data-raw '{
    "name": "admin-api",
    "host": "localhost",
    "port": 8001
}'

```

**Add admin-api route**

``` bash

curl --location --request POST 'http://localhost:8001/services/admin-api/routes' \
--header 'Content-Type: application/json' \
--data-raw '{
    "paths": ["/admin-api"]
}'

```

Now, the admin api is avaliable at `curl localhost:8000/admin-api/`.

**Enable Key auth plugin**

``` bash

curl -X POST http://localhost:8001/services/admin-api/plugins \
    --data "name=key-auth" 

```

**Add Konga as Conusmer**

``` bash

curl --location --request POST 'http://localhost:8001/consumers/' \
--form 'username=konga' \
--form 'custom_id=<some-guid>'

```

This request will return an id in the response, like this:

``` json

{
    "created_at":1630533203,
    "custom_id":"cebd360d-3de6-4f8f-81b2-31575fe9846a",
    "username":"konga",
    "tags":null,
    "id":"02a7de00-ca56-45ac-9974-5830a3fddbb8"
}

```

You will use this id, in this case `02a7de00-ca56-45ac-9974-5830a3fddbb8` to next step.

**Create API Key for Konga**

This request will create a new api-key for the recently created consumer

``` bash

curl --location --request POST 'http://localhost:8001/consumers/<generated-id>/key-auth'

```

This will return a response with the generated jwt secret, like this:

``` json

{
    "created_at":1630533243,
    "consumer":{
        "id":"02a7de00-ca56-45ac-9974-5830a3fddbb8"
    },
    "id":"47c94c7b-f48d-4279-9bbd-f24fac8296a6",
    "ttl":null,
    "tags":null,
    "key":"KSTC4mZHC4kkLbIp3ve8B3mE88tC7nl5"
}

```

where the secret is `KSTC4mZHC4kkLbIp3ve8B3mE88tC7nl5`

**References**

- [Setup Kong and Konga](https://dev.to/vousmeevoyez/setup-kong-konga-part-2-dan)
- [Kong Loopback](https://docs.konghq.com/gateway-oss/2.0.x/secure-admin-api/#kong-api-loopback)
- [Gist of docker compose from Konga creator](https://gist.github.com/pantsel/73d949774bd8e917bfd3d9745d71febf)
