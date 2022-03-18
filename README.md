# DWARFURL /dwôrfˈfərl/
App that provides URL shortner functionality similar to [Tinyurl](https://tinyurl.com/).

## Structure
The app is broken down into 2 major components.
1. [URL Shortner API service](https://github.com/lomeshpatel/dwarfurl/tree/master/urlshortner_api)
2. [Single page web app](https://github.com/lomeshpatel/dwarfurl/tree/master/web-app)

## Running The App
These instruction allow you to run the entire app on your computer in a production-like environment. It also makes the app ready for deployment on any cloud environment that support [Docker](https://www.docker.com/).

### Step 1 - [Install Docker and docker-compose](https://docs.docker.com/get-docker/):
This is probably the most involved step on these instructions. But Docker has provided a very detailed and helpful [documentation](https://docs.docker.com/get-docker/) to make this step as painless as possible.

### Step 2 - Clone this repo:
There are several ways you can do this. The easiest one is to use `git` command, but that will require you to install [Git](https://git-scm.com/) if you don't already have it.
```
git clone git@github.com:lomeshpatel/dwarfurl.git
OR
git clone https://github.com/lomeshpatel/dwarfurl.git
```

Another option is to simply download the repo as a zip file by clicking on the `Code` menu up top and then clicking on `Download ZIP` menu item.

### Step 3 - Run the app:
```
cd dwarfurl
docker-compose --env-file ./.env.prod up
```

### Step 4 - Access the app:
http://localhost:8080