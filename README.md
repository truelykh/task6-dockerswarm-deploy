# Task 6 – Docker Swarm Deployment
## Java Web Application

> **Successfully completed and deployed using Docker Swarm.**  
> Images stored in **Nexus Repository**, built and pushed via **Jenkins Pipelines**, running in **Apache Tomcat** container.

---

## 📁 Project Structure

```
Task 6 - dockerswarm - deploy/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/task6/servlet/
│       │       └── Task6Servlet.java      # Main servlet
│       └── webapp/
│           └── WEB-INF/
│               ├── views/
│               │   └── index.jsp          # Landing page (JSP)
│               └── web.xml                # Deployment descriptor
├── Dockerfile                             # Tomcat 9 / JDK 11 image
├── docker-compose.yml                     # Docker Swarm stack (3 replicas)
├── Jenkinsfile                            # CI/CD declarative pipeline
├── pom.xml                                # Maven build config + Nexus dist.mgmt
└── README.md
```

---

## 🛠 Tech Stack

| Layer          | Technology                         |
|----------------|------------------------------------|
| Language       | Java 11                            |
| Framework      | Java Servlet API + JSP             |
| Build Tool     | Apache Maven 3.8                   |
| Container      | Apache Tomcat 9 (Docker)           |
| Image Registry | Sonatype Nexus Repository          |
| CI/CD          | Jenkins Declarative Pipeline       |
| Orchestration  | Docker Swarm (3 replicas)          |

---

## 🚀 Quick Start

### 1. Build the WAR
```bash
mvn clean package
```

### 2. Build the Docker Image
```bash
docker build -t task6-app:1.0.0 .
```

### 3. Tag & Push to Nexus
```bash
docker tag task6-app:1.0.0 nexus:8081/repository/docker-hosted/task6-app:1.0.0
docker push nexus:8081/repository/docker-hosted/task6-app:1.0.0
```

### 4. Deploy to Docker Swarm
```bash
# Initialise Swarm (if not already)
docker swarm init

# Deploy the stack
docker stack deploy -c docker-compose.yml task6

# Verify services
docker service ls
docker service ps task6_app
```

### 5. Access the App
```
http://<swarm-manager-ip>:8080/
```

---

## 🔄 CI/CD Pipeline Stages

```
Checkout → Build (Maven) → Test → Docker Build → Push to Nexus → Deploy to Swarm
```

### Jenkins Setup

1. Create a **Pipeline** job in Jenkins.
2. Point it to this repository (SCM).
3. Add the following credentials:
   - `nexus-docker-credentials` – Nexus username/password
   - `swarm-manager-ssh`        – SSH private key for Swarm manager node

---

## 🌐 Swarm Service Details

| Parameter      | Value            |
|----------------|------------------|
| Stack Name     | `task6`          |
| Service Name   | `task6_app`      |
| Replicas       | 3                |
| Published Port | 8080             |
| Network        | `task6-net` (overlay) |
| Update Policy  | Rolling (1 at a time, start-first) |
| Rollback       | Automatic on failure |

---

## 📦 Nexus Repository

- **Type**: Docker Hosted Repository  
- **URL**: `http://nexus:8081/repository/docker-hosted/`  
- **Image**: `task6-app:<BUILD_NUMBER>`

---

*Task 6 – Successfully Completed ✅*
