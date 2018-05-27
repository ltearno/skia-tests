# si dans un contenur docker
apt update -y
apt install -y git python curl clang build-essential freeglut3-dev libfontconfig-dev libfreetype6-dev libgif-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libqt4-dev libjpeg-dev libicu-dev libwebp-dev

# install depot_tools
git clone 'https://chromium.googlesource.com/chromium/tools/depot_tools.git'
export PATH="${PWD}/depot_tools:${PATH}"

# clone skia
fetch skia # or git clone https://skia.googlesource.com/skia.git
cd skia
python tools/git-sync-deps

# generating skia build configurations
bin/gn gen out/Static --args='is_official_build=true'
bin/gn gen out/Shared --args='is_official_build=true is_component_build=true'
bin/gn gen out/Debug
bin/gn gen out/Release --args='is_debug=false'
bin/gn gen out/Clang --args='cc="clang" cxx="clang++"'
bin/gn gen out/Cached --args='cc_wrapper="ccache"'
bin/gn gen out/RTTI --args='extra_cflags_cc=["-frtti"]'

bin/gn gen out/Test --args='is_official_build=true cc="clang" cxx="clang++"'

# how to print a configuration options list
# bin/gn args out/Debug --list

# build a configuration
ninja -C out/Clang