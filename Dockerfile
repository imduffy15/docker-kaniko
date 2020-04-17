FROM gcr.io/kaniko-project/executor:debug

RUN [ "sh", "-c", "mkdir -p /root; mkdir -p /bin; ln -s /busybox/sh /bin/sh" ]
