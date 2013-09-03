#!/usr/bin/env sh


function require_success {
    STATUS=$?
    MESSAGE=$1
    if [ "$STATUS" != "0" ]; then
        echo $MESSAGE
        exit $STATUS
    fi
}


function install_macports {
    PREFIX=/opt/local
    MACPORTS="MacPorts-2.2.0"
    curl https://distfiles.macports.org/MacPorts/$MACPORTS.tar.gz > $MACPORTS.tar.gz --insecure
    tar -xzf $MACPORTS.tar.gz

    cd $MACPORTS
    ./configure --prefix=$PREFIX
    make 
    sudo make install
    cd ..

    export PATH=$PREFIX/bin:$PATH
    sudo port -v selfupdate
    sudo port install pkgconfig libpng freetype
    require_success "Failed to install matplotlib dependencies"
}

function install_matplotlib {
    yes | git clone http://github.com/matplotlib/matplotlib.git
    $PIP install -e matplotlib
    require_success "Failed to install matplotlib"
}


function install_macports_python {
    #major.minor version
    M_dot_m=$1
    Mm=`echo $M_dot_m | tr -d '.'`
    PY="py$Mm"
    FORCE=$2

    echo ""
    echo ""
    echo "installing python $M_dot_m"
    echo ""
    echo ""

    echo "$FORCE"

    if [ "$FORCE" == "noforce" ]; then
        FORCE=""
        echo "+++ no forcing"
    elif [ "$FORCE" == "force" ]; then
        echo "+++ forcing"
        FORCE="-f"
    else
        echo "this is force $FORCE"
        exit "weird force option"
    fi

    sudo port install $FORCE python$Mm
    require_success "Failed to install python"

    sudo port install $PY-numpy libpng freetype
    require_success "Failed to install matplotlib dependencies"

    if [ -z "$3" ]; then
        VENV=0
    elif [ "$3" == "venv" ]; then
        VENV=1
    fi
    echo "VENV is $VENV"
    
    if [ "$VENV" == 0 ]; then
        sudo port install $PY-pip

        export PYTHON=/opt/local/bin/python$M_dot_m
        export PIP="sudo /opt/local/bin/pip-$M_dot_m"
    elif [ "$VENV" == 1 ]; then
        sudo port install $PY-virtualenv
        virtualenv-$M_dot_m $HOME/venv --system-site-packages
        source $HOME/venv/bin/activate

        export PYTHON=$HOME/venv/bin/python
        export PIP=$HOME/venv/bin/pip
    fi
}


function install_tkl_85 {
    TCL_VERSION="8.5.14.0"
    curl http://downloads.activestate.com/ActiveTcl/releases/$TCL_VERSION/ActiveTcl$TCL_VERSION.296777-macosx10.5-i386-x86_64-threaded.dmg > ActiveTCL.dmg
    hdiutil attach ActiveTCL.dmg -mountpoint /Volumes/ActiveTcl
    sudo installer -pkg /Volumes/ActiveTcl/ActiveTcl-8.5.pkg -target /
    require_success "Failed to install ActiveTcl $TCL_VERSION"
}


function install_mac_python {
    PY_VERSION=$1
    curl http://python.org/ftp/python/$PY_VERSION/python-$PY_VERSION-macosx10.6.dmg > python-$PY_VERSION.dmg
    hdiutil attach python-$PY_VERSION.dmg -mountpoint /Volumes/Python
    sudo installer -pkg /Volumes/Python/Python.mpkg -target /
    require_success "Failed to install Python.org Python $PY_VERSION" 
    M_dot_m=${PY_VERSION:0:3}
    export PYTHON=/usr/local/bin/python$M_dot_m
}


function install_freetype {
    FT_VERSION=$1
    curl -L http://sourceforge.net/projects/freetype/files/freetype2/2.5.0/freetype-2.5.0.1.tar.bz2/download > freetype.tar.bz2
    tar -xjf freetype.tar.bz2
    cd freetype-$FT_VERSION
    ./configure --enable-shared=no --enable-static=true
    make
    sudo make install
    require_success "Failed to install freetype $FT_VERSION" 
    cd ..
}


function install_libpng {
    VERSION=$1
    curl -L http://downloads.sourceforge.net/project/libpng/libpng16/$VERSION/libpng-$VERSION.tar.gz > libpng.tar.gz
    tar -xzf libpng.tar.gz
    cd libpng-$VERSION
    ./configure --enable-shared=no --enable-static=true
    make
    sudo make install
    require_success "Failed to install libpng $VERSION"
    cd ..
}


function install_xquartz {
    VERSION=$1
    curl http://xquartz.macosforge.org/downloads/SL/XQuartz-$VERSION.dmg > xquartz.dmg
    hdiutil attach xquartz.dmg -mountpoint /Volumes/XQuartz
    sudo installer -pkg /Volumes/XQuartz/XQuartz.pkg -target /
    require_success "Failed to install XQuartz $VERSION"
}


function install_mac_numpy {
    NUMPY=$1
    PY=$2
    MAC=$3
    curl -L http://downloads.sourceforge.net/project/numpy/NumPy/$NUMPY/numpy-$NUMPY-py$PY-python.org-macosx$MAC.dmg > numpy.dmg
    hdiutil attach numpy.dmg
    sudo installer -pkg /Volumes/numpy/numpy-$NUMPY-py$PY.mpkg/ -target /
    require_success "Failed to install numpy"
}


