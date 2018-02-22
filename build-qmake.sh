
build_qmake () {
  path="$1"
  options="$2"
  qmake $options "$path"
  make -j$(nproc)
  sudo make install
}
