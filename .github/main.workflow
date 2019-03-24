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
  uses = "docker://bltavares/actions:autobump"
  secrets = ["GITHUB_TOKEN"]
}

action "latest-linux" {
  uses = "docker://rustreleaser/action:x86_64-unknown-linux-gnu"
  needs = ["autobump"]
  secrets = ["GITHUB_TOKEN"]
  env = {
    PKG_NAME = "s3-syncer"
  }
}

action "latest-windows" {
  uses = "docker://rustreleaser/action:x86_64-pc-windows-gnu"
  needs = ["autobump"]
  secrets = ["GITHUB_TOKEN"]
  env = {
    PKG_NAME = "s3-syncer"
  }
}

action "latest-static" {
  uses = "docker://rustreleaser/action:x86_64-unknown-linux-musl"
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
  uses = "docker://rustreleaser/action:x86_64-unknown-linux-musl"
  secrets = ["GITHUB_TOKEN"]
  env = {
    PKG_NAME = "s3-syncer"
  }
}

action "release-linux" {
  uses = "docker://rustreleaser/action:x86_64-unknown-linux-gnu"
  secrets = ["GITHUB_TOKEN"]
  env = {
    PKG_NAME = "s3-syncer"
  }
}

action "release-windows" {
  uses = "docker://rustreleaser/action:x86_64-pc-windows-gnu"
  secrets = ["GITHUB_TOKEN"]
  env = {
    PKG_NAME = "s3-syncer"
  }
}
