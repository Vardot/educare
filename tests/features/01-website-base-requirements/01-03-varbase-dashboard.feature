@regression @any @admin @dashboard
Feature: The Varbase welcome dashboard shows each editorial role what it needs
  Editorial users land on the Varbase welcome dashboard from Varbase Admin Base:
  a welcome card with their picture and name, Add content, Top tasks, their own
  drafts, recent content and pages, and what is scheduled to publish.

  @check @local @development @staging @production
  Scenario: Check that the webmaster sees the Varbase welcome dashboard
    Given I am a logged in user with the "webmaster" user
     When I go to "/admin/dashboard"
      And I wait until the page is loaded
     Then I should see "Welcome,"
      And I should see "Add content"
      And I should see "Top tasks"
      And I should see "My Drafts"
      And I should see "Recent content"
      And I should see "Recent pages"
      And I should see "Scheduled"
      And I should see "Pages with accessibility alerts"
      And I should not see "Announcements"
      And I should not see "Drupal Events and User Groups"
      And I should not see "The website encountered an unexpected error"

  # WHY THE ROLE SCENARIOS ARE @wip
  #
  # They log in as the Educare testing users (Content editor, Content admin, SEO
  # admin, Site admin, Super admin, Normal user). Educare's CI does not seed those
  # accounts yet - only webmaster exists - so the same as 11-02-role-boundaries,
  # they stay @wip (CI skips @wip) until the testing users are seeded. They pass
  # against a site that has the users.

  @wip @check @local @development
  Scenario Outline: Check that <role> sees the Varbase welcome dashboard
    Given I am a logged in user with the "<role>" user
     When I go to "/admin/dashboard"
      And I wait until the page is loaded
     Then I should see "Welcome,"
      And I should see "Add content"
      And I should see "Top tasks"
      And I should see "My Drafts"
      And I should see "Recent content"
      And I should see "Recent pages"
      And I should see "Scheduled"
      And I should not see "Announcements"
      And I should not see "Drupal Events and User Groups"

    Examples:
      | role           |
      | Content editor |
      | Content admin  |
      | Site admin     |
      | Super admin    |

  @wip @check @local @development
  Scenario: Check that the SEO admin sees the dashboard without Recent pages
    Given I am a logged in user with the "SEO admin" user
     When I go to "/admin/dashboard"
      And I wait until the page is loaded
     Then I should see "Welcome,"
      And I should see "My Drafts"
      And I should not see "Recent pages"

  @wip @check @local @development
  Scenario: Check that a normal user is refused the dashboard
    Given I am a logged in user with the "Normal user" user
     When I go to "/admin/dashboard/welcome"
      And I wait until the page is loaded
     Then the response status code should be 403
