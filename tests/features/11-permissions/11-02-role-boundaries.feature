Feature: Permissions - What each Educare role may and may not do
      As the owner of an Educare site
      I want each Educare role held to the permissions the recipe grants it
      So that a permission added or lost when the recipe changes is caught.

  # WHY THESE ARE @wip
  #
  # Every scenario here needs the six Educare testing users (Content editor,
  # Content Admin, SEO Admin, Site Admin, Super admin, Normal user) that
  # cucumber.js already lists in worldParameters.users. On the release-candidate
  # site those accounts do not exist - only `webmaster` does - so these scenarios
  # cannot be run, and shipping them untagged would turn the gate red. CI skips
  # @wip. Remove the tag once the suite's testing users are seeded (the same
  # accounts Varbase's `add-testing-users` step creates).
  #
  # WHAT THEY ASSERT, AND WHY IT IS WORTH ASSERTING
  #
  # The expectations below are not guesses: each was read off the running site by
  # asking Drupal directly, per role, with an unsaved account carrying only that
  # role. They encode the Educare recipe's own permission grants:
  #
  #   Program is the restricted bundle. Content editor and Content Admin may
  #   create and edit Programs. SEO Admin and Site Admin may NOT - neither has
  #   `create program content`, and neither passes node access `update` on a
  #   Program. That asymmetry is Educare-specific: Programs are the admissions
  #   product, and the roles that tune SEO or administer the site are not the
  #   roles that own the curriculum.
  #
  #   Canvas pages are for content roles. Content editor, Content Admin and Site
  #   Admin hold `create canvas_page` and `edit canvas_page`; SEO Admin holds
  #   neither. Only Site Admin may edit the global header and footer regions
  #   (`edit canvas global regions`).
  #
  #   Taxonomy administration is Content Admin and Site Admin only. Content editor
  #   may create terms in the Educare vocabularies but may not administer them.
  #
  #   User administration is Site Admin only.
  #
  # A boundary scenario is worth more than a happy path, so each role gets its
  # refusals AND one thing it must still be able to do - a role locked out of
  # everything would otherwise pass every refusal.

  @wip @check @security @local @development
  Scenario: A Content editor may author every Educare content type
    Given I am a logged in user with the "Content editor" user
     Then I should be allowed "/node/add/news"
      And I should be allowed "/node/add/event"
      And I should be allowed "/node/add/program"
      And I should be allowed "/node/add/page"
      And I should be allowed "/admin/content"
      And I should be allowed "/admin/content/media"

  @wip @check @security @local @development
  Scenario: A Content editor may not administer taxonomy or users
    Given I am a logged in user with the "Content editor" user
     Then I should be refused "/admin/structure/taxonomy/add"
      And I should be refused "/admin/people"
      And I should be refused "/admin/modules"
      And I should be refused "/admin/config/development/performance"

  # SEO Admin is the sharpest boundary in the template: it authors News, Events
  # and Utility pages, and must not touch Programs or Canvas pages at all.
  @wip @check @security @local @development
  Scenario: An SEO Admin may author News, Events and Utility pages
    Given I am a logged in user with the "SEO admin" user
     Then I should be allowed "/node/add/news"
      And I should be allowed "/node/add/event"
      And I should be allowed "/node/add/page"
      And I should be allowed "/admin/content"

  @wip @check @security @local @development
  Scenario: An SEO Admin may not create or edit a Program
    Given I am a logged in user with the "SEO admin" user
     Then I should be refused "/node/add/program"
     When I go to "/programs/biology"
      And I wait until the page is loaded
     Then "h1" should have text "Biology"
      And I should be refused "/programs/biology/edit"

  @wip @check @security @local @development
  Scenario: An SEO Admin may not create or edit a Canvas page
    Given I am a logged in user with the "SEO admin" user
     Then I should be refused "/admin/content/pages"

  # Site Admin administers the site and the global Canvas regions, but the
  # curriculum is not its to edit.
  @wip @check @security @local @development
  Scenario: A Site Admin administers users, taxonomy and the Canvas pages
    Given I am a logged in user with the "Site admin" user
     Then I should be allowed "/admin/people"
      And I should be allowed "/admin/structure/taxonomy/manage/degrees/overview"
      And I should be allowed "/admin/content/pages"

  @wip @check @security @local @development
  Scenario: A Site Admin may not create or edit a Program
    Given I am a logged in user with the "Site admin" user
     Then I should be refused "/node/add/program"
      And I should be refused "/programs/biology/edit"

  # Content Admin is the role that owns the Educare vocabularies - Degrees,
  # Program type, Study level, Event Categories, News Categories.
  @wip @check @security @local @development
  Scenario: A Content Admin administers the Educare vocabularies
    Given I am a logged in user with the "Content admin" user
     Then I should be allowed "/admin/structure/taxonomy/manage/degrees/overview"
      And I should be allowed "/admin/structure/taxonomy/manage/program_type/overview"
      And I should be allowed "/admin/structure/taxonomy/manage/study_level/overview"
      And I should be allowed "/node/add/program"

  @wip @check @security @local @development
  Scenario: A Content Admin may not administer users or the site configuration
    Given I am a logged in user with the "Content admin" user
     Then I should be refused "/admin/people"
      And I should be refused "/admin/modules"

  # A plain authenticated account gets nothing editorial. This is the boundary a
  # site with open registration depends on.
  @wip @check @security @local @development
  Scenario: A Normal user may read the site and nothing more
    Given I am a logged in user with the "Normal user" user
     Then I should be allowed "/"
      And I should be allowed "/programs"
      And I should be refused "/node/add/news"
      And I should be refused "/node/add/program"
      And I should be refused "/admin/content"
      And I should be refused "/admin/people"
