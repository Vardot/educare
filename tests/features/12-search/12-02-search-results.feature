@any @regression @search
Feature: Search results - The /search results page
      As a site visitor
      I want the search results page to lead with its own heading and search box
      So that I can read what I searched for, refine it in place, and open any
      result from a single, unambiguous link.

  # Drupal Canvas owns the content region, so no page title block runs on this
  # route: the search view component prints the view title as the page <h1>.
  # Exactly one - a second one would break the heading order for everybody.
  @check @a11y @local @development @staging @production
  Scenario: The results page carries exactly one first-level heading
    Given I am an anonymous user
     When I go to "/search?keywords=education"
      And I wait until the page is loaded
     Then the "search page heading" should be visible
      And "main h1" should have a count of 1

  # The box has to be on the page itself, not only in the header panel, and it
  # has to sit under the heading and above the result count.
  @check @local @development @staging @production
  Scenario: The filter bar renders inline, between the heading and the summary
    Given I am an anonymous user
     When I go to "/search?keywords=education"
      And I wait until the page is loaded
     Then the "search filter bar" should be visible
      And the "search field" should be visible
      And the "search submit" should be visible
      And the element ".view-search .view-filters" should appear after the element ".view-search h1"
      And the element ".view-search .view-header" should appear after the element ".view-search .view-filters"

  # The box arrives filled in with what was searched for, so refining is an
  # edit rather than a retype.
  @check @local @development @staging @production
  Scenario: The inline search box carries the current query
    Given I am an anonymous user
     When I go to "/search?keywords=education"
      And I wait until the page is loaded
     Then the "search field" should have the value "education"

  # The result summary the view header carries.
  @check @local @development @staging @production
  Scenario: The results page states how many results it is showing
    Given I am an anonymous user
     When I go to "/search?keywords=education"
      And I wait until the page is loaded
     Then the search results should be counted

  # The index holds both nodes and Canvas pages and the view ships a title
  # field per entity type, so a row must never print an empty second heading
  # or offer the same destination twice.
  @check @local @development @staging @production
  Scenario: Every result row has one heading and one link
    Given I am an anonymous user
     When I go to "/search?keywords=education"
      And I wait until the page is loaded
      And I remember the result total
     Then every search result row should have one heading and one link

  # Refining from the results page has to work the same way as from the header.
  @check @local @development @staging @production
  Scenario: Refining the query from the results page re-runs the search
    Given I am an anonymous user
     When I go to "/search?keywords=education"
      And I wait until the page is loaded
      And I remember the result total
      And I refine the search to "scholarship"
     Then current url should have the "keywords" parameter with the "scholarship" value
      And the "search field" should have the value "scholarship"
      And the result total should be smaller than before

  # A query that matches nothing has to say so, in a readable notice rather
  # than a blank content region.
  @check @local @development @staging @production
  Scenario: A query with no matches shows a readable empty state
    Given I am an anonymous user
     When I go to "/search?keywords=xylophone+kumquat+zeppelin"
      And I wait until the page is loaded
     Then the "search page heading" should be visible
      And the "search filter bar" should be visible
      And the "search empty notice" should be visible
      And the "search rows" should have a count of 0

  # The results page is a normal page of the site: header and footer are whole.
  @check @local @development @staging @production
  Scenario: The results page keeps the site header and footer
    Given I am an anonymous user
     When I go to "/search?keywords=education"
      And I wait until the page is loaded
     Then the page should have a working header
      And the page should have a working footer
