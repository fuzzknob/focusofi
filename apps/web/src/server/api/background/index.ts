import { useDrizzle, tables, sql } from '@/server/services/drizzle'

export default defineCachedEventHandler(async () => {
  const db = useDrizzle()
  const background = await db.select().from(tables.backgrounds).orderBy(sql`RANDOM()`).limit(1).get()
  return {
    img: background?.img,
  }
}, {
  getKey: () => '/api/background',
  maxAge: 300,
  swr: true,
})
