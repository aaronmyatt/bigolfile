Feature: Testing through the big file
  As a developer
  I want tests to call the code the scenarios lead to
  So that the test suite mirrors the spec

  Each scenario runs as a test of the same name, so a scenario's name finds its test as well
  as its code. In Givens, godog runs each scenario as a subtest named after it, spaces as
  underscores.

  Scenario: Every scenario has a test of the same name
    Given the scenario "Reject an expired code"
    When the tests run
    Then a test named "Reject an expired code" runs
    And it sets up the Given steps, calls the code and checks the Then steps

  # Not tried: Givens's steps reach the big file through the App and Window types.
  @todo
  Scenario: One export opens the big file to tests
    Given the big file
    Then it opens all its sections to tests through a single export
    And tests reach the big file only through that export

  # Not tried: Givens's steps run against a real Window.
  @todo
  Scenario: Tests need no running server
    Given dependencies are passed in
    When a test calls the big file's code with fakes
    Then it runs without the framework edge

  # Not true of Givens yet: Window holds caches and UI state that sections share.
  @todo
  Scenario: Sections share no hidden state
    Given two tests call code in different sections
    When they run in any order
    Then neither depends on state left by the other
