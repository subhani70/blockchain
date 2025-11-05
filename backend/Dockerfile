FROM node:22-alpine

# Set working directory
WORKDIR /backend

# Copy application source code
COPY . /backend

# Install only production dependencies
RUN npm i

# Expose the app port
EXPOSE 5000

# Run the application
CMD ["npm", "start"]
