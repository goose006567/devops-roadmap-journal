# Day 6 Notes

## Terraform's Model
You declare the **desired state** in `.tf` files. Terraform compares that to reality and figures out what to create / change / destroy to get there. You describe *what* you want, never *how* to do it.

## The State File (terraform.tfstate)
Terraform's memory of what it has already created. It maps your declarations to real resource IDs. Never edit it by hand — a corrupt state means Terraform no longer knows what it owns.

## plan vs apply
- `terraform plan` shows what would change *before anything happens* — read it like a diff
- `terraform apply` executes it
- Rule: plan before apply, always read the plan

## Idempotency
Running `apply` twice with no changes does nothing the second time. This makes IaC safe to re-run — it's the property that makes infrastructure reproducible.

## Extra Notes (day-of)
- AWS Free Tier: destroy everything at end of session to avoid billing
- Never commit `terraform.tfstate` or init it into git by default