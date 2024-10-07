#!/usr/bin/env bashio

bashio::log.info "Getting configuration..."

# Grab configuration options using bashio
DEBUG="$(bashio::config 'debug')"
MQTT_HOST="$(bashio::config 'mqtt_host' 'core-mosquitto')"  # Default to core-mosquitto
SMTP_LISTEN_PORT="$(bashio::config 'smtp_listen_port' '25')"
SMTP_AUTH_REQUIRED="$(bashio::config 'smtp_auth_required' 'false')"
SMTP_RELAY_HOST="$(bashio::config 'smtp_relay_host')"
SMTP_RELAY_PORT="$(bashio::config 'smtp_relay_port')"
SMTP_RELAY_USER="$(bashio::config 'smtp_relay_user')"
SMTP_RELAY_PASS="$(bashio::config 'smtp_relay_pass')"
SMTP_RELAY_STARTTLS="$(bashio::config 'smtp_relay_starttls' 'false')"
SMTP_RELAY_TIMEOUT_SECS="$(bashio::config 'smtp_relay_timeout_secs' '30')"
MQTT_PORT="$(bashio::config 'mqtt_port' '1883')"
MQTT_USER="$(bashio::config 'mqtt_user')"
MQTT_PASS="$(bashio::config 'mqtt_pass')"
MQTT_TOPIC="$(bashio::config 'mqtt_topic' 'smtp2mqtt')"
PUBLISH_ATTACHMENTS="$(bashio::config 'publish_attachments' 'true')"
SAVE_ATTACHMENTS="$(bashio::config 'save_attachments' 'false')"

# Enable debugging if required
if [[ "$DEBUG" == "true" ]]; then
    bashio::log.info "Debug mode is enabled."
    bashio::log.info "MQTT_HOST: $MQTT_HOST"
    bashio::log.info "SMTP_LISTEN_PORT: $SMTP_LISTEN_PORT"
    bashio::log.info "MQTT_PORT: $MQTT_PORT"
    bashio::log.info "MQTT_TOPIC: $MQTT_TOPIC"
fi

# Set the attachment save directory if needed
if [[ "$SAVE_ATTACHMENTS" == "true" ]]; then
    SAVE_ATTACHMENTS_DIR="/share/smtp2mqtt"
    if [[ -n "$MQTT_TOPIC" ]] && [[ "$MQTT_TOPIC" != "null" ]]; then
        SAVE_ATTACHMENTS_DIR="/share/$MQTT_TOPIC"
    fi
    bashio::log.info "Creating attachment save directory: $SAVE_ATTACHMENTS_DIR"
    mkdir -p "$SAVE_ATTACHMENTS_DIR" || {
        bashio::log.error "Failed to create directory: $SAVE_ATTACHMENTS_DIR"
        exit 1
    }
fi

bashio::log.info "Starting application..."
exec python3 /app/smtp2mqtt.py
