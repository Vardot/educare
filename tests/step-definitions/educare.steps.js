'use strict';

const { Before, AfterStep, When, Then, setDefaultTimeout } = require('@cucumber/cucumber');

// The harness sets a 45s default step timeout. The breakpoint warm-up pass
// visits one page at seven breakpoints in a single step, which legitimately
// exceeds that on a loaded shared runner - give every step more headroom.
setDefaultTimeout(90 * 1000);

const assert = require('assert');

const { smartSettle, friendly } = require('@vardot/varbase-e2e/tests/step-definitions/varbase-e2e');

/** Settle budget shared by every step here. */
function budget(world) {
  return (world.minWaitTime && world.minWaitTime.page) || 8000;
}

/** Absolute URL for a site-relative path. */
function absolute(world, path) {
  if (path.startsWith('http')) return path;
  return world.launchUrl.replace(/\/$/, '') + (path.startsWith('/') ? path : '/' + path);
}

/**
 * Choose an option in an exposed filter, addressing the filter by the label the
 * visitor reads ("Type", "Industry", "Study level").
 *
 * The core `I select "X" from "Y"` step only consults the label when Y contains
 * a space; a single-word filter label such as "Type" is looked up as [name=Type]
 * / #Type instead and times out. This step always resolves by label.
 *
 * Example #1: When I select "Workshop" from the "Type" filter
 * Example #2: When I select "Technology" from the "Industry" filter
 * Example #3: And I select "Sciences" from the "Type" filter
 * Example #4: When we select "Conference" from the "Type" filter
 * Example #5: And I select "- Any -" from the "Type" filter
 */
When(/^(?:I |we )*select "([^"]*)" from the "([^"]*)" filter$/, async function (option, label) {
  const form = this.page.locator('form.views-exposed-form');
  const select = form.getByLabel(label, { exact: true });
  try {
    await select.selectOption({ label: option }, { timeout: 5000 });
  } catch (e) {
    throw friendly(
      `Could not choose "${option}" in the "${label}" filter.`,
      `Check the option text matches exactly, and that the exposed filter form has a "${label}" label. ` +
      ((e.message || '').split('\n')[0])
    );
  }
  await smartSettle(this.page, budget(this));
});

/**
 * Resolve a listing card's link by its accessible name.
 *
 * Educare listing cards (News, Events, Programs) place a Bootstrap
 * stretched-link over the whole card: an empty <a> whose only accessible name
 * is its aria-label. It has no text to match and a zero-size box, so neither
 * `I follow "..."` nor a raw click can reach it.
 */
async function cardHref(page, name) {
  return page.evaluate((cardName) => {
    const wanted = cardName.trim().toLowerCase();
    const links = Array.from(document.querySelectorAll('.view a[href]'));
    // A News card's accessible name is "<title> <date>", an Events or Programs
    // card's is just the title, so match on the leading title.
    const hit = links.find((a) => {
      const label = (a.getAttribute('aria-label') || a.textContent || '').trim().toLowerCase();
      return label === wanted || label.startsWith(wanted);
    });
    return hit ? hit.getAttribute('href') : null;
  }, name);
}

/**
 * Assert a listing card links to the page it names — the card is only useful if
 * it reaches the right content.
 *
 * Example #1: Then the "Sustainable Business Forum" card should link to "/events/sustainable-business-forum"
 * Example #2: Then the "Biology" card should link to "/programs/biology"
 * Example #3: And the "Undergraduate Robotics Team Wins Regional Championship" card should link to "/news/undergraduate-robotics-team-wins-regional-championship"
 * Example #4: Then the "Chemistry" card should link to "/programs/chemistry"
 * Example #5: And the "Global Education Forum" card should link to "/events/global-education-forum"
 */
Then(/^the "([^"]*)" card should link to "([^"]*)"$/, async function (name, path) {
  const href = await cardHref(this.page, name);
  if (!href) {
    throw friendly(
      `No listing card named "${name}" was found.`,
      'The card link is an empty stretched-link; its accessible name comes from aria-label.'
    );
  }
  assert.strictEqual(
    href.replace(/^https?:\/\/[^/]+/, ''),
    path,
    `The "${name}" card links to "${href}" instead of "${path}".`
  );
});

/**
 * Open a listing card, following the link the visitor clicks on the card.
 *
 * Navigates to the card link's href instead of clicking it: the stretched-link
 * anchor has a zero-size box, so a real click times out on actionability even
 * though the visitor's click lands on the card's ::after overlay.
 *
 * Example #1: When I open the "Sustainable Business Forum" card
 * Example #2: When I open the "Biology" card
 * Example #3: And I open the "Global Education Forum" card
 * Example #4: When we open the "Chemistry" card
 * Example #5: And I open the "Astrophysics" card
 */
When(/^(?:I |we )*open the "([^"]*)" card$/, async function (name) {
  const href = await cardHref(this.page, name);
  if (!href) {
    throw friendly(
      `No listing card named "${name}" was found.`,
      'Check the card is on the current page of the listing.'
    );
  }
  await this.page.goto(absolute(this, href), { waitUntil: 'domcontentloaded' });
  await smartSettle(this.page, budget(this));
});

