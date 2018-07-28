#! /bin/sh -e

# Start the DXR webserver.

DXR_CONFIG_PATH=/code/dxr.config
DXR_REPO_PATH=~/dxr
DXR_INDEXED_STAMP_PATH=/code/.initial_dxr_index_completed

if [ ! -f "$DXR_CONFIG_PATH" ]; then
  echo "no DXR config at '$DXR_CONFIG_PATH', creating example config"
  cp $DXR_REPO_PATH/tooling/docker/dxr.config.example $DXR_CONFIG_PATH
fi

# Build the index for the first time if it hasn't been done yet.
# We create a file to mark when this happens so that we only
# do it automatically on first boot.
if [ ! -f "$DXR_INDEXED_STAMP_PATH" ];then
  echo "no index has been built yet, building now"

  echo "Indexing repositories"
  dxr index --verbose -c $DXR_CONFIG_PATH

  date > $DXR_INDEXED_STAMP_PATH
fi

echo "Starting webserver "
dxr serve --all -c $DXR_CONFIG_PATH
