# Etapa base para instalar ferramentas necessárias
FROM archlinux:latest AS base

# Atualizar repositórios e instalar pacotes essenciais
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
    && pacman -Scc --noconfirm

# Criar e configurar o ambiente virtual para Python
RUN python -m venv /home/dev-container/venv \
    && source /home/dev-container/venv/bin/activate \
    && pip install --no-cache-dir --upgrade pip setuptools

# Instalar .NET e C#
RUN curl -fsSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --install-dir /usr/share/dotnet \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Adicionar usuário para desenvolvimento
RUN mkdir -p /home/dev-container && useradd -m keuwey && chown keuwey /home/dev-container
USER keuwey

# Etapa final para reduzir o tamanho da imagem
FROM archlinux:latest

# Copiar as ferramentas do estágio base
COPY --from=base /usr /usr
COPY --from=base /bin /bin
COPY --from=base /lib /lib
COPY --from=base /sbin /sbin
COPY --from=base /etc /etc
COPY --from=base /home /home

# Configurar ponto de montagem para o volume
VOLUME ["/home/dev-container"]

# Configurar diretório padrão ao iniciar o container
WORKDIR /home/dev-container

# Comando padrão ao iniciar o container
CMD ["/bin/bash"]
