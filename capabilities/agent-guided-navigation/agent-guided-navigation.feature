Feature: Agent-guided navigation
  As a developer
  I want an agent to move me around the big file
  So that I stay in the zone

  A small finder script takes a Feature, Rule or Scenario name and prints the lines of its
  section and the functions in them. A name matches word for word first, then as part of a
  heading, ignoring case. The agent runs the same script, so it reads one slice, not the whole
  file. In Givens it's scripts/entry.sh.

  Scenario: Jump to a scenario's code
    Given the big file has the comment "// Scenario: Reject an expired code"
    When a developer runs the finder with "Reject an expired code"
    Then it prints the section's file and lines, like "big.go:29-49"
    And each function in the section, with its line

  Scenario: Part of a name is enough
    Given the big file has the comment "// Scenario: Reject an expired code"
    When a developer runs the finder with "expired"
    Then it finds the section for "Reject an expired code"
    And a heading named word for word wins over one that only contains the name

  Scenario: The agent reads only the slice it needs
    Given the big file is large
    When an agent works on "Reject an expired code"
    Then it runs the finder for that scenario's lines
    And reads that slice plus the helpers it calls
    And loads the whole file only when asked

  Scenario: Set up a debugging session for a scenario
    Given a developer wants to debug "Reject an expired code"
    When they run the finder with --debug and "Reject an expired code"
    Then it prints a debugger command that runs only that scenario's test
    And a breakpoint on each function in the section
    And with --run as well, the debugger starts and stops in the section's code

  Scenario: Line numbers are worked out, never stored
    Given the feature files name scenarios, not lines
    When a developer wants to jump to the code themselves
    Then the finder works out the file and lines from the name
    And no line number is written into a feature file

  Scenario: A human can find the way alone
    Given no agent is around
    When a developer searches the big file for "Reject an expired code"
    Then they land on its heading

  @error
  Scenario: A name nothing matches
    Given no heading or scenario is named "Refund a code"
    When a developer runs the finder with "Refund a code"
    Then it says nothing in the big file is named "Refund a code", and asks if its story is in yet
    And it exits with an error

  @error
  Scenario: Debugging needs a scenario's name
    Given "Apply a discount code" is a Feature, not a scenario
    When a developer runs the finder with --debug and "Apply a discount code"
    Then it prints the Feature's section
    And it says --debug takes a scenario's name, to know which test to run

  @error
  Scenario: A pointer section has nothing to debug
    Given "Browse the shop from the keyboard" has a pointer section with no functions
    When a developer runs the finder with --debug and "Browse the shop from the keyboard"
    Then it says the section has no functions to stop in
    And it exits with an error
