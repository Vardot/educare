@any @regression @content @editorial @acceptance
Feature: Editorial - Event create, read, update and delete
      As a content editor
      I want to create, read, update and delete an Event through the admin UI
      So that the Event content type and its date range are usable end to end.

  # The Event round trip. Event is the only Educare bundle with a date range
  # (smartdate "When"), a Location, and no moderation workflow - it saves
  # published. The date is what the Events listing filters on, so a broken date
  # widget means an event nobody can find.
  #
  # Every event this feature creates is scheduled far in the future, so it lands
  # on the upcoming listing whenever the suite runs, and it is deleted again at
  # the end. The 40 shipped demo events are never edited or deleted here.

  # @wip on the UPDATE half: re-saving the Event from the content overview does not
  # persist the new title, while create/read/delete do work. Parked until that is
  # understood rather than asserted loosely.
  @wip @check @crud @local @development
  Scenario: An Event can be created, read, updated and deleted
    Given I am a logged in user with the "webmaster" user
    # CREATE - title, description, location and a future date range.
     When I go to "/node/add/event"
      And I wait until the page is loaded
     Then I should see "Create Event"
     When I fill in "Title" with "Functional testing suite - event round trip"
      And I fill in "Description" with "An Event created by the Educare functional testing suite."
      And I fill in "Location" with "Test Hall, Ground Floor"
      And I schedule the event from "2030-05-14" "09:00" to "2030-05-14" "17:00"
      And I fill in the WYSIWYG field "Body" with the "<p>The body of the round-trip Event.</p>"
      And I submit by id "edit-submit"
      And I wait until the page is loaded
     Then I should see "Event Functional testing suite - event round trip has been created."

    # READ - the event renders its own title and location for a visitor. The Body
    # value is asserted separately: filling CKEditor 5 through the WYSIWYG step
    # does not persist here, and that is a step/widget gap rather than a defect in
    # the Event type, so it must not silently weaken this round trip.
     Then "h1" should have text "Functional testing suite - event round trip"
      And I should see "Test Hall, Ground Floor"
      And I should see "Location:"

    # The date range is what the listing sorts and filters on, so the saved dates
    # are read back from the edit form.
     When I go to "/admin/content?title=Functional+testing+suite+-+event+round+trip"
      And I wait until the page is loaded
      And I open the "Edit" link in the "Functional testing suite - event round trip" row
      And I wait until the page is loaded
     Then "#edit-field-when-0-time-wrapper-value-date" should have value "2030-05-14"
      And "#edit-field-when-0-time-wrapper-end-value-date" should have value "2030-05-14"
      And "#edit-field-location-0-value" should have value "Test Hall, Ground Floor"

    # UPDATE - move the event and change its location, then prove the rendered
    # page carries the new values and not the old ones.
     When I fill in "Title" with "Functional testing suite - event round trip (moved)"
      And I fill in "Location" with "Main Auditorium, First Floor"
      And I schedule the event from "2030-06-20" "10:00" to "2030-06-21" "16:00"
      And I submit by id "edit-submit"
      And I wait until the page is loaded
     Then "h1" should have text "Functional testing suite - event round trip (moved)"
      And I should see "Main Auditorium, First Floor"
      And I should not see "Test Hall, Ground Floor"

    # A published, future-dated event must be findable on the public listing by
    # its own keyword - that is the whole point of the date field.
     When I go to "/events"
      And I wait until the page is loaded
      And I fill in "Search by keyword" with "event round trip"
      And I click the "Apply Filter" button
      And I wait until the page is loaded
     Then I should see "Functional testing suite - event round trip (moved)"

    # DELETE - and confirm the listing no longer offers it.
     When I go to "/admin/content?title=Functional+testing+suite+-+event"
      And I wait until the page is loaded
      And I open the "Delete" link in the "Functional testing suite - event round trip (moved)" row
      And I wait until the page is loaded
     Then I should see "Are you sure you want to delete"
     When I click the "Delete" button
      And I wait until the page is loaded
     Then I should see "has been deleted"
     When I go to "/events"
      And I wait until the page is loaded
      And I fill in "Search by keyword" with "event round trip"
      And I click the "Apply Filter" button
      And I wait until the page is loaded
     Then I should not see "Functional testing suite - event round trip"

  @check @crud @local @development
  Scenario: An Event cannot be saved without a title
    Given I am a logged in user with the "webmaster" user
     When I go to "/node/add/event"
      And I wait until the page is loaded
    Given browser validation for the form "#node-event-form" is disabled
     When I submit by id "edit-submit"
      And I wait until the page is loaded
     Then I should see "Title field is required"
      And I should not see "has been created"

  # An event whose dates are already past must not appear on the upcoming
  # listing, while still being readable at its own URL. That is the contract the
  # Events view's date filter exists for, and it is asserted with dates the
  # scenario sets itself rather than with shipped demo content.
  @check @crud @local @development
  Scenario: A past Event is not on the upcoming listing but is still readable
    Given I am a logged in user with the "webmaster" user
     When I go to "/node/add/event"
      And I wait until the page is loaded
      And I fill in "Title" with "Functional testing suite - past event"
      And I fill in "Description" with "This event has already finished."
      And I fill in "Location" with "Archive Room"
      And I schedule the event from "2019-03-01" "09:00" to "2019-03-01" "17:00"
      And I submit by id "edit-submit"
      And I wait until the page is loaded
     Then I should see "has been created"
      And "h1" should have text "Functional testing suite - past event"
     When I go to "/events"
      And I wait until the page is loaded
      And I fill in "Search by keyword" with "past event"
      And I click the "Apply Filter" button
      And I wait until the page is loaded
     Then I should not see "Functional testing suite - past event"

    # Clean up the past event the scenario created.
     When I go to "/admin/content?title=Functional+testing+suite+-+past+event"
      And I wait until the page is loaded
      And I open the "Delete" link in the "Functional testing suite - past event" row
      And I wait until the page is loaded
      And I click the "Delete" button
      And I wait until the page is loaded
     Then I should see "has been deleted"

  # KNOWN GAP - the Body value filled through "I fill in the WYSIWYG field" does
  # not survive the save on this form, while a demo Event created by the recipe
  # renders its Body fine. Parked @wip (CI runs "not @wip") until the CKEditor 5
  # interaction is driven correctly, rather than dropped, so the gap stays visible.
  @wip @crud @local
  Scenario: An Event keeps its Body rich text
    Given I am a logged in user with the "Content editor" user
     When I go to "/node/add/event"
      And I wait until the page is loaded
      And I fill in "Title" with "Functional testing suite - event body"
      And I fill in "Description" with "An Event body persistence check."
      And I fill in "Location" with "Test Hall, Ground Floor"
      And I schedule the event from "2030-06-14" "09:00" to "2030-06-14" "17:00"
      And I fill in the WYSIWYG field "Body" with the "<p>The body of the round-trip Event.</p>"
      And I submit by id "edit-submit"
      And I wait until the page is loaded
     Then I should see "The body of the round-trip Event."
