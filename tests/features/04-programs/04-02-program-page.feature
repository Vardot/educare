Feature: Programs - Program page
      As a prospective student
      I want a Program page with its degrees, sections and a call to action
      So that I can understand a program and how to apply.

  # A Program full page renders its title, the degrees it awards and the standard
  # sections (What You'll Learn, Sample Courses, Career Paths), plus a "Ready To
  # Take The Next Step?" call-to-action banner - not an empty content region.
  @check @local @development @staging @production
  Scenario: A program page renders its degrees, sections and call to action
    Given I am an anonymous user
     When I go to "/programs/biology"
      And I wait until the page is loaded
     Then the page should have a main landmark
      And I should see "Biology"
      And I should see "Degrees"
      And I should see "What You'll Learn"
      And I should see "Ready To Take The Next Step?"

  @check @local @development @staging @production
  Scenario: A program page links back to the Programs section
    Given I am an anonymous user
     When I go to "/programs/biology"
      And I wait until the page is loaded
     Then "nav[aria-label='breadcrumb']" should be visible
      And "nav[aria-label='breadcrumb'] a[href='/programs']" should have a count of 1
