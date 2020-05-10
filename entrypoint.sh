#!/bin/bash

if [ -z "$REGISTRY_HOST" ] || [ -z "$REGISTRY_USER" ] || [ -z "$REGISTRY_PASSWORD" ]; then
    exec /bin/bash $@
fi

mkdir -p /kaniko/.docker/

cat <<EOF >> /kaniko/.docker/config.json
{
    "auths": {
        "$REGISTRY_HOST": {
            "auth": "$(echo -n $REGISTRY_USER:$REGISTRY_PASSWORD | base64)"
        }
    }
}
EOF

exec /bin/bash $@
