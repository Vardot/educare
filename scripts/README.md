# Educare Scripts

## Add Educare Testing Users

To add testing users for each default user role in Educare.

```
cd PROJECT_DIR_NAME/recipes/educare/scripts
bash add-testing-users.sh
```

The out put for this bash command:
```
 ----------------------------------------------------------------
      User name: Normal user
      User mail: test.authenticated@vardot.com
  User password: dD.123123ddd
      User role: _none_
 =================================================================
 [success] Created a new user with uid 8
   No user role for this user
 ----------------------------------------------------------------
      User name: Content editor
      User mail: test.content_editor@vardot.com
  User password: dD.123123ddd
      User role: content_editor
 =================================================================
 [success] Created a new user with uid 9
 [success] Added content_editor role to Content editor
 ----------------------------------------------------------------
      User name: Content admin
      User mail: test.content_admin@vardot.com
  User password: dD.123123ddd
      User role: content_admin
 =================================================================
 [success] Created a new user with uid 10
 [success] Added content_admin role to Content admin
 ----------------------------------------------------------------
      User name: SEO admin
      User mail: test.seo_admin@vardot.com
  User password: dD.123123ddd
      User role: seo_admin
 =================================================================
 [success] Created a new user with uid 11
 [success] Added seo_admin role to SEO admin
 ----------------------------------------------------------------
      User name: Site admin
      User mail: test.site_admin@vardot.com
  User password: dD.123123ddd
      User role: site_admin
 =================================================================
 [success] Created a new user with uid 12
 [success] Added site_admin role to Site admin
 ----------------------------------------------------------------
      User name: Super admin
      User mail: test.super_admin@vardot.com
  User password: dD.123123ddd
      User role: administrator
 =================================================================
 [success] Created a new user with uid 13
 [success] Added administrator role to Super admin
```

## Delete Educare Testing Users
To delete all generated testing users, with all content created by them.
```
cd PROJECT_DIR_NAME/recipes/educare/scripts
bash delete-testing-users.sh
```

The out put for this bash command:
```
 ----------------------------------------------------------------
      User name: Normal user
      User mail: test.authenticated@vardot.com
  User password: dD.123123ddd
      User role: _none_
 =================================================================
 [warning] All content created by Normal user will be deleted.

 // Cancel user account?: : yes.

>  [notice] Deleted user: Normal user <test.authenticated@vardot.com>.
>  [notice] Message: Account /Normal user/ has been deleted.
>
 ----------------------------------------------------------------
      User name: Content editor
      User mail: test.content_editor@vardot.com
  User password: dD.123123ddd
      User role: content_editor
 =================================================================
 [warning] All content created by Content editor will be deleted.

 // Cancel user account?: : yes.

>  [notice] Deleted user: Content editor <test.content_editor@vardot.com>.
>  [notice] Message: Account /Content editor/ has been deleted.
>
 ----------------------------------------------------------------
      User name: Content admin
      User mail: test.content_admin@vardot.com
  User password: dD.123123ddd
      User role: content_admin
 =================================================================
 [warning] All content created by Content admin will be deleted.

 // Cancel user account?: : yes.

>  [notice] Deleted user: Content admin <test.content_admin@vardot.com>.
>  [notice] Message: Account /Content admin/ has been deleted.
>
 ----------------------------------------------------------------
      User name: SEO admin
      User mail: test.seo_admin@vardot.com
  User password: dD.123123ddd
      User role: seo_admin
 =================================================================
 [warning] All content created by SEO admin will be deleted.

 // Cancel user account?: : yes.

>  [notice] Deleted user: SEO admin <test.seo_admin@vardot.com>.
>  [notice] Message: Account /SEO admin/ has been deleted.
>
 ----------------------------------------------------------------
      User name: Site admin
      User mail: test.site_admin@vardot.com
  User password: dD.123123ddd
      User role: site_admin
 =================================================================
 [warning] All content created by Site admin will be deleted.

 // Cancel user account?: : yes.

>  [notice] Deleted user: Site admin <test.site_admin@vardot.com>.
>  [notice] Message: Account /Site admin/ has been deleted.
>
 ----------------------------------------------------------------
      User name: Super admin
      User mail: test.super_admin@vardot.com
  User password: dD.123123ddd
      User role: administrator
 =================================================================
 [warning] All content created by Super admin will be deleted.

 // Cancel user account?: : yes.

>  [notice] Deleted user: Super admin <test.super_admin@vardot.com>.
>  [notice] Message: Account /Super admin/ has been deleted.

```
## Change the list of users and their passwords
* Edit the `users` array in `add-testing-users.sh` and `delete-testing-users.sh`.
* Each entry follows the format: `"name|mail|password|role"`
* Add more users or change the password for the listed users.