/**
 * Assert a meta tag's content, addressed by `name` or `property`.
 *
 * The core metatag step takes a data table of attributes and matches them all,
 * which cannot express "this property has content starting with X". This reads
 * one tag and compares its content.
 *
 * Example #1: Then the "og:title" meta tag should be "Undergraduate Robotics Team Wins Regional Championship"
 * Example #2: Then the "og:type" meta tag should be "article"
 * Example #3: And the "og:site_name" meta tag should be "Educare"
 * Example #4: Then the "description" meta tag should contain "robotics team"
 * Example #5: And the "og:description" meta tag should contain "regional championship"
 */
Then(/^the "([^"]*)" meta tag should (be|contain) "([^"]*)"$/, async function (key, mode, expected) {
  const content = await this.page.evaluate((k) => {
    const el = document.querySelector(`meta[name="${k}"], meta[property="${k}"]`);
    return el ? el.getAttribute('content') : null;
  }, key);
  if (content === null) {
    throw friendly(`No meta tag with name or property "${key}" was rendered.`);
  }
  if (mode === 'be') {
    assert.strictEqual(content, expected, `The "${key}" meta tag is "${content}", expected "${expected}".`);
  } else {
    assert.ok(
      content.toLowerCase().includes(expected.toLowerCase()),
      `The "${key}" meta tag is "${content}", which does not contain "${expected}".`
    );
  }
});

/**
 * Assert the canonical URL ends with a path — the SEO contract for a node's
 * one addressable URL, independent of the host the site is tested on.
 *
 * Example #1: Then the canonical url should end with "/programs/biology"
 * Example #2: Then the canonical url should end with "/events/global-education-forum"
 * Example #3: And the canonical url should end with "/news/undergraduate-robotics-team-wins-regional-championship"
 * Example #4: Then the canonical url should end with "/about"
 * Example #5: And the canonical url should end with "/privacy"
 */
Then(/^the canonical url should end with "([^"]*)"$/, async function (path) {
  const href = await this.page.evaluate(() => {
    const el = document.querySelector('link[rel="canonical"]');
    return el ? el.getAttribute('href') : null;
  });
  if (href === null) throw friendly('No canonical link was rendered.');
  assert.ok(href.endsWith(path), `The canonical url is "${href}", which does not end with "${path}".`);
});

/**
 * Assert the current user is refused a path — the site answers "403 Forbidden"
 * or "404 Not Found" and does not render the requested administrative screen.
 *
 * Asserts the HTTP status, not a message: a template can word "Access denied"
 * any way it likes, but a 200 on an editorial screen is a permission defect.
 *
 * Example #1: Then I should be refused "/admin/content"
 * Example #2: Then I should be refused "/node/add/program"
 * Example #3: And I should be refused "/admin/people"
 * Example #4: Then we should be refused "/admin/structure/taxonomy"
 * Example #5: And I should be refused "/admin/modules"
 */
Then(/^(?:I |we )*should be refused "([^"]*)"$/, async function (path) {
  const response = await this.page.goto(absolute(this, path), { waitUntil: 'domcontentloaded' });
  const status = response ? response.status() : 0;
  assert.ok(
    status === 403 || status === 404,
    `Expected "${path}" to be refused, but the site answered ${status}.`
  );
  await smartSettle(this.page, budget(this));
});

