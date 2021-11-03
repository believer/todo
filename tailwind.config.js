module.exports = {
  mode: 'jit',
  purge: ['./src/**/*.bs.js'],
  darkMode: 'media',
  theme: {
    extend: {},
  },
  variants: {
    extend: {
      ringWidth: ['hover', 'group-hover'],
      ringOffsetWidth: ['hover', 'group-hover'],
      ringColor: ['hover', 'group-hover'],
      ringOffsetColor: ['hover', 'group-hover'],
    },
  },
  plugins: [],
}
