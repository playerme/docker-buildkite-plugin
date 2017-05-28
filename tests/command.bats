#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment to enable stub debug output:
# export DOCKER_STUB_DEBUG=/dev/tty

@test "Runs the command using docker" {
  export BUILDKITE_PLUGIN_DOCKER_WORKDIR=/app
  export BUILDKITE_PLUGIN_DOCKER_IMAGE=image:tag
  export BUILDKITE_COMMAND="command1 \"a string\" && command2"

  stub docker \
    "run -it --rm -v $PWD:/app --workdir /app image:tag bash -c 'command1 \"a string\" && command2' : echo ran command in docker"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran command in docker"

  unstub docker
  unset BUILDKITE_PLUGIN_DOCKER_WORKDIR
  unset BUILDKITE_PLUGIN_DOCKER_IMAGE
  unset BUILDKITE_COMMAND
}