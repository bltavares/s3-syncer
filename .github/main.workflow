workflow "push" {
  on = "push"
  resolves = ["release-static", "release-linux", "release-windows"]
}

action "release-static" {
  uses = "./../../../repos/actions/rust-releaser/x86_64-unknown-linux-musl"

  env = {
   PKG_NAME = "s3-syncer"
  }
}

action "release-linux" {
  uses = "./../../../repos/actions/rust-releaser/x86_64-unknown-linux-gnu"

  env = {
   PKG_NAME = "s3-syncer"
  }
}

action "release-windows" {
  uses = "./../../../repos/actions/rust-releaser/x86_64-pc-windows-gnu"

  env = {
   PKG_NAME = "s3-syncer"
  }
}
