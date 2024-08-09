import {
	pgTable,
	unique,
	pgEnum,
	serial,
	text,
	timestamp,
	foreignKey,
	integer,
	boolean,
} from "drizzle-orm/pg-core";
import { sql } from "drizzle-orm";

export const aiModelEnum = pgEnum("ai_model_enum", [
	"OpenAssistant/oasst-sft-4-pythia-12b-epoch-3.5",
	"mistralai/Mistral-7B-Instruct-v0.1",
]);
export const chatConversationMessageActorEnum = pgEnum(
	"chat_conversation_message_actor_enum",
	["user", "assistant"],
);
export const oauthProviderEnum = pgEnum("oauth_provider_enum", [
	"github",
	"google",
]);

export const chatUser = pgTable(
	"chat_user",
	{
		id: serial("id").primaryKey().notNull(),
		primaryEmail: text("primary_email").notNull(),
		hashedPassword: text("hashed_password"),
		createdAt: timestamp("created_at", { mode: "string" }).defaultNow(),
		updatedAt: timestamp("updated_at", { mode: "string" }).defaultNow(),
	},
	(table) => {
		return {
			chatUserPrimaryEmailUnique: unique("chat_user_primary_email_unique").on(
				table.primaryEmail,
			),
		};
	},
);

export const chatConversation = pgTable("chat_conversation", {
	id: serial("id").primaryKey().notNull(),
	name: text("name").notNull(),
	model: aiModelEnum("model").notNull(),
	createdAt: timestamp("created_at", { mode: "string" }).defaultNow(),
	updatedAt: timestamp("updated_at", { mode: "string" }).defaultNow(),
	chatUserId: integer("chat_user_id")
		.notNull()
		.references(() => chatUser.id, { onDelete: "cascade" }),
});

export const chatConversationFile = pgTable("chat_conversation_file", {
	id: serial("id").primaryKey().notNull(),
	title: text("title"),
	language: text("language").default("text").notNull(),
	fileExtension: text("file_extension").default("txt").notNull(),
	text: text("text").notNull(),
	createdAt: timestamp("created_at", { mode: "string" }).defaultNow(),
	updatedAt: timestamp("updated_at", { mode: "string" }).defaultNow(),
	chatUserId: integer("chat_user_id")
		.notNull()
		.references(() => chatUser.id, { onDelete: "cascade" }),
	chatConversationId: integer("chat_conversation_id")
		.notNull()
		.references(() => chatConversation.id, { onDelete: "cascade" }),
	chatConversationMessageId: integer("chat_conversation_message_id")
		.notNull()
		.references(() => chatConversationMessage.id, { onDelete: "cascade" }),
});

export const chatConversationMessage = pgTable("chat_conversation_message", {
	id: serial("id").primaryKey().notNull(),
	message: text("message").notNull(),
	actor: chatConversationMessageActorEnum("actor").default("user").notNull(),
	createdAt: timestamp("created_at", { mode: "string" }).defaultNow(),
	updatedAt: timestamp("updated_at", { mode: "string" }).defaultNow(),
	chatUserId: integer("chat_user_id")
		.notNull()
		.references(() => chatUser.id, { onDelete: "cascade" }),
	chatConversationId: integer("chat_conversation_id")
		.notNull()
		.references(() => chatConversation.id, { onDelete: "cascade" }),
});

export const chatUserOauthAccount = pgTable("chat_user_oauth_account", {
	id: serial("id").primaryKey().notNull(),
	provider: oauthProviderEnum("provider").notNull(),
	oauthUserId: text("oauth_user_id").notNull(),
	oauthEmail: text("oauth_email").notNull(),
	createdAt: timestamp("created_at", { mode: "string" }).defaultNow(),
	updatedAt: timestamp("updated_at", { mode: "string" }).defaultNow(),
	chatUserId: integer("chat_user_id")
		.notNull()
		.references(() => chatUser.id, { onDelete: "cascade" }),
});

export const chatGithubAppInstallation = pgTable(
	"chat_github_app_installation",
	{
		id: serial("id").primaryKey().notNull(),
		githubAccountType: text("github_account_type").notNull(),
		githubAccountAvatarUrl: text("github_account_avatar_url").notNull(),
		githubAccountId: integer("github_account_id").notNull(),
		githubAccountName: text("github_account_name"),
		createdAt: timestamp("created_at", { mode: "string" }).defaultNow(),
		updatedAt: timestamp("updated_at", { mode: "string" }).defaultNow(),
		chatUserId: integer("chat_user_id")
			.notNull()
			.references(() => chatUser.id, { onDelete: "cascade" }),
	},
);

export const chatGithubAppInstallationRepository = pgTable(
	"chat_github_app_installation_repository",
	{
		id: serial("id").primaryKey().notNull(),
		githubRepositoryId: integer("github_repository_id").notNull(),
		githubRepositoryName: text("github_repository_name").notNull(),
		githubRepositoryDescription: text("github_repository_description"),
		githubRepositorySize: integer("github_repository_size"),
		githubRepositoryLanguage: text("github_repository_language"),
		githubRepositoryLicense: text("github_repository_license"),
		githubRepositoryUrl: text("github_repository_url").notNull(),
		githubRepositoryWebsiteUrl: text("github_repository_website_url"),
		githubRepositoryDefaultBranch: text("github_repository_default_branch"),
		githubRepositoryIsPrivate: boolean(
			"github_repository_is_private",
		).notNull(),
		githubRepositoryIsFork: boolean("github_repository_is_fork"),
		githubRepositoryIsTemplate: boolean("github_repository_is_template"),
		githubRepositoryIsArchived: boolean(
			"github_repository_is_archived",
		).notNull(),
		createdAt: timestamp("created_at", { mode: "string" }).defaultNow(),
		updatedAt: timestamp("updated_at", { mode: "string" }).defaultNow(),
		chatGithubAppInstallationId: integer("chat_github_app_installation_id")
			.notNull()
			.references(() => chatGithubAppInstallation.id, { onDelete: "cascade" }),
	},
);
