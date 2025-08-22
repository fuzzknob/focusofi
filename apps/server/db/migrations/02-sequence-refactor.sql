-- Settings table --
ALTER TABLE `settings` RENAME COLUMN `break_successions` TO `work_sessions`;

-- Timer Table --
DROP TABLE `timers`;

CREATE TABLE `timers` (
    `id` integer PRIMARY KEY NOT NULL,
    `timer_state` text NOT NULL,
    `current_sequence` text NOT NULL,
    `sequence_gen_count` integer DEFAULT 1 NOT NULL,
    `started_at` integer NOT NULL,
    `accumulated_break` integer DEFAULT 0 NOT NULL,
    `accumulated_work` integer DEFAULT 0 NOT NULL,
    `user_id` integer NOT NULL,
    `created_at` integer DEFAULT (unixepoch ()) NOT NULL,
    `updated_at` integer DEFAULT (unixepoch ()) NOT NULL,
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE no action ON DELETE cascade
);
