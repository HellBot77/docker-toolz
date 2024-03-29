FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/d3ward/toolz.git && \
    cd toolz && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:20 as build

WORKDIR /toolz
COPY --from=base /git/toolz .
RUN npm install && \
    npm run build

FROM lipanski/docker-static-website

COPY --from=build /toolz/dist toolz