## Wire a Drupal CMS project for Educare

Educare is a `Site` recipe, so it is not tied to Varbase. On a Varbase 11 base
(`drupal/varbase_project`) nothing extra is needed. A plain `drupal/cms` codebase is
missing the composer and npm wiring Varbase ships, and `composer require drupal/educare`
fails on it before the recipe is ever downloaded.

`drupal-cms-wiring.php` adds all of it. It is idempotent, reports what it changed, and
takes `--dry-run`.

```
cd PROJECT_DIR_NAME/recipes/educare/scripts
php drupal-cms-wiring.php
```

Run it from the project root instead and it will find the root itself.

What it merges in comes from two editable asset files, so changing the wiring never
means editing the script:

* `scripts/assets/drupal-cms.composer.json` is merged into the root `composer.json`
* `scripts/assets/drupal-libraries.package.json` is merged into the root `package.json`

Both merges are additive: every leaf is set, existing sibling keys are left alone, and
re-running reports what was already in place.

What it sets:

* `minimum-stability: dev` + `prefer-stable: true` — every `drupal/varbase_*_base` it requires is `1.0.x-dev` and ``drupal/vartheme_bs5_educare`` is `1.0.x-dev`,
  against `drupal/cms`'s `stable`.
* `config.allow-plugins` for `cweagans/composer-patches`, `vardot/varbase-patches` and
  `oomphinc/composer-installers-extender` — varbase-patches is a plugin and pulls the
  extender in, and `drupal/cms` allows neither, so composer aborts its install step.
* `extra.enable-patching`, `extra.composer-exit-on-patch-failure` and the default-deny
  `extra.composer-patches.allowed-dependency-patches` allowlist — this is what lets
  `drupal/canvas` resolve with its patches.
* the `drupal-libraries` block in `package.json` plus the `postinstall` hook, and copies
  `drupal-libraries-sync.js` to the project root's `scripts/`.
* `.yarnrc.yml` with `nodeLinker: node-modules` — Yarn 4 defaults to Plug'n'Play and
  writes no `node_modules/` for the sync script to copy from.

Then, from the project root:

```
composer require drupal/educare -W
corepack enable && corepack yarn install
```

`vardot/varbase-patches` arrives as a requirement of this recipe, so it does not need
requiring separately: the wiring above only has to permit its plugin first.

`-W` is required: a partial update keeps the locked `symfony/css-selector`, which
`drupal/storybook` (via `varbase_dev_base`) conflicts with.

`drupal-recipe-unpack.on-require` is set to `false`. Left on, Composer flattens every
dependency of a `drupal-recipe` into the root `composer.json` and drops the recipe
itself, so `drupal/educare` disappears from the file and roughly 190 transitive entries
take its place. With it off the root keeps a single named requirement, and the recipe is
still installed into `recipes/`.

Patch resolution is default-deny, and dependencies that declare patches with a path
relative to the project root are ignored outright (`drupal/ai_context` is one). Those
paths only resolve from a root that happens to ship the file, so leaving them enabled
fails the require before the install begins. This mirrors `varbase_project`.

The `🧩 (Drupal CMS) Install Educare site template` CI job runs exactly these steps on a
plain `drupal/cms` codebase and asserts the result, so the wiring cannot rot unnoticed:
it checks the recipe and Canvas are in place, the `allow-plugins` entries and both patch
lists are set, at least six libraries are declared, the install completes, and
`vartheme_bs5_educare` ends up the default theme.

Known limit — the browser installer. `drush site:install` completes on a plain Drupal
CMS base, but picking the template in the browser installer at `/core/install.php` fails
at roughly 49%, for a reason outside this recipe:

    Call to a member function getConfigDependencyName() on null in
    Drupal\Core\Entity\EntityDisplayBase->calculateDependencies()

Drupal CMS installs `layout_builder`, and `drupal_cms_search` clones every node view
display (`cloneAs: node.%.search_index`), so LayoutBuilderEntityViewDisplay's dependency
calculation hits a field definition that is null. Reproduced on more than one site
template, so it is not specific to Educare. Use `drush site:install` on this base until
it is fixed upstream; Varbase 11 has neither problem.
