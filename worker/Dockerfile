FROM node:14.14.0-alpine

USER node

# WSL fix: use `node` user and `/home/node/app` dir to fix issues with node processes being run by root
# and volume bookmarking being created by root
RUN mkdir -p /home/node/app
WORKDIR '/home/node/app'

# must specify node user ownership of files
COPY --chown=node:node package.json .
RUN npm install
COPY --chown=node:node . .

CMD [ "npm", "run", "start"]