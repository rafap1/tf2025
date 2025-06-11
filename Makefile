## Makefile - prueba - no usar en produccion
## 

.DEFAULT_GOAL ?= help
.PHONY: help

help:
	@echo "${Company} - ${Project}"
	@echo "${Description}"
	@echo ""


###################### Parameters ######################
Description ?= Despliegue de Infrasestructura con Terraform

Company ?= lumon
Project ?= mdr
env ?= dev

ProjDir ?= ./${env}

## Used to store temportary .out files from terraform plan
TempDir ?= /tmp

## Directories of different terraform modules of RBB Socios project
OneTimeDir ?= ${ProjDir}/0_onetime/
BaseDir ?= ${ProjDir}/1_base/
PortalDir ?= ${ProjDir}/2_portal
DbDir ?= ${ProjDir}/3_db
DevOpsDir ?= ${ProjDir}/4_devops
MgmtDir ?= ${ProjDir}/5_mgmt

##========================= FORMAT =========================
all-format:  onetime-format base-format portal-format db-format devops-format mgmt-format

onetime-format: 
	terraform -chdir=${OneTimeDir}  fmt
base-format: 
	terraform -chdir=${BaseDir}  fmt
portal-format: 
	terraform -chdir=${PortalDir} fmt
db-format:
	terraform -chdir=${DbDir} fmt
devops-format:
	terraform -chdir=${DevOpsDir} fmt
mgmt-format:
	terraform -chdir=${MgmtDir} fmt


##========================= INIT =========================
# Note: in this case "all" includes onetime since plan cannot change infra
#
all-init:  onetime-init base-init portal-init db-init devops-init mgmt-init

onetime-init: 
	terraform -chdir=${OneTimeDir}  init
base-init: 
	terraform -chdir=${BaseDir}  init
portal-init: 
	terraform -chdir=${PortalDir} init
db-init:
	terraform -chdir=${DbDir} init
devops-init:
	terraform -chdir=${DevOpsDir} init
mgmt-init:
	terraform -chdir=${MgmtDir} init

##========================= INIT upgrade =========================
# Note: in this case "all" includes onetime since plan cannot change infra
#
all-init-upgrade:  onetime-init-upgrade base-init-upgrade portal-init-upgrade db-init-upgrade devops-init-upgrade mgmt-init-upgrade

onetime-init-upgrade: 
	terraform -chdir=${OneTimeDir}  init -upgrade
base-init-upgrade: 
	terraform -chdir=${BaseDir}  init -upgrade
portal-init-upgrade: 
	terraform -chdir=${PortalDir} init -upgrade
db-init-upgrade:
	terraform -chdir=${DbDir} init -upgrade
devops-init-upgrade:
	terraform -chdir=${DevOpsDir} init -upgrade
mgmt-init-upgrade:
	terraform -chdir=${MgmtDir} init -upgrade

##========================= PLAN =========================
# Note: in this case "all" includes onetime since plan cannot change infra
#
all-plan:  onetime-plan base-plan portal-plan db-plan devops-plan mgmt-plan

onetime-plan:
	@echo 
	@echo "============================== One Time (${env}) =============================="
	@echo 
	terraform -chdir=${OneTimeDir} fmt
	terraform -chdir=${OneTimeDir} validate 
	terraform -chdir=${OneTimeDir}  plan -var-file=onetime_${env}.tfvars
base-plan:
	@echo 
	@echo "==============================   Base   (${env}) =============================="
	@echo 
	terraform -chdir=${BaseDir} fmt
	terraform -chdir=${BaseDir} validate 
	terraform -chdir=${BaseDir}  plan  -var-file=base_${env}.tfvars
portal-plan:
	@echo 
	@echo "==============================  Portal  (${env}) =============================="
	@echo 
	terraform -chdir=${PortalDir} fmt
	terraform -chdir=${PortalDir} validate 
	terraform -chdir=${PortalDir} plan	-var-file=portal_${env}.tfvars
db-plan:
	@echo
	@echo "============================== Database (${env}) =============================="
	@echo 
	terraform -chdir=${DbDir} fmt
	terraform -chdir=${DbDir} validate 
	terraform -chdir=${DbDir} plan -var-file=db_${env}.tfvars
devops-plan:
	@echo
	@echo "==============================  DevOps  (${env}) =============================="
	@echo 
	terraform -chdir=${DevOpsDir} fmt
	terraform -chdir=${DevOpsDir} validate 
	terraform -chdir=${DevOpsDir} plan -var-file=devops_${env}.tfvars
