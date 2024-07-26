#!/bin/sh

DLLFILENAME="Resonite.dll"

RESONITEDLL=$(find . -name ${DLLFILENAME})

if [ "$PROCMON" = true ]; then
	eval "$(fnm env --shell=bash)"
	node ${HEADLESSDIR}/procmon &
fi

cd ${HEADLESSDIR}

if [ "$RML" = true ]; then
  exec dotnet ${RESONITEDLL} -HeadlessConfig Config/Config.json -Logs Logs -CachePath ${CACHEDIR} -DataPath ${DATADIR} -LoadAssembly "Libraries/ResoniteModLoaderHeadless.dll"
else
  exec dotnet ${RESONITEDLL} -HeadlessConfig Config/Config.json -Logs Logs -CachePath ${CACHEDIR} -DataPath ${DATADIR}
fi
