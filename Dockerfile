FROM node:16-alpine

LABEL description="hiring-devops-fizzbuzz"

# include curl binary using os package
RUN apk add --no-cache curl

# create base directory to put apps, use node user as runtime user
RUN mkdir /app && chown node:node /app
USER node
WORKDIR /app

# declare listening port
EXPOSE 3000

# only copy package*.json files first to do packages installation as a layer
COPY package*.json .
RUN npm ci

# copy necessary app files
# not using * to avoid all other files including testing scripts for now
COPY . /app

# define container healthcheck
HEALTHCHECK --interval=3m --timeout=3s CMD curl -f http://localhost:3000/

# start app
ENTRYPOINT [ "npm" ]
CMD ["run", "local"]
