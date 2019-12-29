FROM cyberdojo/rack-base
LABEL maintainer=jon@jaggersoft.com

COPY --chown=nobody:nogroup . /app

ARG COMMIT_SHA
ENV SHA=${COMMIT_SHA}

EXPOSE 5027

USER nobody
CMD [ "/app/up.sh" ]