/**
 * Assert the current user may open a path — the site answers 200 and renders it.
 *
 * Pairs with "should be refused" so a permission scenario always carries the
 * positive half: a role that can reach nothing would otherwise pass every
 * refusal assertion.
 *
 * Example #1: Then I should be allowed "/admin/content"
 * Example #2: Then I should be allowed "/node/add/news"
 * Example #3: And I should be allowed "/admin/content/media"
 * Example #4: Then we should be allowed "/node/add/event"
 * Example #5: And I should be allowed "/admin/content/pages"
 */
Then(/^(?:I |we )*should be allowed "([^"]*)"$/, async function (path) {
  const response = await this.page.goto(absolute(this, path), { waitUntil: 'domcontentloaded' });
  const status = response ? response.status() : 0;
  assert.strictEqual(status, 200, `Expected "${path}" to be allowed, but the site answered ${status}.`);
  await smartSettle(this.page, budget(this));
});

/**
 * Assert the document title. varbase-e2e only ships `the page should have a
 * title` (non-empty) and a `wait until the page title contains` wait, so there
 * is no way to state the SEO contract as an assertion.
 *
 * Example #1: Then the page title should contain "Biology"
 * Example #2: Then the page title should contain "Global Education Forum"
 * Example #3: And the page title should contain "Educare"
 * Example #4: Then the page title should contain "News"
 * Example #5: And the page title should contain "About"
 */
Then(/^the page title should contain "([^"]*)"$/, async function (expected) {
  const title = await this.page.title();
  assert.ok(
    title.toLowerCase().includes(expected.toLowerCase()),
    `The page title is "${title}", which does not contain "${expected}".`
  );
});

/** Read the "Showing 1-12 of 38" / "Shown articles: 1-12 of 15" total. */
async function resultTotal(page) {
  return page.evaluate(() => {
    const text = (document.querySelector('.view-header') || document.body).textContent || '';
    const match = text.match(/of\s+(\d+)/);
    return match ? parseInt(match[1], 10) : null;
  });
}

/**
 * Remember how many results the listing reports, so a later step can prove a
 * filter reduced it without hardcoding a total that decays.
 *
 * Example #1: When I remember the result total
 * Example #2: And I remember the result total
 * Example #3: When we remember the result total
 * Example #4: Given I remember the result total
 * Example #5: And we remember the result total
 */
When(/^(?:I |we )*remember the result total$/, async function () {
  const total = await resultTotal(this.page);
  if (total === null) {
    throw friendly('The listing reports no result total.', 'Expected a view header such as "Showing 1-12 of 38".');
  }
  this.educareRememberedTotal = total;
});

/**
 * Assert the listing now reports fewer results than it did — the proof that an
 * applied filter actually filtered.
 *
 * Example #1: Then the result total should be smaller than before
 * Example #2: And the result total should be smaller than before
 * Example #3: Then the result total should be the same as before
 * Example #4: And the result total should be the same as before
 * Example #5: Then the result total should be smaller than before
 */
Then(/^the result total should be (smaller than|the same as) before$/, async function (mode) {
  if (this.educareRememberedTotal == null) {
    throw friendly('No result total was remembered.', 'Add "When I remember the result total" before this step.');
  }
  const total = await resultTotal(this.page);
  if (total === null) throw friendly('The listing reports no result total.');
  if (mode === 'smaller than') {
    assert.ok(
      total < this.educareRememberedTotal,
      `The listing still reports ${total} results, down from ${this.educareRememberedTotal} — the filter did not narrow it.`
    );
  } else {
    assert.strictEqual(
      total, this.educareRememberedTotal,
      `The listing reports ${total} results, was ${this.educareRememberedTotal}.`
    );
  }
});

/**
 * Assert the listing reports at least one result, so a filter scenario cannot
 * pass merely by returning nothing.
 *
 * Example #1: Then the result total should be at least 1
 * Example #2: And the result total should be at least 1
 * Example #3: Then the result total should be at least 5
 * Example #4: And the result total should be at least 2
 * Example #5: Then the result total should be at least 12
 */
Then(/^the result total should be at least (\d+)$/, async function (minimum) {
  const total = await resultTotal(this.page);
  if (total === null) throw friendly('The listing reports no result total.');
  assert.ok(
    total >= parseInt(minimum, 10),
    `The listing reports ${total} results, fewer than the ${minimum} expected.`
  );
});

