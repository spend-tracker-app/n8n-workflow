# Project Setup Guide

This project uses Docker Compose to run [n8n](https://n8n.io/) with a PostgreSQL database.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/) installed on your machine.

## Getting Started

1. **Clone the repository**

   ```sh
   git clone https://github.com/ooijingkai10/n8n-workflow.git
   cd n8n-workflow
   ```

2. **Start the services**

   ```sh
   docker compose up -d
   ```

   This will start:
   - n8n
   - PostgreSQL (default DB: `n8n`, user: `changeUser`, password: `changePassword`)

3. **Access n8n**

   Open [http://localhost:5678](http://localhost:5678) in your browser.

4. **Import the Workflow**

   - In the n8n UI, click on the menu (top right) → Import Workflow.
   - Select and upload `workflow.json` from the project directory.

5. **Configure Credentials**

   - Go to **Credentials** in n8n.
   - Add a new **Postgres** credential with:
     - **Database**: `n8n`
     - **User**: `changeUser`
     - **Password**: `changePassword`
     - **Host**: `postgres` (if running inside Docker)
     - **Port**: `5432`
   - Add a new **Telegram Bot** credential with your **Bot Token**.
   - For the **IMAP** node:
     - **IMAP Server**: e.g., `imap.gmail.com`
     - **Email**: your Gmail address
     - **Password**: your Gmail App Password (not your main password; generate an App Password in your Google Account settings)

6. **Set Up Gmail Mailboxes (for IMAP node)**

   - In Gmail, create filter rules to automatically label emails you want to process.
   - The IMAP node can then target these labeled mailboxes.

7. **Activate the Workflow**

   - Open the imported workflow.
   - Click **Activate** to start automation.

## Notes

- To stop the services, run:
  ```sh
  docker compose down
  ```
- Keep your credentials (especially Telegram Bot Token and Gmail App Password) secure.
