import eslintPluginImport from 'eslint-plugin-import';
import eslintPluginPrettier from 'eslint-plugin-prettier';
import eslintPluginUnusedImports from 'eslint-plugin-unused-imports';
import eslintRecommended from '@eslint/js';

export default [
  eslintRecommended.configs.recommended,
  {
    ignores: ['node_modules/', 'vendor/', 'tmp/', 'log/', 'bin/', 'db/', 'public/packs/'],
    languageOptions: {
      ecmaVersion: 2021,
      sourceType: 'module',
      globals: {
        window: 'readonly',
        document: 'readonly',
        process: 'readonly',
        console: 'readonly',
        require: 'readonly',
      },
    },
    plugins: {
      import: eslintPluginImport,
      prettier: eslintPluginPrettier,
      'unused-imports': eslintPluginUnusedImports,
    },
    rules: {
      'no-console': 'warn',
      'unused-imports/no-unused-imports': 'error',
      'prettier/prettier': 'error',
    },
  },
];
