Feature: Permissions - The editorial back end is closed to visitors
      As the owner of an Educare site
      I want no part of the editorial back end reachable by an anonymous visitor
      So that the site cannot be edited, and unpublished work cannot be read, by the public.

  # Educare grants its editorial permissions to four roles the recipe ships
  # (Content editor, Content Admin, SEO Admin, Site Admin). Anonymous gets none of
  # them. That is asserted here on the status code rather than on a message: a
  # theme can word "Access denied" however it likes, but a 200 on a node form is
  # a permission defect whatever the page says.
  #
  # Every refusal is paired with a positive: the same anonymous visitor must still
  # be able to read the public site. A scenario that only ever asserts refusals
  # would pass on a site that is entirely broken.

  @check @security @local @development @staging @production
  Scenario: An anonymous visitor can read the public site
    Given I am an anonymous user
     Then I should be allowed "/"
      And I should be allowed "/news"
      And I should be allowed "/events"
      And I should be allowed "/programs"
      And I should be allowed "/contact-us"

  # No Educare content type may be created by the public.
  @check @security @local @development @staging @production
  Scenario Outline: An anonymous visitor cannot create <name> content
    Given I am an anonymous user
     Then I should be refused "<path>"

    Examples: Educare content types
      | name         | path              |
      | News post    | /node/add/news    |
      | Event        | /node/add/event   |
      | Program      | /node/add/program |
      | Utility page | /node/add/page    |

  # Nor may the public reach the editorial screens the four roles use.
  @check @security @local @development @staging @production
  Scenario Outline: An anonymous visitor cannot reach <name>
    Given I am an anonymous user
     Then I should be refused "<path>"

    Examples: Editorial screens
      | name                  | path                        |
      | the content overview  | /admin/content              |
      | the media overview    | /admin/content/media        |
      | the media library     | /admin/content/media-grid   |
      | the people overview   | /admin/people               |
      | taxonomy admin        | /admin/structure/taxonomy   |
      | content type admin    | /admin/structure/types      |
      | the appearance page   | /admin/appearance           |
      | the modules page      | /admin/modules              |
      | the configuration     | /admin/config               |

  # Educare's 12 Canvas pages are public to read at their own paths and closed to
  # edit. Both halves are asserted together so the pair cannot drift apart.
  @check @security @local @development @staging @production
  Scenario: An anonymous visitor can read a Canvas page but not edit it
    Given I am an anonymous user
     When I go to "/about"
      And I wait until the page is loaded
     Then I should see "We Are Here To Guide You"
      And I should be refused "/admin/content/pages"

  # The demo content is published, so its node forms must be refused rather than
  # rendered read-only.
  @check @security @local @development @staging @production
  Scenario Outline: An anonymous visitor cannot edit or delete the <name>
    Given I am an anonymous user
     When I go to "<path>"
      And I wait until the page is loaded
     Then "h1" should have text "<title>"
      And I should be refused "<path>/edit"
      And I should be refused "<path>/delete"

    Examples:
      | name         | path                           | title                  |
      | event page   | /events/global-education-forum | Global Education Forum |
      | program page | /programs/biology              | Biology                |

  # The contact form is the one form the public may submit. Asserting that keeps
  # the refusals above honest: the site is closed for editing, not closed.
  @check @security @local @development @staging @production
  Scenario: An anonymous visitor can still use the contact form
    Given I am an anonymous user
     When I go to "/contact-us"
      And I wait until the page is loaded
     Then the "contact form" should be visible
      And the "Submit Form" button should be visible