/**
 * Remember the first card's accessible name, so a keyword scenario can filter
 * on content the listing is actually showing right now. Date-filtered listings
 * change what they show over time; this never goes stale.
 *
 * Example #1: When I remember the first card title
 * Example #2: And I remember the first card title
 * Example #3: When we remember the first card title
 * Example #4: Given I remember the first card title
 * Example #5: And I remember the first card title
 */
When(/^(?:I |we )*remember the first card title$/, async function () {
  const title = await this.page.evaluate(() => {
    const heading = document.querySelector('.view-content h2, .view-content h3, .view-content h4, .view-content h5, .view-content h6');
    return heading ? heading.textContent.trim().replace(/\s+/g, ' ') : null;
  });
  if (!title) {
    throw friendly('The listing shows no cards.', 'Expected at least one card carrying a heading.');
  }
  this.educareFirstCardTitle = title;
});

/**
 * Type the remembered card title into a filter field, then assert the filtered
 * listing still shows it. Together they prove the keyword filter matches the
 * content it is given, whatever that content happens to be today.
 *
 * Example #1: When I fill in "Search by keyword" with the remembered card title
 * Example #2: And I fill in "Search by" with the remembered card title
 * Example #3: When we fill in "Search by keyword" with the remembered card title
 * Example #4: And I fill in "Search by keyword" with the remembered card title
 * Example #5: Given I fill in "Search by" with the remembered card title
 */
When(/^(?:I |we )*fill in "([^"]*)" with the remembered card title$/, async function (label) {
  if (!this.educareFirstCardTitle) {
    throw friendly('No card title was remembered.', 'Add "When I remember the first card title" first.');
  }
  await this.page.getByLabel(label, { exact: true }).fill(this.educareFirstCardTitle);
  await smartSettle(this.page, budget(this));
});

/**
 * Assert the remembered card is still (or no longer) in the listing.
 *
 * Example #1: Then I should see the remembered card title
 * Example #2: And I should see the remembered card title
 * Example #3: Then I should not see the remembered card title
 * Example #4: And I should not see the remembered card title
 * Example #5: Then we should see the remembered card title
 */
Then(/^(?:I |we )*should( not)? see the remembered card title$/, async function (negate) {
  if (!this.educareFirstCardTitle) {
    throw friendly('No card title was remembered.', 'Add "When I remember the first card title" first.');
  }
  const names = await this.page.evaluate(() =>
    Array.from(document.querySelectorAll('.view-content h2, .view-content h3, .view-content h4, .view-content h5, .view-content h6'))
      .map((h) => h.textContent.trim().replace(/\s+/g, ' '))
  );
  const present = names.includes(this.educareFirstCardTitle);
  if (negate) {
    assert.ok(!present, `The listing still shows "${this.educareFirstCardTitle}".`);
  } else {
    assert.ok(present, `The listing no longer shows "${this.educareFirstCardTitle}"; it shows ${JSON.stringify(names)}.`);
  }
});

/**
 * Fill an Event's "When" smartdate range.
 *
 * The widget renders four inputs (start date, start time, end date, end time)
 * whose visible labels are all just "Date" and "Time", repeated again by the
 * authored-on and scheduler fields, so no label-based step can address them.
 * Accepts varbase-e2e relative-date tokens, e.g. "[relative:+7 days#YYYY-MM-DD]".
 *
 * Example #1: When I schedule the event from "2027-03-01" "09:00" to "2027-03-01" "17:00"
 * Example #2: When I schedule the event from "2027-06-15" "10:30" to "2027-06-16" "16:00"
 * Example #3: And I schedule the event from "2027-01-05" "14:00" to "2027-01-05" "15:30"
 * Example #4: When we schedule the event from "2027-09-09" "08:00" to "2027-09-09" "12:00"
 * Example #5: And I schedule the event from "2028-02-02" "11:00" to "2028-02-02" "13:00"
 */
