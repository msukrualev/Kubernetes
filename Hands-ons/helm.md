# Kubernetes Hands-on Day-10: Helm

## Part 1 - Setting up the Kubernetes Cluster

- Launch a Kubernetes Cluster of Ubuntu 20.04 with two nodes

- Check if Kubernetes is running and nodes are ready.

```bash
kubectl cluster-info
kubectl get node
```

## Part 2 - Basic Operations with Helm


* Install Helm  [Helm Installation](https://helm.sh/docs/intro/install/).
for windows first install schokoley package administrator then 

run windows powershell as admin then write these commands respectively:
1 Get-ExecutionPolicy
2 Set-ExecutionPolicy AllSigned
3 Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
4- choco install kubernetes-helm

if you are on Mac or Linux follow the nexts  

```bash
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
helm version
```

- `helm search hub` searches the Artifact Hub, which lists helm charts from dozens of different repositories.

- `helm search repo` searches the repositories that we have added to your local helm client (with helm repo add). This search is done over local data, and no public network connection is needed.

- We can find publicly available charts by running helm search hub:

```bash
helm search hub
```

- Searches for all wordpress charts on Artifact Hub.

```bash
helm search hub wordpress
```

- We can add the repository using the following command.

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
```

- Using helm search repo, we can find the names of the charts in repositories we have already added:

```bash
helm search repo bitnami
```

- Type the `helm install command` to install a chart.

```bash
helm repo update
helm install nginx-release bitnami/nginx
```

- We get a simple idea of the features of this Nginx chart by running `helm show chart bitnami/nginx`. Or we could run `helm show all bitnami/nginx` to get all information about the chart.

```bash
helm show chart bitnami/nginx
helm show all bitnami/nginx
```

- Whenever we install a chart, a new release is created. So one chart can be installed multiple times into the same cluster. And each can be independently managed and upgraded.

- Install a new release with bitnami/nginx chart.

```bash
helm install my-release \
  --set Username=admin \
  --set Password=password \
    bitnami/nginx
```

- It's easy to see what has been released using Helm.

```bash
helm list
```

- Uninstall a release.

```bash
helm uninstall my-release
helm uninstall mysql-release
```

## Part 3 - Creating Helm chart

- Create a new chart with following command.

```bash
helm create batch107-chart
```

- See the files of batch107-chart.

```bash
ls batch107-chart
```

- Remove the files from `templates` folder.

```bash
rm -rf batch107-chart/templates/*
```

- Create a `configmap.yaml` file under `batch107-chart/templates` folder with following content.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: batch107-chart-config
data:
  myvalue: "Hello World"
```

- Install the batch107-chart.

```bash
helm install helm-demo batch107-chart
```

- List the releases.

```bash
helm ls
```

- Let's see the configmap.

```bash
kubectl get cm
kubectl describe cm batch107-chart-config
```

- Remove the release.

```bash
helm uninstall helm-demo
```

- Let's create our own values and use it within the template. Update the `batch107-chart/values.yaml` as below.

```yaml
course: DevOps
```

- Edit the batch107-chart/templates/configmap.yaml as below.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: batch107-chart-config
data:
  myvalue: "batch107-chart configmap example"
  course: {{ .Values.course }}
``` 

- Let's see how the values are getting substituted with the `dry-run` option.

```bash
helm install --debug --dry-run mydryrun batch107-chart
```

- Install the batch107-chart.

```bash
helm install myvalue batch107-chart
```

- Check the values that got deployed with the following command.

```bash
helm get manifest myvalue
```

- Remove the release.

```bash
helm uninstall myvalue
```

- Let's change the default value from the values.yaml file when the release is getting released.

```bash
helm install --debug --dry-run setflag batch107-chart --set course=AWS
```

- We can also get values with built-in objects. Objects can be simple and have just one value. Or they can contain other objects or functions. For example. the Release object contains several objects (like Release.Name) and the Files object has a few functions.

- Edit the batch107-chart/templates/configmap.yaml as below.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-config
data:
  myvalue: "batch107-chart configmap example"
  course: {{ .Values.course }}
``` 

- Let's see how the values are getting substituted with the `dry-run` option.

```bash
helm install --debug --dry-run builtin-object batch107-chart
```

- Let's try more examples to get more clarity. Update the `batch107-chart/values.yaml` as below.

```yaml
course: DevOps
lesson:
  topic: helm
```

- So far, we've seen how to place information into a template. But that information is placed into the template unmodified. Sometimes we want to transform the supplied data in a way that makes it more useful to us.

- Helm has over 60 available functions. Some of them are defined by the [Go template language](https://pkg.go.dev/text/template) itself. Most of the others are part of the [Sprig template](https://masterminds.github.io/sprig/) library. Let's see some functions.

- Update the `batch107-chart/templates/configmap.yaml` as below.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-config
data:
  myvalue: "batch107-chart configmap example"
  course: {{ quote .Values.course }}
  topic: {{ upper .Values.lesson.topic }}
  time: {{ now | date "2006.01.02" | quote }} 
```

 Let's see how the values are getting substituted with the `dry-run` option.

```bash
helm install --debug --dry-run morevalues batch107-chart
```

- **now** function shows the current date/time.

- **date** function formats a date.

### Helm Notes:

- In this part, we are going to look at Helm's tool for providing instructions to your chart users. At the end of a `helm install` or `helm upgrade`, Helm can print out a block of helpful information for users. This information is highly customizable using templates.

- To add installation notes to your chart, simply create a `batch107-chart/NOTES.txt` file. This file is plain text, but it is processed like a template and has all the normal template functions and objects available.

- Let's create a simple `NOTES.txt` file under `batch107-chart/templates` folder.

```txt
Thank you for installing {{ .Chart.Name }}.

Your release is named {{ .Release.Name }}.

To learn more about the release, try:

  $ helm status {{ .Release.Name }}
  $ helm get all {{ .Release.Name }}
```

- Let's run our helm chart.

```bash
helm install notes-demo batch107-chart
```

- Using NOTES.txt this way is a great way to give your users detailed information about how to use their newly installed chart. Creating a NOTES.txt file is strongly recommended, though it is not required.

- Remove the release.

```bash
helm uninstall notes-demo
```
