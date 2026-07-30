Feature: Website Base Requirements - Front-end pages
      As a site visitor
      I want every Educare front-end page to be healthy
      So that I can navigate, read and trust the site on any page.

  # Walking skeleton for the Educare Varbase functional testing suite: proves the
  # LAUNCH_URL, the browser, the step definitions and the reports dir all work,
  # and that every Educare canvas page is structurally healthy for an anonymous
  # visitor. Each page must expose the base landmarks and declare a language.
  @check @local @development @staging @production
  Scenario Outline: The <name> page is healthy
    Given I am an anonymous user
     When I go to "<path>"
      And I wait until the page is loaded
     Then "header[role='banner']" should be visible
      And "footer[role='contentinfo']" should be visible
      And the page should have a main landmark
      And the page should have a navigation landmark
      And the page should have a skip link
      And the page should declare a language
      And the page should have a title

    Examples: Canvas pages
      | name         | path          |
      | Home         | /             |
      | About        | /about        |
      | Admissions   | /admissions   |
      | Student Life | /student-life |
      | Research     | /research     |
      | News         | /news         |
      | Events       | /events       |
      | Programs     | /programs     |
      | Contact Us   | /contact-us   |
      | Privacy      | /privacy      |

  # A known piece of copy per landmark page proves the page rendered its own
  # content, not just a healthy shell.
  @check @local @development @staging @production
  Scenario Outline: The <name> page renders its own content
    Given I am an anonymous user
     When I go to "<path>"
      And I wait until the page is loaded
     Then I should see "<text>"

    Examples: Landmark copy
      | name     | path      | text                     |
      | Home     | /         | Shape Your Future        |
      | About    | /about    | We Are Here To Guide You |
      | News     | /news     | Latest Updates           |
      | Events   | /events   | Upcoming Events          |
      | Programs | /programs | All programs             |
      | Privacy  | /privacy  | Privacy policy           |
