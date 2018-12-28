#!/bin/bash

script_dir=$( dirname $(readlink -f "$0") )
helm_dir="$script_dir/hygieia"
chart_vers=$(grep -oP '(?<=version: ).*' "${helm_dir}/Chart.yaml")

clean_check() {
    # The purpose of this script is to ensure that there are no new/modified
    # files in the current repo. This is to ensure we don't delete any changes
    echo "Checking that your Git repo is clean"
    if [[ -z $(git status --porcelain) ]]; then
        echo "Git repository is clean proceding with release"
    else
        echo "Git repository is not clean. Commit your changes and/or"\
             "run the following command"
        echo "      git clean -xdf"
        exit 1
    fi
}

releasability_check() {
    cd "$script_dir"
    git fetch --tags
    git tag -l | grep -q "$chart_vers"
    if [[ $? -eq 0 ]]; then
        echo "Tag for version $chart_vers was already found. Please update chart version."
        exit 1
    else
        echo "Tag for version $chart_vers was not found. Proceeding with release."
    fi
}

do_release() {
    set -e
    cd "$script_dir"
    mkdir -p blah

    echo "Fetching from gh-pages"
    git fetch origin gh-pages
    git --work-tree=blah/ checkout origin/gh-pages -- .

    echo "Packaging new helm chart"
    helm dep up hygieia
    helm package -d blah/ hygieia/
    helm repo index blah/

    echo "Publishing to gh-pages"
    git add blah/
    tree_id=$(git write-tree --prefix=blah/)
    commit_id=$(git commit-tree -p FETCH_HEAD -m "Updating gh pages" "$tree_id")
    git push -u origin +"$commit_id":refs/heads/gh-pages
    set +e
}

tag_repo() {
    git tag "$chart_vers"
    git push -u origin "$chart_vers"
}

clean_repo() {
    git reset HEAD .
    git clean -fxd
}

clean_check
releasability_check
do_release
tag_repo
clean_repo
