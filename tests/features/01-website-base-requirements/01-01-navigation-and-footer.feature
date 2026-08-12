@any @regression @smoke @content
Feature: Website Base Requirements - Main navigation and footer
      As a site visitor
      I want the main navigation and footer to name and reach every section
      So that I can move around the site without guessing at URLs.

  # 01-00 checks each page exposes a navigation landmark. That passes on an
  # empty <nav>. These scenarios check the navigation is populated: every main
  # menu item the recipe ships is present as a link to its own section, so a
  # menu link lost when the recipe is re-applied fails here.
  #
  # Each item is asserted as a link with an href, not as page text: "Research"
  # appears in body copy on several pages, and a heading is not a way to
  # navigate.

  @check @local @development @staging @production
  Scenario Outline: The main navigation links to the <name> section
    Given I am an anonymous user
     When I go to "/"
      And I wait until the page is loaded
     Then the link "<name>" with the href "<path>" within the element "header[role='banner']" should exist

    Examples: Main menu
      | name         | path          |
      | About        | /about        |
      | Programs     | /programs     |
      | Research     | /research     |
      | Admissions   | /admissions   |
      | Student Life | /student-life |
      | Events       | /events       |
      | News         | /news         |
      | Contact Us   | /contact-us   |

  # The header navigation is global: it is rendered from the Canvas Header
  # region, so it must be the same on an interior page as on the home page. A
  # regression that renders the menu only on the front page fails here.
  @check @local @development @staging @production
  Scenario: The main navigation is the same on an interior page
    Given I am an anonymous user
     When I go to "/programs/biology"
      And I wait until the page is loaded
     Then the link "About" with the href "/about" within the element "header[role='banner']" should exist
      And the link "Events" with the href "/events" within the element "header[role='banner']" should exist
      And the link "Contact Us" with the href "/contact-us" within the element "header[role='banner']" should exist

  # The footer carries a Quicklinks column repeating the main sections, the
  # institution's contact details and the social profiles. Each is asserted
  # inside the footer landmark so a match in page copy cannot stand in for it.
  @check @local @development @staging @production
  Scenario: The footer repeats the main sections as quicklinks
    Given I am an anonymous user
     When I go to "/"
      And I wait until the page is loaded
     Then I should see "Quicklinks" in the "footer" region
      And the link "About" with the href "/about" within the element "footer[role='contentinfo']" should exist
      And the link "Programs" with the href "/programs" within the element "footer[role='contentinfo']" should exist
      And the link "Admissions" with the href "/admissions" within the element "footer[role='contentinfo']" should exist
      And the link "Research" with the href "/research" within the element "footer[role='contentinfo']" should exist
      And the link "Student Life" with the href "/student-life" within the element "footer[role='contentinfo']" should exist
      And the link "News" with the href "/news" within the element "footer[role='contentinfo']" should exist

  @check @local @development @staging @production
  Scenario: The footer carries the institution's contact details
    Given I am an anonymous user
     When I go to "/"
      And I wait until the page is loaded
     Then I should see "+1 489 239 2389" in the "footer" region
      And I should see "john.doe@gmail.com" in the "footer" region
      And I should see "450 Jane Stanford Way" in the "footer" region

  # The social profiles are icon links, so their accessible names are the only
  # thing a screen reader (or this test) can identify them by.
  @check @local @development @staging @production
  Scenario: The footer links the institution's social profiles
    Given I am an anonymous user
     When I go to "/"
      And I wait until the page is loaded
     Then the "Linkedin" link should be visible
      And the "Facebook" link should be visible
      And the "Instagram" link should be visible
      And the "X-Twitter" link should be visible

  # The newsletter block is a call to action, not a form: its Subscribe button
  # sends the visitor to the contact page. Asserting the destination catches the
  # button being wired to a dead or placeholder URL.
  @check @local @development @staging @production
  Scenario: The newsletter call to action invites a subscription and reaches the contact page
    Given I am an anonymous user
     When I go to "/"
      And I wait until the page is loaded
     Then I should see "Subscribe to Our Newsletters"
      And I should see "Be the first to hear about university events, news, and updates"
      And the link "SUBSCRIBE" with the href "/contact-us" should exist

  # The breadcrumb trail on a detail page must name the section it belongs to,
  # so a visitor can climb back up. Each content type has its own trail.
  @check @local @development @staging @production
  Scenario Outline: The <name> breadcrumb names its section
    Given I am an anonymous user
     When I go to "<path>"
      And I wait until the page is loaded
     Then I should see "Home" in the "breadcrumb" region
      And I should see "<section>" in the "breadcrumb" region

    Examples:
      | name         | path                             | section          |
      | news article | /news/undergraduate-robotics-team-wins-regional-championship | News |
      | event        | /events/global-education-forum    | Events           |
      | program      | /programs/biology                 | Explore programs |
