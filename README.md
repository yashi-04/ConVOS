# ConVOS: Containerized Virtual OS 

A lightweight, containerized virtual operating system environment built with Docker, providing an isolated and controlled environment for running applications and services.

## Project Synopsis

Containerized Virtual OS is a project that creates a minimal, secure, and isolated operating system environment using Docker containers. It provides a controlled environment with:

- Resource limits and constraints
- User management and authentication
- Custom environment configuration
- Isolated filesystem
- Basic system utilities and tools

The system is built on Alpine Linux for minimal footprint and maximum efficiency, making it ideal for development, testing, and running isolated applications.

## Features

- 🐳 Docker-based containerization
- 🔒 Resource isolation and limits
- 👤 User management system
- 🛠️ Customizable environment
- 📁 Isolated filesystem
- 🔧 Basic system utilities (bash, python3, nano, etc.)

## Project Structure

```
containerized-vos/
├── Dockerfile          # Container definition
├── setup.sh           # Main setup script
├── config/            # Configuration files
│   ├── environment.conf
│   ├── limits.conf
│   └── users.conf
├── scripts/           # System scripts
│   ├── init.sh
│   ├── login.sh
│   └── setup_environment.sh
└── fs/               # Filesystem templates
```

## Requirements

- Docker
- Bash shell
- At least 1GB of available RAM
- 1 CPU core

## Quick Start

🔹 Step 1: Clone the repository:
   ```bash
   git clone https://github.com/yashi-04/ConVOS.git
   cd containerized-vos
   ```

🔹 Step 2: Run the setup script:
   ```bash
   ./setup.sh
   ```

This will:
- Build the Docker image
- Start the container with default resource limits
- Provide an interactive shell

## Configuration

The system can be configured through various configuration files:

- `config/environment.conf`: Environment variables and settings
- `config/limits.conf`: Resource limits and constraints
- `config/users.conf`: User accounts and permissions

## Resource Limits

By default, the container runs with:
- 1 CPU core
- 1GB RAM
- Isolated network namespace

These limits can be modified in the `setup.sh` script or through Docker run parameters.

.

🔹 Step 3: Run the Setup Script (Optional)   
If setup.sh is meant to prepare your environment (e.g., download models or data), run:
      
bash 
Copy  
Edit  
`chmod +x setup.sh`
`./setup.sh   `
🔹 Step 4: Build the Docker Image  
bash  
Copy  
Edit  
`docker build -t convos-app`
This uses the Dockerfile to create an image named convos-app.

🔹 Step 5: Run the Container
bash  
Copy  
Edit  
`docker run -it --rm convos-app`   
You might need to map ports or mount volumes depending on the app's purpose. That info should be in the README.md or Dockerfile.   


`docker build -t vos:latest` 
`docker run -it --rm --name vos --cpus 1.0 --memory 1g --hostname vos-container vos:latest`

## License
MIT 

## Authors

* Shivam Rattan
* Yashi Sharma
* Divyansh Singh
* Ayush Mehendiratta
