Feature: Quality - Performance budgets on the Educare pages
      As a site owner
      I want the Educare pages to load within a budget
      So that a regression in page weight, image derivatives or query count is caught early.

  # Educare's pages are image-heavy: every listing card and every hero renders a
  # drimage_improved derivative, and the Canvas pages compose many components.
  # That is exactly where page weight creeps in unnoticed.
  #
  # Budgets are measured with Navigation Timing (navigationStart to loadEventEnd)
  # and are deliberately generous - they are regression alarms, not targets. A
  # tight budget on a shared CI runner would be a flake generator; the point is to
  # notice a page that suddenly takes twice as long.
  #
  # These run after the warm-up feature, so the first-request cost of generating
  # image derivatives is not charged to the page under measurement.

  @perf @local @development @staging @production
  Scenario Outline: The <name> page loads within budget
    Given I am an anonymous user
     When I go to "<path>"
      And I wait until the page is loaded
     Then the page should load in less than 8 seconds

    Examples: Canvas pages
      | name         | path          |
      | Home         | /             |
      | About        | /about        |
      | Admissions   | /admissions   |
      | Student Life | /student-life |
      | Research     | /research     |
      | Contact Us   | /contact-us   |
      | Privacy      | /privacy      |

  # The three listings each run a view with an exposed filter and a pager, so they
  # carry more query cost than a Canvas page and are the most likely to regress.
  @perf @local @development @staging @production
  Scenario Outline: The <name> listing loads within budget
    Given I am an anonymous user
     When I go to "<path>"
      And I wait until the page is loaded
     Then the page should load in less than 8 seconds

    Examples:
      | name     | path      |
      | News     | /news     |
      | Events   | /events   |
      | Programs | /programs |

  @perf @local @development @staging @production
  Scenario Outline: The <name> content page loads within budget
    Given I am an anonymous user
     When I go to "<path>"
      And I wait until the page is loaded
     Then the page should load in less than 8 seconds

    Examples:
      | name         | path                                                         |
      | News article | /news/undergraduate-robotics-team-wins-regional-championship |
      | Event page   | /events/global-education-forum                               |
      | Program page | /programs/biology                                            |

  # A filtered listing must not cost dramatically more than an unfiltered one: an
  # exposed filter that drops the view's caching would show up here first.
  @perf @local @development @staging @production
  Scenario: A filtered news listing loads within budget
    Given I am an anonymous user
     When I go to "/news?search=robotics"
      And I wait until the page is loaded
     Then the page should load in less than 8 seconds
      And I should see "Undergraduate Robotics Team Wins Regional Championship"

  # A phone viewport asks the theme for the smallest image derivatives. If those
  # are being generated per request rather than served from cache, the mobile
  # budget is where it shows.
  @perf @local @development @staging @production
  Scenario: The home page loads within budget on a phone
    Given I am an anonymous user
     When I set the viewport to the "xs" breakpoint
      And I go to "/"
      And I wait until the page is loaded
     Then the page should load in less than 8 seconds
