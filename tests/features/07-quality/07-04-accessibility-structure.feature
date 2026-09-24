@regression @any @a11y
Feature: Quality - Accessibility structure
      As a keyboard and screen reader user
      I want every page type to carry a sound document structure
      So that I can skip to the content, follow the headings and reach every control.

  @a11y @local @development @staging @production
  Scenario Outline: The <page> page carries a sound document structure
    Given I am an anonymous user
     When I go to "<path>"
      And wait
     Then the page should have a title
      And the page should declare a language
      And the page should have exactly one h1
      And the heading hierarchy should be valid
      And the page should have a main landmark
      And the page should have a navigation landmark
      And the page should have a skip link
      And user zoom should be allowed

    Examples:
      | page           | path                                                         |
      | home           | /                                                            |
      | about          | /about                                                       |
      | admissions     | /admissions                                                  |
      | student life   | /student-life                                                |
      | research       | /research                                                    |
      | news listing   | /news                                                        |
      | events listing | /events                                                      |
      | programs       | /programs                                                    |
      | contact us     | /contact-us                                                  |
      | privacy        | /privacy                                                     |
      | news article   | /news/undergraduate-robotics-team-wins-regional-championship |
      | event page     | /events/global-education-forum                               |
      | program page   | /programs/biology                                            |
      | search         | /search?keywords=education                                   |

  @a11y @local @development @staging @production
  Scenario Outline: Every control and image on the <page> page can be identified
    Given I am an anonymous user
     When I go to "<path>"
      And wait
     Then every image should have an alt attribute
      And every link should have an accessible name
      And every button should have an accessible name
      And every ARIA reference should resolve
      And every ARIA role should be valid
      And no element should have a positive tabindex

    Examples:
      | page           | path                                                         |
      | home           | /                                                            |
      | about          | /about                                                       |
      | admissions     | /admissions                                                  |
      | student life   | /student-life                                                |
      | research       | /research                                                    |
      | news listing   | /news                                                        |
      | events listing | /events                                                      |
      | programs       | /programs                                                    |
      | contact us     | /contact-us                                                  |
      | privacy        | /privacy                                                     |
      | news article   | /news/undergraduate-robotics-team-wins-regional-championship |
      | event page     | /events/global-education-forum                               |
      | program page   | /programs/biology                                            |
      | search         | /search?keywords=education                                   |

  # Scoped to the component, so a failure names the component rather than the
  # page it happened to be on.
  @a11y @local @development @staging @production
  Scenario: The main navigation is accessible in its own right
    Given I am an anonymous user
     When I go to "/"
      And wait
     Then the element "nav.navbar" should pass an accessibility audit

  @a11y @local @development @staging @production
  Scenario: The breadcrumb and the share block on a program page are accessible
    Given I am an anonymous user
     When I go to "/programs/biology"
      And wait
     Then the element ".breadcrumb-item" should not violate the accessibility rule "color-contrast"
      And the element ".webshare" should pass an accessibility audit
      And the element ".webshare" should not violate the accessibility rule "link-name"