mgmt-plan:
	@echo 
	@echo "==============================  Mgmt  (${env})   =============================="
	@echo 
	terraform -chdir=${MgmtDir} fmt
	terraform -chdir=${MgmtDir} validate 
	terraform -chdir=${MgmtDir} plan -var-file=mgmt_${env}.tfvars

## NOTE - "all" does NOT include onetime and does NOT include database
# all-apply-auto-approve: base-apply-auto-approve portal-apply-auto-approve devops-apply-auto-approve mgmt-apply-auto-approve

# portal-devops-mgmt-apply-auto-approve: portal-apply-auto-approve devops-apply-auto-approve mgmt-apply-auto-approve

# base-portal-devops-apply-auto-approve: base-apply-auto-approve portal-apply-auto-approve devops-apply-auto-approve

onetime-apply-auto-approve:
	@echo "======================= One Time (Apply) (${env}) ========================================"
	rm -f ${TempDir}/onetime_${env}.out
	terraform -chdir=${OneTimeDir} fmt
	terraform -chdir=${OneTimeDir} validate 
	terraform -chdir=${OneTimeDir} plan -out ${TempDir}/onetime_${env}.out -var-file=onetime_${env}.tfvars
	terraform -chdir=${OneTimeDir} apply -auto-approve ${TempDir}/onetime_${env}.out
base-apply-auto-approve:
	rm -f ${TempDir}/base_${env}.out
	@echo "======================= Base (Apply) (${env}) ========================================"
	terraform -chdir=${BaseDir} fmt
	terraform -chdir=${BaseDir} validate 
	terraform -chdir=${BaseDir} plan -out ${TempDir}/base_${env}.out -var-file=base_${env}.tfvars
	terraform -chdir=${BaseDir} apply -auto-approve  ${TempDir}/base_${env}.out

## TEMPORAL - capado base-apply-auto-approve 
## SOLO HACE PRE
# base-apply-auto-approve:
# 	@echo "======================= Base (Apply) (${env})  ========================================"
# 	rm -f ${TempDir}/base_pre.out
# 	terraform -chdir=pre/1_base/ fmt
# 	terraform -chdir=pre/1_base/ validate
# 	terraform -chdir=pre/1_base/ plan  -var-file=base_pre.tfvars
# 	terraform -chdir=pre/1_base/ plan -out ${TempDir}/base_pre.out -var-file=base_pre.tfvars
# 	terraform -chdir=pre/1_base/ apply -auto-approve ${TempDir}/base_pre.out
# ## ===========================  fin temporal


portal-apply-auto-approve:
	@echo "======================= Portal (Apply) (${env}) ========================================"
	rm -f ${TempDir}/portal_${env}.out
	terraform -chdir=${PortalDir} fmt
	terraform -chdir=${PortalDir} validate 
	terraform -chdir=${PortalDir} plan -out ${TempDir}/portal_${env}.out -var-file=portal_${env}.tfvars
	terraform -chdir=${PortalDir} apply -auto-approve  ${TempDir}/portal_${env}.out

db-apply-auto-approve:
	@echo "======================= DB (Apply) (${env}) ========================================"
	rm -f ${TempDir}/db_${env}.out
	terraform -chdir=${DbDir} fmt
	terraform -chdir=${DbDir} validate 
	terraform -chdir=${DbDir} plan -out ${TempDir}/db_${env}.out -var-file=db_${env}.tfvars
	terraform -chdir=${DbDir} apply -auto-approve  ${TempDir}/db_${env}.out

devops-apply-auto-approve:
	@echo "======================= DevOps (Apply) (${env}) ========================================"
	rm -f ${TempDir}/devops_${env}.out
	terraform -chdir=${DevOpsDir} fmt
	terraform -chdir=${DevOpsDir} validate 
	terraform -chdir=${DevOpsDir} plan -out ${TempDir}/devops_${env}.out -var-file=devops_${env}.tfvars
	terraform -chdir=${DevOpsDir} apply -auto-approve  ${TempDir}/devops_${env}.out

