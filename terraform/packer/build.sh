#!/bin/bash
cd "$(dirname "$0")"

packer init templates/
packer validate templates/selena-base-ami.pkr.hcl
packer build templates/selena-base-ami.pkr.hcl
