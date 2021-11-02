# TODO

This is a TODO application built using [ReScript](https://rescript-lang.org/)
and [TailwindCSS](https://tailwindcss.com/).

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
