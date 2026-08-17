@any @regression @search
Feature: Header search - The search toggle in the site header
      As a site visitor
      I want a search control in the header of every page
      So that I can start a search from wherever I am, without the box taking
      room from the navigation until I ask for it.

  # The Canvas global Header region places an Icon Toggle carrying the search
  # view's exposed form. At rest only the icon shows: the panel is a Bootstrap
  # dropdown menu, so it is in the DOM but not displayed.
  @check @local @development @staging @production
  Scenario: The header carries a search toggle that starts collapsed
    Given I am an anonymous user
     When I go to "/"
      And I wait until the page is loaded
     Then the "header search toggle" should be visible
      And the "header search field" should not be visible

  # The panel is the only thing that changes - the main navigation stays put.
  @check @local @development @staging @production
  Scenario: Opening the toggle reveals the search field and keeps the menu
    Given I am an anonymous user
     When I go to "/"
      And I wait until the page is loaded
      And I click on the element "header[role=banner] .icon-toggle__button"
     Then the "header search field" should be visible within 10 seconds
      And the "main nav" should be visible

  # Every page carries the header, so the toggle has to be there on a listing
  # and on a content page too, not only on the front page.
  @check @local @development @staging @production
  Scenario Outline: The search toggle is present on the <name> page
    Given I am an anonymous user
     When I go to "<path>"
      And I wait until the page is loaded
     Then the "header search toggle" should be visible

    Examples:
      | name     | path      |
      | News     | /news     |
      | Events   | /events   |
      | Programs | /programs |
      | Privacy  | /privacy  |

  # Submitting from the header has to land on the results page and carry the
  # query with it, so the results page opens already filtered.
  @check @local @development @staging @production
  Scenario: Searching from the header lands on the results page with the query
    Given I am an anonymous user
     When I go to "/"
      And I wait until the page is loaded
      And I search the header for "education"
     Then the path should be "/search"
      And current url should have the "keywords" parameter with the "education" value
      And the "search view" should be visible

  # The toggle is a button with an accessible name, not a bare icon.
  @check @a11y @local @development @staging @production
  Scenario: The search toggle is reachable by its accessible name
    Given I am an anonymous user
     When I go to "/"
      And I wait until the page is loaded
     Then the "Search" button should be visible
      And the element "header[role=banner] .icon-toggle__button" with the attribute "aria-expanded" and the value "false" should exist
