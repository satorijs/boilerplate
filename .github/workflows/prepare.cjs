const { readFileSync, writeFileSync } = require('fs')

const source = JSON.parse(readFileSync('package.json', 'utf8'))

source.scripts = {
  start: source.scripts.start,
}

delete source.yakumo
delete source.workspaces
delete source.devDependencies

writeFileSync('package.json', JSON.stringify(source, null, 2))
