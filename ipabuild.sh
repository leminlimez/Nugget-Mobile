if [[ $* == *--scriptdebug* ]]; then
    set -x
fi
set -e

APP_NAME="Nugget"
FILE_EXT="ipa"
WORKING_LOCATION="$(pwd)"
APP_BUILD_FILES="$WORKING_LOCATION/layout/Applications/$APP_NAME.app"
DEBUG_LOCATION="$WORKING_LOCATION/.theos/obj/debug"
RELEASE_LOCATION="$WORKING_LOCATION/.theos/obj"
if [[ $* == *--debug* ]]; then
    BUILD_LOCATION="$DEBUG_LOCATION/$APP_NAME.app"
else
    BUILD_LOCATION="$RELEASE_LOCATION/$APP_NAME.app"
fi

if [[ $* == *--clean* ]]; then
    echo "[*] Cleaning..."
    rm -rf build
    make clean
fi

if [ ! -d "build" ]; then
    mkdir build
fi
#remove existing archive if there
if [ -d "build/$APP_NAME.$FILE_EXT" ]; then
    rm -rf "build/$APP_NAME.$FILE_EXT"
fi

if ! type "gmake" >/dev/null; then
    echo "[!] gmake not found, using macOS bundled make instead"
    make clean
    if [[ $* == *--debug* ]]; then
        make
    else
        make FINALPACKAGE=1
    fi
else
    gmake clean
    if [[ $* == *--debug* ]]; then
        gmake -j"$(sysctl -n machdep.cpu.thread_count)"
    else
        gmake -j"$(sysctl -n machdep.cpu.thread_count)" FINALPACKAGE=1
    fi
fi

if [ -d $BUILD_LOCATION ]; then
    # Add the necessary files
    echo "Adding application files"
    cp -r $APP_BUILD_FILES/*.png $BUILD_LOCATION
    cp -r $APP_BUILD_FILES/*.plist $BUILD_LOCATION
    cp -r "$APP_BUILD_FILES/Assets.car" "$BUILD_LOCATION/Assets.car"
    
    # Add the frameworks
    echo "Adding framework files"
    mkdir -p $BUILD_LOCATION/Frameworks
    if [[ $* == *--debug* ]]; then
        cp -r $DEBUG_LOCATION/*.dylib "$BUILD_LOCATION/Frameworks"
    else
        cp -r $RELEASE_LOCATION/*.dylib "$BUILD_LOCATION/Frameworks"
    fi

    # Create payload
    echo "Creating payload"
    cd build
    mkdir Payload
    cp -r $BUILD_LOCATION Payload/$APP_NAME.app

    # Archive
    echo "Archiving"
    if [[ $* != *--debug* ]]; then
        strip Payload/$APP_NAME.app/$APP_NAME
    fi
    zip -vr $APP_NAME.$FILE_EXT Payload
    rm -rf $APP_NAME.app
    rm -rf Payload
fi
