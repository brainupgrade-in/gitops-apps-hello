# GitOps Apps - Hello World

## Overview

This repository, part of the `brainupgrade-in` organization, demonstrates a basic application setup in a GitOps environment. It is designed as a reference for implementing GitOps principles using Kubernetes and other cloud-native technologies. The repository contains the source code and configuration for a simple "Hello World" application, showcasing best practices in cloud-native development and deployment.

## Prerequisites

- Kubernetes Cluster: You should have access to a Kubernetes cluster where you can deploy this application.
- Familiarity with GitOps: Basic understanding of GitOps principles and workflows.
- Required Tools: Kubernetes command-line tool (`kubectl`), Git, and optionally a CI/CD tool like Jenkins or GitLab CI.

## Repository Structure

- `k8s/`: Kubernetes manifests for deploying the application.
- `src/`: Source code of the Hello World application.
- `Dockerfile`: Dockerfile for building the application container.
- `README.md`: This file, containing documentation for the repository.

## Getting Started

1. **Clone the Repository:**
```
git clone https://github.com/brainupgrade-in/gitops-apps-hello.git
cd gitops-apps-hello
```
2. **Build and Push the Docker Image:**
(Replace `<your-docker-hub>` with your Docker Hub username)
```
docker build -t <your-docker-hub>/gitops-hello-app:v1 .
docker push <your-docker-hub>/gitops-hello-app:v1
```
3. **Deploy to Kubernetes:**
Update the image in `k8s/deployment.yaml` with your Docker Hub image.
`kubectl apply -f k8s/`

4. **Verify Deployment:**
Check the status of your deployment with:
`kubectl get all`

## Contributing

Contributions to this repository are welcome. To contribute:

1. Fork the repository.
2. Create a new branch for your feature (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

Project Link: [https://github.com/brainupgrade-in/gitops-apps-hello](https://github.com/brainupgrade-in/gitops-apps-hello)


# RBAC
```
kubectl create role jenkins -n jenkins --verb=create,list,get,watch,delete --resource=pods,pods/log,pods/exec,deploy,svc
kubectl create rolebinding jenkins -n jenkins --role=jenkins --serviceaccount=jenkins/default
```
