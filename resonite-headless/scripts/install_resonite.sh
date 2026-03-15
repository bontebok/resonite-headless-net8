#!/bin/sh

${STEAMCMDDIR}/steamcmd.sh \
        +@sSteamCmdForcePlatformType windows \
  	+force_install_dir ${STEAMAPPDIR} \
	+login ${STEAMLOGIN} \
  	+app_license_request ${STEAMAPPID} \
	+app_update ${STEAMAPPID} -beta ${STEAMBETA} -betapassword ${STEAMBETAPASSWORD} \
	+quit
