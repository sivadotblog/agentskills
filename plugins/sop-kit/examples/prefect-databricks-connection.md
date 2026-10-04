---
id: prefect-databricks-connection
title: Connect a Prefect flow to Databricks with an SPN
version: 0.2
owner: Data Platform Engineering
risk: medium
skills: [azure-cli, databricks, prefect]
---

## Inputs
- **tenant_id**: Azure tenant ID? Example: `00000000-0000-0000-0000-000000000000`
- **spn_client_id**: SPN application (client) ID? Example: `00000000-0000-0000-0000-000000000000`
- **key_vault**: Key Vault name for the SPN secret? Example: `kv-dataplatform-dev`
- **secret_name**: Name for the secret in Key Vault? Example: `dbx-spn-secret`
- **databricks_host**: Databricks workspace URL? Example: `https://adb-1234567890.12.azuredatabricks.net`
- **environment**: Which environment? Allowed: dev, test, prod
- **repo_path**: Where is the flow repo on your laptop? Example: `~/code/my-flows`
- **spn_secret** (sensitive): Never ask for it. The user puts it in Key Vault in step 2.

## Prerequisites
- Azure CLI is logged in. Check: `az account show`. Fix: run `az login`.
- The flow repo is on the laptop. Check: `git -C {{repo_path}} status`. Fix: clone the repo, then give its path.

## Steps

### 1. Confirm the SPN exists
- Who: agent
- Do: `az ad sp show --id {{spn_client_id}} --query appId -o tsv`
- Check: output equals {{spn_client_id}}

### 2. Put the SPN secret in Key Vault
- Who: you
- Do: Open the Azure portal, go to Key Vault **{{key_vault}}** > Secrets > Generate/Import. Name it **{{secret_name}}** and paste the SPN secret there. Do not paste it in this chat.
- Check: `az keyvault secret show --vault-name {{key_vault}} --name {{secret_name}} --query id -o tsv` returns a URL ending in {{secret_name}}/...

### 3. Add the SPN to the Databricks workspace
- Who: you
- Do: Open {{databricks_host}}. Go to Settings > Identity and access > Service principals > Add. Add {{spn_client_id}}.
- Check: Ask "Do you see {{spn_client_id}} in the Service principals list?"

### 4. Write the connection config
- Who: agent
- Do: Create `{{repo_path}}/config/{{environment}}/databricks-connection.yaml` with:
  ```yaml
  databricks:
    host: {{databricks_host}}
    auth:
      type: azure_spn
      tenant_id: {{tenant_id}}
      client_id: {{spn_client_id}}
      secret_ref: keyvault://{{key_vault}}/{{secret_name}}
  ```
- Check: the file exists and contains `client_id: {{spn_client_id}}`

### 5. Commit the config on a new branch
- Who: agent
- Approval needed: yes
- Do: In {{repo_path}}, create branch `sop/dbx-connection-{{environment}}`, add the config file, commit with message "Add Databricks SPN connection for {{environment}}".
- Check: `git -C {{repo_path}} log -1 --pretty=%s` shows that message

### 6. Open a pull request
- Who: you
- Do: Push the branch and open a PR. If you are not sure how, ask and I will give you the exact commands.
- Check: Ask "Is the PR open?"

## Done when
- Check: `{{repo_path}}/config/{{environment}}/databricks-connection.yaml` contains `secret_ref: keyvault://{{key_vault}}/{{secret_name}}`

## After you finish
Once the PR is merged, the flow can be deployed with `prefect deploy`. Run it once in {{environment}} and confirm the Databricks job starts. If it fails, check the flow logs in Splunk.
