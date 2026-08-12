@any @regression @smoke @content
Feature: Website Base Requirements - Front-end pages warm-up
      As the test runner
      I want each Educare public page visited once at every testing breakpoint before the health checks
      So that the theme's image derivatives are generated and cached first.

  # WHY THIS RUNS FIRST
  #
  # vartheme_bs5_educare renders responsive images through drimage_improved,
  # which generates a WebP derivative per rendered width on the fly. The first
  # request for a derivative can be dropped while it is still being generated
  # (most visibly under HTTP/2), which later surfaces as a dropped image request
  # and a slow first paint on the very next scenario. On 4 August 2026 that
  # showed up as "The Home page is healthy" failing its first attempt and passing
  # on retry - a flake the suite's `retry: 1` hid, so the run still reported
  # 36 of 36 passed. A masked flake in a release gate is worse than a missing
  # test, because it reads as green.
  #
  # Visiting each page once at every viewport breakpoint in the testing settings
  # primes the derivative cache for all widths, so the health checks serve them
  # as static files. This feature makes NO assertions: it is not a test, it is
  # the condition the tests need.
  #
  # ORDERING: cucumber runs a folder's feature files in filename order, and
  # "01-00-front-end-pages-warm-up.feature" sorts before
  # "01-00-front-end-pages.feature" ("-" precedes "."). To make that ordering
  # obvious rather than incidental, rename the health-check file to
  # 01-06-front-end-pages.feature, matching the Varbase suite's numbering.

  @check @local @development @staging @production
  Scenario Outline: Warm up the <name> page across all breakpoints
    Given I am an anonymous user
     When I warm up "<path>" at all testing breakpoints

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

    Examples: Content pages
      | name         | path                                                         |
      | News article | /news/undergraduate-robotics-team-wins-regional-championship |
      | Event page   | /events/global-education-forum                               |
      | Program page | /programs/biology                                            |
