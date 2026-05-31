FROM mcr.microsoft.com/devcontainers/rust:1-1-bullseye

# Install required libusb dependencies and direnv for development
RUN sudo apt-get update && \
    sudo apt-get install -y libudev-dev libusb-1.0.0-dev direnv && \
    sudo rm -rf /var/lib/apt/lists/*

RUN echo 'eval "$(direnv hook bash)"' >> /home/vscode/.bashrc
