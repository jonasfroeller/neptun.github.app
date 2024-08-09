-- Current sql file was generated after introspecting the database
-- If you want to run this migration please uncomment this code before executing migrations
/*
DO $$ BEGIN
 CREATE TYPE "public"."ai_model_enum" AS ENUM('OpenAssistant/oasst-sft-4-pythia-12b-epoch-3.5', 'mistralai/Mistral-7B-Instruct-v0.1');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "public"."chat_conversation_message_actor_enum" AS ENUM('user', 'assistant');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "public"."oauth_provider_enum" AS ENUM('github', 'google');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "chat_user" (
	"id" serial PRIMARY KEY NOT NULL,
	"primary_email" text NOT NULL,
	"hashed_password" text,
	"created_at" timestamp DEFAULT now(),
	"updated_at" timestamp DEFAULT now(),
	CONSTRAINT "chat_user_primary_email_unique" UNIQUE("primary_email")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "chat_conversation" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"model" "ai_model_enum" NOT NULL,
	"created_at" timestamp DEFAULT now(),
	"updated_at" timestamp DEFAULT now(),
	"chat_user_id" integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "chat_conversation_file" (
	"id" serial PRIMARY KEY NOT NULL,
	"title" text,
	"language" text DEFAULT 'text' NOT NULL,
	"file_extension" text DEFAULT 'txt' NOT NULL,
	"text" text NOT NULL,
	"created_at" timestamp DEFAULT now(),
	"updated_at" timestamp DEFAULT now(),
	"chat_user_id" integer NOT NULL,
	"chat_conversation_id" integer NOT NULL,
	"chat_conversation_message_id" integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "chat_conversation_message" (
	"id" serial PRIMARY KEY NOT NULL,
	"message" text NOT NULL,
	"actor" "chat_conversation_message_actor_enum" DEFAULT 'user' NOT NULL,
	"created_at" timestamp DEFAULT now(),
	"updated_at" timestamp DEFAULT now(),
	"chat_user_id" integer NOT NULL,
	"chat_conversation_id" integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "chat_user_oauth_account" (
	"id" serial PRIMARY KEY NOT NULL,
	"provider" "oauth_provider_enum" NOT NULL,
	"oauth_user_id" text NOT NULL,
	"oauth_email" text NOT NULL,
	"created_at" timestamp DEFAULT now(),
	"updated_at" timestamp DEFAULT now(),
	"chat_user_id" integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "chat_github_app_installation" (
	"id" serial PRIMARY KEY NOT NULL,
	"github_account_type" text NOT NULL,
	"github_account_avatar_url" text NOT NULL,
	"github_account_id" integer NOT NULL,
	"github_account_name" text,
	"created_at" timestamp DEFAULT now(),
	"updated_at" timestamp DEFAULT now(),
	"chat_user_id" integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "chat_github_app_installation_repository" (
	"id" serial PRIMARY KEY NOT NULL,
	"github_repository_id" integer NOT NULL,
	"github_repository_name" text NOT NULL,
	"github_repository_description" text,
	"github_repository_size" integer,
	"github_repository_language" text,
	"github_repository_license" text,
	"github_repository_url" text NOT NULL,
	"github_repository_website_url" text,
	"github_repository_default_branch" text,
	"github_repository_is_private" boolean NOT NULL,
	"github_repository_is_fork" boolean,
	"github_repository_is_template" boolean,
	"github_repository_is_archived" boolean NOT NULL,
	"created_at" timestamp DEFAULT now(),
	"updated_at" timestamp DEFAULT now(),
	"chat_github_app_installation_id" integer NOT NULL
);
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "chat_conversation" ADD CONSTRAINT "chat_conversation_chat_user_id_chat_user_id_fk" FOREIGN KEY ("chat_user_id") REFERENCES "public"."chat_user"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "chat_conversation_file" ADD CONSTRAINT "chat_conversation_file_chat_user_id_chat_user_id_fk" FOREIGN KEY ("chat_user_id") REFERENCES "public"."chat_user"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "chat_conversation_file" ADD CONSTRAINT "chat_conversation_file_chat_conversation_id_chat_conversation_i" FOREIGN KEY ("chat_conversation_id") REFERENCES "public"."chat_conversation"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "chat_conversation_file" ADD CONSTRAINT "chat_conversation_file_chat_conversation_message_id_chat_conver" FOREIGN KEY ("chat_conversation_message_id") REFERENCES "public"."chat_conversation_message"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "chat_conversation_message" ADD CONSTRAINT "chat_conversation_message_chat_user_id_chat_user_id_fk" FOREIGN KEY ("chat_user_id") REFERENCES "public"."chat_user"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "chat_conversation_message" ADD CONSTRAINT "chat_conversation_message_chat_conversation_id_chat_conversatio" FOREIGN KEY ("chat_conversation_id") REFERENCES "public"."chat_conversation"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "chat_user_oauth_account" ADD CONSTRAINT "chat_user_oauth_account_chat_user_id_chat_user_id_fk" FOREIGN KEY ("chat_user_id") REFERENCES "public"."chat_user"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "chat_github_app_installation" ADD CONSTRAINT "chat_github_app_installation_chat_user_id_chat_user_id_fk" FOREIGN KEY ("chat_user_id") REFERENCES "public"."chat_user"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "chat_github_app_installation_repository" ADD CONSTRAINT "chat_github_app_installation_repository_chat_github_app_install" FOREIGN KEY ("chat_github_app_installation_id") REFERENCES "public"."chat_github_app_installation"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

*/