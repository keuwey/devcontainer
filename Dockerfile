# Base da imagem
FROM archlinux:latest

# Atualizar pacotes e instalar ferramentas essenciais
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

# Configurar usuário root com senha definida
RUN echo "root:2wk@7n,./" | chpasswd

# Criar usuário para desenvolvimento
RUN mkdir -p /home/dev-container \
    && useradd -m keuwey \
    && chown keuwey:keuwey /home/dev-container

# Instalar o .NET
RUN curl -fsSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --install-dir /usr/share/dotnet \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Configurar ambiente virtual para Python
RUN python -m venv /home/dev-container/.venv \
    && /home/dev-container/.venv/bin/pip install --no-cache-dir --upgrade pip setuptools \
    && /home/dev-container/.venv/bin/pip install ruff mypy uv \
    && npm install -g pyright

# Configurar PATH para incluir ferramentas adicionais
ENV PATH="/usr/share/dotnet:/home/dev-container/.venv/bin:${PATH}"

# Definir volume e diretório de trabalho
VOLUME ["/home/dev-container"]
WORKDIR /home/dev-container

# Mudar para o usuário de desenvolvimento
USER keuwey

# Comando padrão
CMD ["/bin/bash"]
