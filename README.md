# Terraform GCP Three-Tier (GKE + Cloud SQL) - mlpt-cloudteam-migration

Stack:
- VPC + Subnets (web/app/db per environment)
- Cloud NAT + Router
- GKE Standard (IP alias)
- Cloud SQL MySQL (Private IP)
- Remote state in GCS

## Prasyarat
- Terraform >= 1.6, gcloud, kubectl
- Auth:
  - gcloud auth login
  - gcloud auth application-default login
  - gcloud config set project mlpt-cloudteam-migration
  - gcloud config set compute/region asia-southeast2
  - gcloud config set compute/zone asia-southeast2-a
- Enable APIs:
  gcloud services enable compute.googleapis.com container.googleapis.com sqladmin.googleapis.com servicenetworking.googleapis.com iam.googleapis.com cloudresourcemanager.googleapis.com monitoring.googleapis.com logging.googleapis.com artifactregistry.googleapis.com

## Backend state
- Buat bucket GCS untuk state (ubah nama sesuai unik global):
  gsutil mb -l asia-southeast2 gs://tf-state-mlpt-cloudteam-migration
  gsutil versioning set on gs://tf-state-mlpt-cloudteam-migration
- Pastikan backend.hcl menunjuk bucket tersebut.

## Struktur
- modules/network: VPC, subnets (web/app/db), secondary ranges (pods/services), NAT, firewall opsional, PSC range
- modules/gke: Cluster GKE Standard + node pool autoscaling
- modules/sql: Cloud SQL MySQL private IP + service networking + DB/user
- envs/{dev,stg,prod}.tfvars: konfigurasi per environment

## Quick start (dev)
- terraform init -backend-config="backend.hcl"
- terraform workspace new dev (sekali)
- terraform workspace select dev
- terraform plan -var-file="envs/dev.tfvars"
- terraform apply -var-file="envs/dev.tfvars" -auto-approve

## Validasi
- VPC/Subnet:
  gcloud compute networks list
  gcloud compute networks subnets list --filter="network=vpc-main"
- NAT:
  gcloud compute routers nats list --region=asia-southeast2
- GKE:
  gcloud container clusters get-credentials gke-app-dev --region asia-southeast2 --project mlpt-cloudteam-migration
  kubectl get nodes
- Cloud SQL:
  gcloud sql instances describe mysql-db-dev

## Note
- Terraform di repo ini membuat VPC.
- 1 VPC dengan 3x3 subnet (web/app/db per env). Nanti bisa di-scale ke per-env VPC jika dibutuhkan.
- Private cluster bisa ditambah nanti (private nodes + control plane authorized networks).

## Destroy
- terraform destroy -var-file="envs/dev.tfvars" -auto-approve