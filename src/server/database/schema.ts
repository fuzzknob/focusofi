import { sql, relations } from 'drizzle-orm'
import { sqliteTable, integer, text } from 'drizzle-orm/sqlite-core'

const basicColumns = {
  id: integer().primaryKey({ autoIncrement: true }),
  createdAt: integer('created_at', { mode: 'timestamp' })
    .notNull()
    .default(sql`(unixepoch())`),
  updatedAt: integer('updated_at', { mode: 'timestamp' })
    .notNull()
    .$onUpdate(() => new Date()),
}

export const backgrounds = sqliteTable('backgrounds', {
  ...basicColumns,
  img: text().notNull().unique(),
})

// users table
export const users = sqliteTable('users', {
  ...basicColumns,
  email: text().notNull().unique(),
  role: text({ enum: ['USER', 'ADMIN'] }).default('USER'),
  hasVerified: integer('has_verified', { mode: 'boolean' }).default(false),
})

export const usersRelations = relations(users, ({ many, one }) => ({
  emailOtps: many(emailOtps),
  sessions: many(sessions),
  settings: one(settings),
  timers: one(timers),
}))

// email_otps table
export const emailOtps = sqliteTable('email_otps', {
  ...basicColumns,
  otpCode: text('otp_code').notNull().unique(),
  expiration: integer({ mode: 'timestamp' }).notNull(),
  userId: integer('user_id').notNull().references(() => users.id, { onDelete: 'cascade' }),
})

export const emailOtpsRelations = relations(emailOtps, ({ one }) => ({
  user: one(users, {
    fields: [emailOtps.userId],
    references: [users.id],
  }),
}))

// sessions table
export const sessions = sqliteTable('sessions', {
  ...basicColumns,
  token: text().notNull().unique(),
  expiration: integer({ mode: 'timestamp' }).notNull(),
  userId: integer('user_id').notNull().references(() => users.id, { onDelete: 'cascade' }),
})

export const sessionsRelations = relations(sessions, ({ one }) => ({
  user: one(users, {
    fields: [sessions.userId],
    references: [users.id],
  }),
}))

// settings table
export const settings = sqliteTable('settings', {
  ...basicColumns,
  workLength: integer('work_length').notNull().default(2400),
  shortBreakLength: integer('short_break_length').notNull().default(120),
  longBreakLength: integer('long_break_length').notNull().default(600),
  breakSuccessions: integer('break_successions').notNull().default(4),
  userId: integer('user_id').notNull().references(() => users.id, { onDelete: 'cascade' }),
})

export const settingsRelations = relations(settings, ({ one }) => ({
  user: one(users, {
    fields: [settings.userId],
    references: [users.id],
  }),
}))

// timer table
export const timers = sqliteTable('timers', {
  ...basicColumns,
  startTime: integer('start_time', { mode: 'timestamp_ms' }).notNull(),
  timerStartedAt: integer('timer_started_at', { mode: 'timestamp_ms' }).notNull(),
  status: text('status', {
    enum: ['IDLE', 'WORKING', 'SHORT_BREAK', 'LONG_BREAK', 'PAUSED', 'STOPPED'],
  }).notNull(),
  successionCount: integer('session_count').notNull(),
  elapsedPrePause: integer('elapsed_pre_pause').notNull().default(0),
  workTillStatusChange: integer('work_till_status_change').notNull().default(0),
  breakTillStatusChange: integer('break_till_status_change').notNull().default(0),
  userId: integer('user_id').notNull().references(() => users.id, { onDelete: 'cascade' }),
})

export const timersRelations = relations(timers, ({ one }) => ({
  user: one(users, {
    fields: [timers.userId],
    references: [users.id],
  }),
}))
