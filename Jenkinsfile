pipeline {
    agent any

    environment {
        NEXUS_URL         = 'http://nexus:8081'
        NEXUS_REGISTRY   = 'nexus:8081'
        NEXUS_DOCKER_REPO = 'dockerswarm'
        IMAGE_NAME        = 'task6-app'
        IMAGE_TAG         = "${env.BUILD_NUMBER}"
        FULL_IMAGE        = "${NEXUS_REGISTRY}/repository/${NEXUS_DOCKER_REPO}/${IMAGE_NAME}:${IMAGE_TAG}"
        SWARM_STACK       = 'task6'
        NEXUS_CREDS       = 'nexus_credentials'
        SWARM_SSH_CREDS   = 'swarm-manager-ssh'
        SWARM_MANAGER_IP  = 'swarm-manager'
        DOCKER            = '/usr/local/bin/docker'
        DOCKER_CFG        = '/tmp/docker-cfg'
        DOCKER_BUILDKIT   = '0'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${NEXUS_CREDS}", usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {
                    sh """
                        mkdir -p ${DOCKER_CFG}
                        echo '{"auths":{}}' > ${DOCKER_CFG}/config.json

                        DOCKER_CONFIG=${DOCKER_CFG} ${DOCKER} build \\
                            --add-host nexus:host-gateway \\
                            --build-arg NEXUS_USER=\$NEXUS_USER \\
                            --build-arg NEXUS_PASS=\$NEXUS_PASS \\
                            -t ${FULL_IMAGE} .

                        echo \$NEXUS_PASS | DOCKER_TLS_VERIFY=0 DOCKER_CONFIG=${DOCKER_CFG} ${DOCKER} login ${NEXUS_REGISTRY} -u \$NEXUS_USER --password-stdin
                        DOCKER_CONFIG=${DOCKER_CFG} ${DOCKER} push ${FULL_IMAGE}
                        DOCKER_TLS_VERIFY=0 DOCKER_CONFIG=${DOCKER_CFG} ${DOCKER} logout ${NEXUS_REGISTRY}
                        rm -rf ${DOCKER_CFG}
                    """
                }
            }
        }

        stage('Deploy') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: "${SWARM_SSH_CREDS}", keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
                    sh """
                        export IMAGE_TAG=${IMAGE_TAG}
                        envsubst < docker-compose.yml > stack.yml

                        scp -i \$SSH_KEY -o StrictHostKeyChecking=no stack.yml \${SSH_USER}@${SWARM_MANAGER_IP}:/tmp/task6-stack.yml
                        ssh -i \$SSH_KEY -o StrictHostKeyChecking=no \${SSH_USER}@${SWARM_MANAGER_IP} \\
                            "docker stack deploy -c /tmp/task6-stack.yml ${SWARM_STACK} --with-registry-auth"
                    """
                }
            }
        }
    }

    post {
        always { cleanWs() }
    }
}
