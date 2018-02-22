
build_cmake () {
  path="$1"
  options="$2"
  cmake $options "$path"
  make -j$(nproc)
  sudo make install
}
