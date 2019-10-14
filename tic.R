do_package_checks()

if (ci_has_env("id_rsa") && !ci_is_tag()) {
  get_stage("install") %>%
    add_step(step_install_cran("desc")) %>%
    add_step(step_install_cran("dplyr"))

  # pkgdown documentation can be built optionally. Other example criteria:
  # - `inherits(ci(), "TravisCI")`: Only for Travis CI
  # - `ci()$is_tag()`: Only for tags, not for branches
  # - `Sys.getenv("BUILD_PKGDOWN") != ""`: If the env var "BUILD_PKGDOWN" is set
  # - `Sys.getenv("TRAVIS_EVENT_TYPE") == "cron"`: Only for Travis cron jobs
  get_stage("before_deploy") %>%
    add_step(step_setup_ssh())

  get_stage("deploy") %>%
    add_step(step_build_pkgdown()) %>%
    add_step(step_push_deploy(path = "docs", branch = "gh-pages"))

  if (ci_get_branch() == "master") {
    get_stage("deploy") %>%
      add_step(step_run_code(source("data-raw/update-data.R", echo = TRUE))) %>%
      add_step(step_push_deploy(
        path = c("DESCRIPTION", "data"),
        commit_message = "New Mutation Data added and version bumped.")
      )
  }
}