When(/^(?:I |we )*schedule the event from "([^"]*)" "([^"]*)" to "([^"]*)" "([^"]*)"$/,
  async function (startDate, startTime, endDate, endTime) {
    // The smartdate widget renders its duration select and end date at zero size
    // and marks the end date data-hide="1", driving them from its own JS. None of
    // them pass Playwright's visibility check, so locator.fill()/selectOption()
    // time out on a form a human can complete fine. Set the values directly and
    // dispatch the events the widget listens for ("custom" duration is what keeps
    // it from recomputing the end from the start). The assertion that this worked
    // is the rendered Event page, not the form.
    const ok = await this.page.evaluate(({ startDate, startTime, endDate, endTime }) => {
      const set = (id, value) => {
        const el = document.getElementById(id);
        if (!el) return false;
        el.value = value;
        el.dispatchEvent(new Event('input', { bubbles: true }));
        el.dispatchEvent(new Event('change', { bubbles: true }));
        return true;
      };
      const filled = [
        set('edit-field-when-0-time-wrapper-value-date', startDate),
        set('edit-field-when-0-time-wrapper-value-time', startTime),
        set('edit-field-when-0-duration', 'custom'),
        set('edit-field-when-0-time-wrapper-end-value-date', endDate),
        set('edit-field-when-0-time-wrapper-end-value-time', endTime),
      ];
      return filled.every(Boolean);
    }, { startDate, startTime, endDate, endTime });

    if (!ok) {
      throw friendly(
        'The Event "When" smartdate widget is missing one of its inputs.',
        'Expected edit-field-when-0-time-wrapper-{value,end-value}-{date,time} and edit-field-when-0-duration.'
      );
    }
    await smartSettle(this.page, budget(this));
  });

/** Registered CSS/XPath selector for a name, else the name as a raw selector. */
function named(world, name) {
  if (world.__selectorsCss && world.__selectorsCss[name]) return world.__selectorsCss[name];
  if (world.__selectorsXpath && world.__selectorsXpath[name]) return 'xpath=' + world.__selectorsXpath[name];
  return name;
}

/**
 * Auto-retrying visibility assertion on a registered selector name.
 *
 * Example #1: Then the "pagination" should be visible
 * Example #2: Then the "nav toggle" should not be visible
 * Example #3: And the "exposed filters form" should be visible
 * Example #4: Then the "contact form" should be visible within 10 seconds
 * Example #5: And the "share heading" should be visible
 */
Then(/^the "([^"]*)" should( not)? be visible(?: within (\d+) seconds?)?$/, async function (name, negate, seconds) {
  const locator = this.page.locator(named(this, name)).first();
  const timeout = (seconds ? parseInt(seconds, 10) : 5) * 1000;
  try {
    await locator.waitFor({ state: negate ? 'hidden' : 'visible', timeout });
  } catch {
    throw friendly(
      `Expected "${name}" ${negate ? 'not to be' : 'to be'} visible within ${timeout / 1000}s.`,
      `It resolved to the selector "${named(this, name)}".`
    );
  }
});

/**
 * Auto-retrying count assertion on a registered selector name — how many cards
 * a listing rendered, without spelling the component selector out in Gherkin.
 *
 * Example #1: Then the "events cards" should have a count of 12
 * Example #2: Then the "news cards" should have a count of 3
 * Example #3: And the "programs cards" should have a count of 8
 * Example #4: Then the "events cards" should have a count of 0
 * Example #5: And the "news cards" should have a count of 12 within 10 seconds
 */
Then(/^the "([^"]*)" should have a count of (\d+)(?: within (\d+) seconds?)?$/, async function (name, expected, seconds) {
  const locator = this.page.locator(named(this, name));
  const want = parseInt(expected, 10);
  const deadline = Date.now() + (seconds ? parseInt(seconds, 10) : 5) * 1000;
  let count = -1;
  while (Date.now() < deadline) {
    count = await locator.count();
    if (count === want) return;
    await this.page.waitForTimeout(100);
  }
  throw friendly(
    `Expected ${want} "${name}", found ${count}.`,
    `"${name}" resolved to the selector "${named(this, name)}".`
  );
});

/**
 * Assert text is or is not inside a registered region — scoping the assertion so
 * the same words elsewhere on the page cannot stand in for it.
 *
 * Example #1: Then I should see "Quicklinks" in the "footer" region
 * Example #2: Then I should see "News" in the "breadcrumb" region
 * Example #3: And I should not see "Apply Filter" in the "footer" region
 * Example #4: Then I should see "About" in the "site header" region
 * Example #5: And I should see "Location:" in the "main content" region
 */
