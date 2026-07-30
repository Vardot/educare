# Educare — Varbase functional testing suite

Browser-driven BDD tests for the Educare site template, built with
[webship-js](https://webship.co/docs/webship-js) (Playwright + Cucumber-js).

The suite ships inside the recipe so any Educare install can be verified the
same way, and so Educare's GitLab CI can build a Varbase 11 site, apply the
Educare recipe and drive the whole site through the browser.

## Layout

| Path | Role |
|---|---|
| `cucumber.js` | World parameters: `launchUrl`, the test-user registry, breakpoints, screenshot/video/JS-error policy. |
| `playwright.config.ts` | Browser/launch/context options (env-driven headless / slowMo). |
| `tests/features/NN-*/` | BDD `.feature` files, one folder per area (one CI job per folder). |
| `tests/step-definitions/` | Educare custom step definitions, layered on the webship-js core steps. |
| `tests/selectors/educare-theme.json` | Named CSS selectors for the Educare theme. |
| `tests/reports/` `tests/screenshots/` `tests/videos/` | Generated run artifacts (git-ignored). |

## Feature folders

| Folder | Covers |
|---|---|
| `01-website-base-requirements` | Every front-end canvas page is healthy (landmarks, language, title) and renders its own copy. |
| `02-news` | News listing (filters, keyword narrowing) and a News article (title, share, related, breadcrumb). |
| `03-events` | Events listing (12-per-page summary, Search-by-keyword + Type filters, no Industry) and an Event page. |
| `04-programs` | Programs listing (Undergraduate/Graduate toggle, keyword filter) and a Program page (degrees, sections, CTA). |
| `05-exposed-filters` | The exposed filter form is present on News/Events/Programs and absent on non-listing pages (form-scoped). |
| `06-contact` | The Contact Us page renders a working contact form. |

## Run against a live Educare site

```bash
npm install                     # or: yarn install
npx playwright install --with-deps chromium
LAUNCH_URL=https://my-educare.ddev.site npm run test:chromium
```

Run one folder / one scenario, the same knobs CI uses:

```bash
FEATURES="tests/features/02-news/**/*.feature" LAUNCH_URL=... npm run test:chromium
LAUNCH_URL=... npx cucumber-js --config cucumber.js --tags "@check and not @wip"
```

## Conventions

- Assert visible labels/roles and provided behaviour, never page reachability
  or theme markup.
- Every scenario carries environment tags (`@local @development @staging
  @production`) plus a lane tag (`@check`). Count-based assertions that depend on
  the recipe's demo content are tagged `@local @development` only.
- The recipe installs its own demo content (News, Events, Programs, canvas
  pages), so most scenarios run against that; no separate `tests/recipes/`
  seeding is needed for the recipe's own suite.
