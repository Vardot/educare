@any @regression @a11y
Feature: Accessibility - Every shipped page is accessible
      As a visitor using assistive technology
      I want every page the Educare template ships to be operable and perceivable
      So that I can read, navigate and use the site.

  # Educare is aimed at education and public-sector institutions, where WCAG 2.1
  # AA is a procurement requirement. The template was audited with axe-core on
  # 2 August 2026: no critical and no serious violations anywhere, and a
  # recurring moderate heading-order issue where card titles hardcode a deep
  # heading level under a section heading.
  #
  # These scenarios gate what is clean today so it stays clean:
  #   - zero critical and zero serious axe violations on every shipped page;
  #   - the specific rules the brand and the content model depend on
  #     (colour contrast, image alt text, form labels, accessible names, valid
  #     ARIA), each named so a failure says which contract broke;
  #   - the structural facts a screen-reader user navigates by.
  #
  # heading-order is deliberately NOT gated: it is a known open moderate finding
  # and fixing it is a theme change (a heading-level prop on the card title
  # components). A scenario asserting the full AA rule set would be red on
  # arrival and would be muted rather than fixed. When the heading levels are
  # decoupled from the visual size, add:
  #     Then the page should pass an accessibility audit at level "AA"
  # and delete this note.

  @check @a11y @local @development @staging @production
  Scenario Outline: The <name> page has no critical or serious accessibility violations
    Given I am an anonymous user
     When I go to "<path>"
      And I wait until the page is loaded
     Then the page should have no critical accessibility violations
      And the page should have no serious accessibility violations

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
      | name           | path                                                         |
      | News article   | /news/undergraduate-robotics-team-wins-regional-championship |
      | Event page     | /events/global-education-forum                               |
      | Program page   | /programs/biology                                            |
      | Search results | /search?keywords=education                                   |

  # The brand palette (navy, orange, cream) passes AA today. Naming the rule
  # means a designer changing a colour token gets a failure that says
  # "color-contrast", not a generic audit total.
  @check @a11y @local @development @staging @production
  Scenario Outline: The <name> page keeps its text readable and its controls named
    Given I am an anonymous user
     When I go to "<path>"
      And I wait until the page is loaded
     Then the page should pass the accessibility rules "color-contrast"
      And the page should pass the accessibility rules "image-alt, input-image-alt"
      And the page should pass the accessibility rules "label, form-field-multiple-labels"
      And the page should pass the accessibility rules "button-name, link-name"
      And the page should pass the accessibility rules "aria-valid-attr, aria-valid-attr-value, aria-roles"

    Examples:
      | name           | path                                                         |
      | Home           | /                                                            |
      | News           | /news                                                        |
      | Events         | /events                                                      |
      | Programs       | /programs                                                    |
      | Contact Us     | /contact-us                                                  |
      | News article   | /news/undergraduate-robotics-team-wins-regional-championship |
      | Event page     | /events/global-education-forum                               |
      | Program page   | /programs/biology                                            |
      | Search results | /search?keywords=education                                   |

  # The structural facts a screen-reader user relies on to orient. 01-00 covers
  # the landmarks, skip link, language and title; these are the ones it does not:
  # a single h1, every image carrying alt text, every field labelled, every
  # control named, resolvable ARIA references, and a tab order the author has
  # not overridden.
  @check @a11y @local @development @staging @production
  Scenario Outline: The <name> page is navigable by assistive technology
    Given I am an anonymous user
     When I go to "<path>"
      And I wait until the page is loaded
     Then the page should have exactly one h1
      And every image should have an alt attribute
      And every form field should have an accessible label
      And every button should have an accessible name
      And every link should have an accessible name
      And every ARIA reference should resolve
      And every ARIA role should be valid
      And no element should have a positive tabindex
      And user zoom should be allowed

    Examples:
      | name           | path                                                         |
      | Home           | /                                                            |
      | About          | /about                                                       |
      | News           | /news                                                        |
      | Events         | /events                                                      |
      | Programs       | /programs                                                    |
      | Contact Us     | /contact-us                                                  |
      | Privacy        | /privacy                                                     |
      | News article   | /news/undergraduate-robotics-team-wins-regional-championship |
      | Event page     | /events/global-education-forum                               |
      | Program page   | /programs/biology                                            |
      | Search results | /search?keywords=education                                   |

  # The exposed filter form is generated markup; its labels are what a screen
  # reader announces before each control. Auditing the form subtree on its own
  # means a labelling regression there is not lost in a whole-page total.
  @check @a11y @local @development @staging @production
  Scenario Outline: The <name> filter form is accessible on its own
    Given I am an anonymous user
     When I go to "<path>"
      And I wait until the page is loaded
     Then the element "main form.views-exposed-form" should pass an accessibility audit

    Examples:
      | name     | path      |
      | News     | /news     |
      | Events   | /events   |
      | Programs | /programs |

  # The contact form is the site's conversion point and the one place a visitor
  # types. Its subtree must pass the full AA rule set, not just the severities.
  #
  # `required fields should be consistently marked` is deliberately NOT asserted
  # here. It requires a field carrying the native `required` attribute to carry
  # `aria-required="true"` as well, and Educare's contact webform renders eight
  # fields with `required` alone. That is correct HTML: browsers map `required`
  # to the implicit aria-required state, so assistive technology already
  # announces it, and axe-core raises nothing on the same form. Asserting it
  # would be a false alarm, not a finding.
  @check @a11y @local @development @staging @production
  Scenario: The contact form passes a full accessibility audit
    Given I am an anonymous user
     When I go to "/contact-us"
      And I wait until the page is loaded
     Then the element "form.webform-submission-form" should pass an accessibility audit
      And every form field should have an accessible label
      And every button should have an accessible name

  # A keyboard user's first action on every page is the skip link. It has to be
  # the first thing focus reaches and it has to name where it goes.
  @check @a11y @local @development @staging @production
  Scenario: The skip link is the first thing a keyboard user reaches
    Given I am an anonymous user
     When I go to "/"
      And I wait until the page is loaded
      And I press the key "Tab"
     Then the focused element should match ".skip-link"

  # At a phone width the accessibility contract is the same one. Running the
  # severity gate at xs catches a mobile-only regression, such as a collapsed
  # menu whose toggle loses its name.
  @check @a11y @local @development @staging @production
  Scenario Outline: The <name> page stays accessible on a phone
    Given I am an anonymous user
     When I set the viewport to the "xs" breakpoint
      And I go to "<path>"
      And I wait until the page is loaded
     Then the page should have no critical accessibility violations
      And the page should have no serious accessibility violations
      And every button should have an accessible name
      And every link should have an accessible name

    Examples:
      | name       | path        |
      | Home       | /           |
      | News       | /news       |
      | Events     | /events     |
      | Programs   | /programs   |
      | Contact Us | /contact-us |
