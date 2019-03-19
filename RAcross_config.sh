# SETUP_TYPE
# 0:install(after delete cache)
# 1:install(after cache undelete)
# 2:cache
# 3:install from cache(after delete cache)
# 4:install from cache(after cache undelete)
RACROSS_SETUP_TYPE=0

RACROSS_SETUP_CACHE=0
if [ ${RACROSS_SETUP_TYPE} = 0 ] || [ ${RACROSS_SETUP_TYPE} = 1 ] || [ ${RACROSS_SETUP_TYPE} = 2 ] ; then
	RACROSS_SETUP_CACHE=1
fi
RACROSS_SETUP_INSTALL=0
if [ ! ${RACROSS_SETUP_TYPE} = 2 ] ; then
	RACROSS_SETUP_INSTALL=1
fi
RACROSS_SETUP_DELETE=0
if [ ${RACROSS_SETUP_TYPE} = 0 ] || [ ${RACROSS_SETUP_TYPE} = 3 ] ; then
	RACROSS_SETUP_DELETE=1
fi

