#!/bin/bash

# Env vars
ENV_NAME="${PWD##*/}"
ENV_DIR="$HOME/.venvs/${ENV_NAME}"
INSTALLED=$(pip list | grep virtualenv)

# Emojis
THUMB_DOWN="\xF0\x9F\x91\x8E"
FIRE="\xF0\x9F\x94\xA5"
HUNDRED="\xF0\x9F\x92\xAF"
OK="\xF0\x9F\x91\x8C"
MONKEY="\xF0\x9F\x99\x8A"
ROCKET="\xF0\x9F\x9A\x80"

function compile_requirements {
        # Compile requirements.in to requirements.txt with hashes
        pip-compile --quiet \
            --generate-hashes \
            --output-file=requirements.txt \
            requirements.in
}

function compile_and_sync {
    # Check if requirements.txt exists
    if [ ! -f requirements.txt ]; then
        printf "\n ${THUMB_DOWN} --> No \"requirements.txt\" found - Compiling hashes to \"requirements.txt\" "
    else
        printf "\n ${ROCKET} --> \"requirements.txt\" found - Updating compiled hashes "
    fi

    compile_requirements

    printf "\n ${FIRE} --> Syncing requirements.txt with virtual environment \n\n"

    # Sync requiremnts.txt hashes with venv
    pip-sync -q
}

function check_env {
    # Check to see if already activated to avoid redundant activating
    if [ "$VIRTUAL_ENV" != "${ENV_DIR}" ]; then

        printf "\n ${HUNDRED} --> Activating virtualenv \"$ENV_NAME\" "

        # Activate the virtual environment
        source ${ENV_DIR}/bin/activate
    fi
}

function create_env {
    printf "\n ${OK} --> Creating virtualenv named ${ENV_NAME} in ${ENV_DIR} "

    # Create virtual env in ~/.venvs with name of project
    virtualenv -q ${ENV_DIR}

    # Activate the virtual environment
    source ${ENV_DIR}/bin/activate

    # Install pip-tools in environment
    pip3 install -q pip-tools
}

function run {
    # Check if requirements.in exists
    if [ -f requirements.in ]; then

        # Check if env dir already exists
        if [ -e "${ENV_DIR}" ]; then
            check_env
        else
            create_env
        fi

        compile_and_sync
    fi
}

# Check if virtualenv is installed
if [ -n "$INSTALLED" ]; then
    run
else
    # If not already in virtual environment, install virtualenv and run
    if [ "$VIRTUAL_ENV" != "${ENV_DIR}" ]; then
        printf "\n ${MONKEY} --> Virtualenv not installed - Installing now "
        pip3 install -q virtualenv
        run
    fi
fi
