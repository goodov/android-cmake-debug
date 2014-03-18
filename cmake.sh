cur_dir=`pwd`

cmake_path=$cur_dir/CMake
java_project=$cur_dir/sources/Teapot
project_path=$cur_dir/sources
build_path=$cur_dir/build
build_folder=android

mkdir $build_path
cd $build_path
mkdir ${build_folder}_debug
cd ${build_folder}_debug

cmake -G"Eclipse CDT4 - Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE="$cmake_path/toolchains/android.cmake" -DANDROID_TOOLCHAIN_NAME=arm-linux-androideabi-4.8 -DCMAKE_BUILD_TYPE=Debug -DLIBRARY_OUTPUT_PATH_ROOT="$java_project" -DANDROID_NATIVE_API_LEVEL=android-9 "$project_path"

cd $build_path
mkdir ${build_folder}_release
cd ${build_folder}_release

cmake -G"Eclipse CDT4 - Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE="$cmake_path/toolchains/android.cmake" -DANDROID_TOOLCHAIN_NAME=arm-linux-androideabi-4.8 -DCMAKE_BUILD_TYPE=Release -DLIBRARY_OUTPUT_PATH_ROOT="$java_project" -DANDROID_NATIVE_API_LEVEL=android-9 "$project_path"

cd $cur_dir