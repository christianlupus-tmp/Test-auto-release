#!/bin/bash

set -x

major=$(cat .github/actions/version-bumping/major)
minor=$(cat .github/actions/version-bumping/minor)
release=$(cat .github/actions/version-bumping/release)

message=$(git log HEAD~1...HEAD --format='%s%n%b')

if echo "$messages" | grep '%MAJOR%' > /dev/null ; then
	
	echo 'Creating major version'
	let major=$major+1
	minor=0
	release=0
	
elif echo "$messages" | grep '%MINOR%' > /dev/null; then
	
	echo 'Creating minor version'
	let minor=minor+1
	release=0
	
else
	
	echo 'Creating release version'
	let release=$release+1
	
fi

echo "Updating bumped version files"
echo $major > .github/actions/version-bumping/major
echo $minor > .github/actions/version-bumping/minor
echo $release > .github/actions/version-bumping/release

git add .github/actions/version-bumping/major .github/actions/version-bumping/minor .github/actions/version-bumping/release

version="$major.$minor.$release"
echo "New version is $version."

git config user.name 'Github actions bot'
git config user.mail 'bot@noreply.github.com'

git commit -m "Bump to version $version"
git tag "v$version"

git push origin stable
git push origin "v$version"
