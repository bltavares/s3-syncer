workflow "push" {
  on = "push"
  resolves = "release"
}

action "release" {
  uses = "./../../../repos/actions/rust-releaser"
}
