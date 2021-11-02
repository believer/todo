# TODO

[![](https://github.com/believer/todo/workflows/Release/badge.svg)](https://github.com/believer/todo/actions?workflow=Release)

This is a TODO application built using [ReScript](https://rescript-lang.org/)
and [TailwindCSS](https://tailwindcss.com/). The compiled output, `*.bs.js` files, have been included to display what the compiled output looks like.

## Run project locally

```sh
npm install
# Start ReScript compiler
npm start
# in another tab to start Vite
npm run server
```

When both processes are running, open a browser at http://localhost:3000

## Build for Production

```sh
npm run clean
npm run build
npm run build:production
```

This will clean up any artifacts from development, compile the ReScript files
and create a build using [Vite](https://vitejs.dev/).

Some parts of the project have been bootstrapped using my own CLI [Supreme](https://github.com/opendevtools/supreme). Commands used are: `rescript`, `nvm`, `jest`, `prettier`, `github-actions`
