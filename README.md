# resonite-headless-net8
A docker image for Resonite's .NET 8 headless, includes components to aid in monitoring logs and thread performance of the headless server. You do not need to clone this repository to use, see the full instructions below.

Usage: Create a directory which will contain the headless server files. Within this directory, create the following directories:

* Config
* Logs
* *rml_mods
* *rml_config

(*only required if using the Resonite Mod Loader)

```
mkdir myheadless && cd myheadless
mkdir -p {Config,Logs}
```

If you will be using Resonite Mod Loader, create the additional directories.
```mkdir -p {rml_mods,rml_config}```

Now create a docker-compose.yaml file based on the ```docker-compose.yaml.sample``` provided in the repository and customize as needed. If you are not going to use the node-red based log monitor, you can remove the 'monitor' service completely. Additionally, you can remove the rml_mods and rml_config folders from the volumes if you do not intend on using the Resonite Mod Loader.

Finally, create a .env file based on the ```sample.env``` file in the repository. Update the ```HOSTUSERID``` and ```HOSTGROUPID``` values with your local user's UID and GID. Replace the field values indicated with ```<>``` with the applicable values and remove the ```<>``` symbols. These values include the headless branch beta key and your steam login and password. Customize the additional values in the .env file as needed.

Drop in your headless ```Config.json``` into the ```Config``` folder and start the headless by bringing up the docker container.

```docker compose up -d```

Based on the neos-headless docker image by shadowpanther.
