import { useDrizzle, tables } from '../services/drizzle'
import backgroundGifs from '@/configs/backgrounds.json'

export default defineTask({
  meta: {
    name: 'db:seed',
    description: 'Seeds the db',
  },
  async run() {
    console.log('Running Db seed task...')
    const drizzle = useDrizzle()
    await drizzle.insert(tables.backgrounds).values(backgroundGifs.map(img => ({ img })))
    return { result: 'success' }
  },
})
