FROM golang:1.16

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh

# Install Docker
RUN curl -fsSL https://get.docker.com/ | sh

# Install Dapr CLI
RUN wget -q https://raw.githubusercontent.com/dapr/cli/master/install/install.sh -O - | /bin/bash

# Install Delve for Debugging
RUN go install github.com/go-delve/delve/cmd/dlv@latest

# Install golangci-lint
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b /go/bin v1.38.0

# Clone the dapr repos
WORKDIR /go/src

# Clone dapr
RUN mkdir -p github.com/dapr/dapr
RUN git clone https://github.com/dapr/dapr.git github.com/dapr/dapr

# Clone component-contrib
RUN mkdir -p github.com/dapr/components-contrib
RUN git clone https://github.com/dapr/components-contrib.git github.com/dapr/components-contrib

WORKDIR /go/src/github.com/dapr

COPY . .
RUN chmod u+x pull

WORKDIR /go/src/github.com/dapr/components-contrib