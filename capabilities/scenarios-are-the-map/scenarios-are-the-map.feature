Feature: Scenarios are the map
  As a developer
  I want every scenario to lead to the code that does it
  So that I go from intent to code in one hop

  The big file tells the stories in order, as literate code. Each story has a section that
  starts with a "Feature:" comment, its Feature's name word for word. Inside it, each Rule has
  a "Rule:" comment, and a "Scenario:" comment marks the code a scenario starts in, where that
  helps a reader. The feature files carry no pointers back: no tags, no file names, no line
  numbers. The big file points at the scenarios, not the other way round.

  A heading doesn't have to be exact about where the code starts. A section is enough for a
  reader, and an agent fills the gap.

  The running example is a shop's "Apply a discount code" story, with the scenarios "Apply a
  valid code" and "Reject an expired code".

  Scenario: A search for a scenario's name lands on its code
    Given the shop's big file has the comment "// Scenario: Apply a valid code"
    When a developer searches the big file for "Apply a valid code"
    Then they land on the code that applies a discount code

  Scenario: Several scenarios share one piece of code
    Given "Apply a valid code" and "Reject an expired code" both apply a code
    When a developer reads the big file
    Then both Scenario comments sit together above "apply discount code"
    And no code is repeated between them

  Scenario: A scenario with no comment of its own
    Given "Reject an expired code" is under Rule: Codes run out
    And the big file has no Scenario comment for it
    When a developer looks for "Reject an expired code"
    Then they land on the section for "Codes run out"
    And a scenario outside any Rule lands on its Feature's section

  Scenario: Given steps set up and Then steps check
    Given a scenario with Given, When and Then steps
    When its test is written
    Then its Given steps set up the starting state
    And its When step calls the code its section holds
    And its Then steps check the result

  Scenario: The big file reads in story order
    Given the capabilities folders list "Apply a discount code" before "Check out"
    When a developer reads the big file top to bottom
    Then the discount code section comes before the checkout section
    And reading on follows the stories

  Scenario: Feature files carry no code pointers
    Given a developer writes the scenario "Apply a valid code"
    Then it has no tag naming its code
    And it has no file name or line number

  # Not tried: Givens keeps godog and its step definitions.
  @todo
  Scenario: Feature files work without step definitions
    Given no BDD runner runs the feature files
    Then they still work as bookmarks into the big file
    And there is no step-definition glue to keep up
