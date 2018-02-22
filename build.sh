#!/bin/bash

set -e

source build-cmake.sh
source build-qmake.sh

PROJECTS=$(cat projects.list)
SYSTEMLIB="/usr/lib"

if [ -f /usr/bin/dpkg ]; then
  gnuType=$(dpkg-architecture -qDEB_HOST_GNU_TYPE)
  SYSTEMLIB="/usr/lib/$gnuType"
fi

for project in $PROJECTS; do
  name=$(echo $project | cut -f1 -d:)
  build=$(echo $project | cut -f2 -d:)
  options=$(echo $project | cut -f3 -d:)
  path="../../$name"
  build_path="build/$name"
  if [ -f "$build_path/.built" ]; then
    echo "Alredy built $name"
    continue;
  fi

  echo "Building $name with $build in $build_path"
  mkdir -p $build_path
  cd $build_path

  case "$options" in
    systemlib)
      options="-DCMAKE_INSTALL_LIBDIR=$SYSTEMLIB"
      ;;
    systemprefix)
      options="-DCMAKE_INSTALL_PREFIX=/usr"
      ;;
    gps)
      options="-DLOCATION_SERVICE_ENABLE_GPS_PROVIDER=OFF"
      ;;
  esac

  case "$build" in
    qmake)
      build_qmake "$path" "$options"
      ;;
    cmake)
      build_cmake "$path" "$options"
      ;;
    *)
      echo "Unknown build system $build"
      exit 1
    esac
    touch .built
    cd ../..
done
