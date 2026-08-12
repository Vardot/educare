@any @regression @content @events
Feature: Events - Events listing
      As a site visitor
      I want an Events listing at /events with cards, a summary and filters
      So that I can browse and narrow down upcoming events.

  # The Educare recipe ships 40 demo Events; the upcoming listing pages 12 at a
  # time under the "Upcoming Events" heading, above a result summary. The view
  # filters on field_when_end_value > now, so both the TOTAL and which events land
  # on page one decay as demo events end. Assert the "1-12" page range and a full
  # page of event cards, never a total or a pinned event title, or the scenario
  # goes red on a date rather than on a defect. A total under 13 still fails,
  # which is the real signal that the demo events have aged out.
  @check @local @development
  Scenario: The events listing shows event cards and a result summary
    Given I am an anonymous user
     When I go to "/events"
      And I wait until the page is loaded
     Then I should see "Upcoming Events"
      And I should see text matching "Showing 1-12 of \d+"
      And ".view-events" should be visible
      And ".view-events .card-dated-vertical__title" should have a count of 12

  # The Events recipe exposes ONLY the keyword ("Search by keyword") and "Type"
  # filters - "Industry" was removed. Assert it is absent so a regression that
  # re-adds it is caught.
  @check @local @development @staging @production
  Scenario: The events listing exposes only the Search by keyword and Type filters
    Given I am an anonymous user
     When I go to "/events"
      And I wait until the page is loaded
     Then "form.views-exposed-form" should be visible
      And I should see "Search by keyword"
      And I should see "Type"
      And I should not see "Industry"
