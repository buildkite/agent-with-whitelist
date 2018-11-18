@test "simple whitelist matching" {
  export BUILDKITE_PIPELINE_SLUG=my-app
  export BUILDKITE_BRANCH=master
  export BUILDKITE_AGENT_WHITELIST_PIPELINES=my-app/master

  run ./hooks/environment

  [ "$status" -eq 0 ]
  [ "$output" = "Whitelist pattern 'my-app/master' allowed" ]

  unset BUILDKITE_PIPELINE_SLUG
  unset BUILDKITE_BRANCH
  unset BUILDKITE_AGENT_WHITELIST_PIPELINES
}

@test "branch-less match" {
  export BUILDKITE_PIPELINE_SLUG=my-app
  export BUILDKITE_BRANCH=master
  export BUILDKITE_AGENT_WHITELIST_PIPELINES=my-app

  run ./hooks/environment

  [ "$status" -eq 0 ]
  [ "$output" = "Whitelist pattern 'my-app' allowed" ]

  unset BUILDKITE_PIPELINE_SLUG
  unset BUILDKITE_BRANCH
  unset BUILDKITE_AGENT_WHITELIST_PIPELINES
}

@test "branch-less match with multi-pipeline" {
  export BUILDKITE_PIPELINE_SLUG=my-app
  export BUILDKITE_BRANCH=master
  export BUILDKITE_AGENT_WHITELIST_PIPELINES=my-app,my-app-2

  run ./hooks/environment

  [ "$status" -eq 0 ]
  [ "$output" = "Whitelist pattern 'my-app' allowed" ]

  unset BUILDKITE_PIPELINE_SLUG
  unset BUILDKITE_BRANCH
  unset BUILDKITE_AGENT_WHITELIST_PIPELINES
}

@test "branch match with multi-pipeline" {
  export BUILDKITE_PIPELINE_SLUG=my-app
  export BUILDKITE_BRANCH=master
  export BUILDKITE_AGENT_WHITELIST_PIPELINES=my-app/master,my-app-2

  run ./hooks/environment

  [ "$status" -eq 0 ]
  [ "$output" = "Whitelist pattern 'my-app/master' allowed" ]

  unset BUILDKITE_PIPELINE_SLUG
  unset BUILDKITE_BRANCH
  unset BUILDKITE_AGENT_WHITELIST_PIPELINES
}

@test "simple whitelist mismatch" {
  export BUILDKITE_PIPELINE_SLUG=my-app-2
  export BUILDKITE_BRANCH=master
  export BUILDKITE_AGENT_WHITELIST_PIPELINES=my-app/master

  run ./hooks/environment

  [ "$status" -eq 1 ]
  [ "$output" = "my-app-2/master is not allowed to run on this agent" ]

  unset BUILDKITE_PIPELINE_SLUG
  unset BUILDKITE_BRANCH
  unset BUILDKITE_AGENT_WHITELIST_PIPELINES
}

@test "multi-value whitelist mismatch" {
  export BUILDKITE_PIPELINE_SLUG=my-app-3
  export BUILDKITE_BRANCH=master
  export BUILDKITE_AGENT_WHITELIST_PIPELINES=my-app/master,my-app-2/master

  run ./hooks/environment

  [ "$status" -eq 1 ]
  [ "$output" = "my-app-3/master is not allowed to run on this agent" ]

  unset BUILDKITE_PIPELINE_SLUG
  unset BUILDKITE_BRANCH
  unset BUILDKITE_AGENT_WHITELIST_PIPELINES
}

@test "fork-checking" {
  export BUILDKITE_PIPELINE_SLUG=my-app
  export BUILDKITE_BRANCH=master:thing
  export BUILDKITE_AGENT_WHITELIST_PIPELINES=my-app/master:thing

  run ./hooks/environment

  [ "$status" -eq 1 ]
  [ "$output" = "Third-party forks aren't allowed" ]

  unset BUILDKITE_PIPELINE_SLUG
  unset BUILDKITE_BRANCH
  unset BUILDKITE_AGENT_WHITELIST_PIPELINES
}

@test "fork-checking disabled" {
  export BUILDKITE_PIPELINE_SLUG=my-app
  export BUILDKITE_BRANCH=master:thing
  export BUILDKITE_AGENT_WHITELIST_PIPELINES=my-app/master:thing
  export BUILDKITE_AGENT_ALLOW_FORKS=true

  run ./hooks/environment

  [ "$status" -eq 0 ]
  [ "$output" = "Whitelist pattern 'my-app/master:thing' allowed" ]

  unset BUILDKITE_PIPELINE_SLUG
  unset BUILDKITE_BRANCH
  unset BUILDKITE_AGENT_WHITELIST_PIPELINES
}