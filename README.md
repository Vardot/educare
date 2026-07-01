<img src="logo.png" alt="Educare" width="96">

# Educare
[![pipeline status](https://git.drupalcode.org/project/educare/badges/1.0.x/pipeline.svg)](https://git.drupalcode.org/project/educare/-/pipelines)
[![Educare](https://img.shields.io/badge/Educare-1.0.x--dev-0d6efc?labelColor=001d38&style=flat-square)](https://www.drupal.org/project/educare)

A Drupal CMS site template recipe for education websites (schools, universities, academies, e-learning), built the Varbase recipe-first way.

## Install with Composer

To install the most recent release of Varbase 11.0.x, run this command:

```bash
composer create-project drupal/varbase_project:~11.0.0 PROJECT_DIR_NAME --no-dev --no-interaction
```

Then require the recipe and apply it with DDEV:

```bash
ddev composer require drupal/educare:1.0.x-dev
ddev drush recipe ../recipes/contrib/educare
ddev drush cache:rebuild
```


## Learn More

- [Issue #3607227](https://www.drupal.org/project/educare/issues/3607227)
- [Drupal Recipes](https://www.drupal.org/docs/extending-drupal/drupal-recipes)
- [Varbase Starter](https://www.drupal.org/project/varbase_starter)
