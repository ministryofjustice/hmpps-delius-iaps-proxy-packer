#!/bin/bash
set +x

function set_branch_name() {
    echo "CODEBUILD_GIT_BRANCH = $CODEBUILD_GIT_BRANCH"

    if [ "$CODEBUILD" == "true" ]; then
        if [ "$BRANCH_NAME" == "" ]; then
            export BRANCH_NAME=$CODEBUILD_GIT_BRANCH
        fi
    else
        export BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
    fi

    echo "BRANCH_NAME = '$BRANCH_NAME'"
}

function set_git_latest_main_tag() {
    echo '----------------------------------------------'
    echo "Setting IMAGE_TAG_VERSION"
    echo '----------------------------------------------'
    export IMAGE_TAG_VERSION=$(curl -s https://api.github.com/repos/ministryofjustice/hmpps-delius-iaps-proxy-packer/tags | jq -r '.[0].name')
    echo "Set IMAGE_TAG_VERSION to '$IMAGE_TAG_VERSION'"
}

function set_tag_version() {
    set_branch_name
    if [ "${BRANCH_NAME}" == "main" ]; then
        echo "Branch name is '${BRANCH_NAME}' so getting latest tag"
        set_git_latest_main_tag
    else
        echo "Branch name is '${BRANCH_NAME}' so setting tag to 0.0.0"
        export IMAGE_TAG_VERSION='0.0.0'
    fi
}

function verify_image() {
    echo '----------------------------------------------'
    echo "Running packer validate ${1}"
    echo '----------------------------------------------'
    USER=`whoami` packer validate $1

    RESULT=$?
    echo '----------------------------------------------'
    echo "Verify return code was: $RESULT"
    echo '----------------------------------------------'
    return $RESULT
}

function build_image() {
    echo '----------------------------------------------'
    echo "Running packer build for Linux Image ${1}"
    echo '----------------------------------------------'

    USER=`whoami` packer build ${1}
    RESULT=$?

    echo '----------------------------------------------'
    echo "Build Image return code was: $RESULT"
    echo '----------------------------------------------'
    return $RESULT
}

function build_windows_image() {
    echo '----------------------------------------------'
    echo "Running packer build for Windows Image ${1}"
    echo '----------------------------------------------'

    USER=`whoami` packer build $1
    RESULT=$?

    echo '----------------------------------------------'
    echo "Build Image return code was: $RESULT"
    echo '----------------------------------------------'
    return $RESULT
}

function print_env() {
    env | sort
}

function print_packerfile() {
    echo '----------------------------------------------'
    echo "PACKERFILE=${PACKERFILE}"
    echo '----------------------------------------------'
}

function set_environment_variables() {
    echo '----------------------------------------------'
    echo "Setting Environment Variables"
    echo '----------------------------------------------'

    # taken from https://raw.githubusercontent.com/thii/aws-codebuild-extras/master/install
    export CI=true
    export CODEBUILD=true
    export CODEBUILD_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
    export CODEBUILD_GIT_BRANCH="$(git symbolic-ref HEAD --short 2>/dev/null)"
    if [ "$CODEBUILD_GIT_BRANCH" = "" ] ; then
        CODEBUILD_GIT_BRANCH="$(git branch -a --contains HEAD | sed -n 2p | awk '{ printf $1 }')";
        export CODEBUILD_GIT_BRANCH=${CODEBUILD_GIT_BRANCH#remotes/origin/};
    fi
    export CODEBUILD_GIT_CLEAN_BRANCH="$(echo $CODEBUILD_GIT_BRANCH | tr '/' '.')"
    export CODEBUILD_GIT_ESCAPED_BRANCH="$(echo $CODEBUILD_GIT_CLEAN_BRANCH | sed -e 's/[]\/$*.^[]/\\\\&/g')"
    export CODEBUILD_GIT_MESSAGE="$(git log -1 --pretty=%B)"
    export CODEBUILD_GIT_AUTHOR="$(git log -1 --pretty=%an)"
    export CODEBUILD_GIT_AUTHOR_EMAIL="$(git log -1 --pretty=%ae)"
    export CODEBUILD_GIT_COMMIT="$(git log -1 --pretty=%H)"
    export CODEBUILD_GIT_SHORT_COMMIT="$(git log -1 --pretty=%h)"
    export CODEBUILD_GIT_TAG="$(git describe --tags --exact-match 2>/dev/null)"
    export CODEBUILD_GIT_MOST_RECENT_TAG="$(git describe --tags --abbrev=0)"
    export CODEBUILD_PULL_REQUEST=false
    if [ "${CODEBUILD_GIT_BRANCH#pr-}" != "$CODEBUILD_GIT_BRANCH" ] ; then
        export CODEBUILD_PULL_REQUEST=${CODEBUILD_GIT_BRANCH#pr-};
    fi
    export CODEBUILD_PROJECT=${CODEBUILD_BUILD_ID%:$CODEBUILD_LOG_PATH}
    export CODEBUILD_BUILD_URL=https://$AWS_DEFAULT_REGION.console.aws.amazon.com/codebuild/home?region=$AWS_DEFAULT_REGION#/builds/$CODEBUILD_BUILD_ID/view/new



    echo "==> AWS CodeBuild Extra Environment Variables:"
    echo "==> CI = $CI"
    echo "==> CODEBUILD = $CODEBUILD"
    echo "==> CODEBUILD_ACCOUNT_ID = $CODEBUILD_ACCOUNT_ID"
    echo "==> CODEBUILD_GIT_AUTHOR = $CODEBUILD_GIT_AUTHOR"
    echo "==> CODEBUILD_GIT_AUTHOR_EMAIL = $CODEBUILD_GIT_AUTHOR_EMAIL"
    echo "==> CODEBUILD_GIT_BRANCH = $CODEBUILD_GIT_BRANCH"
    echo "==> CODEBUILD_GIT_CLEAN_BRANCH = $CODEBUILD_GIT_CLEAN_BRANCH"
    echo "==> CODEBUILD_GIT_ESCAPED_BRANCH = $CODEBUILD_GIT_ESCAPED_BRANCH"
    echo "==> CODEBUILD_GIT_COMMIT = $CODEBUILD_GIT_COMMIT"
    echo "==> CODEBUILD_GIT_SHORT_COMMIT = $CODEBUILD_GIT_SHORT_COMMIT"
    echo "==> CODEBUILD_GIT_MESSAGE = $CODEBUILD_GIT_MESSAGE"
    echo "==> CODEBUILD_GIT_TAG = $CODEBUILD_GIT_TAG"
    echo "==> CODEBUILD_GIT_MOST_RECENT_TAG = $CODEBUILD_GIT_MOST_RECENT_TAG"
    echo "==> CODEBUILD_PROJECT = $CODEBUILD_PROJECT"
    echo "==> CODEBUILD_PULL_REQUEST = $CODEBUILD_PULL_REQUEST"

    echo 'Setting IMAGE_TAG_VERSION'
    set_tag_version

    # output env vars for debug
    print_env
}

# set environment
set_environment_variables

# get PACKERFILE to verify/build as arg 1
PACKERFILE=${1}
print_packerfile

verify_image $PACKERFILE
build_image $PACKERFILE
