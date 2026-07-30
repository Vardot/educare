Feature: News - News article
      As a site visitor
      I want a News article page with its title, body and related stories
      So that I can read a story and find more like it.

  # A News full page renders its title and lead paragraph, a "Share" block and a
  # "Stories You May Also Like" related section. The featured image renders
  # through drimage as a 16:9 hero.
  @check @local @development @staging @production
  Scenario: A news article renders its title, share and related stories
    Given I am an anonymous user
     When I go to "/news/first-year-students-reflect-their-first-semester-campus"
      And I wait until the page is loaded
     Then the page should have a main landmark
      And I should see "Share"
      And I should see "Stories You May Also Like"
      And "main img" should be visible

  # The article page carries a breadcrumb back to the News listing.
  @check @local @development @staging @production
  Scenario: A news article links back to the News section
    Given I am an anonymous user
     When I go to "/news/first-year-students-reflect-their-first-semester-campus"
      And I wait until the page is loaded
     Then "nav[aria-label='breadcrumb']" should be visible
      And "nav[aria-label='breadcrumb'] a[href='/news']" should have a count of 1
