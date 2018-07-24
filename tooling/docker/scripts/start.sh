#! /bin/sh -e

# Start the DXR webserver.

DXR_CONFIG_PATH=/code/dxr.config

if [ ! -f "$DXR_CONFIG_PATH" ]; then
  echo "please mount a volume at /code that contains a 'dxr.config' file"
  exit 1
fi

dxr serve --all -c $DXR_CONFIG_PATH
