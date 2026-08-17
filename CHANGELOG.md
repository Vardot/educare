# Changelog

All notable changes to the Educare site template recipe are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0-alpha2] - 2026-08-17
### Added
- Header search box, a heading on the search results page, and one result per row. [#3617501](https://www.drupal.org/i/3617501)
- Varbase Patches in the Composer requirements. [#3614680](https://www.drupal.org/i/3614680)

### Changed
- Moved the Stories view displays to Varbase News Base and Varbase Events Base. [#3616588](https://www.drupal.org/i/3616588)
- Switched the functional testing suite to the Varbase functional testing suite, with a shared install, caching and gating jobs. [#3615980](https://www.drupal.org/i/3615980)
- Merged the per-suite test reports into one Create reports pipeline job. [#3616081](https://www.drupal.org/i/3616081)

### Fixes
- Require a released Varbase Patches instead of the `11.0.x-dev` branch. [#3617362](https://www.drupal.org/i/3617362)
- Added the search index view modes and displays for the content types and taxonomy terms. [#3617242](https://www.drupal.org/i/3617242)
- List real events, news and programs on the Home page instead of static cards. [#3616545](https://www.drupal.org/i/3616545)

## [1.0.0-alpha1] - 2026-08-09
### Added
- Initial release of the Educare site template recipe.

[Unreleased]: https://git.drupalcode.org/project/educare/-/compare/1.0.0-alpha2...1.0.x
[1.0.0-alpha2]: https://git.drupalcode.org/project/educare/-/compare/1.0.0-alpha1...1.0.0-alpha2
[1.0.0-alpha1]: https://git.drupalcode.org/project/educare/-/tags/1.0.0-alpha1
