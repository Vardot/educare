@any @regression @content @programs
Feature: Programs - Study levels and program filtering
      As a prospective student
      I want the Programs listing to switch between Undergraduate and Graduate
      So that I only see the programs I can actually apply to.

  # The Undergraduate / Graduate toggle is the Study level exposed filter,
  # rendered as a required pair of links rather than a select: the listing is
  # never unfiltered, it always shows one level. 04-01 checks both words are on
  # the page; these scenarios check switching level changes which programs are
  # listed, which is the behaviour a prospective student depends on.
  #
  # No absolute total is asserted: totals are counts of shipped demo content.
  # What is asserted is set membership - an undergraduate program is listed and a
  # graduate one is not, and the reverse after switching - which is the behaviour
  # and cannot pass if the toggle stops filtering.

  @check @local @development
  Scenario: The programs listing opens on Undergraduate programs
    Given I am an anonymous user
     When I go to "/programs"
      And I wait until the page is loaded
     Then I should see text matching "Showing 1-12 of \d+"
      And the "programs cards" should have a count of 12
      And I should see "Biology"
      And I should see "Computer Science"
      And I should not see "Astrophysics"

  @check @local @development
  Scenario: Switching to Graduate lists the graduate programs instead
    Given I am an anonymous user
     When I go to "/programs"
      And I wait until the page is loaded
      And I remember the result total
     Then I should see "Biology"
     When I follow "Graduate"
      And I wait until the page is loaded
     Then the result total should be smaller than before
      And I should see "Astrophysics"
      And I should see "Applied Mathematics"
      And I should not see "Biology"

  @check @local @development
  Scenario: Switching back to Undergraduate restores the undergraduate programs
    Given I am an anonymous user
     When I go to "/programs?level=30"
      And I wait until the page is loaded
     Then I should see "Astrophysics"
     When I follow "Undergraduate"
      And I wait until the page is loaded
     Then the "programs cards" should have a count of 12
      And I should see "Biology"
      And I should not see "Astrophysics"

  # The Type filter narrows within the selected level. Arts & Humanities leaves
  # the four humanities undergraduate programs and drops the sciences.
  @check @local @development
  Scenario: Choosing a Type narrows the programs listing within the level
    Given I am an anonymous user
     When I go to "/programs"
      And I wait until the page is loaded
      And I remember the result total
     When I select "Arts & Humanities" from the "Type" filter
      And I click the "Apply Filter" button
      And I wait until the page is loaded
     Then the result total should be smaller than before
      And the result total should be at least 1
      And I should see "Comparative Literature"
      And I should not see "Biology"

  @check @local @development
  Scenario: A keyword and its Reset work on the programs listing
    Given I am an anonymous user
     When I go to "/programs"
      And I wait until the page is loaded
      And I remember the result total
      And I fill in "Search by keyword" with "chemistry"
      And I click the "Apply Filter" button
      And I wait until the page is loaded
     Then I should see "Chemistry"
      And I should not see "Biology"
     When I click the "Reset" button
      And I wait until the page is loaded
     Then the result total should be the same as before
      And I should see "Biology"

  @check @local @development
  Scenario: A program card opens the program it names
    Given I am an anonymous user
     When I go to "/programs"
      And I wait until the page is loaded
     Then the "Biology" card should link to "/programs/biology"
     When I open the "Biology" card
     Then "h1" should have text "Biology"
      And I should see "Explore other programs"

  # A program page must state the level and the degrees it awards - the two
  # facts a prospective student decides on. Biology is an Undergraduate program
  # in Sciences awarding an A.B. and a B.S.
  @check @local @development
  Scenario: A program page states its level, subject area and degrees
    Given I am an anonymous user
     When I go to "/programs/biology"
      And I wait until the page is loaded
     Then I should see "Undergraduate"
      And I should see "Sciences"
      And I should see "Degrees"
      And I should see "A.B."
      And I should see "B.S."
      And I should see "Ready to take the next step?"