mgmt-apply-auto-approve:
	@echo "======================= Mgmt (Apply) (${env}) ========================================"
	rm -f ${TempDir}/mgmt_${env}.out
	terraform -chdir=${MgmtDir} fmt
	terraform -chdir=${MgmtDir} validate 
	terraform -chdir=${MgmtDir} plan -out ${TempDir}/mgmt_${env}.out -var-file=mgmt_${env}.tfvars
	terraform -chdir=${MgmtDir} apply -auto-approve  ${TempDir}/mgmt_${env}.out

## ===================== Outputs of different modules ===============
all-output: onetime-output base-output portal-output db-output devops-output

onetime-output:
	@echo "======================= OneTimeDir (${env}) ========================================"
	terraform -chdir=${OneTimeDir} output
base-output:
	@echo "======================= Base (${env}) =================================================="
	terraform -chdir=${BaseDir} output
portal-output:
	@echo "======================= Portal (${env}) ================================================"
	terraform -chdir=${PortalDir} output 
db-output:
	@echo "======================= Database (${env}) =============================================="
	terraform -chdir=${DbDir} output 
devops-output:
	@echo "======================= Devops (${env}) ================================================"
	terraform -chdir=${DevOpsDir} output 
mgmt-output:
	@echo "======================= Mgmt (${env}) =================================================="
	terraform -chdir=${MgmtDir} output 
## ===================== List resources in the Terraform state of different modules ===============
all-list:
	@echo "======================= One Time (${env}) ========================================"
	terraform -chdir=${OneTimeDir} state list
	@echo "======================= Base (${env}) ========================================"
	terraform -chdir=${BaseDir} state list
	@echo "======================= Portal (${env}) ========================================"
	terraform -chdir=${PortalDir} state list
	@echo "======================= Database (${env}) ========================================"
	terraform -chdir=${DbDir} state list
	@echo "======================= Devops (${env}) ========================================"
	terraform -chdir=${DevOpsDir} state list
	@echo "======================= Mgmt (${env}) ========================================"
	terraform -chdir=${MgmtDir} state list

## Destroy operations 

entorno-parcial-destroy: mgmt-destroy devops-destroy portal-destroy db-destroy  

db-destroy :
	@echo "======================= DB destroy  (${env}) ========================================"
	@if ! case "${env}" in "maq" | "dev" | "pre") exit 0 ;; esac; then \
		echo "Destroy db only available in environments 'maq', 'dev', 'pre'"; \
		exit 1; \
	fi
	@read -p "Are you sure that you want to destroy Database in ${env}'? [y/N]: " sure && [ $${sure:-N} = 'y' ]
	terraform -chdir=${DbDir} destroy -auto-approve  -var-file=db_${env}.tfvars	
mgmt-destroy:
	@echo "======================= Mgmt destroy  (${env}) ========================================"
	@if ! case "${env}" in "maq" | "dev" | "pre") exit 0 ;; esac; then \
		echo "Destroy Mgmt only available in environment 'maq'"; \
		exit 1; \
	fi
	@read -p "Are you sure that you want to destroy Mgmt in ${env}'? [y/N]: " sure && [ $${sure:-N} = 'y' ]
	terraform -chdir=${MgmtDir} destroy -auto-approve  -var-file=mgmt_${env}.tfvars
portal-destroy:
	@echo "======================= Portal destroy  (${env}) ========================================"
	@if ! case "${env}" in "maq" | "dev" | "pre") exit 0 ;; esac; then \
		echo "Destroy portal only available in environment 'maq'"; \
		exit 1; \
	fi
	@read -p "Are you sure that you want to destroy Portal in ${env}'? [y/N]: " sure && [ $${sure:-N} = 'y' ]
	terraform -chdir=${PortalDir} destroy -auto-approve  -var-file=portal_${env}.tfvars
devops-destroy:
	@echo "======================= Devops destroy  (${env}) ========================================"
	@if ! case "${env}" in "maq" | "dev" | "pre") exit 0 ;; esac; then \
		echo "Destroy Devops only available in environment 'maq'"; \
		exit 1; \
	fi
	@read -p "Are you sure that you want to destroy Devops in ${env}'? [y/N]: " sure && [ $${sure:-N} = 'y' ]
	terraform -chdir=${DevOpsDir} destroy -auto-approve  -var-file=devops_${env}.tfvars

# TO DESTROY - use actual terraform commands
# Examples :

# to destroy portal pre version
## cd pre/2_portal
## terraform destroy -var-file=portal_pre.tfvars

# to destroy base pro version
## cd pro/1_base
## terraform destroy -var-file=base_pro.tfvars

