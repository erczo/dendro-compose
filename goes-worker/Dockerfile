FROM dendro/dendra-worker

MAINTAINER J. Scott Smith <scott@newleafsolutionsinc.com>

# Install GOES Tasks
USER root
RUN npm install @dendra-science/worker-tasks-goes

COPY production.json /home/node/app/config

# Best practice: run as user 'node'
USER node
