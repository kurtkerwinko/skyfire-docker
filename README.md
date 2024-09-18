# Skyfire Docker


## Software requirements

- [Docker](https://www.docker.com/)


## Setup

__*NOTE: The default settings are configured to run the servers on localhost (127.0.0.1)*__

1. Create `.env` file containing the following variables. See `sample.env` for reference

```
# Server
SKYFIRE_PUBLIC_IP=...            # (Optional) Skyfire IP address / server IP address.
                                 #   Defaults to 127.0.0.1
SKYFIRE_DOCKER_BIND_IP=...       # (Optional) Docker container bind IP address for
                                 #   Skyfire services. Defaults to 127.0.0.1

# Database
DATABASE_PASS=...                # Database password

# Skyfire
GIT_SKYFIRE_REPO_COMMIT=...      # (Optional) The branch/commit to checkout for the
                                 #   Skyfire repo. Defaults to master
DB_ARCHIVE_URL=...               # The link to the Skyfire database archive release
```

2. Build Skyfire
    - Run `docker compose build skyfire`

3. Install databases
    - **WARNING: Running this deletes the entire database and all contents**
    - Run `docker compose run --rm database-migrations /root/auto-migration.sh`

4. (Optional) Extract files from the client
    - **NOTE: Do if you don't already have the necessary extracted files**
    - Create the `./data/extractor/client` directory
    - Move all contents of the retail client folder into the `./data/extractor/client` directory
    - Run `docker compose run --rm extractor /root/run-extractor.sh`
    - Skip to `Step 6`

5. (Optional) Add extracted files
    - **NOTE: Only if you have the necessary extracted files**
    - Create the `./data/extractor/resources` directory
    - Copy the extracted folders to the `./data/extractor/resources` directory
        - `db2`
        - `dbc`
        - `maps`
        - `vmaps`
        - (Optional) `cameras`
        - (Optional) `Buildings`

6. (Optional) Set [config](#setting-authserverworldserver-config)

7. Start servers
    - Run `docker compose up -d`


## Setting authserver/worldserver config

- Create `./skyfire.env` file
- Add one config setting per line in the format `key=value`
    - For `authserver.conf` settings, prepend with `AUTHSERVER_`.
        - Setting `WrongPass.MaxCount = 5`
            - Add `AUTHSERVER_WrongPass.MaxCount=5`
    - For `worldserver.conf` settings, prepend with `WORLDSERVER_`.
        - Setting `Rate.Honor = 10`
            - Add `WORLDSERVER_Rate.Honor=10`
- Changes will only apply after restarting containers
    - `docker compose restart`


## Account creation

1. Attach stdio to running `world-server` container
    - `docker compose attach world-server`
2. Create account
    - `account create [username] [password]`
3. Exit prompt by doing <kbd>Ctrl+p</kbd> then <kbd>Ctrl+q</kbd>
    - Note: Closing the terminal or pressing <kbd>Ctrl+c</kbd> will cause the running server to stop
