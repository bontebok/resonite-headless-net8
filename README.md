# resonite-headless-net8
A docker image for Resonite's .NET 8 headless, includes components to aid in monitoring logs and thread performance of the headless server.

Usage: Create a directory which will contain the headless server files. Within this directory, create the following directories:

Example:
```mkdir myheadless && cd myheadless```

```
Config
Logs
```

Example:
```mkdir -p {Config,Logs}```

If you intend on using the Resonite Mod Loader, create these additional directories:

```
rml_mods
rml_config
```

Example:
```mkdir -p {rml_mods,rml_config}```

Now create a docker-compose.yaml file based on the sample provided in the repository and customize as needed. If you are not going to use the node-red based log monitor, you can remove the 'monitor' service completely. Additionally, you can remove the rml_mods and rml_config folders from the volumes if you do not intend on using the Resonite Mod Loader.

Finally, create a .env file based on the sample.env file in the repository. Replace the fields with your steam login and the Resonite headless branch password. Customise the values as needed.

Drop in your headless Config.json into the Config folder and start the headless by bringing up the docker container.

```docker compose up -d```

Based on the neos-headless docker image by shadowpanther.
