@any @regression @smoke @content
Feature: Website Base Requirements - Responsive navigation and listings
      As a site visitor on a phone
      I want the navigation and the listings to work at a small viewport
      So that I can use the site without a desktop browser.

  # Nothing in the suite has run at a small viewport before, so a menu that
  # collapses to a toggle nobody can open, or a listing that only renders its
  # cards above a breakpoint, would ship unnoticed.
  #
  # The Educare header collapses the main menu behind a Bootstrap toggle below
  # the lg breakpoint. Two things must hold: at a phone width the toggle is the
  # way in and the menu starts closed; at a desktop width the menu is open and
  # the toggle is gone. Both halves are asserted so a collapse that never
  # collapses, and one that never expands, both fail.
  #
  # The closed state is asserted on the collapsible menu container, not on a menu
  # link: the same section names appear again in the footer quicklinks, which are
  # visible at every width, so a page-wide link check would never see the menu as
  # closed.

  @check @local @development @staging @production
  Scenario: On a phone the main menu is behind a navigation toggle
    Given I am an anonymous user
     When I set the viewport to the "xs" breakpoint
      And I go to "/"
      And I wait until the page is loaded
     Then the "nav toggle" should be visible
      And the "main nav menu" should not be visible

  @check @local @development @staging @production
  Scenario: On a phone the navigation toggle opens the main menu
    Given I am an anonymous user
     When I set the viewport to the "xs" breakpoint
      And I go to "/"
      And I wait until the page is loaded
     Then the "main nav menu" should not be visible
     When I click the "nav toggle" control
      And I wait 2 seconds
     Then the "main nav menu" should be visible
      And the "About" link should be visible
      And the "Programs" link should be visible
      And the "Contact Us" link should be visible

  @check @local @development @staging @production
  Scenario: On a desktop the main menu is open and needs no toggle
    Given I am an anonymous user
     When I set the viewport to the "xl" breakpoint
      And I go to "/"
      And I wait until the page is loaded
     Then the "main nav menu" should be visible
      And the "About" link should be visible
      And the "nav toggle" should not be visible

  # Each listing must render its cards at a phone width too. The count is the
  # same as on desktop - the grid reflows, it does not drop content.
  @check @local @development
  Scenario Outline: The <name> listing renders its cards on a phone
    Given I am an anonymous user
     When I set the viewport to the "xs" breakpoint
      And I go to "<path>"
      And I wait until the page is loaded
     Then the "<cards>" should have a count of 12
      And I should see "<marker>"

    Examples:
      | name     | path      | cards          | marker              |
      | News     | /news     | news cards     | Latest Updates      |
      | Events   | /events   | events cards   | Upcoming Events     |
      | Programs | /programs | programs cards | All programs        |

  # The exposed filter form must still be usable on a phone: a filter that is
  # rendered but never reachable is not a filter.
  @check @local @development
  Scenario: The events filter still narrows the listing on a phone
    Given I am an anonymous user
     When I set the viewport to the "xs" breakpoint
      And I go to "/events"
      And I wait until the page is loaded
      And I fill in "Search by keyword" with "forum"
      And I click the "Apply Filter" button
      And I wait until the page is loaded
     Then I should see "Sustainable Business Forum"
      And I should not see "Future Leaders Summit"

  # The contact form is the site's one conversion point; it has to be fillable
  # on a phone.
  @check @local @development @staging @production
  Scenario: The contact form is usable on a phone
    Given I am an anonymous user
     When I set the viewport to the "xs" breakpoint
      And I go to "/contact-us"
      And I wait until the page is loaded
     Then the "contact form" should be visible
      And the "Submit Form" button should be visible
