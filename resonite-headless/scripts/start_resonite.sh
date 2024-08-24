#!/bin/sh

cd ${STEAMAPPDIR}/Headless

DLLFILENAME="Resonite.dll"

RESONITEDLL=$(find . -name ${DLLFILENAME})

if [ "$PROCMON" = true ]; then
	eval "$(fnm env --shell=bash)"
	node ${HEADLESSDIR}/procmon &
fi

if [ "$RML" = true ]; then
  exec dotnet ${RESONITEDLL} -HeadlessConfig ../../Config/Config.json -Logs ../../Logs -CachePath ${CACHEDIR} -DataPath ${DATADIR} -LoadAssembly Libraries/ResoniteModLoader.dll
else
  exec dotnet ${RESONITEDLL} -HeadlessConfig ../../Config/Config.json -Logs ../../Logs -CachePath ${CACHEDIR} -DataPath ${DATADIR}
fi
