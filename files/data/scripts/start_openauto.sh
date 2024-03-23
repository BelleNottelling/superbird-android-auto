#!/bin/bash
cd ~
if [ -e ~/openauto/bin/autoapp ]; then
    echo "Starting OpenAuto"
    ~/openauto/bin/autoapp
else
    echo "OpenAuto has not yet been built. Beginning the process"

    echo "Building AASDK"
    if [ -e ~/aasdk_build ]; then
        rm -rf ~/aasdk_build
    fi
    mkdir aasdk_build
    cd aasdk_build
    cmake -DCMAKE_BUILD_TYPE=Release ~/aasdk
    make -j

    echo "Building OpenAuto"
    if [ -e ~/openauto_build ]; then
        rm -rf ~/openauto_build
    fi
    mkdir openauto_build
    cd openauto_build
    cmake -DCMAKE_BUILD_TYPE=Release -DAASDK_INCLUDE_DIRS="/home/$USER/aasdk/include" -DAASDK_LIBRARIES="/home/$USER/aasdk/lib/libaasdk.so" -DAASDK_PROTO_INCLUDE_DIRS="/home/$USER/aasdk_build" -DAASDK_PROTO_LIBRARIES="/home/$USER/aasdk/lib/libaasdk_proto.so" ~/openauto
    make -j

    echo "Build complete, launching OpenAuto"
    ~/openauto/bin/autoapp
fi

# clear the display
/scripts/clear_display.sh
