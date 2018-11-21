FROM buildkite/agent:3

# Install aws-cli via pip (because the aws-cli package isn't available)
RUN apk -v --update add \
      python \
      # We'll remove this later
      py-pip \
      # awscli cli uses groff and less to output command help
      groff \
      less \
      # and it uses mailcap for mimetypes
      mailcap \
      # and some projects use make \
      make \
    && \
    # Upgrade pip
    pip install --upgrade pip && \
    # Finally we install aws
    pip install --upgrade awscli && \
    # Don't need pip
    apk -v --purge del py-pip && \
    # Clean up
    rm /var/cache/apk/*

COPY hooks /buildkite/hooks

ENV BUILDKITE_HOOKS_PATH=/buildkite/hooks
