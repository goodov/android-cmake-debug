@echo off

pushd .

SET cmake_path=%CD%\CMake
SET java_project=%CD%\sources\Teapot
SET project_path=%CD%\sources
SET build_path=%CD%\build
SET build_folder=android

mkdir %build_path%
cd %build_path%
mkdir %build_folder%_debug
cd %build_folder%_debug

cmake -G"Eclipse CDT4 - MinGW Makefiles" -DCMAKE_TOOLCHAIN_FILE="%cmake_path%\toolchains\android.cmake" -DANDROID_TOOLCHAIN_NAME=arm-linux-androideabi-4.8 -DCMAKE_BUILD_TYPE=Debug -DLIBRARY_OUTPUT_PATH_ROOT="%java_project%" -DANDROID_NATIVE_API_LEVEL=android-9 "%project_path%"

cd %build_path%
mkdir %build_folder%_release
cd %build_folder%_release

cmake -G"Eclipse CDT4 - MinGW Makefiles" -DCMAKE_TOOLCHAIN_FILE="%cmake_path%\toolchains\android.cmake" -DANDROID_TOOLCHAIN_NAME=arm-linux-androideabi-4.8 -DCMAKE_BUILD_TYPE=Release -DLIBRARY_OUTPUT_PATH_ROOT="%java_project%" -DANDROID_NATIVE_API_LEVEL=android-9 "%project_path%"

popd