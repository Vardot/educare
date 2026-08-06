Feature: News - Filtering and paging the news listing
      As a site visitor
      I want to narrow the News listing with its filters and page through the rest
      So that I can find the story I am looking for instead of scrolling 15 articles.

  # The existing 02-01 scenarios reach the filtered listing by typing the query
  # string into the URL, which proves the view's filter handlers but never the
  # form the visitor actually uses. These scenarios drive the exposed form:
  # fill the field, press Apply Filter, and check the listing narrowed.
  #
  # Every filter scenario pairs a positive with a negative: the matching article
  # stays and a known non-matching one drops out, so an exposed filter that
  # silently stopped filtering (returning everything) fails.
  #
  # No absolute result total is asserted anywhere. Totals are counts of shipped
  # demo content, which changes when the recipe's default content changes; the
  # page RANGE ("1-12") is pager configuration and is safe. Where a filter has to
  # be shown to have narrowed the listing, the total is compared against the
  # listing's own earlier value instead.

  @check @local @development
  Scenario: Typing a keyword and applying it narrows the news listing
    Given I am an anonymous user
     When I go to "/news"
      And I wait until the page is loaded
      And I remember the result total
     Then I should see text matching "Shown articles: 1-12 of \d+"
     When I fill in "Search by" with "robotics"
      And I click the "Apply Filter" button
      And I wait until the page is loaded
     Then the result total should be smaller than before
      And the result total should be at least 1
      And I should see "Undergraduate Robotics Team Wins Regional Championship"
      And I should not see "Community Clean-Up Day Draws Record Volunteer Turnout"

  # The Industry filter is a taxonomy select on the News listing. Choosing
  # Technology must leave only the two Technology articles.
  @check @local @development
  Scenario: Choosing an Industry narrows the news listing to that industry
    Given I am an anonymous user
     When I go to "/news"
      And I wait until the page is loaded
      And I remember the result total
     When I select "Technology" from the "Industry" filter
      And I click the "Apply Filter" button
      And I wait until the page is loaded
     Then the result total should be smaller than before
      And the result total should be at least 1
      And I should see "Undergraduate Robotics Team Wins Regional Championship"
      And I should not see "Community Clean-Up Day Draws Record Volunteer Turnout"

  # The Type filter is the second taxonomy select. Research must leave only the
  # four Research articles - and none of the Community ones.
  @check @local @development
  Scenario: Choosing a Type narrows the news listing to that type
    Given I am an anonymous user
     When I go to "/news"
      And I wait until the page is loaded
      And I remember the result total
     When I select "Research" from the "Type" filter
      And I click the "Apply Filter" button
      And I wait until the page is loaded
     Then the result total should be smaller than before
      And the result total should be at least 1
      And I should see "Chemistry Department Publishes Breakthrough Study on Clean Water Filtration"
      And I should not see "Community Clean-Up Day Draws Record Volunteer Turnout"

  # Reset must clear the filter and restore the full listing, otherwise a
  # visitor who mis-filters is stranded.
  @check @local @development
  Scenario: Reset clears an applied filter and restores the full news listing
    Given I am an anonymous user
     When I go to "/news"
      And I wait until the page is loaded
      And I remember the result total
      And I fill in "Search by" with "robotics"
      And I click the "Apply Filter" button
      And I wait until the page is loaded
     Then the result total should be smaller than before
     When I click the "Reset" button
      And I wait until the page is loaded
     Then the result total should be the same as before
      And the "news cards" should have a count of 12

  # The listing pages 12 at a time - pager configuration, not content - so the
  # ranges are stable whatever the total. Which articles land on page two is not
  # asserted: every demo article shares one authored date, so the order across
  # the page boundary is not stable.
  @check @local @development
  Scenario: The news listing pages the remaining articles onto a second page
    Given I am an anonymous user
     When I go to "/news"
      And I wait until the page is loaded
     Then the "pagination" should be visible
      And the "news cards" should have a count of 12
     When I click on the link with the title "Go to page 2"
      And I wait until the page is loaded
     Then I should see text matching "Shown articles: 13-\d+ of \d+"
      And the "news cards" should have a count of 3

  # A card is only useful if it reaches its article. Assert the card links to
  # the article's own path, then open it and confirm the article page answers
  # with that title.
  @check @local @development
  Scenario: A news card opens the article it names
    Given I am an anonymous user
     When I go to "/news?search=robotics"
      And I wait until the page is loaded
     Then the "Undergraduate Robotics Team Wins Regional Championship" card should link to "/news/undergraduate-robotics-team-wins-regional-championship"
     When I open the "Undergraduate Robotics Team Wins Regional Championship" card
     Then "h1" should have text "Undergraduate Robotics Team Wins Regional Championship"
      And I should see "Stories you may also like"