Then(/^(?:I |we )*should( not)? see "([^"]*)" in the "([^"]*)" region$/, async function (negate, text, name) {
  const locator = this.page.locator(named(this, name)).first();
  try {
    await locator.waitFor({ state: 'attached', timeout: 5000 });
  } catch {
    throw friendly(`The "${name}" region is not on the page.`, `It resolved to "${named(this, name)}".`);
  }
  const content = (await locator.textContent()) || '';
  if (negate) {
    assert.ok(!content.includes(text), `The "${name}" region should not contain "${text}" but it does.`);
  } else {
    assert.ok(content.includes(text), `The "${name}" region does not contain "${text}".`);
  }
});

/**
 * Click a registered control, waiting for it to be actionable first.
 *
 * Example #1: When I click the "nav toggle" control
 * Example #2: And I click the "nav toggle" control
 * Example #3: When we click the "modal close" control
 * Example #4: Given I click the "nav toggle" control
 * Example #5: And I click the "nav toggle" control
 */
When(/^(?:I |we )*click the "([^"]*)" control$/, async function (name) {
  const locator = this.page.locator(named(this, name)).first();
  try {
    await locator.click({ timeout: 10000 });
  } catch (e) {
    throw friendly(
      `Could not click the "${name}" control.`,
      `It resolved to "${named(this, name)}". ` + ((e.message || '').split('\n')[0])
    );
  }
  await smartSettle(this.page, budget(this));
});

/**
 * Open the listing's first card, whichever it is today. Pairs with
 * "I remember the first card title" for date-filtered listings, where naming a
 * card would decay.
 *
 * Example #1: When I open the first card
 * Example #2: And I open the first card
 * Example #3: When we open the first card
 * Example #4: Given I open the first card
 * Example #5: And we open the first card
 */
When(/^(?:I |we )*open the first card$/, async function () {
  const href = await this.page.evaluate(() => {
    const link = document.querySelector('.view-content a[aria-label][href]');
    return link ? link.getAttribute('href') : null;
  });
  if (!href) throw friendly('The listing shows no cards to open.');
  await this.page.goto(absolute(this, href), { waitUntil: 'domcontentloaded' });
  await smartSettle(this.page, budget(this));
});

Before(function () {
  this.assetsFolder = './tests/assets/';
});

/**
 * Dismiss core's autosave_form "restore your draft?" dialog whenever it
 * appears, keeping the feature enabled rather than switching it off for CI.
 *
 * It fires on any node/add or node/edit form once an earlier scenario left a
 * draft behind for the same user + bundle - which several editorial
 * scenarios do, since they create more than one Utility page in the same
 * session. Its jQuery UI overlay covers the whole page and intercepts every
 * click, so every following step times out with no error of its own; the
 * real symptom is invisible unless someone opens a browser and looks.
 * Discarding keeps each scenario's content deterministic either way.
 */
AfterStep(async function () {
  if (!this.page || this.page.isClosed()) return;
  const dialog = this.page.locator('.ui-dialog.autosave-dialog');
  if (await dialog.isVisible().catch(() => false)) {
    await dialog.getByRole('button', { name: 'Discard' }).click().catch(() => {});
  }
});

/**
 * Assert a control identified by its accessible name and role is NOT visible.
 *
 * varbase-e2e ships the positive `the "X" <role> should be visible` but no
 * negative, so there is no way to state that a collapsed menu is closed - the
 * half of a responsive-navigation scenario that proves the collapse works.
 *
 * Example #1: Then the "About" link should not be visible
 * Example #2: Then the "Apply Filter" button should not be visible
 * Example #3: And the "Programs" link should not be visible
 * Example #4: Then the "Reset" button should not be visible
 * Example #5: And the "Contact Us" link should not be visible
 */
Then(/^the "([^"]*)" (button|link|tab|menuitem|checkbox|radio|option) should not be visible(?: within (\d+) seconds?)?$/,
  async function (name, role, seconds) {
    const locator = this.page.getByRole(role, { name, exact: true }).first();
    const deadline = Date.now() + (seconds ? parseInt(seconds, 10) : 5) * 1000;
    while (Date.now() < deadline) {
      const visible = await locator.isVisible().catch(() => false);
      if (!visible) return;
      await this.page.waitForTimeout(100);
    }
    throw friendly(`The "${name}" ${role} is still visible.`);
  });

