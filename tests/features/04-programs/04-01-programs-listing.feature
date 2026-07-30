Feature: Programs - Programs listing
      As a prospective student
      I want a Programs listing at /programs with an Undergraduate / Graduate
      toggle, degree badges and a keyword filter
      So that I can browse programs and the degrees they award.

  # The Educare recipe ships demo Programs. The "All programs" listing pages 12
  # at a time, offers an Undergraduate / Graduate level toggle and a keyword
  # ("Enter keyword") + "Type" exposed filter. A marker program and its degree
  # badge prove the rows render.
  @check @local @development
  Scenario: The programs listing shows programs with an Undergraduate / Graduate toggle
    Given I am an anonymous user
     When I go to "/programs"
      And I wait until the page is loaded
     Then I should see "All programs"
      And I should see text matching "Showing 1-12 of 12"
      And I should see "Undergraduate"
      And I should see "Graduate"
      And I should see "Biology"

  @check @local @development @staging @production
  Scenario: The programs listing exposes the Enter keyword and Type filters
    Given I am an anonymous user
     When I go to "/programs"
      And I wait until the page is loaded
     Then "form.views-exposed-form" should be visible
      And "input[placeholder='Enter keyword']" should be visible
      And I should see "Type"

  # A keyword search narrows the listing to the matching program.
  @check @local @development
  Scenario: A keyword search narrows the programs listing
    Given I am an anonymous user
     When I go to "/programs?search=chemistry"
      And I wait until the page is loaded
     Then I should see "Chemistry"
      And I should not see "Biology"
