Feature: Events - Events listing
      As a site visitor
      I want an Events listing at /events with cards, a summary and filters
      So that I can browse and narrow down upcoming events.

  # The Educare recipe ships 40 demo Events; the upcoming listing pages 12 at a
  # time under the "Upcoming Events" heading, above a result summary. The summary
  # range "Showing 1-12 of 39" asserts the 12-per-page paging deterministically.
  @check @local @development
  Scenario: The events listing shows event cards and a result summary
    Given I am an anonymous user
     When I go to "/events"
      And I wait until the page is loaded
     Then I should see "Upcoming Events"
      And I should see text matching "Showing 1-12 of 39"
      And I should see "Global Education Forum"

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
