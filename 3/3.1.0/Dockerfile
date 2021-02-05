FROM bitnami/minideb:jessie

ENV VERSION 3.1.0
ENV INSTALL_DIR /home/tigergraph
ENV DOWNL_URL http://dl.tigergraph.com/enterprise-edition/tigergraph-${VERSION}-offline.tar.gz 

# Copy resources
COPY ./resources/* /tmp/

RUN apt-get -qq update && \
  apt-get install -y --no-install-recommends sudo curl vim iproute2 net-tools cron ntp locales tar uuid-runtime openssh-client openssh-server > /dev/null && \
  apt-get clean -y && \
  rm -Rf /var/lib/apt/lists/* /var/cache/apt/archives /var/log/apt && \
  # Adding user and sudo
  useradd -ms /bin/bash tigergraph && \
  mkdir /var/run/sshd && \
  echo 'root:root' | chpasswd && \
  echo 'tigergraph:tigergraph' | chpasswd && \
  sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
  sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
  echo "tigergraph    ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers && \
  # preparing installation file
  /usr/sbin/sshd && \
  cd /home/tigergraph/ && \
  curl -s -L $DOWNL_URL -o /home/tigergraph/tigergraph-ent.tar.gz && \
  tar xfz tigergraph-ent.tar.gz && \
  rm -f tigergraph-ent.tar.gz && \
  # Tweak original OS check and config
  mv /tmp/os_utils /home/tigergraph/tigergraph-${VERSION}-offline/utils/os_utils && \
  mv /tmp/check_utils /home/tigergraph/tigergraph-${VERSION}-offline/utils/check_utils && \
  mv /tmp/install_conf.json /home/tigergraph/tigergraph-${VERSION}-offline && \
  # Preparing installation folders
  mkdir -p ${INSTALL_DIR} && \
  chown -R tigergraph:tigergraph ${INSTALL_DIR} && \
  mkdir /tmp/tigergraph_logs
  # Install
RUN  cd /home/tigergraph/tigergraph-* && \
  ./install.sh -n
  # Stop gadmin
RUN ls ${INSTALL_DIR}/app/ && \
  su - tigergraph -c "${INSTALL_DIR}/app/${VERSION}-offline/cmd/gadmin stop all -y"
  # Original cleanups
RUN rm -fR /home/tigergraph/tigergraph-* && \
  rm -fR ${INSTALL_DIR}/app/${VERSION}/syspre_pkg && \
  rm -f ${INSTALL_DIR}/gium_prod.tar.gz && \
  rm -f ${INSTALL_DIR}/pkg_pool/tigergraph_*.tar.gz && \
  # Documentation cleanups
  rm -Rf ${INSTALL_DIR}/app/${VERSION}/document/examples  && \
  rm -Rf ${INSTALL_DIR}/app/${VERSION}/document/DEMO  && \
  rm -Rf ${INSTALL_DIR}/app/${VERSION}/document/benchmark  && \
  rm -Rf ${INSTALL_DIR}/app/${VERSION}/document/help  && \
  rm -Rf ${INSTALL_DIR}/app/${VERSION}/dev/gdk/gsdk/visualization/* && \
  rm -Rf ${INSTALL_DIR}/app/${VERSION}/dev/gdk/gsdk/document/examples  && \
  rm -Rf ${INSTALL_DIR}/app/${VERSION}/dev/gdk/gsdk/document/DEMO  && \
  rm -Rf ${INSTALL_DIR}/app/${VERSION}/dev/gdk/gsdk/document/benchmark  && \
  rm -Rf ${INSTALL_DIR}/app/${VERSION}/dev/gdk/gsdk/document/help  && \
  rm -Rf ${INSTALL_DIR}/app/${VERSION}/dev/gdk/gsdk/*.txt  && \
  # GUI cleanups
  rm -f ${INSTALL_DIR}/app/${VERSION}/bin/gui/server/node_modules/tar/test/dir-normalization.tar && \
  rm -f ${INSTALL_DIR}/app/${VERSION}/bin/gui/server/node_modules/tar-pack/test/fixtures/packed.tar && \
  rm -f ${INSTALL_DIR}/app/${VERSION}/bin/gui/server/node_modules/tar-pack/test/fixtures/packed.tar.gz && \
  rm -f ${INSTALL_DIR}/app/${VERSION}/bin/gui/server/node_modules/sqlite3/node_modules/tar/test/dir-normalization.tar && \
  rm -f ${INSTALL_DIR}/app/${VERSION}/bin/gui/server/node_modules/sqlite3/node_modules/tar-pack/test/fixtures/packed.tar && \
  rm -f ${INSTALL_DIR}/app/${VERSION}/gui/server/node_modules/sqlite3/node_modules/tar-pack/test/fixtures/packed.tar.gz && \
  rm -f ${INSTALL_DIR}/app/${VERSION}/gui/server/node_modules/sqlite3/node_modules/extsprintf/Makefile.targ && \
  rm -f ${INSTALL_DIR}/app/${VERSION}/bin/gui/server/node_modules/sqlite3/deps/sqlite-autoconf-3150000.tar.gz && \
  rm -f ${INSTALL_DIR}/app/${VERSION}/bin/gui/server/node_modules/extsprintf/Makefile.targ && \
  rm -f ${INSTALL_DIR}/app/${VERSION}/bin/gui/node/lib/node_modules/npm/node_modules/request/node_modules/http-signature/node_modules/jsprim/node_modules/extsprintf/Makefile.targ && \
  # Misc cleanups
  rm -Rf ${INSTALL_DIR}/app/${VERSION}/.syspre/usr/share/man && \
  rm -Rf /usr/share/man/* && \
  rm -Rf /usr/share/i18n/charmaps/* && \
  rm -Rf ${INSTALL_DIR}/app/${VERSION}/.syspre/usr/share/doc && \
  rm -Rf ${INSTALL_DIR}/app/${VERSION}/.syspre/usr/lib/jvm/java-8-openjdk-amd64-1.8.0.171/jre/man && \
  rm -Rf ${INSTALL_DIR}/app/${VERSION}/.syspre/usr/lib/jvm/java-8-openjdk-amd64-1.8.0.171/man && \
  rm -f /usr/share/info/*.gz && \
  rm -Rf /usr/share/doc && \
  rm -Rf /var/log/*  && \
  rm -Rf ${INSTALL_DIR}/log/*  && \
  # Checking image
  mv /tmp/checkimage.sh ${INSTALL_DIR} && \
  chmod 755 ${INSTALL_DIR}/checkimage.sh && \
  tar czfh ${INSTALL_DIR}/tmp/initdata.tgz -C ${INSTALL_DIR}/data . && \
  # Clean up temp files
  rm -Rf /tmp/* 
  # OPTIMIZE files & folders
RUN cd ${INSTALL_DIR}/app/${VERSION}/bin/ && \
  rm -f libprofiler.so.0 libprofiler.so.0.4.18 libtcmalloc.so.4 libtcmalloc.so.4.5.3 libtigergraph.so tg_shadower && \
  ln -s libprofiler.so libprofiler.so.0 && \
  ln -s libprofiler.so libprofiler.so.0.4.18 && \
  ln -s libtcmalloc.so libtcmalloc.so.4 && \
  ln -s libtcmalloc.so libtcmalloc.so.4.5.3 && \
  ln -s ../dev/gdk/gsdk/lib/tg_${VERSION}_dev/libtigergraph.so . && \
  ln -s ../../../app/cmd/.tg_shadower tg_shadower && \
  cd ${INSTALL_DIR}/app/${VERSION}/.syspre/usr/lib/x86_64-linux-gnu/dri/ && \
  rm -f r200_dri.so nouveau_vieux_dri.so i965_dri.so i915_dri.so && \
  ln -s radeon_dri.so r200_dri.so && \
  ln -s radeon_dri.so nouveau_vieux_dri.so && \
  ln -s radeon_dri.so i965_dri.so && \
  ln -s radeon_dri.so i915_dri.so && \
  cd ${INSTALL_DIR}/app/${VERSION}/zk/lib/ && \
  rm -f log4j-1.2.17.jar && \
  ln -s ../../kafka/libs/log4j-1.2.17.jar . && \
  # Finalize image
  echo "export VISIBLE=now" >> /etc/profile && \
  echo "export USER=tigergraph" >> /home/tigergraph/.bash_tigergraph && \
  chown -R tigergraph:tigergraph /home/tigergraph && \
  chown -R tigergraph:tigergraph ${INSTALL_DIR} && \
  mkdir /docker-entrypoint-initdb.d

EXPOSE 22
EXPOSE 9000
EXPOSE 14240

ENTRYPOINT /usr/sbin/sshd && ${INSTALL_DIR}/checkimage.sh && su - tigergraph bash -c "/home/tigergraph/tigergraph/app/cmd/gadmin start all" && \
  if [ -n "$(ls -A /docker-entrypoint-initdb.d/ 2>/dev/null)" ]; then \
    for file in /docker-entrypoint-initdb.d/*.gsql; do \
      su - tigergraph bash -c "/home/tigergraph/tigergraph/app/cmd/gsql -f "$file"" || continue; \
    done \ 
  fi && \
  su - tigergraph bash -c "tail -f /home/tigergraph/tigergraph/log/admin/ADMIN.INFO"
