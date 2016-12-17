FROM mongo:3.4

MAINTAINER J. Scott Smith <scott@newleafsolutionsinc.com>

COPY auth-entrypoint.sh /auth-entrypoint.sh
RUN chmod +x /auth-entrypoint.sh

COPY auth-init.sh /auth-init.sh
RUN chmod +x /auth-init.sh
