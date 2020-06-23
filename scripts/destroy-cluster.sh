#!/bin/bash

kubectl delete deployments,jobs,services,pods,pvc --all
kubectl delete deployments,jobs,services,pods,pvc --all -n kube-system