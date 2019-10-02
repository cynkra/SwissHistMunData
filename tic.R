get_stage("before_script") %>%
  add_code_step({
    remotes::install_local(".")
  })

get_stage("install") %>%
  add_step(step_install_cran("sendmailR"))

if (SwissHistMunData::check_data() && SwissHistMunData::check_past_changes()) {
  get_stage("script") %>%
    add_step(step_run_code(SwissHistMunData::overwrite_data())) %>%
    add_step(step_run_code(desc::desc_bump_version('dev')))
}

do_package_checks()

if (Sys.getenv("id_rsa") != "" && !ci()$is_tag()) {
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
}

if (SwissHistMunData::check_data() && SwissHistMunData::check_past_changes()) {
  get_stage("before_deploy") %>%
    add_step(step_setup_ssh())

  get_stage("deploy") %>%
    add_step(step_push_deploy(path = "data", commit_message = "New Mutation Data added and version bumped."))
}
