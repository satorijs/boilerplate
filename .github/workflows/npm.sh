mkdir -p $RUNNER_TEMP/dist
cp -a * $RUNNER_TEMP/dist
cp -a .github $RUNNER_TEMP/dist
cp -a .vscode $RUNNER_TEMP/dist
cp .* $RUNNER_TEMP/dist

cd .yarn
mkdir $RUNNER_TEMP/dist/.yarn
cp -a patches $RUNNER_TEMP/dist/.yarn
cp -a plugins $RUNNER_TEMP/dist/.yarn
cp -a releases $RUNNER_TEMP/dist/.yarn
cp -a sdks $RUNNER_TEMP/dist/.yarn
cp -a versions $RUNNER_TEMP/dist/.yarn

mv $RUNNER_TEMP/dist dist
cd dist

rm -rf node_modules

# do not ignore lockfiles
sed -i .gitignore \
-e '/yarn.lock/d'

# if $GITHUB_REF is in the form of refs/tags/v* then it's a release
if [[ $GITHUB_REF == refs/tags/v* ]]; then
  cat package.json | jq ".private=false" > package.json.tmp
  mv -f package.json.tmp package.json
  cd ..
  tar -czf dist.tgz dist
  npm publish dist.tgz --access public
else
  VERSION=$(cat package.json | grep '"version":' | cut -d '"' -f 4)
  cat package.json | jq ".version=\"$VERSION-$GITHUB_SHA\" | .private=false" > package.json.tmp
  mv -f package.json.tmp package.json
  cd ..
  tar -czf dist.tgz dist
  npm publish dist.tgz --access public --tag nightly
fi
