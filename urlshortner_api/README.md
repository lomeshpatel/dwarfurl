# URL Shortner API

Provides a REST-ful API that can be used to facilitate URL Shortner use-cases.

Detailed specification can be found in `openapi.yml` file.

## Technology Stack

  * Language: [Elixir](https://elixir-lang.org/)
  * MVC Framework: [Phoenix](https://hexdocs.pm/phoenix/overview.html)
  * Database: [Postgres](https://www.postgresql.org/)

## Design
### **Database**
### urls

Table that holds all shortned URLs.

| Column | Type | Description |
| ------ | ---- | ----------- |
| slug (PK)   | varchar(255) | URL Base64 encoded string that represents the original URL |
| original_url | varchar(65536) | Original URL with max length of 64KB |
| inserted_at | timestamp | Inserted timestamp |
| updated_at  | timestamp | Updated timestamp |

### slugs

Table that holds all used and unused slugs.

| Column | Type | Description |
| ------ | ---- | ----------- |
| slug (PK) | varchar(255) | URL Base64 encoded string that represents the original URL |
| is_used | boolean | (Default: `false`) Marks if the slug has already been used |
| inserted_at | timestamp | Inserted timestamp |
| updated_at  | timestamp | Updated timestamp |

### **Service**

  * At startup, 
    * generates 100 (configurable) of URL Base64 encoded strings of 8 (configurable) characters and stores them in the `slugs` table.
    * starts `SlugCache` [GenServer](https://hexdocs.pm/elixir/GenServer.html) that
      * reads 100 (configurable) slugs in the memory and marks them `used`
  * For every request to shorten the URL `POST /v1/urls`, `SlugCache`
    * sychronously serves one slug
    * asynchronously refills the in-memory cache when the configurable threshold is reached (default: 75)
  * For every request to fetch the original URL `GET /v1/urls/{slug}`
    * reads the record from `urls` table and returns it

## Run it locally for development and testing

### Prerequisites:

  1. [Install Elixir](https://elixir-lang.org/install.html)
  2. Clone this repo
```
git clone git@github.com:lomeshpatel/dwarfurl.git
cd dwarfurl/urlshortner_api
```

### Start Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start the Postgres DB with `docker-compose up -d`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

### Run Unit/Integration Tests:

  * `mix test`
  * With coverage report: `mix test --cover`

### Run Contract/Performance Tests:

  * Install [Node](https://nodejs.org/)

```
npx newman run contract_test/contract_test.postman_collection.json -e contract_test/Development.postman_environment.json
```

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
