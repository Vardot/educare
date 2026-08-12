@any @regression @canvas
Feature: Drupal Canvas - The shipped Educare Canvas pages are listed
      As a site builder taking over an Educare site
      I want every Canvas page the recipe ships to open in the Canvas editor
      So that the pages can be edited, not just viewed.

  # Educare's 12 pages - Home, About, Admissions, Student Life, Research, News,
  # Events, Explore programs, Contact Us, and three programme pages - are
  # canvas_page entities whose component trees the recipe ships as configuration.
  # A page can render perfectly for a visitor and still fail to open in the
  # editor, if a component the tree references is missing or its props no longer
  # validate. That failure is invisible from the front end and total for whoever
  # has to edit the page, which makes it the highest-value Canvas assertion for a
  # site template.
  #
  # The editor is a heavy React SPA, so opening it is slow by nature and each
  # page's own scenario lives in its own 10-0N-*.feature / CI bucket rather than
  # sharing one - a shared runner under load can burn a 30-minute job on just two
  # or three of these before the rest ever get a turn. This file only lists the
  # pages; the editor-open assertions are split out per page group.

  @check @canvas @local @development
  Scenario: The Canvas pages the recipe ships are listed for a site builder
    Given I am a logged in user with the "webmaster" user
     When I go to "/admin/content/pages"
      And I wait until the page is loaded
     Then I should see "Home"
      And I should see "About"
      And I should see "Admissions"
      And I should see "Student Life"
      And I should see "Research"
      And I should see "Contact Us"
      And I should see "Explore programs"
