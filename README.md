# Project Setup Guide

This project uses Docker Compose to run [n8n](https://n8n.io/) with a PostgreSQL database. All credentials and workflows are configured automatically — you only need to supply a `.env` file before starting.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/) installed on your machine.

## Getting Started

### 1. Clone the repository

```sh
git clone https://github.com/ooijingkai10/n8n-workflow.git
cd n8n-workflow
```

### 2. Create your `.env` file

Copy the example environment file and fill in your credentials:

```sh
cp .env.example .env
```

Open `.env` and replace the placeholder values:

| Variable | Description |
|---|---|
| `POSTGRES_USER` | PostgreSQL root username |
| `POSTGRES_PASSWORD` | PostgreSQL root password |
| `POSTGRES_DB` | PostgreSQL database name |
| `POSTGRES_NON_ROOT_USER` | PostgreSQL non-root username used by n8n |
| `POSTGRES_NON_ROOT_PASSWORD` | PostgreSQL non-root password used by n8n |
| `TELEGRAM_BOT_TOKEN` | Your Telegram bot token (see instructions below) |
| `TELEGRAM_GROUP_ID` | The Telegram group/chat ID where the bot will send messages |
| `IMAP_USER` | Your Gmail address (e.g. `user@gmail.com`) |
| `IMAP_PASSWORD` | Your Gmail App Password (see instructions below) |
| `IMAP_HOST` | IMAP server host (e.g. `imap.gmail.com`) |

#### How to get your Telegram Bot Token

1. Open Telegram and start a chat with [@BotFather](https://t.me/BotFather).
2. Send `/newbot` and follow the prompts to create a new bot.
3. BotFather will give you a token like `123456789:ABCDefGhIJKlmNoPQRsTUVwxyZ` — copy this into `TELEGRAM_BOT_TOKEN`.

#### How to get your Telegram Group ID

1. Add [@Getmyid_bot](https://t.me/Getmyid_bot) to the group temporarily.
2. It will reply with the group/chat ID — copy the number (including the leading `-` if present) into `TELEGRAM_GROUP_ID`.
3. Remove `@Getmyid_bot` from the group after you have the ID.

#### Add your bot to the Telegram group with admin permission

1. Open the group in Telegram.
2. Go to **Group Info → Administrators → Add Admin**.
3. Search for your bot by its username and add it as an administrator.

> Admin permission is required so the bot can send messages to the group.

#### How to get your Gmail App Password (for IMAP)

1. Make sure **2-Step Verification** is enabled on your Google Account.
2. Go to [https://myaccount.google.com/apppasswords](https://myaccount.google.com/apppasswords).
3. Generate a new App Password for "Mail".
4. Copy the 16-character password into `IMAP_PASSWORD`.

> Use your full Gmail address as `IMAP_USER` (e.g. `user@gmail.com`).

### 3. Start the automation stack

```sh
docker compose up -d
```

This single command will:
- Start a **PostgreSQL** database and create the required tables.
- Start **n8n** and automatically import all workflows.
- Inject your credentials (IMAP, Telegram, PostgreSQL) into n8n — no manual configuration needed.

### 4. Access n8n (optional)

Open [http://localhost:5678](http://localhost:5678) in your browser to view or manage your workflows.

## Stopping the stack

```sh
docker compose down
```

## Security Notes

- Keep your `.env` file private — never commit it to version control (it is already listed in `.gitignore`).
- Rotate your Gmail App Password and Telegram Bot Token if they are ever exposed.
