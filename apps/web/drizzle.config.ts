import { defineConfig } from 'drizzle-kit'

export default defineConfig({
  dialect: 'sqlite',
  casing: 'snake_case',
  schema: './src/server/database/schema.ts',
  out: './src/server/database/migrations',
})
