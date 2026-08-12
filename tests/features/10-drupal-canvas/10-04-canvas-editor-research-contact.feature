@any @regression @canvas @slow @flaky
Feature: Drupal Canvas - Research and Contact Us open in the Canvas editor
      As a site builder taking over an Educare site
      I want the Research and Contact Us Canvas pages to open in the Canvas editor
      So that they can be edited, not just viewed.

  # See 10-01-canvas-pages-listed.feature for why this is split per page group.

  @check @canvas @local @development
  Scenario Outline: The <name> Canvas page opens in the Canvas editor
    Given I am a logged in user with the "webmaster" user
     When I open the "<name>" Canvas page in the editor
     Then the url should match "/canvas/editor/canvas_page/"

    Examples: Research and Contact Us
      | name        |
      | Research    |
      | Contact Us  |
