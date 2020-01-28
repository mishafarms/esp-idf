#!/bin/bash
set -e

# get uid/gid
USER_UID=`ls -nd /home/myuser | cut -f3 -d' '`
USER_GID=`ls -nd /home/myuser | cut -f4 -d' '`

# get the current uid/gid of myuser
CUR_UID=`getent passwd myuser | cut -f3 -d: || true`
CUR_GID=`getent group myuser | cut -f3 -d: || true`

# if they don't match, adjust
if [ ! -z "$USER_GID" -a "$USER_GID" != "$CUR_GID" ]; then
  groupmod -g ${USER_GID} myuser
fi
if [ ! -z "$USER_UID" -a "$USER_UID" != "$CUR_UID" ]; then
  usermod -u ${USER_UID} myuser
  # fix other permissions
  find / -uid ${CUR_UID} -mount -exec chown ${USER_UID}.${USER_GID} {} \;
fi

echo "The number of arguments is: $#"
echo "The args are $1"

if [[ $1 != *eclipse* ]]; then
    echo "IDF_PATH = $IDF_PATH"
    . $IDF_PATH/export.sh
fi

export PATH="/opt/esp/tools/cmake/cmake-3.15.5/bin:/opt/esp/tools/ninja/1.9.0/:${PATH}"

# drop access to myuser and run cmd

exec gosu myuser "$@"
