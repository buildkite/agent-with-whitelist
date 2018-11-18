FROM buildkite/agent
COPY hooks /buildkite/hooks
ENV BUILDKITE_HOOKS_PATH=/buildkite/hooks