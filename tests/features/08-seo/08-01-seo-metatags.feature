Feature: SEO - Metatags and sharing previews
      As a marketing team
      I want every page to declare its own title, description and share preview
      So that search engines and social platforms present the site correctly.

  # The Educare template ships the Varbase SEO base: Metatag, one canonical URL
  # per node, and Open Graph output built from the node's own fields. Nothing in
  # the suite checked any of it, so a content type whose description field was
  # not mapped to the meta description would ship with every page sharing the
  # site default - invisible in a browser and expensive to discover later.
  #
  # Values are asserted against the node's real field content, so a mapping that
  # silently falls back to the site name or an empty string fails.

  @check @seo @local @development @staging @production
  Scenario: A news article declares its own title, description and canonical URL
    Given I am an anonymous user
     When I go to "/news/undergraduate-robotics-team-wins-regional-championship"
      And I wait until the page is loaded
     Then the canonical url should end with "/news/undergraduate-robotics-team-wins-regional-championship"
      And the "description" meta tag should contain "robotics team took first place"
      And the page title should contain "Undergraduate Robotics Team Wins Regional Championship"

  # Open Graph is what LinkedIn and Facebook render when the article is shared.
  # An article shared with no image, or with the site name as its title, is a
  # marketing defect.
  @check @seo @local @development @staging @production
  Scenario: A news article carries a complete Open Graph share preview
    Given I am an anonymous user
     When I go to "/news/undergraduate-robotics-team-wins-regional-championship"
      And I wait until the page is loaded
     Then the "og:type" meta tag should be "article"
      And the "og:site_name" meta tag should be "Educare"
      And the "og:title" meta tag should be "Undergraduate Robotics Team Wins Regional Championship"
      And the "og:description" meta tag should contain "robotics team took first place"
      And the "og:url" meta tag should contain "/news/undergraduate-robotics-team-wins-regional-championship"
      And the "og:image" meta tag should contain "/sites/default/files/"

  # The share image must be a real derivative of the article's featured image,
  # generated at the size the platforms crop to. Asserting the declared
  # dimensions catches the image style being detached from the metatag.
  @check @seo @local @development
  Scenario: The share image is generated at the social preview size
    Given I am an anonymous user
     When I go to "/news/undergraduate-robotics-team-wins-regional-championship"
      And I wait until the page is loaded
     Then the "og:image:width" meta tag should be "1200"
      And the "og:image:height" meta tag should be "630"

  @check @seo @local @development @staging @production
  Scenario Outline: The <name> page declares its own canonical URL
    Given I am an anonymous user
     When I go to "<path>"
      And I wait until the page is loaded
     Then the canonical url should end with "<path>"

    Examples:
      | name         | path                             |
      | About        | /about                           |
      | Admissions   | /admissions                      |
      | Privacy      | /privacy                         |
      | Event page   | /events/global-education-forum   |
      | Program page | /programs/biology                |

  # Each page must put its own name in the browser and search-result title, not
  # just the site name.
  @check @seo @local @development @staging @production
  Scenario Outline: The <name> page titles itself
    Given I am an anonymous user
     When I go to "<path>"
      And I wait until the page is loaded
     Then the page should have a title
      And the page title should contain "<title>"

    Examples:
      | name         | path                           | title                   |
      | About        | /about                         | About                   |
      | News         | /news                          | News                    |
      | Events       | /events                        | Events                  |
      | Event page   | /events/global-education-forum | Global Education Forum  |
      | Program page | /programs/biology              | Biology                 |

  # A page that should not be indexed must say so, and - just as important - the
  # public pages must NOT carry a noindex directive. Educare ships no noindex on
  # its public pages; a recipe change that added one site-wide would be silent
  # until traffic dropped.
  @check @seo @local @development @staging @production
  Scenario Outline: The <name> page is not excluded from search engines
    Given I am an anonymous user
     When I go to "<path>"
      And I wait until the page is loaded
     Then the meta tag should not exist with the following attributes:
       | name    | robots   |
       | content | noindex  |

    Examples:
      | name     | path      |
      | Home     | /         |
      | News     | /news     |
      | Events   | /events   |
      | Programs | /programs |

  # The XML sitemap is what a search engine crawls first. It has to exist and be
  # served as XML. Its body is not asserted here: the browser applies the
  # sitemap's XSL stylesheet, so the DOM the test can read is the transformed
  # output, not the source URLs.
  @check @seo @local @development
  Scenario: The XML sitemap is published as XML
    Given I am an anonymous user
     Then I should be allowed "/sitemap.xml"
      And the response header "Content-Type" should contain the value "xml"
