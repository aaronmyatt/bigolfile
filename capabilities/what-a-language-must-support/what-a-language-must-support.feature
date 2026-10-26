Feature: What a language must support
  As a developer choosing a language
  I want the few things this workflow depends on
  So that any language that has them will do

  Go has them: names resolve across a package's files, and delve (dlv), its debugger, sets
  breakpoints by function name from the command line.

  Scenario: Names resolve at call time
    Given a section calls a helper defined further down
    When the program runs
    Then the call works without forward declarations

  Scenario: The agent can drive the debugger
    Given the agent knows a section's functions by name
    When it sets up a debugging session
    Then it sets a breakpoint on each by name
    And it does so from the command line

  # Givens, at 7,740 lines: one scenario's test (Record a run) runs again in 1.2 s; big.go
  # builds again in 0.1 s.
  Scenario: Feedback without leaving the file
    Given a developer changes one section
    When they want to see the effect
    Then they can re-run its scenario's test in seconds
    And they don't restart the whole system

  # Givens, at 7,740 lines plus 2,777 in big_helpers.go, with a warm build cache: gopls
  # checks big.go in 1.5 s and finds references in 0.5 s, tigerlint takes 0.7 s on the
  # package, and the finder 0.03 s.
  Scenario: Large files stay responsive
    Given the big file has grown to thousands of lines
    Then the editor, type checker and language server stay usable
