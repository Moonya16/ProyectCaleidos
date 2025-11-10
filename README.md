# 🛰️ Proyect Caleidos Infrastructure – EKS Autoscaling & Load Test

Este proyecto implementa una infraestructura completa en **AWS** utilizando **Terraform** y **Amazon EKS** para probar **autoscaling dinámico de workloads en contenedores**.  
El entorno permite desplegar, exponer y escalar automáticamente aplicaciones basadas en **NGINX**, simulando carga real mediante pods generadores de tráfico HTTP y CPU.

---

## 🧩 Arquitectura General

1. **Amazon EKS (Elastic Kubernetes Service)**  
   - Cluster gestionado con Terraform, desplegado en subnets privadas.  
   - Maneja cargas de trabajo bajo un Deployment con HPA (Horizontal Pod Autoscaler).  

2. **Node Groups (EC2 Managed Nodes)**  
   - Instancias pequeñas **t3.micro** configuradas para escalar según la demanda de pods.  
   - IAM Roles con políticas para EKS, CNI, ECR y CloudWatch.

3. **NGINX Deployment + HPA**  
   - Pods con contenedores `nginx:1.27-alpine`.  
   - Recursos con límites definidos (`cpu: 500m`, `memory: 256Mi`).  
   - Expuesto mediante un **LoadBalancer Service**.  
   - Autoescalamiento basado en CPU y memoria (mín. 2 pods, máx. 5).

4. **Metrics Server**  
   - Implementado para recolectar métricas del cluster (CPU / Memoria).  
   - Necesario para que el HPA funcione correctamente.

5. **Cargas de prueba (Load Generators)**  
   - Pods `alpine/curl` lanzando peticiones HTTP concurrentes al servicio NGINX.  
   - Simulación de carga progresiva para observar escalamiento automático.

---

## 📁 Estructura del Proyecto

```bash
terraform/
├── infraestructure/
│   ├── modules/
│   │   ├── network/             # VPC, subnets y seguridad
│   │   ├── eks/                 # Cluster y node groups
│   │   ├── node_group/          # Configuración de nodos EC2 gestionados
│   ├── main.tf                  # Definición principal de la infraestructura
│   ├── variables.tf             # Variables reutilizables
│   ├── outputs.tf               # Salidas clave (cluster, subnets, etc.)
│   ├── backend.hcl              # Configuración del backend remoto (S3)
│   └── terraform.tfvars         # Variables del entorno
└── k8s/
    ├── nginx/
    │   ├── base/
    │   │   ├── deployment.yaml  # Definición base de NGINX
    │   │   ├── service.yaml     # LoadBalancer Service
    │   │   └── hpa.yaml         # Horizontal Pod Autoscaler
    │   └── overlays/
    │       └── dev/             # Overlay para entorno de desarrollo
    │           └── kustomization.yaml
```

## 🚀 Flujo de Ejecución

1. **Terraform** crea:
   - VPC, subnets privadas, security groups.
   - Cluster EKS y Node Group administrado (t3.medium). Escalado a medium para mayor manejo de carga y eficiencia

2. **Despliegue de NGINX**
   ```bash
   kubectl apply -k k8s/nginx/overlays/dev
   ```

3. **Instalación de Metrics Server**
   ```bash
   kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
   ```

4. **Simulación de carga**
   ```bash
   kubectl exec -it -n proyect-dev nginx-deployment-f957869cc-2dkh9 -- sh 
   #Dentro del pod
   apk add --no-cache stress-ng >/dev/null
   stress-ng --cpu 2 --timeout 120s --metrics-brief

   #Para ver procesos activos (a ver si ya termino stress-ng)
   ps aux
   ```

5. **Monitoreo de escalamiento**
   ```bash
   kubectl get hpa -n proyect-dev
   ```

5. **Escalamiento Manual**
   ```bash
   kubectl scale deployment nginx-deployment -n proyect-dev --replicas=5
   ```