# Use Node 20 Alpine (small, secure) - includes 'node' user (UID 1000, GID 1000)
FROM node:20-alpine

# Install dumb-init for proper signal handling + sqlite for OmniRoute
RUN apk add --no-cache dumb-init sqlite

# Create app directory
WORKDIR /app

# Install OmniRoute globally (pinned version)
RUN npm install -g omniroute@3.8.50

# Create data directory with correct permissions for existing 'node' user
RUN mkdir -p /data && chown -R node:node /data

# Switch to existing non-root 'node' user (UID 1000, GID 1000)
USER node

# Expose port (Render sets PORT env var, default 20128)
EXPOSE 20128

# Health check (uses PORT env var)
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:${PORT:-20128}/health || exit 1

# Use dumb-init to handle signals properly
ENTRYPOINT ["dumb-init", "--"]

# Start OmniRoute server (uses PORT env var from Render)
CMD ["sh", "-c", "omniroute serve --port ${PORT:-20128} --no-open"]