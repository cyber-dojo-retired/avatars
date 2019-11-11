FROM cyberdojo/rack-base
LABEL maintainer=jon@jaggersoft.com

WORKDIR /app
COPY --chown=nobody:nogroup . .

ARG SHA
ENV SHA=${SHA}

EXPOSE 5027

USER nobody
CMD [ "./up.sh" ]
