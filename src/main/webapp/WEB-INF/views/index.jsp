<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.time.LocalDateTime" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="Task 6 - Java App successfully deployed using Docker Swarm, Nexus Repository, Jenkins Pipeline, and Apache Tomcat" />
    <title>Task 6 | Docker Swarm Deployment</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800;900&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet" />
    <style>
        /* ====== CSS Reset & Design Tokens ====== */
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --bg-dark:       #0a0e1a;
            --bg-card:       rgba(255,255,255,0.04);
            --bg-card-hover: rgba(255,255,255,0.08);
            --border:        rgba(255,255,255,0.10);
            --border-accent: rgba(99,179,237,0.40);

            --green:  #48bb78;
            --blue:   #63b3ed;
            --purple: #9f7aea;
            --orange: #ed8936;
            --cyan:   #4fd1c5;
            --red:    #fc8181;

            --text-primary:   #f0f4ff;
            --text-secondary: #a0aec0;
            --text-muted:     #718096;

            --gradient-hero: linear-gradient(135deg, #0a0e1a 0%, #0d1b2e 50%, #0a0e1a 100%);
            --gradient-success: linear-gradient(135deg, #1a4731, #22543d);
            --gradient-blue:  linear-gradient(135deg, #1a365d, #2a4a7f);
            --gradient-glow:  linear-gradient(90deg, var(--blue), var(--purple), var(--cyan));

            --radius-sm: 8px;
            --radius-md: 16px;
            --radius-lg: 24px;
            --radius-xl: 32px;

            --shadow-card: 0 4px 24px rgba(0,0,0,0.4);
            --shadow-glow: 0 0 60px rgba(99,179,237,0.12);
        }

        /* ====== Base ====== */
        html { scroll-behavior: smooth; }

        body {
            font-family: 'Inter', system-ui, sans-serif;
            background: var(--bg-dark);
            color: var(--text-primary);
            min-height: 100vh;
            overflow-x: hidden;
            line-height: 1.6;
        }

        /* ====== Animated Background ====== */
        .bg-orbs {
            position: fixed; inset: 0; z-index: 0; pointer-events: none;
            overflow: hidden;
        }
        .orb {
            position: absolute; border-radius: 50%;
            filter: blur(80px); opacity: 0.18;
            animation: drift 20s ease-in-out infinite alternate;
        }
        .orb-1 { width: 600px; height: 600px; top: -200px; left: -200px; background: var(--blue); animation-duration: 18s; }
        .orb-2 { width: 500px; height: 500px; bottom: -150px; right: -150px; background: var(--purple); animation-duration: 22s; animation-delay: -8s; }
        .orb-3 { width: 400px; height: 400px; top: 40%; left: 50%; background: var(--cyan); animation-duration: 25s; animation-delay: -5s; }

        @keyframes drift {
            from { transform: translate(0, 0) scale(1); }
            to   { transform: translate(40px, 30px) scale(1.08); }
        }

        /* ====== Layout ====== */
        .container {
            position: relative; z-index: 1;
            max-width: 1100px;
            margin: 0 auto;
            padding: 0 24px;
        }

        /* ====== Header / Hero ====== */
        .hero {
            text-align: center;
            padding: 80px 24px 60px;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(72, 187, 120, 0.15);
            border: 1px solid rgba(72, 187, 120, 0.35);
            color: var(--green);
            padding: 8px 20px;
            border-radius: 100px;
            font-size: 0.82rem;
            font-weight: 600;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            margin-bottom: 32px;
        }

        .pulse-dot {
            width: 8px; height: 8px;
            background: var(--green);
            border-radius: 50%;
            animation: pulse 1.8s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; transform: scale(1); }
            50%       { opacity: 0.4; transform: scale(0.7); }
        }

        .hero-task {
            font-size: clamp(0.85rem, 2vw, 1rem);
            font-weight: 600;
            letter-spacing: 0.2em;
            text-transform: uppercase;
            background: var(--gradient-glow);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 16px;
        }

        .hero-title {
            font-size: clamp(2.2rem, 5vw, 3.8rem);
            font-weight: 900;
            line-height: 1.1;
            letter-spacing: -0.03em;
            margin-bottom: 24px;
        }

        .hero-title .highlight {
            background: var(--gradient-glow);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .hero-message {
            font-size: clamp(1rem, 2.5vw, 1.2rem);
            color: var(--text-secondary);
            max-width: 680px;
            margin: 0 auto 48px;
            font-weight: 400;
        }

        /* ====== Cards Grid ====== */
        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
            margin-bottom: 48px;
        }

        .card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 28px 24px;
            transition: transform 0.25s ease, background 0.25s ease, border-color 0.25s ease, box-shadow 0.25s ease;
            cursor: default;
        }

        .card:hover {
            transform: translateY(-4px);
            background: var(--bg-card-hover);
            border-color: var(--border-accent);
            box-shadow: var(--shadow-glow);
        }

        .card-icon {
            font-size: 2rem;
            margin-bottom: 16px;
            display: block;
        }

        .card-label {
            font-size: 0.75rem;
            font-weight: 600;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            color: var(--text-muted);
            margin-bottom: 6px;
        }

        .card-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 8px;
        }

        .card-desc {
            font-size: 0.87rem;
            color: var(--text-secondary);
        }

        /* Color accents per card */
        .card-swarm   { border-top: 3px solid var(--blue); }
        .card-nexus   { border-top: 3px solid var(--orange); }
        .card-jenkins { border-top: 3px solid var(--red); }
        .card-tomcat  { border-top: 3px solid var(--green); }

        /* ====== Info Panel ====== */
        .info-panel {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 40px;
            margin-bottom: 48px;
        }

        .info-panel h2 {
            font-size: 1.4rem;
            font-weight: 700;
            margin-bottom: 28px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .info-table {
            width: 100%;
            border-collapse: collapse;
        }

        .info-table tr + tr td { border-top: 1px solid var(--border); }

        .info-table td {
            padding: 14px 0;
            font-size: 0.92rem;
        }

        .info-table td:first-child {
            color: var(--text-muted);
            font-weight: 500;
            width: 200px;
            padding-right: 24px;
        }

        .info-table td:last-child {
            font-family: 'JetBrains Mono', monospace;
            color: var(--text-primary);
            font-size: 0.85rem;
        }

        .badge-ok {
            display: inline-block;
            background: rgba(72, 187, 120, 0.15);
            color: var(--green);
            border: 1px solid rgba(72, 187, 120, 0.3);
            border-radius: 6px;
            padding: 2px 10px;
            font-size: 0.78rem;
            font-weight: 600;
            margin-left: 10px;
        }

        /* ====== Pipeline Steps ====== */
        .pipeline {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 40px;
            margin-bottom: 48px;
        }

        .pipeline h2 {
            font-size: 1.4rem;
            font-weight: 700;
            margin-bottom: 32px;
        }

        .pipeline-steps {
            display: flex;
            align-items: flex-start;
            gap: 0;
            flex-wrap: wrap;
        }

        .step {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            flex: 1;
            min-width: 120px;
            position: relative;
        }

        .step:not(:last-child)::after {
            content: '';
            position: absolute;
            top: 22px;
            right: -50%;
            width: 100%;
            height: 2px;
            background: linear-gradient(90deg, var(--blue), var(--purple));
            opacity: 0.5;
        }

        .step-circle {
            width: 44px; height: 44px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            margin-bottom: 10px;
            border: 2px solid var(--border-accent);
            background: rgba(99,179,237,0.1);
            position: relative; z-index: 1;
            animation: stepGlow 3s ease-in-out infinite;
        }

        @keyframes stepGlow {
            0%, 100% { box-shadow: 0 0 0 0 rgba(99,179,237,0.3); }
            50%       { box-shadow: 0 0 0 8px rgba(99,179,237,0); }
        }

        .step-name {
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 4px;
        }

        .step-sub {
            font-size: 0.72rem;
            color: var(--text-muted);
        }

        /* ====== Footer ====== */
        .footer {
            text-align: center;
            padding: 40px 24px;
            color: var(--text-muted);
            font-size: 0.84rem;
            border-top: 1px solid var(--border);
        }

        .footer strong { color: var(--text-secondary); }

        /* ====== Responsive ====== */
        @media (max-width: 640px) {
            .info-panel, .pipeline { padding: 24px; }
            .step:not(:last-child)::after { display: none; }
            .pipeline-steps { flex-direction: column; gap: 20px; }
        }
    </style>
</head>
<body>

<!-- Animated Background Orbs -->
<div class="bg-orbs">
    <div class="orb orb-1"></div>
    <div class="orb orb-2"></div>
    <div class="orb orb-3"></div>
</div>

<!-- ===================== HERO ===================== -->
<div class="container">
    <section class="hero" id="hero">
        <div class="status-badge">
            <span class="pulse-dot"></span>
            Deployed &amp; Running
        </div>

        <p class="hero-task">Task 6 &mdash; Docker Swarm Deployment</p>

        <h1 class="hero-title">
            Successfully <span class="highlight">Completed</span><br/>
            &amp; Deployed
        </h1>

        <p class="hero-message">
            Task 6 has been <strong>successfully completed and deployed using Docker Swarm</strong>.
            Docker images were stored in the <strong>Nexus Repository</strong>,
            built and pushed via <strong>Jenkins Pipelines</strong>,
            and are running inside an <strong>Apache Tomcat container</strong>.
        </p>
    </section>

    <!-- ===================== TECH CARDS ===================== -->
    <section class="cards-grid" id="tech-stack">

        <div class="card card-swarm">
            <span class="card-icon">🐳</span>
            <p class="card-label">Orchestration</p>
            <p class="card-title">Docker Swarm</p>
            <p class="card-desc">Multi-node container orchestration with rolling updates and service scaling.</p>
        </div>

        <div class="card card-nexus">
            <span class="card-icon">📦</span>
            <p class="card-label">Image Registry</p>
            <p class="card-title">Nexus Repository</p>
            <p class="card-desc">Docker images versioned and stored in Sonatype Nexus private registry.</p>
        </div>

        <div class="card card-jenkins">
            <span class="card-icon">⚙️</span>
            <p class="card-label">CI / CD</p>
            <p class="card-title">Jenkins Pipeline</p>
            <p class="card-desc">Automated build, test, push, and deploy stages via Declarative Jenkinsfile.</p>
        </div>

        <div class="card card-tomcat">
            <span class="card-icon">🚀</span>
            <p class="card-label">Runtime</p>
            <p class="card-title">Apache Tomcat</p>
            <p class="card-desc">WAR file deployed inside a Tomcat 9 container serving this Java web app.</p>
        </div>

    </section>

    <!-- ===================== RUNTIME INFO ===================== -->
    <section class="info-panel" id="runtime-info">
        <h2>⚡ Deployment Info</h2>
        <table class="info-table">
            <tr>
                <td>Application</td>
                <td>task6-dockerswarm-app v1.0.0 <span class="badge-ok">LIVE</span></td>
            </tr>
            <tr>
                <td>Server</td>
                <td>${serverInfo}</td>
            </tr>
            <tr>
                <td>Java Version</td>
                <td>${javaVersion}</td>
            </tr>
            <tr>
                <td>Container Host</td>
                <td>${hostname}</td>
            </tr>
            <tr>
                <td>Swarm Service</td>
                <td>${swarmService}</td>
            </tr>
            <tr>
                <td>Nexus – WAR Artifacts</td>
                <td>${nexusMavenRepo}</td>
            </tr>
            <tr>
                <td>Nexus – Docker Images</td>
                <td>${nexusDockerRepo}</td>
            </tr>
            <tr>
                <td>Deployment Time</td>
                <td>${deploymentTime}</td>
            </tr>
        </table>
    </section>

    <!-- ===================== PIPELINE STEPS ===================== -->
    <section class="pipeline" id="pipeline">
        <h2>🔄 CI/CD Pipeline Stages</h2>
        <div class="pipeline-steps">
            <div class="step">
                <div class="step-circle">📥</div>
                <p class="step-name">Checkout</p>
                <p class="step-sub">Git SCM</p>
            </div>
            <div class="step">
                <div class="step-circle">🔨</div>
                <p class="step-name">Build</p>
                <p class="step-sub">Maven Package</p>
            </div>
            <div class="step">
                <div class="step-circle">🧪</div>
                <p class="step-name">Test</p>
                <p class="step-sub">Unit Tests</p>
            </div>
            <div class="step">
                <div class="step-circle">🐳</div>
                <p class="step-name">Docker Build</p>
                <p class="step-sub">Image Build</p>
            </div>
            <div class="step">
                <div class="step-circle">📦</div>
                <p class="step-name">Push Nexus</p>
                <p class="step-sub">Registry Upload</p>
            </div>
            <div class="step">
                <div class="step-circle">🚀</div>
                <p class="step-name">Swarm Deploy</p>
                <p class="step-sub">Service Update</p>
            </div>
        </div>
    </section>
</div>

<!-- ===================== FOOTER ===================== -->
<footer class="footer">
    <p>
        <strong>Task 6</strong> &mdash; Successfully Completed &amp; Deployed &nbsp;|&nbsp;
        Docker Swarm &bull; Nexus Repository &bull; Jenkins Pipeline &bull; Tomcat Container
    </p>
    <p style="margin-top:8px;color:#4a5568;">
        &copy; 2026 &mdash; Rakesh &nbsp;&middot;&nbsp; Java Web Application
    </p>
</footer>

</body>
</html>
