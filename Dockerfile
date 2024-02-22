FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/d3ward/toolz.git && \
    cd toolz && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:alpine as build

WORKDIR /toolz
COPY --from=base /git/toolz .
RUN npm install && \
    npm run build

FROM pierrezemb/gostatic

COPY --from=build /toolz/build /srv/http/toolz
EXPOSE 8043
