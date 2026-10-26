Feature: Deliberate exceptions
  As a developer
  I want a short, explicit list of what lives elsewhere
  So that splitting is a decision, not drift

  Only four kinds of code may leave the big file without a reason of its own. Any other split
  needs one. Either way, the big file's header lists the file and why it's elsewhere.
  Dependencies are passed in as plainly as possible.

  # Givens: internal/app/model; the edges; snapshot.go, offers.go and the other core glue;
  # internal/browser.
  Scenario Outline: Allowed adjacent files
    Given code that is <kind>
    Then it may live in an adjacent file
    And the big file's header lists that file and why

    Examples:
      | kind                                    |
      | a data model definition                 |
      | framework glue at the edge              |
      | the dispatcher every story runs through |
      | a third-party integration               |

  Scenario: Any other split needs a reason
    Given part of a story is a shell script that runs in the developer's shell
    When a developer leaves it out of the big file
    Then the big file's header names the script and why it's elsewhere
    And code with no reason stays in the big file

  # Givens: internal/assert, the one package tigerlint lets panic, and internal/app/starter,
  # since Go embeds only files under the package's own folder.
  Scenario: A tool forces a split
    Given the linter lets only the assertions package panic
    Then the assertions stay in a package of their own
    And the big file's header names the linter rule that keeps them there

  Scenario: A scenario done outside the big file
    Given "Run from a subfolder" is done by the shell script, not the app
    And the big file has no Scenario comment for it
    When a developer looks for "Run from a subfolder"
    Then they land on its Feature's section
    And the section's opening comment says where in the script to look

  # Not tried: no Givens story calls another service.
  @todo
  Scenario: Third-party dependencies are passed in simply
    Given "apply discount code" needs a pricing service
    When it's called
    Then the service is passed in as an argument
    And no dependency injection framework is used
    And a test can pass a fake in its place
