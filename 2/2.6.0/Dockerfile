FROM bitnami/minideb:jessie

ENV DEV_VERSION 2.6.0
ENV INSTALL_DIR /home/tigergraph/tigergraph

# Copy resources
COPY ./resources/* /tmp/

RUN apt-get -qq update && \
  apt-get install -y --no-install-recommends curl vim iproute2 net-tools cron ntp locales tar uuid-runtime openssh-client openssh-server > /dev/null && \
  apt-get clean -y && \
  rm -Rf /var/lib/apt/lists/* /var/log/apt && \
  # Adding user and sudo
  useradd -ms /bin/bash tigergraph && \
  mkdir /var/run/sshd && \
  echo 'root:root' | chpasswd && \
  echo 'tigergraph:tigergraph' | chpasswd && \
  sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
  sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
  echo "tigergraph    ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers &&   apt-get clean -y && \
  curl -s -L http://dl.tigergraph.com/developer-edition/tigergraph-${DEV_VERSION}-developer.tar.gz \
    -o /home/tigergraph/tigergraph-dev.tar.gz && \
  /usr/sbin/sshd && \
  cd /home/tigergraph/ && \
  tar xfz tigergraph-dev.tar.gz && \
  rm -f tigergraph-dev.tar.gz && \
  # Remove original OS check 
  mv /tmp/os_utils /home/tigergraph/tigergraph-${DEV_VERSION}-developer/utils/os_utils && \
  mv /tmp/check_utils /home/tigergraph/tigergraph-${DEV_VERSION}-developer/utils/check_utils && \
  mv /tmp/install_conf.json /home/tigergraph/tigergraph-${DEV_VERSION}-developer && \
  # Preparing installation folders
  mkdir -p ${INSTALL_DIR} && \
  chown -R tigergraph:tigergraph ${INSTALL_DIR} && \
  mkdir /tmp/tigergraph_logs && \
  # Install
  cd /home/tigergraph/tigergraph-* && \
  ./install.sh -n && \
  # Original cleanups
  rm -fR /home/tigergraph/tigergraph-* && \
  rm -fR ${INSTALL_DIR}/dev/deploy_pkg && \
  rm -f ${INSTALL_DIR}/gium_prod.tar.gz && \
  rm -f ${INSTALL_DIR}/pkg_pool/tigergraph_*.tar.gz && \
  # Documentation cleanups
  rm -Rf ${INSTALL_DIR}/document/examples  && \
  rm -Rf ${INSTALL_DIR}/document/DEMO  && \
  rm -Rf ${INSTALL_DIR}/document/benchmark  && \
  rm -Rf ${INSTALL_DIR}/document/help  && \
  rm -Rf ${INSTALL_DIR}/dev/gdk/gsdk/visualization/* && \
  rm -Rf ${INSTALL_DIR}/dev/gdk/gsdk/document/examples  && \
  rm -Rf ${INSTALL_DIR}/dev/gdk/gsdk/document/DEMO  && \
  rm -Rf ${INSTALL_DIR}/dev/gdk/gsdk/document/benchmark  && \
  rm -Rf ${INSTALL_DIR}/dev/gdk/gsdk/document/help  && \
  rm -Rf ${INSTALL_DIR}/dev/gdk/gsdk/*.txt  && \
  # GUI cleanups
  rm -f ${INSTALL_DIR}/bin/gui/server/node_modules/tar/test/dir-normalization.tar && \
  rm -f ${INSTALL_DIR}/bin/gui/server/node_modules/tar-pack/test/fixtures/packed.tar && \
  rm -f ${INSTALL_DIR}/bin/gui/server/node_modules/tar-pack/test/fixtures/packed.tar.gz && \
  rm -f ${INSTALL_DIR}/bin/gui/server/node_modules/sqlite3/node_modules/tar/test/dir-normalization.tar && \
  rm -f ${INSTALL_DIR}/bin/gui/server/node_modules/sqlite3/node_modules/tar-pack/test/fixtures/packed.tar && \
  rm -f ${INSTALL_DIR}/gui/server/node_modules/sqlite3/node_modules/tar-pack/test/fixtures/packed.tar.gz && \
  rm -f ${INSTALL_DIR}/gui/server/node_modules/sqlite3/node_modules/extsprintf/Makefile.targ && \
  rm -f ${INSTALL_DIR}/bin/gui/server/node_modules/sqlite3/deps/sqlite-autoconf-3150000.tar.gz && \
  rm -f ${INSTALL_DIR}/bin/gui/server/node_modules/extsprintf/Makefile.targ && \
  rm -f ${INSTALL_DIR}/bin/gui/node/lib/node_modules/npm/node_modules/request/node_modules/http-signature/node_modules/jsprim/node_modules/extsprintf/Makefile.targ && \
  # Misc cleanups
  rm -Rf ${INSTALL_DIR}/.syspre/usr/share/man && \
  rm -Rf /usr/share/man/* && \
  rm -Rf /usr/share/i18n/charmaps/* && \
  rm -Rf ${INSTALL_DIR}/.syspre/usr/share/doc && \
  rm -Rf ${INSTALL_DIR}/.syspre/usr/lib/jvm/java-8-openjdk-amd64-1.8.0.171/jre/man && \
  rm -Rf ${INSTALL_DIR}/.syspre/usr/lib/jvm/java-8-openjdk-amd64-1.8.0.171/man && \
  rm -f /usr/share/info/*.gz && \
  rm -Rf /usr/share/doc && \
  rm -Rf /var/log/*  && \
  rm -Rf ${INSTALL_DIR}/log/* && \
  # Clean up temp files
  rm -Rf /tmp/* && \
  # Finalize image
  echo "export VISIBLE=now" >> /etc/profile && \
  echo "export USER=tigergraph" >> /home/tigergraph/.bash_tigergraph && \
  chown -R tigergraph:tigergraph /home/tigergraph && \
  su - tigergraph -c "/home/tigergraph/.gium/gadmin config-apply"

EXPOSE 22
EXPOSE 9000
EXPOSE 14240

ENTRYPOINT /usr/sbin/sshd && su - tigergraph bash -c "/home/tigergraph/.gium/gadmin start" && \
  if [ -n "$(ls -A /docker-entrypoint-initdb.d/ 2>/dev/null)" ]; then \
    for file in /docker-entrypoint-initdb.d/*.gsql; do \
      su - tigergraph bash -c "/home/tigergraph/tigergraph/app/cmd/gsql -f "$file"" || continue; \
    done \ 
  fi && \
  su - tigergraph bash -c "tail -f /home/tigergraph/tigergraph/logs/admin_server/gadmin_server.out"
