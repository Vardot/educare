Feature: Drupal Canvas - Home and About open in the Canvas editor
      As a site builder taking over an Educare site
      I want the Home and About Canvas pages to open in the Canvas editor
      So that they can be edited, not just viewed.

  # See 10-01-canvas-pages-listed.feature for why this is split per page group.

  @check @canvas @local @development
  Scenario Outline: The <name> Canvas page opens in the Canvas editor
    Given I am a logged in user with the "webmaster" user
     When I open the "<name>" Canvas page in the editor
     Then the url should match "/canvas/editor/canvas_page/"

    Examples: Home and About
      | name  |
      | Home  |
      | About |

  # The Canvas page's rendered output and its editor must agree on the same
  # content. Reading the page as a visitor and then opening the same page in the
  # editor proves both halves of one page work, which neither check does alone.
  @check @canvas @local @development
  Scenario: The About Canvas page renders for a visitor and opens for a builder
    Given I am an anonymous user
     When I go to "/about"
      And I wait until the page is loaded
     Then I should see "We Are Here To Guide You"
      And the page should have a working header
      And the page should have a working footer
    Given I am a logged in user with the "webmaster" user
     When I open the "About" Canvas page in the editor
     Then the url should match "/canvas/editor/canvas_page/"
