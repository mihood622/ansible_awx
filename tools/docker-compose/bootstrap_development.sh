#!/bin/bash
set +x

# Move to the source directory so we can bootstrap
if [ -f "/awx_devel/manage.py" ]; then
    cd /awx_devel
else
    echo "Failed to find awx source tree, map your development tree volume"
fi

make awx-link

# AWX bootstrapping
make version_file

if [[ -n "$RUN_MIGRATIONS" ]]; then
    make migrate
else
    wait-for-migrations
fi

make init


if output=$(awx-manage createsuperuser --noinput --username=admin --email=admin@localhost 2> /dev/null); then
    echo $output
    admin_password=$(openssl rand -base64 12)
    echo "Admin password: ${admin_password}"
    awx-manage update_password --username=admin --password=${admin_password}
fi
awx-manage create_preload_data
awx-manage register_default_execution_environments

mkdir -p /awx_devel/awx/public/static
mkdir -p /awx_devel/awx/ui/static
mkdir -p /awx_devel/awx/ui/build/static

# Create resource entries when using Minikube
if [[ -n "$MINIKUBE_CONTAINER_GROUP" ]]; then
    awx-manage shell < /awx_devel/tools/docker-compose-minikube/_sources/bootstrap_minikube.py
fi
