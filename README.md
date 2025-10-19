# Bridging the Gap: Integrating Legacy VMs into a Zero Trust Service Mesh

for a detailed description of the steps please follow the 
Red Hat developer blog [Bridging the Gap: Integrating Legacy VMs into a Zero Trust Service Mesh](todo)

## Service Mesh Pilot Configuration: Preparing the Mesh for Network Topology

```
oc create -f ossm/namespace.yml
oc create -f ossm/istio.yml
```

### Deploying the East-West Gateway for External Access

```
oc create -k ossm/gateway
```

## Creating Your Service Mesh Driver Disk (ISO)

```
cd iso 
./create-driver-disk.sh
```

### Preparing the Virtual Machine: DataVolume Import

```
oc create -f vm/operator/namespace.yml
```

```
oc create -f vm/operator/subscription.yml
```

```
oc create -f vm/operator/hyperconverged.yml
```

#### Preparing VM namespace

```
oc create -f vm/namespace.yml
```

```
oc create -f vm/pvc/yml
```

```
virtctl image-upload pvc servicemesh-driver-disk \
  --namespace vms \
  --size 200Mi --access-mode RWX \
  --no-create \
  --image-path servicemesh-driver.iso
```

## Preparing the Virtual Machine: Authentication Configuration

```
oc create -f vm/sa.yml
```

### Generating and Securing the Istio Authentication Token

```
cd vm
./create-istio-token.sh
oc create -f mesh-istio-token.yml
cd ..
```

## Defining the WorkloadGroup CR

```
oc create -f vm/workloadgroup.yml
```

## Leveraging VM Templates for Simplified Mesh Joining

```
oc create -f vm/template.yml
```

### Accessing the Virtual Machine: SSH via virtctl Proxy

```
cat vm/ssh_config >> ~/.ssh/config
```

### Istio Bootstrap Configurations 

```
ssh cloud-user@vm/mesh.vms
sudo -i 
```

#### mesh configuration in /etc/istio/config/mesh

```
cat vm/mesh 
```

#### cluster.env configuration in /var/lib/istio/envoy/cluster.env

```
cat vm/cluster.env
```

## Final VM Configuration: Ensuring Pilot Reachability

```
oc -n istio-system get service -l app.kubernetes.io/name=istiod -o yaml | \
  yq -r '.items[].spec.clusterIP'
```

```
echo "${istiod-clusterip} istiod.istio-system.svc" >> /etc/hosts
```

```
ls -l /etc/certs/root-cert.pem /var/run/secrets/tokens/istio-token
rpm -q istio-sidecar
```

```
systemctl enable --now istio
```
