workflow "push" {
  on = "push"
  resolves = ["autobump", "latest-linux", "latest-windows", "latest-static"]
}

action "only-master" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "autobump" {
  needs = "only-master"
  uses = "bltavares/actions/autobump@rustreleaser"
  secrets = ["GITHUB_TOKEN"]
}

action "latest-linux" {
  uses = "bltavares/actions/rust-releaser/x86_64-unknown-linux-musl@rustreleaser"
  needs = ["autobump"]
  secrets = ["GITHUB_TOKEN"]

  env = {
    PKG_NAME = "s3-syncer"
  }
}

action "latest-windows" {
  uses = "bltavares/actions/rust-releaser/x86_64-unknown-linux-musl@rustreleaser"
  needs = ["autobump"]
  secrets = ["GITHUB_TOKEN"]

  env = {
    PKG_NAME = "s3-syncer"
  }
}

action "latest-static" {
  uses = "bltavares/actions/rust-releaser/x86_64-unknown-linux-musl@rustreleaser"
  needs = ["autobump"]
  secrets = ["GITHUB_TOKEN"]

  env = {
    PKG_NAME = "s3-syncer"
  }
}

workflow "release" {
  on = "release"
  resolves = ["release-static", "release-linux", "release-windows"]
}

action "release-static" {
  uses = "bltavares/actions/rust-releaser/x86_64-unknown-linux-musl@rustreleaser"
  secrets = ["GITHUB_TOKEN"]

  env = {
    PKG_NAME = "s3-syncer"
  }
}

action "release-linux" {
  uses = "bltavares/actions/rust-releaser/x86_64-unknown-linux-gnu@rustreleaser"
  secrets = ["GITHUB_TOKEN"]

  env = {
    PKG_NAME = "s3-syncer"
  }
}

action "release-windows" {
  uses = "bltavares/actions/rust-releaser/x86_64-pc-windows-gnu@rustreleaser"
  secrets = ["GITHUB_TOKEN"]

  env = {
    PKG_NAME = "s3-syncer"
  }
}
