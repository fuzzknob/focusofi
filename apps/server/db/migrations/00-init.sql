-- users table
CREATE TABLE IF NOT EXISTS `users` (
    `id` integer PRIMARY KEY NOT NULL,
    `email` text NOT NULL,
    `role` text DEFAULT 'USER',
    `has_verified` integer DEFAULT false,
    `created_at` integer DEFAULT (unixepoch ()) NOT NULL,
    `updated_at` integer DEFAULT (unixepoch ()) NOT NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS `users_email_unique` ON `users` (`email`);

-- email_otps table
CREATE TABLE IF NOT EXISTS `email_otps` (
    `id` integer PRIMARY KEY NOT NULL,
    `otp_code` text NOT NULL,
    `expiration` integer NOT NULL,
    `user_id` integer NOT NULL,
    `created_at` integer DEFAULT (unixepoch ()) NOT NULL,
    `updated_at` integer DEFAULT (unixepoch ()) NOT NULL,
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE no action ON DELETE cascade
);

CREATE UNIQUE INDEX IF NOT EXISTS `email_otps_otpCode_unique` ON `email_otps` (`otp_code`);

-- sessions table
CREATE TABLE IF NOT EXISTS `sessions` (
    `id` integer PRIMARY KEY NOT NULL,
    `token` text NOT NULL,
    `expiration` integer NOT NULL,
    `user_id` integer NOT NULL,
    `created_at` integer DEFAULT (unixepoch ()) NOT NULL,
    `updated_at` integer DEFAULT (unixepoch ()) NOT NULL,
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE no action ON DELETE cascade
);

CREATE UNIQUE INDEX IF NOT EXISTS `sessions_token_unique` ON `sessions` (`token`);

-- settings table
CREATE TABLE IF NOT EXISTS `settings` (
    `id` integer PRIMARY KEY NOT NULL,
    `work_length` integer DEFAULT 2400 NOT NULL,
    `short_break_length` integer DEFAULT 120 NOT NULL,
    `long_break_length` integer DEFAULT 600 NOT NULL,
    `break_successions` integer DEFAULT 4 NOT NULL,
    `user_id` integer NOT NULL,
    `created_at` integer DEFAULT (unixepoch ()) NOT NULL,
    `updated_at` integer DEFAULT (unixepoch ()) NOT NULL,
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE no action ON DELETE cascade
);

CREATE UNIQUE INDEX IF NOT EXISTS `settings_user_id_unique` ON `settings` (`user_id`);

-- backgrounds table
CREATE TABLE IF NOT EXISTS `backgrounds` (
    `id` integer PRIMARY KEY NOT NULL,
    `img` text NOT NULL,
    `created_at` integer DEFAULT (unixepoch ()) NOT NULL,
    `updated_at` integer DEFAULT (unixepoch ()) NOT NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS `backgrounds_img_unique` ON `backgrounds` (`img`);

CREATE TABLE IF NOT EXISTS `timers` (
    `id` integer PRIMARY KEY NOT NULL,
    `start_time` integer NOT NULL,
    `status` text NOT NULL,
    `session_count` integer NOT NULL,
    `timer_started_at` integer NOT NULL,
    `elapsed_pre_pause` integer DEFAULT 0 NOT NULL,
    `work_till_status_change` integer DEFAULT 0 NOT NULL,
    `break_till_status_change` integer DEFAULT 0 NOT NULL,
    `user_id` integer NOT NULL,
    `created_at` integer DEFAULT (unixepoch ()) NOT NULL,
    `updated_at` integer DEFAULT (unixepoch ()) NOT NULL,
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE no action ON DELETE cascade
);

CREATE TABLE IF NOT EXISTS `histories` (
    `id` integer PRIMARY KEY NOT NULL,
    `name` text,
    `start_time` integer NOT NULL,
    `end_time` integer NOT NULL,
    `total_work_time` integer NOT NULL,
    `total_break_time` integer NOT NULL,
    `user_id` integer NOT NULL,
    `created_at` integer DEFAULT (unixepoch ()) NOT NULL,
    `updated_at` integer DEFAULT (unixepoch ()) NOT NULL,
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE no action ON DELETE cascade
);

CREATE TABLE IF NOT EXISTS `global_events` (
    `id` integer PRIMARY KEY NOT NULL,
    `name` text NOT NULL,
    `payload` text,
    `created_at` integer DEFAULT (unixepoch ()) NOT NULL,
    `updated_at` integer DEFAULT (unixepoch ()) NOT NULL
);
