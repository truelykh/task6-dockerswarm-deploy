package com.task6.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Task6Servlet - Main servlet for Task 6 Docker Swarm Deployment Demo
 *
 * This servlet demonstrates a Java web application successfully deployed
 * using the following DevOps pipeline:
 *   - Jenkins CI/CD Pipeline
 *   - Nexus Repository (image storage)
 *   - Docker Swarm (orchestration)
 *   - Apache Tomcat (container runtime)
 */
@WebServlet(name = "Task6Servlet", urlPatterns = {"/", "/home"})
public class Task6Servlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Build deployment metadata
        String deploymentTime = LocalDateTime.now()
                .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

        String serverInfo   = getServletContext().getServerInfo();
        String javaVersion  = System.getProperty("java.version");
        String hostname     = System.getenv().getOrDefault("HOSTNAME", "docker-swarm-node");
        String swarmService    = System.getenv().getOrDefault("SWARM_SERVICE_NAME", "task6_app");
        // Nexus: WAR artifacts repo
        String nexusMavenRepo  = System.getenv().getOrDefault("NEXUS_MAVEN_REPO_URL",
                                    "http://nexus:8081/repository/maven-swarm/");
        // Nexus: Docker images repo
        String nexusDockerRepo = System.getenv().getOrDefault("NEXUS_DOCKER_REPO_URL",
                                    "http://nexus:8081/repository/dockerswarm/");

        // Pass attributes to JSP
        request.setAttribute("deploymentTime", deploymentTime);
        request.setAttribute("serverInfo",     serverInfo);
        request.setAttribute("javaVersion",    javaVersion);
        request.setAttribute("hostname",       hostname);
        request.setAttribute("swarmService",   swarmService);
        request.setAttribute("nexusMavenRepo",  nexusMavenRepo);
        request.setAttribute("nexusDockerRepo", nexusDockerRepo);

        // Forward to the JSP view
        request.getRequestDispatcher("/WEB-INF/views/index.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
