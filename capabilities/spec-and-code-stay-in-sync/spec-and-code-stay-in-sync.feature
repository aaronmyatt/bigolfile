Feature: Spec and code stay in sync
  As a developer
  I want a cheap, steady check that the spec and the big file agree
  So that the feature files never quietly lie

  The sync check is a plain test in the normal test run. It reads the feature files with the
  real Gherkin parser and the big file's headings line by line. It also runs whenever a
  feature file or the big file is saved. In Givens it's TestBigFile.

  It checks that each Feature comment names a real Feature, word for word, and that every
  Feature has a section. Sections follow the order of the capabilities folders. A section has
  every Rule of its Feature, in order. A Scenario comment names one of its Feature's scenarios.
  The helpers file holds no Feature, Rule or Scenario comments. Scenario comments are optional.
  While stories are still moving in, the check can count the missing ones instead of failing.

  Scenario: Every heading names something real
    Given the shop's feature files and its big file agree
    When the sync check runs
    Then it passes

  Scenario: Scenario comments are optional
    Given "Reject an expired code" has no Scenario comment in the big file
    When the sync check runs
    Then it passes

  Scenario: Stories still moving in are counted
    Given stories are still moving into the big file
    And it has a section for "Apply a discount code" but not for "Check out"
    When the sync check runs
    Then it passes
    And it reports "1 of 2 stories are in the big file"

  @error
  Scenario: A story with no section, once every story is in
    Given every story has moved into the big file
    And a developer adds check-out-faster.feature with no section for it
    When the sync check runs
    Then it fails, naming check-out-faster.feature
    And it says "Feature: Check out faster" has no section in the big file

  @error
  Scenario: A story heading in the helpers file
    Given the helpers file has "// Feature: Apply a discount code"
    When the sync check runs
    Then it fails, naming the helpers file's line
    And it says the heading belongs in the big file

  @error
  Scenario: A moved comment that reads as a heading
    Given a function's doc comment has a wrapped line starting "// Scenario: or Feature: line"
    When a developer moves the function into the big file unchanged
    Then the sync check fails on that line
    And rewrapping the comment's words fixes it

  Scenario: The check runs on every save
    Given a developer saves apply-a-discount-code.feature or the big file
    Then the sync check runs straight away
    And a mismatch shows before they move on

  Scenario: The check needs no agent
    Given the sync check is a plain test
    When it runs twice on the same files
    Then it gives the same answer both times
    And it costs no agent time or tokens

  @error
  Scenario: A Scenario comment that names no scenario
    Given the big file has "// Scenario: Apply a vaild code"
    When the sync check runs
    Then it fails, naming the big file's line
    And it says "Scenario: Apply a vaild code" isn't in apply-a-discount-code.feature

  @error
  Scenario: A Feature comment that names no Feature
    Given the big file has "// Feature: Apply a discont code"
    When the sync check runs
    Then it fails, naming the big file's line
    And it says no capability has "Feature: Apply a discont code"

  @error
  Scenario: A Rule comment the Feature doesn't have
    Given the big file has "// Rule: Codes never run out" in the discount code section
    When the sync check runs
    Then it fails, naming the section's line
    And it lists the Rules apply-a-discount-code.feature has, in order

  @error
  Scenario: Sections out of order
    Given the big file has the checkout section above the discount code section
    When the sync check runs
    Then it fails, naming the checkout section's line
    And it says sections follow the capabilities folders

  @error
  Scenario: Renaming a scenario breaks its comment
    Given the big file has "// Scenario: Apply a valid code"
    When a developer renames the scenario to "Apply a code" in its feature file
    Then the sync check fails on the old comment's line

  # Not tried: an early check flagged these, but the heading check doesn't.
  @todo
  Scenario: Code no scenario leads to is flagged
    Given a section for a Feature whose capability was deleted
    When the sync check runs
    Then it names the section as one to delete
