#!/bin/sh

# Tag format: build/v{MAJOR}.{MINOR}.{PATCH}-b{BUILD}

PLIST="Sandbox/Info.plist"

get_max_build_from_git_tags(){
    max=0
    numbers=$(git tag | sed -n "s/^build\/v[0-9.]*-b\([0-9]*\)$/\1/p")
    for number in $numbers
    do
        (( $number > $max )) && max=$number
    done
    echo $max
}

get_version() {
    echo $(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$1")
}

build=$(get_max_build_from_git_tags)
build=$(expr $build + 1)

version=$(get_version "$PLIST")

bump_build_version(){
    /usr/libexec/PlistBuddy -c "Set CFBundleVersion $build" "$1"
}

git_commit_and_tag_version(){
    git add -A
    git commit -m "ver $version build $build"
    git tag "build/v$version-b$build"
}

bump_build_version "$PLIST"
git_commit_and_tag_version
