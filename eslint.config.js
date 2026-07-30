// Minimal, self-contained ESLint flat config for the functional testing suite.
// Lints the JS config + custom step definitions. The TypeScript Playwright
// config is excluded (no TS parser dependency is pulled in for a first pass).
module.exports = [
  {
    ignores: [
      'node_modules/**',
      '**/*.ts',
      'tests/reports/**',
      'tests/screenshots/**',
      'tests/videos/**',
    ],
  },
  {
    files: ['cucumber.js', 'tests/step-definitions/**/*.js'],
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: 'commonjs',
      globals: {
        process: 'readonly',
        module: 'writable',
        require: 'readonly',
        __dirname: 'readonly',
        console: 'readonly',
        Promise: 'readonly',
        setTimeout: 'readonly',
      },
    },
    rules: {
      'no-undef': 'error',
      'no-unused-vars': 'warn',
    },
  },
];
