Feature: A thin framework edge
  As a developer
  I want the framework kept at the edge
  So that it never owns business rules

  The edge is the thin framework layer: routes, handlers and non-functional wiring. It parses
  input, hands it to the big file and formats the result. Non-functional needs are written as
  Gherkin Rules. A Rule still gets its "// Rule:" comment in the big file, even when the edge
  enforces it, so the sync check stays simple.

  In an app with a UI, some stories are all edge: keys, layout, commands. They keep their code
  at the edge, and the big file points at it.

  # Not tried: Givens's edges are a TUI, a CLI and godog steps, not routes.
  @todo
  Scenario: A route hands straight to the big file
    Given an HTTP route for applying a discount code
    When a request arrives
    Then the route parses the input
    And calls "apply discount code"
    And formats the result as a response
    And holds no business logic

  # Not tried: Givens's stories have no non-functional Rules yet.
  @todo
  Scenario: Non-functional needs are Rules, not tags
    Given customers must be signed in to apply a code
    Then the feature file says so as Rule: Only signed-in customers can apply codes
    And the Rule groups the scenarios it governs
    And no tag wires up framework behaviour

  # Not tried: as above.
  @todo
  Scenario: A Rule the edge enforces is named in both places
    Given Rule: Only signed-in customers can apply codes is enforced at the edge
    When a developer searches the code for the Rule's name
    Then they find its "// Rule:" comment in the big file, saying where the edge enforces it
    And a comment naming the Rule on the edge code that enforces it
    And "apply discount code" knows nothing about signing in

  # Givens: The kit, Use Givens from the terminal and Work in the terminal.
  Scenario: A story that lives at the edge gets a pointer section
    Given "Browse the shop from the keyboard" is done wholly in the TUI's code
    Then the big file has its Feature comment, in story order
    And its opening comment names the edge files that do it
    And its section holds any core code only that story uses

  # Not true of Givens yet: app imports browser, which imports chromedp.
  @todo
  Scenario: The big file needs no framework
    Given the edge depends on the framework
    Then the big file has no framework dependency
    And its code runs without a server
