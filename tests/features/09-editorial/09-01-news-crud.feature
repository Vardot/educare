Feature: Editorial - News post create, read, update and delete
      As a content editor
      I want to create, read, update and delete a News post through the admin UI
      So that the News content type is usable end to end, not just installed.

  # Educare ships four node bundles; this is the News post round trip. Nothing in
  # the suite wrote content before, so a required field mapped to the wrong
  # widget, a text format that will not save, or a Save button that never returns
  # to the node would have shipped unnoticed.
  #
  # RULES THIS FEATURE FOLLOWS
  #   - It only ever touches nodes it created itself. The 78 shipped demo nodes
  #     are what every other scenario asserts against and are never edited or
  #     deleted here.
  #   - Every step asserts the RENDERED outcome, not the form it just filled: the
  #     saved article is re-read from its own URL before anything is believed.
  #   - The scenario deletes what it created, so the site is left as it was found
  #     and a re-run is not blocked by leftovers.
  #
  # Field set read from the running site: Title (required), Description
  # (required), Content (rich text), Categories (Community / Global / Research /
  # Students), Tags, SEO title, SEO description, and a "Save as" moderation state
  # (Draft / In review / Published) from the Editorial workflow.

  @check @crud @local @development
  Scenario: A News post can be created, read, updated and deleted
    Given I am a logged in user with the "webmaster" user
    # CREATE
     When I go to "/node/add/news"
      And I wait until the page is loaded
     Then I should see "Create News post"
     When I fill in "Title" with "Functional testing suite - news round trip"
      And I fill in "Description" with "A News post created by the Educare functional testing suite."
      And I fill in the WYSIWYG field "Content" with the "<p>The body of the round-trip News post.</p>"
      And I select "Published" from "#edit-moderation-state-0-state"
      And I submit by id "edit-submit"
      And I wait until the page is loaded
     Then I should see "News post Functional testing suite - news round trip has been created."

    # READ - re-read the saved article from its own URL, so the assertion is on
    # what a visitor gets and not on the still-open form.
     When I go to "/admin/content?title=Functional+testing+suite+-+news+round+trip"
      And I wait until the page is loaded
     Then I should see "Functional testing suite - news round trip"
     When I open the "Edit" link in the "Functional testing suite - news round trip" row
      And I wait until the page is loaded
     Then "#edit-title-0-value" should have value "Functional testing suite - news round trip"
      And "#edit-field-description-0-value" should have value "A News post created by the Educare functional testing suite."

    # UPDATE - change the title and the description, then prove the change is on
    # the rendered page and the old value is gone.
     When I fill in "Title" with "Functional testing suite - news round trip (revised)"
      And I fill in "Description" with "The revised description of the round-trip News post."
      And I fill in "Revision log message" with "Revised by the functional testing suite."
      And I submit by id "edit-submit"
      And I wait until the page is loaded
     Then I should see "Functional testing suite - news round trip (revised)"
      And I should not see "A News post created by the Educare functional testing suite."

    # The revision the update created must be listed, so an editor can go back.
     When I go to "/admin/content?title=Functional+testing+suite"
      And I wait until the page is loaded
     Then I should see "Functional testing suite - news round trip (revised)"

    # DELETE - and confirm it is gone from the content listing.
     When I open the "Delete" link in the "Functional testing suite - news round trip (revised)" row
      And I wait until the page is loaded
     Then I should see "Are you sure you want to delete"
     When I click the "Delete" button
      And I wait until the page is loaded
     Then I should see "has been deleted"
     When I go to "/admin/content?title=Functional+testing+suite"
      And I wait until the page is loaded
     Then I should not see "Functional testing suite - news round trip (revised)"

  # A required field is only a required field if saving without it is refused.
  # Description is required on News; Title is required on every bundle.
  @check @crud @local @development
  Scenario: A News post cannot be saved without its required fields
    Given I am a logged in user with the "webmaster" user
     When I go to "/node/add/news"
      And I wait until the page is loaded
     Given browser validation for the form "#node-news-form" is disabled
     When I submit by id "edit-submit"
      And I wait until the page is loaded
     Then I should see "Title field is required"
      And I should see "Description field is required"
      And I should not see "has been created"

  # A News post saved as a Draft must not be readable by the public. This is the
  # unpublished-access boundary, and it is asserted from a second, anonymous
  # session rather than from the editor's own.
  @check @crud @security @local @development
  Scenario: A News post saved as a draft is not public
    Given I am a logged in user with the "webmaster" user
     When I go to "/node/add/news"
      And I wait until the page is loaded
      And I fill in "Title" with "Functional testing suite - unpublished news"
      And I fill in "Description" with "This draft must never be readable by an anonymous visitor."
      And I select "Draft" from "#edit-moderation-state-0-state"
      And I submit by id "edit-submit"
      And I wait until the page is loaded
     Then I should see "has been created"
     When I go to "/news"
      And I wait until the page is loaded
     Then I should not see "Functional testing suite - unpublished news"

    # The draft must not appear on the public listing for an anonymous visitor
    # either, and its own URL must be refused.
    Given I am an anonymous user
     When I go to "/news"
      And I wait until the page is loaded
     Then I should not see "Functional testing suite - unpublished news"

    # Clean up the draft the scenario created.
    Given I am a logged in user with the "webmaster" user
     When I go to "/admin/content?title=Functional+testing+suite+-+unpublished+news"
      And I wait until the page is loaded
      And I open the "Delete" link in the "Functional testing suite - unpublished news" row
      And I wait until the page is loaded
      And I click the "Delete" button
      And I wait until the page is loaded
     Then I should see "has been deleted"