/**
 * Open a collapsed <details> element on a node form.
 *
 * Drupal puts "URL alias", "Menu settings", "Scheduling options" and friends in
 * closed <details>. Their inputs are in the DOM but not actionable, so
 * `I check "Provide a menu link"` times out, and clicking the <summary> is not
 * reliable either (Claro re-renders it). Setting `open` directly is what the
 * browser does when a user clicks it.
 *
 * Example #1: When I expand the "#edit-menu" details
 * Example #2: And I expand the "#edit-path-0" details
 * Example #3: When we expand the "#edit-scheduler-settings" details
 * Example #4: And I expand the "#edit-author" details
 * Example #5: Given I expand the "#edit-options" details
 */
When(/^(?:I |we )*expand the "([^"]*)" details$/, async function (selector) {
  const present = await this.page.locator(selector).count();
  if (!present) {
    throw friendly(
      `No details element matched "${selector}".`,
      'Pass the details id, e.g. "#edit-menu" or "#edit-path-0".'
    );
  }
  // Claro re-initialises node-form details after load and can close one that was
  // opened too early, so open it, settle, then confirm and reopen if it closed.
  for (let attempt = 0; attempt < 3; attempt++) {
    await this.page.evaluate((sel) => {
      const details = document.querySelector(sel);
      if (!details) return;
      details.open = true;
      details.dispatchEvent(new Event('toggle', { bubbles: true }));
    }, selector);
    await smartSettle(this.page, budget(this));
    const open = await this.page.evaluate((sel) => !!document.querySelector(sel)?.open, selector);
    if (open) return;
  }
  throw friendly(
    `The "${selector}" details would not stay open.`,
    'Something re-closes it after load; open it immediately before using its fields.'
  );
});

/**
 * Verify the Educare header is "working": the main navigation menu, rendered
 * through the Canvas global Header region, carries every primary section.
 *
 * Example #1: Then the page should have a working header
 * Example #2: And the page should have a working header
 * Example #3: Then I should have a working header
 * Example #4: And we should have a working header
 * Example #5: Then the page should have a working header
 */
Then(/^(?:the page should have|(?:I |we )*should have) a working header$/, async function () {
  await smartSettle(this.page, budget(this));
  const header = this.page.getByRole('banner').first();
  const text = (await header.textContent().catch(() => '')) || '';
  const expected = ['About', 'Programs', 'Research', 'Admissions', 'Student Life', 'Events', 'News', 'Contact Us'];
  for (const item of expected) {
    if (!text.includes(item)) {
      throw friendly(`Header is missing the "${item}" link.`, 'Check the Main navigation menu in the Canvas Header region.');
    }
  }
});

/**
 * Verify the Educare footer is "working": the quicklinks, the institution's
 * contact details and the social profiles are all rendered.
 *
 * Example #1: Then the page should have a working footer
 * Example #2: And the page should have a working footer
 * Example #3: Then I should have a working footer
 * Example #4: And we should have a working footer
 * Example #5: Then the page should have a working footer
 */
Then(/^(?:the page should have|(?:I |we )*should have) a working footer$/, async function () {
  await smartSettle(this.page, budget(this));
  const footer = this.page.getByRole('contentinfo').first();
  const text = (await footer.textContent().catch(() => '')) || '';
  const expected = [
    'Subscribe to Our Newsletters', 'Quicklinks',
    'About', 'Programs', 'Admissions', 'Research', 'Student Life', 'News',
  ];
  for (const item of expected) {
    if (!text.includes(item)) {
      throw friendly(`Footer is missing "${item}".`, 'Check the Canvas Footer region and the Secondary menu.');
    }
  }
  for (const network of ['Linkedin', 'Facebook', 'Instagram', 'X-Twitter']) {
    if ((await footer.getByRole('link', { name: network }).count()) === 0) {
      throw friendly(`Footer is missing the ${network} profile link.`, 'Check the Social media menu in the Canvas Footer region.');
    }
  }
});
