@any @regression @search
Feature: Search content types and combined filters - Every indexed type renders and the filters work together
      As a site visitor
      I want every program, news post, event and page to show as a proper result, and the filters to combine
      So that I can trust the results page whatever I search for and however I narrow it.

  # One result card per indexed content type, each with its label and its own link.
  @check @local @development @staging @production
  Scenario Outline: A <label> result renders as a card with its label and a link
    Given I am an anonymous user
     When I go to "/search?keywords=the&f[0]=content_type:<type>"
      And I wait until the page is loaded
     Then every search result should be labelled "<label>"
      And ".view-search .views-row:not(:has(a.stretched-link[href^='<prefix>']))" should have a count of 0
      And ".view-search .views-row h2:empty" should have a count of 0
      And I should not see "LogicException"
      And I should not see "Requested delta"
      And I should not see "The website encountered an unexpected error"

    Examples:
      | type    | label   | prefix     |
      | program | Program | /programs/ |
      | news    | News    | /news/     |
      | event   | Event   | /events/   |
      | page    | Page    | /          |

  @check @local @development @staging @production
  Scenario: Two Content Type boxes together list both types and keep the keyword
    Given I am an anonymous user
     When I go to "/search?keywords=the"
      And I wait until the page is loaded
      And I click on the element "#content-type-news"
      And I wait until the URL contains "content_type"
      And I wait until the page is loaded
      And I click on the element "#content-type-page"
      And I wait until the URL contains "page"
      And I wait until the page is loaded
     Then "#content-type-page:checked" should have a count of 1 within 10 seconds
      And "#content-type-news:checked" should have a count of 1
      And current url should have the "keywords" parameter with the "the" value
      And the "search rows" should have a count of 2
      And ".view-search .views-row a.stretched-link[href^='/news/']" should be attached
      And ".view-search .views-row a.stretched-link[href='/privacy']" should be attached

  @check @local @development @staging @production
  Scenario: A Category box and a Content Type box combine
    Given I am an anonymous user
     When I go to "/search?keywords=the&f[0]=category:Conference&f[1]=content_type:event"
      And I wait until the page is loaded
     Then "#category-conference:checked" should have a count of 1
      And "#content-type-event:checked" should have a count of 1
      And every search result should be labelled "Event"

  @check @local @development @staging @production
  Scenario: A new keyword keeps the chosen date
    Given I am an anonymous user
     When I go to "/search?keywords=the&published=4"
      And I wait until the page is loaded
      And I refine the search to "research"
     Then current url should have the "keywords" parameter with the "research" value
      And current url should have the "published" parameter with the "4" value

  # Known gap: the keyword form does not carry f[], so a new keyword drops the facet.
  @wip @check @local @development @staging @production
  Scenario: A new keyword keeps the ticked Content Type
    Given I am an anonymous user
     When I go to "/search?keywords=the&f[0]=content_type:program"
      And I wait until the page is loaded
      And I refine the search to "research"
     Then the url should match "content_type"

  @check @local @development @staging @production
  Scenario: Paging moves the range on and keeps the keyword
    Given I am an anonymous user
     When I go to "/search?keywords=the"
      And I wait until the page is loaded
      And I click on the link with the title "Go to page 2"
      And I wait until the URL contains "page=1"
     Then current url should have the "keywords" parameter with the "the" value
      And I should see text matching "Showing 11-\d+ of \d+"

  @check @local @development @staging @production
  Scenario: The search page with no keyword renders without results or errors
    Given I am an anonymous user
     When I go to "/search"
      And I wait until the page is loaded
     Then "main h1" should have a count of 1
      And the "search field" should have the value ""
      And the "search rows" should have a count of 0
      And I should not see "Page not found"

  @check @local @development @staging @production
  Scenario: The header search closes again with its close button
    Given I am an anonymous user
     When I go to "/"
      And I wait until the page is loaded
      And I click on the element "header[role=banner] .icon-toggle__button"
     Then the "header search field" should be visible within 10 seconds
      And "header[role=banner] .icon-toggle__panel label.visually-hidden" should have text "Search the site"
     When I click on the element "header[role=banner] .icon-toggle__close"
     Then "header[role=banner] .icon-toggle__panel" should be hidden within 10 seconds
      And the "header search toggle" should be visible

  @check @local @development @staging @production
  Scenario Outline: The results page works <width> pixels wide
    Given I am an anonymous user
     When I set the viewport to <width> by <height>
      And I go to "/search?keywords=the"
      And I wait until the page is loaded
     Then the "search field" should be visible
      And "main [data-drupal-facet-id='search_category'] .facets-checkbox" should be visible
      And "main [data-drupal-facet-id='search_content_type'] .facets-checkbox" should be visible
      And the "search date filter" should be visible
      And ".view-search .views-row" should be visible
      And "main nav[aria-label='Pagination']" should be visible
      And there should be no JavaScript errors

    Examples:
      | width | height |
      | 1440  | 900    |
      | 390   | 844    |

  @check @a11y @local @development @staging @production
  Scenario: The filtered results page is labelled and structured
    Given I am an anonymous user
     When I go to "/search?keywords=the&f[0]=content_type:program"
      And I wait until the page is loaded
     Then every form field should have an accessible label
      And the page should have exactly one h1
      And the heading hierarchy should be valid
      And the page should have no serious accessibility violations
