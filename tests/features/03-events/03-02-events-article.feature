Feature: Events - Event page
      As a site visitor
      I want an Event page with its title, details and related events
      So that I can read about an event and find more.

  # An Event full page renders its title and body, a date/location details card
  # and an "Events You May Also Like" related section - it must NOT render as an
  # empty content region (the Canvas full template regression).
  @check @local @development @staging @production
  Scenario: An event page renders its title, details and related events
    Given I am an anonymous user
     When I go to "/events/global-education-forum"
      And I wait until the page is loaded
     Then the page should have a main landmark
      And I should see "Global Education Forum"
      And I should see "Location:"
      And I should see "Events You May Also Like"

  @check @local @development @staging @production
  Scenario: An event page links back to the Events section
    Given I am an anonymous user
     When I go to "/events/global-education-forum"
      And I wait until the page is loaded
     Then "nav[aria-label='breadcrumb']" should be visible
      And "nav[aria-label='breadcrumb'] a[href='/events']" should have a count of 1