if [ "$TEST" == "brew_system" ]
then
    brew update

    # use system python, numpy

    sudo easy_install pip
    brew install freetype libpng pkg-config
    require_success "Failed to install matplotlib dependencies"

    if [ -z "$VENV" ]; then
        # not in a virtual env
        export PIP="sudo pip"
        export PYTHON=/usr/bin/python2.7
    else
        sudo pip install virtualenv
        virtualenv $HOME/venv --system-site-packages
        source $HOME/venv/bin/activate
        export PIP=$HOME/venv/bin/pip
        export PYTHON=$HOME/venv/bin/python
    fi

    install_matplotlib

elif [ "$TEST" == "brew_py" ]
then
    brew update

    brew install python
    require_success "Failed to install python"

    brew install freetype libpng pkg-config
    require_success "Failed to install matplotlib dependencies"

    if [ -z "$VENV" ] ; then
        export PIP=/usr/local/bin/pip
        export PYTHON=/usr/local/bin/python2.7
    else
        pip install virtualenv
        virtualenv $HOME/venv
        source $HOME/venv/bin/activate
        export PIP=$HOME/venv/bin/pip
        export PYTHON=$HOME/venv/bin/python
    fi

    $PIP install numpy
    install_matplotlib

elif [ "$TEST" == "brew_py3" ]
then
    brew update

    brew install python3
    require_success "Failed to install python"

    brew install freetype libpng pkg-config
    require_success "Failed to install matplotlib dependencies"

    if [ -z "$VENV" ] ; then
        export PIP=/usr/local/bin/pip3
        export PYTHON=/usr/local/bin/python3.3
    else
        /usr/local/bin/pip3 install virtualenv
        /usr/local/bin/virtualenv-3.3 $HOME/venv
        source $HOME/venv/bin/activate

        export PIP=$HOME/venv/bin/pip
        export PYTHON=$HOME/venv/bin/python
    fi

    $PIP install numpy

    # dateutil has issues with python 3.3, make sure you get version 2.0
    $PIP install python-dateutil==2.0
    require_success "Failed to install python-dateutil"

    install_matplotlib

elif [ "$TEST" == "macports_py26" ]
then
    VERSION="2.6"

    install_macports
    install_macports_python $VERSION noforce

    install_matplotlib

elif [ "$TEST" == "macports_py27" ]
then
    VERSION="2.7"

    install_macports
    install_macports_python $VERSION force $VENV

    install_matplotlib

elif [ "$TEST" == "macports_py32" ]
then
    VERSION="3.2"

    install_macports
    install_macports_python $VERSION noforce $VENV

    install_matplotlib

elif [ "$TEST" == "macports_py33" ]
then
    VERSION="3.3"

    install_macports
    install_macports_python $VERSION noforce $VENV

    # dateutil 2.1 has issues with python 3.3, make sure you get version 2.0
    $PIP install python-dateutil==2.0
    require_success "Failed to install python-dateutil"

    install_matplotlib

elif [ "$TEST" == "macpython27_10.8" ]
then
    PY_VERSION="2.7.5"
    FT_VERSION="2.5.0.1"
    PNG_VERSION="1.6.3"
    XQUARTZ_VERSION="2.7.4"
    install_mac_python $PY_VERSION
    install_tkl_85
    install_libpng $PNG_VERSION
    install_freetype $FT_VERSION

    curl https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py > ez_setup.py
    sudo $PYTHON ez_setup.py

    PREFIX=/Library/Frameworks/Python.framework/Versions/2.7
    sudo $PREFIX/bin/easy_install-2.7 pip
    export PIP="sudo $PREFIX/bin/pip-2.7"

    # pip gets confused as to which PYTHONPATH it is supposed to look at
    # make sure to upgrade default-installed packges so that they actually
    # show up in $PYTHON's search path
    if [ -z "$BIN_NUMPY" ] ; then
        $PIP install numpy
    else
        install_mac_numpy 1.7.1 2.7 10.6
    fi

    $PIP install python-dateutil
    require_success "Failed to install python-dateutil"

    install_matplotlib

elif [ "$TEST" == "macpython33_10.8" ]
then
    PY_VERSION="3.3.2"
    FT_VERSION="2.5.0.1"
    PNG_VERSION="1.6.3"
    XQUARTZ_VERSION="2.7.4"
    install_mac_python $PY_VERSION
    install_tkl_85
    install_libpng $PNG_VERSION
    install_freetype $FT_VERSION

    curl https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py > ez_setup.py
    sudo $PYTHON ez_setup.py

    PREFIX=/Library/Frameworks/Python.framework/Versions/3.3
    sudo $PREFIX/bin/easy_install pip
    export PIP="sudo $PREFIX/bin/pip-3.3"

    if [ -z "$BIN_NUMPY" ] ; then
        $PIP install numpy
    else
        exit "numpy does not distribute python 3 binaries,  yet"
    fi

    $PIP install python-dateutil==2.0
    require_success "Failed to install python-dateutil"

    install_matplotlib

else
    echo "Unknown test setting ($TEST)"
fi
