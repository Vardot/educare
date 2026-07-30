Feature: Exposed filters - Form-scoped listing filters
      As a site visitor
      I want the exposed filter form on the News, Events and Programs listings
      So that I can narrow each listing, and not have it appear on other pages.

  # The Educare theme attaches the exposed-filters styling only where a views
  # exposed form renders (via hook_form_alter on views_exposed_form). Assert the
  # form is present on every listing page, with a visible Apply and Reset action.
  @check @local @development @staging @production
  Scenario Outline: The <name> listing renders an exposed filter form with Apply and Reset
    Given I am an anonymous user
     When I go to "<path>"
      And I wait until the page is loaded
     Then "form.views-exposed-form" should be visible
      And I should see "Apply Filter"
      And I should see "Reset"

    Examples:
      | name     | path      |
      | News     | /news     |
      | Events   | /events   |
      | Programs | /programs |

  # The exposed filter form is form-scoped: it must NOT appear on non-listing
  # pages such as the home page or a plain content page.
  @check @local @development @staging @production
  Scenario Outline: The <name> page renders no exposed filter form
    Given I am an anonymous user
     When I go to "<path>"
      And I wait until the page is loaded
     Then "form.views-exposed-form" should not be visible

    Examples:
      | name    | path     |
      | Home    | /        |
      | Privacy | /privacy |
