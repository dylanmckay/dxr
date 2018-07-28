#! /bin/sh -e

# Start the DXR webserver.

DXR_CONFIG_PATH=/code/dxr.config
DXR_REPO_PATH=~/dxr

if [ ! -f "$DXR_CONFIG_PATH" ]; then
  echo "no DXR config at '$DXR_CONFIG_PATH', creating example config"
  cp $DXR_REPO_PATH/tooling/docker/dxr.config.example $DXR_CONFIG_PATH
fi


echo "Indexing repositories"
dxr index --verbose -c $DXR_CONFIG_PATH

echo "Starting webserver "
dxr serve --all -c $DXR_CONFIG_PATH
