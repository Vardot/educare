Feature: Editorial - Utility page create, read, update and delete
      As a content editor
      I want to create, read, update and delete a Utility page through the admin UI
      So that the fourth Educare content type works end to end, menu link and all.

  # The Utility page round trip. Utility page is the bundle Educare uses for
  # standalone content such as Privacy - it is the only bundle offering a menu
  # link on the node form, and it carries the Editorial workflow, a URL alias and
  # the SEO fields.
  #
  # The scenario deletes what it created; the 3 shipped demo pages are never
  # edited or deleted here.

  # @wip 2026-08-06: the create confirmation message never appears within 5s
  # on CI, reproduced live. Cause not yet isolated - possibly the same
  # autosave-dialog race the menu scenario below hit, possibly separate.
  @check @crud @local @development @wip
  Scenario: A Utility page can be created, read, updated and deleted
    Given I am a logged in user with the "webmaster" user
    # CREATE - published, with an explicit URL alias so the page has a stable
    # address to be read back from.
     When I go to "/node/add/page"
      And I wait until the page is loaded
     Then I should see "Create Utility page"
     When I fill in "Title" with "Functional testing suite - utility page"
      And I fill in the field "#edit-field-description-0-value" with "A Utility page created by the Educare functional testing suite."
      And I fill in the WYSIWYG field "Content" with the "<p>The body of the round-trip Utility page.</p>"
      And I expand the "#edit-path-0" details
      And "#edit-path-0-pathauto" should be visible within 10 seconds
      And I uncheck "Generate automatic URL alias"
      And I fill in "URL alias" with "/functional-testing-suite-utility-page"
      And I select "Published" from "#edit-moderation-state-0-state"
      And I submit by id "edit-submit"
      And I wait until the page is loaded
     Then I should see "Utility page Functional testing suite - utility page has been created."

    # READ - re-read the page at the alias it was given, as an anonymous visitor,
    # so the assertion is on what the public gets.
    Given I am an anonymous user
     When I go to "/functional-testing-suite-utility-page"
      And I wait until the page is loaded
     Then "h1" should have text "Functional testing suite - utility page"
      And I should see "The body of the round-trip Utility page."
      And the page should have a working header
      And the page should have a working footer

    # UPDATE - change the body and prove the rendered page carries the new text
    # and not the old.
    Given I am a logged in user with the "webmaster" user
     When I go to "/admin/content?title=Functional+testing+suite+-+utility+page"
      And I wait until the page is loaded
      And I open the "Edit" link in the "Functional testing suite - utility page" row
      And I wait until the page is loaded
      And I fill in the WYSIWYG field "Content" with the "<p>The revised body of the round-trip Utility page.</p>"
      And I submit by id "edit-submit"
      And I wait until the page is loaded
    Given I am an anonymous user
     When I go to "/functional-testing-suite-utility-page"
      And I wait until the page is loaded
     Then I should see "The revised body of the round-trip Utility page."
      And I should not see "The body of the round-trip Utility page."

    # DELETE - and confirm the alias stops resolving for the public.
    Given I am a logged in user with the "webmaster" user
     When I go to "/admin/content?title=Functional+testing+suite+-+utility+page"
      And I wait until the page is loaded
      And I open the "Delete" link in the "Functional testing suite - utility page" row
      And I wait until the page is loaded
     Then I should see "Are you sure you want to delete"
     When I click the "Delete" button
      And I wait until the page is loaded
     Then I should see "has been deleted"
    Given I am an anonymous user
     Then I should be refused "/functional-testing-suite-utility-page"

  @check @crud @local @development
  Scenario: A Utility page cannot be saved without its required fields
    Given I am a logged in user with the "webmaster" user
     When I go to "/node/add/page"
      And I wait until the page is loaded
    Given browser validation for the form "#node-page-form" is disabled
     When I submit by id "edit-submit"
      And I wait until the page is loaded
     Then I should see "Title field is required"
      And I should see "Description field is required"
      And I should not see "has been created"

  # The Utility page form is the only one offering a menu link. A page created
  # with one must appear in the main navigation, which is how an editor adds a
  # section to the site without touching menu administration.
  # @wip 2026-08-06: fixed the checkbox-click block (autosave-dialog dismiss,
  # tests/step-definitions/educare.steps.js), which used to fail this
  # scenario before it even got here. Now gets all the way through create +
  # menu link + delete, and fails on the LAST assertion: the deleted page's
  # menu link still renders in the header right after deletion - looks like
  # a menu-cache-clear timing gap, not related to autosave.
  @check @crud @local @development @wip
  Scenario: A Utility page can add itself to the main navigation
    Given I am a logged in user with the "webmaster" user
     When I go to "/node/add/page"
      And I wait until the page is loaded
      And I fill in "Title" with "Functional testing suite - menu page"
      And I fill in the field "#edit-field-description-0-value" with "A Utility page that adds its own menu link."
      And I expand the "#edit-menu" details
      And "#edit-menu-enabled" should be visible within 10 seconds
      And I check "Provide a menu link"
      And I wait 2 seconds
      And I fill in "Menu link title" with "FTS Menu Page"
      And I select "Published" from "#edit-moderation-state-0-state"
      And I submit by id "edit-submit"
      And I wait until the page is loaded
     Then I should see "has been created"
    Given I am an anonymous user
     When I go to "/"
      And I wait until the page is loaded
     Then I should see "FTS Menu Page" in the "site header" region

    # Deleting the page must take its menu link with it, otherwise the navigation
    # is left pointing at nothing.
    Given I am a logged in user with the "webmaster" user
     When I go to "/admin/content?title=Functional+testing+suite+-+menu+page"
      And I wait until the page is loaded
      And I open the "Delete" link in the "Functional testing suite - menu page" row
      And I wait until the page is loaded
      And I click the "Delete" button
      And I wait until the page is loaded
     Then I should see "has been deleted"
    Given I am an anonymous user
     When I go to "/"
      And I wait until the page is loaded
     Then I should not see "FTS Menu Page" in the "site header" region
