# Stage 1: Build
FROM quay.io/keycloak/keycloak:latest AS builder

ENV KC_HEALTH_ENABLED=true \
    KC_METRICS_ENABLED=true

WORKDIR /opt/keycloak

# Copy all themes into the container
COPY themes/ /opt/keycloak/themes/

# Run Keycloak build to optimize
RUN bin/kc.sh build

# Stage 2: Final image
FROM quay.io/keycloak/keycloak:latest

ENV KC_DB=dev-file

# Copy built server and themes
COPY --from=builder /opt/keycloak /opt/keycloak

# Fix permissions
USER root
RUN chown -R keycloak:keycloak /opt/keycloak/themes

USER keycloak

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start-dev"]