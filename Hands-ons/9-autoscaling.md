1) creating a deployment yaml that is php-apache.yaml 

# alias k='kubectl' with this command we can get short the name of kubectl as "k"

apiVersion: apps/v1
kind: Deployment
metadata:
  name: php-apache
spec:
  selector:
    matchLabels:
      run: php-apache
  replicas: 1
  template:
    metadata:
      labels:
        run: php-apache
    spec:
      containers:
      - name: php-apache
        image: k8s.gcr.io/hpa-example
        ports:
        - containerPort: 80
        resources:
          limits:
            memory: 500Mi
            cpu: 100m
          requests:
            memory: 250Mi
            cpu: 80m
---
apiVersion: v1
kind: Service
metadata:
  name: php-apache-service
  labels:
    run: php-apache
spec:
  ports:
  - port: 80
    nodePort: 30002
  selector:
    run: php-apache 
  type: NodePort	
  

2)  then write in the command ; kubectl apply -f php-apache.yaml


3- we can scale our pods with imperative methods

# kubectl autoscale deployment php-apache --cpu-percent=50 --min=2 --max=10

or declaritive

# --- then create horizontal pod  autoscaling yaml file. "hpa.yaml"

apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: php-apache
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: php-apache
  minReplicas: 1
  maxReplicas: 10
  targetCPUUtilizationPercentage: 50


kubectl apply -f hpa.yaml
then with command "kubectl get po -w" in another terminal to watch pods's situation.


# "kubectl get hpa" show the current hpa

4- Set up a stress tool through in ubuntu wsl " wget https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.5.0/components.yaml"
then add in the yaml file this command below.

## 

<!-- # apiVersion: v1
# kind: ServiceAccount
# metadata:
#   labels:
#     k8s-app: metrics-server
#   name: metrics-server
#   namespace: kube-system
# ---
# apiVersion: rbac.authorization.k8s.io/v1
# kind: ClusterRole
# metadata:
#   labels:
#     k8s-app: metrics-server
#     rbac.authorization.k8s.io/aggregate-to-admin: "true"
#     rbac.authorization.k8s.io/aggregate-to-edit: "true"
#     rbac.authorization.k8s.io/aggregate-to-view: "true"
#   name: system:aggregated-metrics-reader
# rules:
# - apiGroups:
#   - metrics.k8s.io
#   resources:
#   - pods
#   - nodes
#   verbs:
#   - get
#   - list
#   - watch
# ---
# apiVersion: rbac.authorization.k8s.io/v1
# kind: ClusterRole
# metadata:
#   labels:
#     k8s-app: metrics-server
#   name: system:metrics-server
# rules:
# - apiGroups:
#   - ""
#   resources:
#   - pods
#   - nodes
#   - nodes/stats
#   - namespaces
#   - configmaps
#   verbs:
#   - get
#   - list
#   - watch
# ---
# apiVersion: rbac.authorization.k8s.io/v1
# kind: RoleBinding
# metadata:
#   labels:
#     k8s-app: metrics-server
#   name: metrics-server-auth-reader
#   namespace: kube-system
# roleRef:
#   apiGroup: rbac.authorization.k8s.io
#   kind: Role
#   name: extension-apiserver-authentication-reader
# subjects:
# - kind: ServiceAccount
#   name: metrics-server
#   namespace: kube-system
# ---
# apiVersion: rbac.authorization.k8s.io/v1
# kind: ClusterRoleBinding
# metadata:
#   labels:
#     k8s-app: metrics-server
#   name: metrics-server:system:auth-delegator
# roleRef:
#   apiGroup: rbac.authorization.k8s.io
#   kind: ClusterRole
#   name: system:auth-delegator
# subjects:
# - kind: ServiceAccount
#   name: metrics-server
#   namespace: kube-system
# ---
# apiVersion: rbac.authorization.k8s.io/v1
# kind: ClusterRoleBinding
# metadata:
#   labels:
#     k8s-app: metrics-server
#   name: system:metrics-server
# roleRef:
#   apiGroup: rbac.authorization.k8s.io
#   kind: ClusterRole
#   name: system:metrics-server
# subjects:
# - kind: ServiceAccount
#   name: metrics-server
#   namespace: kube-system
# ---
# apiVersion: v1
# kind: Service
# metadata:
#   labels:
#     k8s-app: metrics-server
#   name: metrics-server
#   namespace: kube-system
# spec:
#   ports:
#   - name: https
#     port: 443
#     protocol: TCP
#     targetPort: https
#   selector:
#     k8s-app: metrics-server
# ---
# apiVersion: apps/v1
# kind: Deployment
# metadata:
#   labels:
#     k8s-app: metrics-server
#   name: metrics-server
#   namespace: kube-system
# spec:
#   selector:
#     matchLabels:
#       k8s-app: metrics-server
#   strategy:
#     rollingUpdate:
#       maxUnavailable: 0
#   template:
#     metadata:
#       labels:
#         k8s-app: metrics-server
#     spec:
#       containers:
#       - args:
#         - --kubelet-insecure-tls
#         - --cert-dir=/tmp
#         - --secure-port=443
#         - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
#         - --kubelet-use-node-status-port
#         - --metric-resolution=15s
#         image: k8s.gcr.io/metrics-server/metrics-server:v0.5.0
#         imagePullPolicy: IfNotPresent
#         livenessProbe:
#           failureThreshold: 3
#           httpGet:
#             path: /livez
#             port: https
#             scheme: HTTPS
#           periodSeconds: 10
#         name: metrics-server
#         ports:
#         - containerPort: 443
#           name: https
#           protocol: TCP
#         readinessProbe:
#           failureThreshold: 3
#           httpGet:
#             path: /readyz
#             port: https
#             scheme: HTTPS
#           initialDelaySeconds: 20
#           periodSeconds: 10
#         resources:
#           requests:
#             cpu: 100m
#             memory: 200Mi
#         securityContext:
#           readOnlyRootFilesystem: true
#           runAsNonRoot: true
#           runAsUser: 1000
#         volumeMounts:
#         - mountPath: /tmp
#           name: tmp-dir
#       nodeSelector:
#         kubernetes.io/os: linux
#       priorityClassName: system-cluster-critical
#       serviceAccountName: metrics-server
#       volumes:
#       - emptyDir: {}
#         name: tmp-dir
# ---
# apiVersion: apiregistration.k8s.io/v1
# kind: APIService
# metadata:
#   labels:
#     k8s-app: metrics-server
#   name: v1beta1.metrics.k8s.io
# spec:
#   group: metrics.k8s.io
#   groupPriorityMinimum: 100
#   insecureSkipTLSVerify: true
#   service:
#     name: metrics-server
#     namespace: kube-system
#   version: v1beta1
#   versionPriority: 100


" - --kubelet-insecure-tls "

make it like below.






kubectl apply -f components.yaml

on the command line write below respectively for stresstest

kubectl run -it --rm load-generator --image=busybox /bin/sh  

Hit enter for command prompt

while true; do wget -q -O- http://<public ip>:<port number of php-apache-service>; done







