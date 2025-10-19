#!/bin/bash

DURATION=${DURATION:-"600s"}
NAMESPACE=${NAMESPACE:-"vms"}

oc -n ${NAMESPACE} create secret generic mesh-istio-token \
 --from-literal=istio-token="$(oc -n ${NAMESPACE} create token mesh \
   --audience=istio-ca --duration=${DURATION} -o jsonpath='{.status.token}')" \
 --dry-run=client -o yaml > mesh-istio-token.yml

