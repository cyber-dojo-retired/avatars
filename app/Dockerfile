FROM cyberdojo/rack-base:bd4161e
LABEL maintainer=jon@jaggersoft.com

COPY --chown=nobody:nogroup . /app

ARG COMMIT_SHA
ENV SHA=${COMMIT_SHA}

EXPOSE 5027

USER nobody
CMD [ "/app/up.sh" ]
