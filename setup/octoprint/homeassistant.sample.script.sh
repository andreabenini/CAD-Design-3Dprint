#!/usr/bin/env bash
#
# Notify HA about machine shutdown
# Actions: turn_off, turn_on, toggle
#
RESULT=$(curl -v POST \
              -H "Authorization: Bearer <bearerTokenHere>" \
              -H "Content-Type: application/json" \
              -d '{"entity_id": "switch.switchName"}' \
             'http://<ipAddress>:8000/api/services/switch/turn_off')
logger "Switch notified on shutdown"
logger "$RESULT"
