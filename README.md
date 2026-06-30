[![Varbase](https://raw.githubusercontent.com/Vardot/varbase/11.0.x/images/varbase-logo.png)](https://www.drupal.org/project/varbase)

# Educare
[![pipeline status](https://git.drupalcode.org/project/educare/badges/1.0.x/pipeline.svg)](https://git.drupalcode.org/project/educare/-/pipelines)
[![Educare](https://img.shields.io/badge/Educare-1.0.x--dev-0d6efc?labelColor=001d38&style=flat-square)](https://www.drupal.org/project/educare)

A Drupal CMS site template recipe for education websites (schools, universities, academies, e-learning), built the Varbase recipe-first way.

## Requirement

After creating a **Varbase 11** or a **Drupal CMS** project with DDEV, require Educare and apply the recipe:

```bash
ddev composer require drupal/educare:1.0.x-dev
ddev drush recipe ../recipes/contrib/educare
ddev drush cache:rebuild
```

The recipe assembles a complete site through the Drupal Recipe Installer Kit and ships the [vartheme_bs5_educare](https://www.drupal.org/project/vartheme_bs5_educare) Bootstrap 5 front-end theme.

## Learn More

- [Issue #3607227](https://www.drupal.org/project/educare/issues/3607227)
- [Drupal Recipes](https://www.drupal.org/docs/extending-drupal/drupal-recipes)
- [Varbase Starter](https://www.drupal.org/project/varbase_starter)
