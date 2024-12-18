ARG	HOSTUSERID=1000 \
	HOSTGROUPID=1000 \
	USER=resonite \
	STEAMBETA=__CHANGEME__ \
	STEAMBETAPASSWORD=__CHANGEME__ \
	STEAMLOGIN=__CHANGEME__ \
	RML=false \
	PROCMON=false \
	AUTOUPDATE=false

FROM mcr.microsoft.com/dotnet/runtime:9.0-bookworm-slim AS build

LABEL name=resonite-headless maintainer="rucio"

ARG	HOSTUSERID=1000 \
	HOSTGROUPID=1000 \
	USER=resonite \
	STEAMBETA=__CHANGEME__ \
	STEAMBETAPASSWORD=__CHANGEME__ \
	STEAMLOGIN=__CHANGEME__ \
	RML=false \
	PROCMON=false \
	AUTOUPDATE=false

ENV	STEAMAPPID=2519830 \
	STEAMAPP=resonite \
	STEAMCMDDIR=/opt/steamcmd \
        HEADLESSDIR=/opt/resonite \
	STEAMAPPDIR=/opt/resonite/headless \
	DATADIR=/opt/resonite/Data \
	CACHEDIR=/opt/resonite/Cache \
	STEAMCMDURL="https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" \
	RMLLIBURL="https://github.com/stiefeljackal/pardeike.Harmony/releases/latest/download/0Harmony.dll" \
	RMLURL="https://github.com/resonite-modding-group/ResoniteModLoader/releases/latest/download/ResoniteModLoader.dll" \
	CLEANASSETS=false \
	CLEANLOGS=false \
	USER=${USER} \
	HOSTUSERID=${HOSTUSERID} \
	HOSTGROUPID=${HOSTGROUPID} \
	STEAMBETA=${STEAMBETA} \
	STEAMBETAPASSWORD=${STEAMBETAPASSWORD} \
	STEAMLOGIN=${STEAMLOGIN} \
	RML=${RML} \
	PROCMON=${PROCMON} \
	AUTOUPDATE=${AUTOUPDATE}

# Prepare the basic environment and clean
RUN	set -x && \
        dpkg --add-architecture i386 && \
	apt-get -y update && apt-get -y dist-upgrade && \
	apt-get --no-install-recommends -y install curl lib32gcc-s1 libopus0 opus-tools libc6-dev libfreetype6 unzip procps && \
	apt-get -y clean && rm -rf /var/lib/{apt,dpkg,cache}


# Add locales
RUN	DEBIAN_FRONTEND=noninteractive apt-get install -y locales && \
	sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
	sed -i -e 's/# en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen && \
	dpkg-reconfigure --frontend=noninteractive locales && \
	update-locale LANG=en_US.UTF-8 && \
	update-locale LANG=en_GB.UTF-8

ENV	LANG en_US.UTF-8

# Create user, install SteamCMD
RUN	addgroup --gid ${HOSTGROUPID} ${USER}

RUN	adduser --disabled-login \
		--shell /bin/bash \
		--gecos "" \
		--gid ${HOSTGROUPID} \
		--uid ${HOSTUSERID} \
		${USER}

RUN	mkdir -p ${STEAMCMDDIR} ${HEADLESSDIR} ${STEAMAPPDIR} ${DATADIR} ${CACHEDIR} \
		${HEADLESSDIR}/Config ${HEADLESSDIR}/Logs ${HEADLESSDIR}/scripts && \
	chown -R ${USER}:${USER} ${STEAMCMDDIR} ${HEADLESSDIR} ${STEAMAPPDIR} ${DATADIR} ${CACHEDIR}

# Switch user context
USER ${USER}

# Copy any custom patches (N/A)
#COPY	--chown=${USER}:${USER} patches ${HEADLESSDIR}/patches

# Copy setup and startup scripts
COPY	--chown=${USER}:${USER} scripts ${HEADLESSDIR}/scripts

# Install steamcmd and update
RUN	cd ${STEAMCMDDIR} && \
	curl -sqL ${STEAMCMDURL} | tar zxfv -

# Install Resonite
RUN	${HEADLESSDIR}/scripts/install_resonite.sh

# ResoniteModLoader
FROM build AS rml-true

RUN	mkdir -p ${STEAMAPPDIR}/Headless/Libraries ${STEAMAPPDIR}/Headless/rml_libs && \
	ln -sf ${HEADLESSDIR}/rml_mods ${STEAMAPPDIR}/Headless/rml_mods && \
	ln -sf ${HEADLESSDIR}/rml_config ${STEAMAPPDIR}/Headless/rml_config && \
	curl -sqLo ${STEAMAPPDIR}/Headless/Libraries/ResoniteModLoader.dll ${RMLURL} &&\
	curl -sqLo ${STEAMAPPDIR}/Headless/rml_libs/0Harmony.dll ${RMLLIBURL}

# Do nothing
FROM build AS rml-false

FROM rml-${RML} AS rml

# Procmon
FROM rml AS procmon-true

ENV	FNM_PATH="/home/resonite/.local/share/fnm"

RUN	curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
ENV	PATH="$FNM_PATH:$PATH"
RUN	eval "$(fnm env --shell=bash)" && \
	fnm install --lts

COPY	--chown=${USER}:${USER} procmon ${HEADLESSDIR}/procmon

WORKDIR ${HEADLESSDIR}/procmon

RUN	eval "$(fnm env --shell=bash)" && \
	npm install --unsafe-perm --no-update-notifier --no-audit --no-fund --omit=dev

# Do nothing
FROM rml AS procmon-false

FROM procmon-${PROCMON} AS base

WORKDIR ${HEADLESSDIR}

STOPSIGNAL SIGINT

ENTRYPOINT	["/opt/resonite/scripts/setup_resonite.sh"]
CMD		["/opt/resonite/scripts/start_resonite.sh"]
