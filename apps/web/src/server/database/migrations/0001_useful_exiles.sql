CREATE TABLE `settings` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`created_at` integer DEFAULT (unixepoch()) NOT NULL,
	`updated_at` integer NOT NULL,
	`work_length` integer DEFAULT 2400 NOT NULL,
	`short_break_length` integer DEFAULT 120 NOT NULL,
	`long_break_length` integer DEFAULT 600 NOT NULL,
	`break_successions` integer DEFAULT 4 NOT NULL,
	`user_id` integer NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
DROP INDEX `email_otps_otpCode_unique`;--> statement-breakpoint
CREATE UNIQUE INDEX `email_otps_otp_code_unique` ON `email_otps` (`otp_code`);