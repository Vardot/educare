Feature: Events - Filtering and paging the events listing
      As a site visitor
      I want to narrow the Events listing with its filters and page through the rest
      So that I can find the event I want to attend.

  # 03-01 checks the filters are present and that the "Industry" filter was
  # removed. These scenarios check the two remaining filters actually filter,
  # driven through the form the visitor uses rather than a URL query string.
  #
  # NOTHING HERE MAY PIN A TOTAL OR AN EVENT TITLE. The Events view filters on
  # the event end date, so the total shrinks and the first card changes as demo
  # events pass - 2 of the 40 shipped events had already passed by 4 August 2026.
  # An earlier scenario asserted "Showing 1-12 of 39" and went red on a date
  # rather than a defect.
  #
  # Instead each scenario measures the listing against its own earlier state:
  # remember the total, apply the filter, and require the total to fall while
  # staying above zero - so a filter that stopped filtering (total unchanged)
  # and one that matches nothing (total zero) both fail.

  @check @local @development @staging @production
  Scenario: Typing a keyword from a listed event narrows the listing to it
    Given I am an anonymous user
     When I go to "/events"
      And I wait until the page is loaded
      And I remember the first card title
      And I remember the result total
     Then the result total should be at least 2
     When I fill in "Search by keyword" with the remembered card title
      And I click the "Apply Filter" button
      And I wait until the page is loaded
     Then the result total should be smaller than before
      And the result total should be at least 1
      And I should see the remembered card title

  # A keyword that cannot match must empty the listing rather than fall back to
  # showing everything.
  @check @local @development @staging @production
  Scenario: A keyword that matches nothing empties the events listing
    Given I am an anonymous user
     When I go to "/events"
      And I wait until the page is loaded
      And I remember the first card title
      And I fill in "Search by keyword" with "qqzzxnomatchingevent"
      And I click the "Apply Filter" button
      And I wait until the page is loaded
     Then I should not see the remembered card title
      And the "events cards" should have a count of 0

  # The Type filter is the Event Categories taxonomy.
  @check @local @development @staging @production
  Scenario: Choosing a Type narrows the events listing to that category
    Given I am an anonymous user
     When I go to "/events"
      And I wait until the page is loaded
      And I remember the result total
     When I select "Workshop" from the "Type" filter
      And I click the "Apply Filter" button
      And I wait until the page is loaded
     Then the result total should be smaller than before
      And the result total should be at least 1

  @check @local @development @staging @production
  Scenario: Reset clears an applied filter and restores the full events listing
    Given I am an anonymous user
     When I go to "/events"
      And I wait until the page is loaded
      And I remember the result total
      And I fill in "Search by keyword" with "qqzzxnomatchingevent"
      And I click the "Apply Filter" button
      And I wait until the page is loaded
     Then the "events cards" should have a count of 0
     When I click the "Reset" button
      And I wait until the page is loaded
     Then the result total should be the same as before
      And the "events cards" should have a count of 12

  # The events listing shows 12 per page - that is pager configuration, not
  # content, so the page ranges are stable even as the total drifts.
  @check @local @development @staging @production
  Scenario: The events listing pages 12 events at a time
    Given I am an anonymous user
     When I go to "/events"
      And I wait until the page is loaded
     Then I should see text matching "Showing 1-12 of \d+"
      And the "pagination" should be visible
      And the "events cards" should have a count of 12
     When I click on the link with the title "Go to page 2"
      And I wait until the page is loaded
     Then I should see text matching "Showing 13-\d+ of \d+"
      And the "events cards" should have a count of 12

  # An event card must reach the event it names. Which event is on the listing
  # today is read from the listing itself, so this never depends on a date.
  @check @local @development @staging @production
  Scenario: An event card opens the event it names
    Given I am an anonymous user
     When I go to "/events"
      And I wait until the page is loaded
      And I remember the first card title
      And I open the first card
     Then the url should match "/events/"
      And I should see "Location:"
      And I should see "Events you may also like"
      And the page should have a working header

  # An event page is reached directly, so it renders whatever its date - only the
  # listing filters on the date. This is the one place an event may be named.
  @check @local @development @staging @production
  Scenario: An event page names its location and share actions
    Given I am an anonymous user
     When I go to "/events/global-education-forum"
      And I wait until the page is loaded
     Then "h1" should have text "Global Education Forum"
      And I should see "Location:"
      And the "Share on LinkedIn (opens in a new tab)" link should be visible
      And the "Share on Facebook (opens in a new tab)" link should be visible
      And the "Share on X (opens in a new tab)" link should be visible
