Here’s a clean, **MoJ-style PoC README** you can drop straight into `README.md`. It explains *what*, *why*, and *how* without over-engineering.

---

# Infracost GitHub Actions – Proof of Concept

This repository demonstrates a **proof of concept (PoC)** for running **Infracost** against Terraform code using **GitHub Actions**, with cost diffs automatically posted on pull requests.

The goal is to show how infrastructure cost visibility can be introduced early in the PR workflow, without requiring real cloud credentials.

---

## What this PoC does

* Uses a **standalone Terraform directory** (`infracost-poc/`)
* Runs `terraform plan` in CI using **fake AWS credentials**
* Generates **Infracost cost estimates** from Terraform plan JSON
* Compares **PR vs `main`** and posts a **cost diff comment** on the PR
* Only runs when files under `infracost-poc/` change

---

## Repository structure

```text
.
├── infracost-poc/
│   ├── versions.tf        # Terraform & provider versions
│   ├── provider.tf        # AWS provider (CI-safe, no real creds)
│   └── main.tf            # PoC resources used for cost estimation
│
├── .github/
│   └── workflows/
│       └── infracost.yml  # GitHub Actions workflow
│
└── README.md
```

---

## How the workflow works

1. **Triggered on pull requests** to `main` when files under `infracost-poc/` change
2. Checks out:

   * the PR branch (HEAD)
   * the base branch (`main`)
3. Runs:

   * `terraform init`
   * `terraform plan`
   * `terraform show -json`
4. Uses Infracost to:

   * generate a cost breakdown for each plan
   * calculate a **cost diff**
5. Posts (or updates) a **comment on the PR** showing:

   * monthly cost change
   * resources added / changed / removed

---

## Why fake AWS credentials are used

This PoC does **not** deploy infrastructure.

Terraform is only used to:

* evaluate resource configuration
* produce a plan file for Infracost

Using:

```hcl
skip_credentials_validation = true
skip_requesting_account_id  = true
```

allows plans to run safely in CI without AWS access.

---

## Example change to trigger Infracost

Change an instance type in `infracost-poc/main.tf`:

```hcl
resource "aws_instance" "poc_instance" {
  ami           = "ami-12345678"
  instance_type = "t3.small"
}
```

Open a PR → the workflow runs → Infracost comments with a cost increase.

---

## GitHub Secrets required

The repo must contain the following secret:

* **`INFRACOST_API_KEY`**
  Obtained from [https://www.infracost.io/](https://www.infracost.io/)

Stored under Github Secrets


---

## What this PoC intentionally does NOT cover

* Real AWS credentials
* Production Terraform state
* Applying infrastructure
* Organisation-wide rollout
* Budget enforcement / policy blocking

Those would be considered **next steps**, not PoC scope.

---

## Potential next steps

* Upload Infracost JSON as build artifacts
* Extend to real Terraform modules
* Introduce cost thresholds or warnings
* Align with discussed FinOps and/or platform governance patterns

---

## Status

✅ Working proof of concept


