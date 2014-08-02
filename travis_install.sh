#!/usr/bin/env sh
# REQUIREMENTS_FILE (URL or filename for pip requirements file)
# INSTALL_TYPE (type of Python to install)
# VENV (defined if we should install and test in virtualenv)

source terryfy/travis_tools.sh


function delete_compiler {
    sudo rm -f /usr/bin/cc
    sudo rm -f /usr/bin/clang
    sudo rm -f /usr/bin/gcc
    sudo rm -f /usr/bin/c++
    sudo rm -f /usr/bin/clang++
    sudo rm -f /usr/bin/g++
}


function install_requirements {
    delete_compiler
    $PIP_CMD install -q -r ${REQUIREMENTS_FILE}
    require_success "Failed to install requirements"
}

get_python_environment $INSTALL_TYPE $VERSION $VENV
install_requirements
