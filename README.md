# buildkite/agent-with-whitelist

A [buildkite/agent](https://hub.docker.com/r/buildkite/agent/) image with the ability to whitelist which pipelines and branches can be run. This is done via the [environment hook](hooks/environment).

## Configuring

The following environment variables can be used to configure the agent.

### `BUILDKITE_AGENT_WHITELIST_PIPELINES`

A comma separated whitelist of pipelines to limit this agent to running.

You can either specify just the pipeline slug (e.g. `my-app`), which will allow all branches of that pipeline to run, or a pipeline slug and branch (e.g. `my-app/master`).

Examples:

|Value|Result|
|-|-|
|`my-app`|Allows building any branch of the my-app pipeline.|
|`my-app/deploy,other-app`|Allows building only the master branch of the my-app pipeline, and any branch of the other-app pipeline.|

### `BUILDKITE_AGENT_ALLOW_FORKS`

Set this to `true` if you want to allow building third-party forks, or `false` if you want to disable building third-party forks.

Default is `false`.

Examples:

|Value|Result|
|-|-|
|`true`|Allows third-party forks.|
|`false`|Disables third-party forks.|

## Developing

Running the tests:

```bash
docker-compose run --rm tests
```

Running an agent:

```bash
docker-compose build && \
docker-compose run --rm -e BUILDKITE_AGENT_WHITELIST_PIPELINES=xyz agent start --token 123
```
