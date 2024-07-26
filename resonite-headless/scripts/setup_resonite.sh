#!/bin/sh

if [ "$AUTOUPDATE" = true ]; then
	${HEADLESSDIR}/scripts/install_resonite.sh
fi

if [ "$CLEANASSETS" = true ]; then
	find ${DATADIR}/Assets -type f -atime +7 -delete
	find ${CACHEDIR}/Cache -type f -atime +7 -delete
fi

if [ "$CLEANLOGS" = true ]; then
	find ${HEADLESSDIR}/Logs -type f -name *.log -atime +30 -delete
fi

exec $*
