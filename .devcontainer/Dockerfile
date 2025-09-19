FROM mcr.microsoft.com/devcontainers/base:debian

ARG ZIG_VERSION
ARG MINISIGN_VERSION
RUN apt update && apt install -y qemu-system-riscv32 llvm lldb && rm -rf /var/lib/apt/lists/*
USER vscode
WORKDIR /home/vscode
ENV PATH="$PATH:/home/vscode/.local/bin"

ADD --chown=vscode:vscode --chmod=754 install-zig.sh install-zig.sh
RUN ./install-zig.sh ${ZIG_VERSION} ${MINISIGN_VERSION}
