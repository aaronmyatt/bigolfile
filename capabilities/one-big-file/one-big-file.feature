Feature: One big file
  As a developer
  I want nearly all behaviour in one file
  So that I never hunt through a folder tree

  New behaviour goes in the big file by default, and code is written to be easy to delete.
  Code two or more stories use goes in the helpers' own big file, so the big file reads as the
  stories alone. Both sit in one package. Code from that package moves in unchanged; code from
  another package can be folded in too, keeping its behaviour but taking the package's name
  into its own. The big file's header says how it's laid out, what's checked, and what code
  lives elsewhere and why. In Givens: internal/app/big.go and big_helpers.go.

  Scenario: Moving a story in changes no behaviour
    Given "Apply a discount code" lives in discount.go, in the same package as the big file
    When a developer moves its code into the big file unchanged
    Then every test passes as before
    And discount.go keeps only code other stories own

  Scenario: Code two stories use goes in the helpers file
    Given "Apply a discount code" and "Check out" both call "price of the cart"
    When a developer moves "Apply a discount code" in
    Then "price of the cart" goes in the helpers file
    And code only "Apply a discount code" uses goes in its section

  Scenario: A story's code inside another story's function is cut out first
    Given the expiry check sits inline in Check out's "place order" function
    When a developer moves "Apply a discount code" in
    Then the check becomes a named function in the discount code section
    And "place order" calls it where the inline code was

  Scenario: Stories moved at once clash only where every move touches
    Given two developers each move a different story in, from the same commit
    When their work is merged
    Then their sections merge by themselves, kept apart by story order
    But the import blocks and the end of the helpers file can clash

  # Givens folded in 12 packages, from internal/fingerprint to internal/slug.
  Scenario: Folding a package in carries its name into each export
    Given "price" is a package of its own with the function "Of"
    When a developer folds it into the big file's package
    Then "Of" becomes "PriceOf"
    And a name that clashes is merged only if both hold the same value, and renamed if not
    And every test passes as before

  # Givens: the install code and the welcome window. deadcode, a Go tool that finds unused
  # code, missed both: reflection, code that looks up names as it runs, kept them alive.
  Scenario: Code no story calls is deleted, not moved
    Given "export the cart" has no caller outside tests and archived code
    When a developer moves its story in
    Then "export the cart" is deleted, not moved
    And the search for its callers is what found it

  Scenario: A length limit keeps sections in small functions
    Given the project's linter caps how long a function can be
    When a section grows
    Then it splits into named functions inside the section

  # Not tried: the move into the big file only moved code that was already written.
  @todo
  Scenario: New behaviour lands in the big file
    Given a new scenario that needs new code
    When a developer builds it
    Then its code goes in its story's section of the big file
    And no new file is made for it

  # Not true of Givens yet: TestBigFile doesn't print the share. Not tripped either: folding
  # the packages in took big_helpers.go from 15% to 36% of big.go.
  @todo
  Scenario: Helpers outgrowing sections is a tripwire
    Given the sync check prints the helpers file's size as a share of the big file's
    When the share goes past one half
    Then a developer moves a group of helpers that belong together to an adjacent file
    And the big file's header says why it moved

  # Not tried: no story has been retired.
  @todo
  Scenario: Retiring a story removes its code
    Given the "Apply a discount code" story is retired
    When a developer deletes its feature file
    Then its section is deleted from the big file
    And helpers nothing calls any more are deleted

  Rule: Code goes to the stories that call it

    The agents that moved Givens in settled these, and they were enough for every case.

    # Givens: trustOf and runTrusted sit in Trust a project; Drop in calls them.
    Scenario: A seam stays with its story
      Given the expiry check was cut out of Check out's "place order" as a named function
      When a developer moves "Apply a discount code" in
      Then the check goes in the discount code section
      And not in the helpers file, though "place order" calls it

    Scenario: Only live callers count
      Given "price of the cart" is called by "Check out" and by a discount code test
      When a developer decides where it goes
      Then only "Check out" counts as a caller
      And it goes in Check out's section
      And tests, step definitions and archived code never make code shared

    # Givens: the file watcher is under Open a project; reload, a helper, is its one caller.
    Scenario: A helper's inner workings go to the one story they serve
      Given "load the cart" is a helper every story calls
      And it calls "watch the cart", which only "Keep the cart fresh" is about
      Then "load the cart" goes in the helpers file
      And "watch the cart" goes in Keep the cart fresh's section

    # Givens: openRunStore in Open, and kitMessages in snapshot.go.
    Scenario: A one-line call from core glue stays put
      Given the dispatcher calls "apply discount code" in one line
      When a developer moves "Apply a discount code" in
      Then that line stays in the dispatcher
      And the section's opening comment names where it is
      And a call longer than one line is cut out as a seam first
