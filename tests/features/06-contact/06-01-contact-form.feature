Feature: Contact - Contact form
      As a site visitor
      I want a Contact Us page with a working contact form
      So that I can get in touch with the institution.

  # The Contact Us page renders a Webform submission form with the standard
  # Subject / Message fields and a submit action.
  @check @local @development @staging @production
  Scenario: The Contact Us page renders a contact form with a submit action
    Given I am an anonymous user
     When I go to "/contact-us"
      And I wait until the page is loaded
     Then "form.webform-submission-form" should be visible
      And I should see "Subject"
      And I should see "Message"
      And "input[value='Submit Form']" should be visible
