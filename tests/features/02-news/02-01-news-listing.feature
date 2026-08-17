@any @regression @content @news
Feature: News - News listing
      As a site visitor
      I want a News listing at /news with articles and filters
      So that I can browse and narrow down news.

  # The Educare recipe ships 15 demo News articles. The listing renders each as a
  # card under the "Latest Updates" heading, with a keyword ("Search by"),
  # "Industry" and "Type" exposed filter. A marker article title proves the cards
  # render.
  @check @local @development
  Scenario: The news listing shows articles under the Latest Updates heading
    Given I am an anonymous user
     When I go to "/news"
      And I wait until the page is loaded
     Then I should see "Latest Updates"
      And I should see "First-Year Students Reflect On Their First Semester On Campus"

  @check @local @development @staging @production
  Scenario: The news listing exposes the Search by, Industry and Type filters
    Given I am an anonymous user
     When I go to "/news"
      And I wait until the page is loaded
     Then "main form.views-exposed-form" should be visible
      And I should see "Search by"
      And I should see "Industry"
      And I should see "Type"

  # A keyword search narrows the listing: the matching article stays, a
  # non-matching one drops out. Pairs a positive with a negative assertion.
  @check @local @development
  Scenario: A keyword search narrows the news listing
    Given I am an anonymous user
     When I go to "/news?search=robotics"
      And I wait until the page is loaded
     Then I should see "Undergraduate Robotics Team Wins Regional Championship"
      And I should not see "First-Year Students Reflect On Their First Semester On Campus"
