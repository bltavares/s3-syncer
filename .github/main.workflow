workflow "push" {
  on = "push"
  resolves = ["autobump"]
}

action "only-master" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "autobump" {
  needs = "only-master"
  uses = "bltavares/actions/autobump@rust-release"
  secrets = ["GITHUB_TOKEN"]
}

workflow "release" {
  on = "release"
  resolves = ["release-static", "release-linux", "release-windows"]
}

action "release-static" {
  uses = "bltavares/actions/rust-releaser/x86_64-unknown-linux-musl@rust-release"
  secrets = ["GITHUB_TOKEN"]

  env = {
    PKG_NAME = "s3-syncer"
  }
}

action "release-linux" {
  uses = "bltavares/actions/rust-releaser/x86_64-unknown-linux-gnu@rust-release"
  secrets = ["GITHUB_TOKEN"]

  env = {
    PKG_NAME = "s3-syncer"
  }
}

action "release-windows" {
  uses = "bltavares/actions/rust-releaser/x86_64-pc-windows-gnu@rust-release"
  secrets = ["GITHUB_TOKEN"]

  env = {
    PKG_NAME = "s3-syncer"
  }
}
