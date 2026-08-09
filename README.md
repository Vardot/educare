[![Varbase](https://raw.githubusercontent.com/Vardot/varbase/11.0.x/images/varbase-logo.png)](https://www.drupal.org/project/varbase)

<img src="logo.png" alt="Educare" width="120" />

# Educare
[![pipeline status](https://git.drupalcode.org/project/educare/badges/1.0.x/pipeline.svg)](https://git.drupalcode.org/project/educare/-/pipelines)
[![Educare](https://img.shields.io/badge/Educare-1.0.0--alpha1-0d6efc?labelColor=001d38&style=flat-square)](https://git.drupalcode.org/project/educare/-/pipelines?ref=1.0.0-alpha1)

An **education site template** for schools, universities, academies and e-learning platforms, built on
the [Varbase](https://www.drupal.org/project/varbase) distribution with the
[Vartheme BS5 Educare](https://www.drupal.org/project/vartheme_bs5_educare) front-end theme.

## Install with Composer

Start from a Varbase ~11.0.0 project:

```bash
composer create-project drupal/varbase_project:~11.0.0 PROJECT_DIR_NAME --no-dev --no-interaction
```

Then add the Educare site template:

```bash
composer require drupal/educare:1.0.x-dev
```

## Local setup with DDEV

```bash
mkdir my_educare_site
cd my_educare_site
ddev config --project-type=drupal11 --docroot=web --php-version=8.4
ddev start
ddev composer create-project "drupal/varbase_project:~11.0.0"
ddev composer require drupal/educare:1.0.x-dev
ddev launch
```

Finish the installation in the browser and choose **Educare** in the *Choose a site template* step.

Educare is a `type: Site` recipe: it is applied **during** the site install, by the site-template
picker — not with `drush recipe` on a site that is already installed.

## What you get

A fully configured education website — home, programs, admissions, research, student life, events,
news and contact pages — built with Drupal Canvas on the Vartheme BS5 Educare components, with
ready-made patterns that content editors can place on any page.

The template does not reinvent what Varbase already provides. It composes the base recipes and adds
only what is Educare's:

| Section | Comes from |
|---|---|
| Events — the Event content type, the events listing, related events | [Varbase Events Base](https://www.drupal.org/project/varbase_events_base) |
| News — the News content type and its listing | [Varbase News Base](https://www.drupal.org/project/varbase_news_base) |
| Pages, media, editor, workflow, SEO, search, forms, privacy, admin UI | the `varbase_*` and `drupal_cms_*` base recipes |
| The look of it all | [Vartheme BS5 Educare](https://www.drupal.org/project/vartheme_bs5_educare) |

Educare itself owns its theme, its pages and patterns, its demo content, and the theme repointing: the
Canvas templates that the base recipes ship against the base theme are repointed onto Vartheme BS5
Educare with the config actions from
[Varbase Recipes](https://www.drupal.org/project/varbase_recipes).

## Requirements

- Drupal ~11.4, PHP 8.4
- Varbase 11 (`drupal/varbase_project:~11.0.0`)

## Learn more

- [Educare on Drupal.org](https://www.drupal.org/project/educare)
- [Drupal Recipes](https://www.drupal.org/docs/extending-drupal/drupal-recipes)
- [Varbase Starter](https://www.drupal.org/project/varbase_starter)

## Maintainers

Sponsored and developed by [Vardot](https://www.drupal.org/vardot).
