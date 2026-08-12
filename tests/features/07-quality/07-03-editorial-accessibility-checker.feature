@any @regression @a11y
Feature: Quality - Editorial accessibility checker on Educare content
      As an editor of an education site with an accessibility obligation
      I want the in-page accessibility checker to run while I edit Educare content
      So that a page with an accessibility problem is caught before it is published.

  # Educare ships Editoria11y, the in-page checker that flags accessibility
  # problems to the editor on the rendered page rather than in a report. It is the
  # editorial half of the accessibility story: 07-01 gates what axe-core can see
  # from outside, this checks the tool an editor relies on is actually present and
  # running on Educare's own content.
  #
  # It must NOT be visible to the public: the checker panel names problems on the
  # page, which is editorial information.

  @a11y @local @development @staging @production
  Scenario Outline: The accessibility checker is not exposed to visitors on the <name> page
    Given I am an anonymous user
     When I go to "<path>"
      And I wait until the page is loaded
     Then "ed11y-element-panel" should not be attached
      And I should not see "Accessibility issues"

    Examples:
      | name         | path                                                         |
      | Home         | /                                                            |
      | News         | /news                                                        |
      | News article | /news/undergraduate-robotics-team-wins-regional-championship |
      | Programs     | /programs                                                    |

  # For a user who may edit, the checker's toggle must be on the page - that is
  # the whole delivery mechanism. It is asserted on each Educare content type,
  # because the checker attaches per rendered page, not per site.
  @a11y @local @development @staging @production
  Scenario Outline: The accessibility checker runs for an editor on the <name> page
    Given I am a logged in user with the "webmaster" user
     When I go to "<path>"
      And I wait until the page is loaded
     Then "ed11y-element-panel" should be attached within 15 seconds

    Examples:
      | name         | path                                                         |
      | News article | /news/undergraduate-robotics-team-wins-regional-championship |
      | Event page   | /events/global-education-forum                               |
      | Program page | /programs/biology                                            |
      | Home         | /                                                            |

  # The checker's own settings and its site-wide report are administrative. Only
  # a user who administers the site may reach them; an editor may not.
  @a11y @security @local @development @staging @production
  Scenario: The accessibility checker settings are not public
    Given I am an anonymous user
     Then I should be refused "/admin/config/content/editoria11y"
      And I should be refused "/admin/reports/editoria11y"

  @a11y @local @development @staging @production
  Scenario: The webmaster can reach the accessibility checker settings and report
    Given I am a logged in user with the "webmaster" user
     When I go to "/admin/config/content/editoria11y"
      And I wait until the page is loaded
     Then I should see "Editoria11y"
     When I go to "/admin/reports/editoria11y"
      And I wait until the page is loaded
     Then I should see "Editoria11y"
