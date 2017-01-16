# React project template

## Usage

Simply run the following to install all the necessary packages.
```
npm install
```
This will create `node_modules`.

## How this tempate was created.

1. Initialize
```
npm init -y
```

1. Developer Tools
```
npm install webpack --save-dev
```

1. libs
```
npm install jquery --save
```

1. React
```
npm install react react-dom --save
npm install @types/react @types/react-dom --save-dev
```

1. TypeScript
```
npm install typescript awesome-typescript-loader source-map-loader --save-dev
```

1. ESLint --- has not setup yet.

## Files

```
build/  --- TypeScript target Directory
src/    --- TypeScript sources
static/ --- Static files including bundle.js created by webpack.
index.html        --- The top page that loads bundle.js
package.json      --- npm configuration
tsconfig.json     --- TypeScript compiler configuration
webpack.config.js --- webpack configuration
```
