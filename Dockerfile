FROM alpine:latest

ARG VCS_REF
ARG BUILD_DATE

ENV KUBE_LATEST_VERSION="v1.22.2"
ENV HELM_VERSION="v3.7.1"
ENV FILENAME="helm-${HELM_VERSION}-linux-amd64.tar.gz"

RUN apk add --update ca-certificates -t deps curl bash tar

RUN curl -s -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

RUN curl -s -L https://get.helm.sh/${FILENAME} -o /tmp/${FILENAME} \
    && tar -zxvf /tmp/${FILENAME} -C /tmp \
    && mv /tmp/linux-amd64/helm /bin/helm

COPY update_workload.sh /bin/
RUN chmod +x /bin/update_workload.sh

ENTRYPOINT ["/bin/sh", "-l", "-c"]
CMD ["/bin/update_workload.sh"]