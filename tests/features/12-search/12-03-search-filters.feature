@any @regression @search
Feature: Search filters - The filter rail on the /search results page
      As a site visitor
      I want to narrow my search by category, content type and date
      So that I can find the program, news post or event I am after.

  # The rail carries the Category facet, the Content Type facet and the
  # Date Published radios, in that order.
  @check @local @development @staging @production
  Scenario: The filter rail shows the category, content type and date filters
    Given I am an anonymous user
     When I go to "/search?keywords=research"
      And I wait until the page is loaded
     Then the "search category facet" should be visible
      And the "search content type facet" should be visible
      And the "search date filter" should be visible
      And the element "main [data-drupal-facet-id=search_content_type]" should appear after the element "main [data-drupal-facet-id=search_category]"

  # A content type facet narrows the results to that type only.
  @check @local @development @staging @production
  Scenario: The Content Type facet narrows the results
    Given I am an anonymous user
     When I go to "/search?keywords=research"
      And I wait until the page is loaded
      And I remember the result total
      And I filter the search by the "Program" facet item
     Then every search result should be labelled "Program"
      And the result total should be smaller than before

  # A category facet narrows the results, and choosing it again clears it.
  @check @local @development @staging @production
  Scenario: The Category facet narrows the results and resets
    Given I am an anonymous user
     When I go to "/search?keywords=research"
      And I wait until the page is loaded
      And I remember the result total
      And I filter the search by the "Conference" facet item
     Then every search result should be labelled "Event"
      And the result total should be smaller than before
     When I filter the search by the "Conference" facet item
     Then the search results should be counted

  # A Date Published radio submits on change and keeps the keywords.
  @check @local @development @staging @production
  Scenario: The Date Published filter keeps the keywords
    Given I am an anonymous user
     When I go to "/search?keywords=research"
      And I wait until the page is loaded
      And I filter the search by the "Past Year" date
     Then current url should have the "keywords" parameter with the "research" value
      And current url should have the "published" parameter with the "4" value
      And the "search field" should have the value "research"
