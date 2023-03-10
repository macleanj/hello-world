FROM nginxinc/nginx-unprivileged:1.18-alpine

LABEL maintainer="Jerome Mac Lean"
LABEL description="Small hello-world application to test Cloud and CICD solutions"

#
# set base environment variables
#
ARG APP_HOME=/app
ARG APP_SCRATCH_SPACE=${APP_HOME}/scratch
ARG APP_PUBLISH=${APP_HOME}/target
ARG LOCALE=en_US.UTF-8
ARG RUN_AS_USER=1001
ARG RUN_AS_GROUP=1001

ENV \
  APP_HOME=${APP_HOME} \
  APP_SCRATCH_SPACE=${APP_SCRATCH_SPACE} \
  LANGUAGE=${LOCALE} \
  LANG=${LOCALE} \
  LC_ALL=${LOCALE} \
  TERM=xterm \
  PATH=$PATH:${APP_HOME}/node_modules/.bin

WORKDIR ${APP_HOME}

#
# add repos and update (where applicable)
#
USER root

# Adapt source to be able to run ad the default user 1001
# Prepare scratch space, which will be a default mounted emptyDir in Kubernetes.
RUN apk --no-cache add bash shadow \
    && groupmod -g ${RUN_AS_GROUP} nginx \
    && usermod -u ${RUN_AS_USER} -g ${RUN_AS_GROUP} nginx \
    && mkdir -p ${APP_SCRATCH_SPACE} ${APP_PUBLISH}

#############################################################################################
# START: Application specific (example)
# The template uses the following defaults:
# - Directory "/target" in the repository holds the package to be published by nginx (forwarded
#   as artifact by the build stage). Currently holding demo files, which need to be deleted.
# - Directory "${APP_PUBLISH}" within the nginx container will be used as wwwroot.
# Some directories are pointing to the example. Please use the corresponding directory
# in the ci directory.
#############################################################################################
# Copy config
COPY ci/container-runtime/* ${APP_HOME}/

# Copy to be published frontend
COPY target ${APP_PUBLISH}
#############################################################################################
# END: Application specific
#############################################################################################

#
# Run unprivileged
#
RUN chown -R ${RUN_AS_USER}:${RUN_AS_GROUP} ${APP_HOME} \
    && chmod u+x ${APP_HOME}/entrypoint.sh

USER ${RUN_AS_USER}
ENTRYPOINT ["/app/entrypoint.sh"]
