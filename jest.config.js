module.exports = {
  testEnvironment: 'jsdom',
  transformIgnorePatterns: ['node_modules/(?!(rescript)/)'],
  setupFilesAfterEnv: ['<rootDir>/jest-setup.js'],
  watchPlugins: [
    'jest-watch-typeahead/filename',
    'jest-watch-typeahead/testname',
  ],
}
