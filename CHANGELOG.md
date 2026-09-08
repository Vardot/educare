# Changelog

All notable changes to the Educare site template recipe are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.1] - 2026-09-08
### Changed
- Pinned every base recipe and the Educare theme to their released versions instead of dev branches.

### Fixes
- Removed the four never-applied base recipes, so the template resolves on Stable for Drupal CMS. [#3621335](https://www.drupal.org/i/3621335)
- Took the refused, allowed and page-title steps from the Varbase functional testing suite. [#3621385](https://www.drupal.org/i/3621385)

## [1.0.0] - 2026-09-06
### Changed
- First stable release. The recipe is unchanged from 1.0.0-rc1; every `drupal/varbase_*` and `drupal/vartheme_bs5_educare` dependency now resolves to a stable 1.0.0 release, so `composer require drupal/educare:~1` installs on a stock Drupal CMS project template at its default `minimum-stability: stable`.
- Named the colour contrast and top-level heading accessibility rules in the home page regression scenarios. [#3621202](https://www.drupal.org/i/3621202)

## [1.0.0-rc1] - 2026-09-06
### Changed
- Release candidate. No functional changes since 1.0.0-beta1; the dependencies are pinned to releases instead of `1.0.x-dev`.

## [1.0.0-beta1] - 2026-09-05
### Changed
- Gave the site template a properly framed installer screenshot and a description in the Drupal CMS house style. [#3620996](https://www.drupal.org/i/3620996)

## [1.0.0-alpha3] - 2026-09-05
### Changed
- Re-exported the Canvas component configs for the Canvas Icon Picker. [#3620058](https://www.drupal.org/i/3620058)
- Moved Search after Varbase Content Base in `recipe.yml`. [#3620242](https://www.drupal.org/i/3620242)
- Pinned the block component versions to `active`, so a stale hash cannot 500 the Canvas pages. [#3620438](https://www.drupal.org/i/3620438)

### Removed
- The Varbase Patches requirement and the Drupal CMS wiring script from the recipe. [#3618244](https://www.drupal.org/i/3618244)
- `drupal/varbase_dev_base` from `composer.json`: a development recipe that was required but never applied. [#3620331](https://www.drupal.org/i/3620331)
- The dead `drupal-libraries-sync.js` script. [#3620349](https://www.drupal.org/i/3620349)

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

[Unreleased]: https://git.drupalcode.org/project/educare/-/compare/1.0.1...1.0.x
[1.0.1]: https://git.drupalcode.org/project/educare/-/compare/1.0.0...1.0.1
[1.0.0]: https://git.drupalcode.org/project/educare/-/compare/1.0.0-rc1...1.0.0
[1.0.0-rc1]: https://git.drupalcode.org/project/educare/-/compare/1.0.0-beta1...1.0.0-rc1
[1.0.0-beta1]: https://git.drupalcode.org/project/educare/-/compare/1.0.0-alpha3...1.0.0-beta1
[1.0.0-alpha3]: https://git.drupalcode.org/project/educare/-/compare/1.0.0-alpha2...1.0.0-alpha3
[1.0.0-alpha2]: https://git.drupalcode.org/project/educare/-/compare/1.0.0-alpha1...1.0.0-alpha2
[1.0.0-alpha1]: https://git.drupalcode.org/project/educare/-/tags/1.0.0-alpha1
