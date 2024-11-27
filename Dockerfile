FROM archlinux:latest AS base

RUN pacman -Syu --noconfirm \
    bash \
    vim \
    nano \
    curl \
    wget \
    git \
    python \
    python-pip \
    nodejs \
    npm \
    jdk-openjdk \
    mariadb \
    postgresql \
    shadow \
    && pacman -Scc --noconfirm

# Create root user with defined password
RUN echo "root:2wk@7n,./" | chpasswd

# Add a user for development
RUN mkdir -p /home/dev-container && useradd -m keuwey && chown keuwey /home/dev-container
USER keuwey

# Install .NET and C#
RUN curl -fsSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --install-dir /usr/share/dotnet \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Create and configure the virtual environment for Python
RUN python -m venv /home/dev-container/.venv \
    && source /home/dev-container/.venv/bin/activate \
    && pip install --no-cache-dir --upgrade pip setuptools \
    && pip install ruff mypy uv \
    && npm install -g pyright

# Final step to reduce image size
FROM archlinux:latest
COPY --from=base /usr /usr
COPY --from=base /bin /bin
COPY --from=base /lib /lib
COPY --from=base /sbin /sbin
COPY --from=base /etc /etc
COPY --from=base /home /home
VOLUME ["/home/dev-container"]
WORKDIR /home/dev-container

CMD ["/bin/bash"]
