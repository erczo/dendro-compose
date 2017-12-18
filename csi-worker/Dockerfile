FROM dendro/dendra-worker

MAINTAINER J. Scott Smith <scott@newleafsolutionsinc.com>

USER root

RUN mkdir -p /data/state \
	&& chown -R node:node /data/state
VOLUME /data/state

# Install GOES Tasks
RUN npm install @dendra-science/worker-tasks-csi

COPY production.json /home/node/app/config

# Best practice: run as user 'node'
USER node
