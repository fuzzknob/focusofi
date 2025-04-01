CREATE TABLE `timers` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`created_at` integer DEFAULT (unixepoch()) NOT NULL,
	`updated_at` integer NOT NULL,
	`start_time` integer NOT NULL,
	`status` text NOT NULL,
	`session_count` integer NOT NULL,
	`elapsed_pre_pause` integer DEFAULT 0 NOT NULL,
	`work_till_status_change` integer DEFAULT 0 NOT NULL,
	`break_till_status_change` integer DEFAULT 0 NOT NULL,
	`user_id` integer NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE cascade
);
