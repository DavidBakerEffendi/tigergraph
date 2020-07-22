FROM bitnami/minideb:jessie

ENV DEV_VERSION 2.6.0

# Copy resources
COPY ./resources/os_utils /tmp/os_utils

RUN useradd -ms /bin/bash tigergraph && \
  apt-get -qq update && \
  apt-get install -y --no-install-recommends curl vim iproute2 net-tools cron ntp locales tar uuid-runtime openssh-client openssh-server > /dev/null && \
  mkdir /var/run/sshd && \
  echo 'root:root' | chpasswd && \
  echo 'tigergraph:tigergraph' | chpasswd && \
  sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
  sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
  curl -s -L http://dl.tigergraph.com/developer-edition/tigergraph-${DEV_VERSION}-developer.tar.gz \
    -o /home/tigergraph/tigergraph-dev.tar.gz && \
  cd /home/tigergraph/ && \
  tar xfz tigergraph-dev.tar.gz && \
  rm -f tigergraph-dev.tar.gz && \
  # Remove original OS check 
  rm /home/tigergraph/tigergraph-${DEV_VERSION}-developer/utils/os_utils && \
  mv /tmp/os_utils /home/tigergraph/tigergraph-${DEV_VERSION}-developer/utils/os_utils && \
  cd /home/tigergraph/tigergraph-* && \
  ./install.sh -n || : && \
  rm -fR /home/tigergraph/tigergraph-* && \
  rm -fR /home/tigergraph/tigergraph/dev/deploy_pkg && \
  rm -f /home/tigergraph/tigergraph/gium_prod.tar.gz && \
  rm -f /home/tigergraph/tigergraph/pkg_pool/tigergraph_*.tar.gz && \
  echo "export VISIBLE=now" >> /etc/profile && \
  echo "export USER=tigergraph" >> /home/tigergraph/.bash_tigergraph && \
  rm -f /home/tigergraph/.gsql_fcgi/RESTPP.socket.1 && \
  touch /home/tigergraph/.gsql_fcgi/RESTPP.socket.1 && \
  chmod 644 /home/tigergraph/.gsql_fcgi/RESTPP.socket.1 && \
  chown -R tigergraph:tigergraph /home/tigergraph && \
  su - tigergraph -c "/home/tigergraph/.gium/gadmin config-apply"

EXPOSE 22

ENTRYPOINT /usr/sbin/sshd && su - tigergraph bash -c "/home/tigergraph/.gium/gadmin start" && \
  if [ -n "$(ls -A /docker-entrypoint-initdb.d/ 2>/dev/null)" ]; then \
    for file in /docker-entrypoint-initdb.d/*.gsql; do \
      su - tigergraph bash -c "/home/tigergraph/tigergraph/app/cmd/gsql -f "$file"" || continue; \
    done \ 
  fi && \
  su - tigergraph bash -c "tail -f /home/tigergraph/tigergraph/log/admin/ADMIN.INFO"
