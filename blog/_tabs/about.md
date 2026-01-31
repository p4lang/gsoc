---
# the default layout is 'page'
icon: fas fa-info-circle
order: 4
---

---
layout: page
title: About the Site
permalink: /about/
---

## The P4-GSoC Preview Site

This website serves as the live preview and documentation hub for projects developed under the **P4-GSoC** initiative. 

### Technical Overview
The site is built using the **Chirpy Jekyll Theme** and is automatically deployed via **GitHub Actions**. 

* **Source Control**: Managed via the [P4 GSoC](https://github.com/p4lang/gsoc) repository.
* **Decentralized Content**: Posts are written in year-based directories (e.g., `/2024/`, `/2025/`) and injected into the Jekyll engine during the build process.
* **Asset Management**: To ensure cross-platform compatibility between the GitHub UI and the live site, we use **GitHub RAW links** for all diagrams and images.

### The Pipeline
Every time a change is pushed to the `main` branch, a CI/CD pipeline triggers the following steps:
1.  **Environment Setup**: Configures Ruby and Jekyll dependencies.
2.  **Post Injection**: Automatically moves decentralized markdown files into the `_posts` folder.
3.  **Build**: Compiles the markdown and assets into a static site.
4.  **Deployment**: Deploys the final artifact to GitHub Pages in under 30 seconds.

---

> **Note to Contributors**: If you are looking to add your own project updates, please refer to the **Wiki** for instructions on using the correct asset paths to prevent broken images.