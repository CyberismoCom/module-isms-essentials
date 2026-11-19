%* Assertion tests for the review rules of the statement of applicability
(ismsa/calculations/soaControl)

Run from the project root:

    cyberismo calc run tests/soa-review.lp

The tests pass when "results" is empty. Each result is one failed assertion.
The fixtures are under "Test content" > "Statement of applicability review
tests". The statement of applicability has no identifier field, so the tests
find each fixture by its title.
*%

% Policy checks: ismsa_test_expectPolicy(Title, PolicyTitle).
% A fixture must have each expected policy check, and no other one.
% Without a review task, only "Review task missing" fails. "Failing policy
% checks in all review tasks" needs a review task.
ismsa_test_expectPolicy("SoA approved without review tasks", "Review task missing").
ismsa_test_expectPolicy("SoA approved with an open review", "The review subtasks of approved documents must be closed").

% Fixtures without policy checks: ismsa_test_expectNoPolicy(Title).
ismsa_test_expectNoPolicy("SoA draft without review tasks").
ismsa_test_expectNoPolicy("SoA draft with a closed review").
ismsa_test_expectNoPolicy("SoA approved with a current review").

% Denied transitions: ismsa_test_expectDenied(Title, Transition, Message),
% ismsa_test_expectNotDenied(Title, Transition, Message), and
% ismsa_test_expectAllowed(Title, Transition).
% A statement of applicability without review tasks cannot be approved, and
% the message says why.
ismsa_test_expectDenied("SoA draft without review tasks", "Approve", "Add a review task before approving").
ismsa_test_expectNotDenied("SoA draft without review tasks", "Approve", "Fix policy failures in at least one of the review subtask(s) before approving").
% ismsa asks for the approval date before approval, so this fixture has one.
ismsa_test_expectAllowed("SoA draft with a closed review", "Approve").

% Bind the expectations to the fixture cards

ismsa_test_soaPage(Page) :-
    projectCard(Page),
    field(Page, "title", "Statement of applicability review tests").

ismsa_test_soaFixture(Id, Card) :-
    ismsa_test_soaPage(Page),
    parent(Card, Page),
    projectCard(Card),
    field(Card, "title", Id).

ismsa_test_expected(Id) :- ismsa_test_expectPolicy(Id, _).
ismsa_test_expected(Id) :- ismsa_test_expectNoPolicy(Id).
ismsa_test_expected(Id) :- ismsa_test_expectDenied(Id, _, _).
ismsa_test_expected(Id) :- ismsa_test_expectNotDenied(Id, _, _).
ismsa_test_expected(Id) :- ismsa_test_expectAllowed(Id, _).

% Assertions

ismsa_test_failure(Id, "missing") :-
    ismsa_test_expected(Id),
    not ismsa_test_soaFixture(Id, _).

ismsa_test_failure(Id, "title is not unique") :-
    ismsa_test_expected(Id),
    #count { Card : ismsa_test_soaFixture(Id, Card) } > 1.

ismsa_test_failure(Id, @concatenate("policy check missing: ", Title)) :-
    ismsa_test_expectPolicy(Id, Title),
    ismsa_test_soaFixture(Id, Card),
    not base_policyCheckFailure(Card, _, Title, _).

ismsa_test_failure(Id, @concatenate("unexpected policy check: ", Title)) :-
    ismsa_test_soaFixture(Id, Card),
    base_policyCheckFailure(Card, _, Title, _),
    not ismsa_test_expectPolicy(Id, Title).

ismsa_test_failure(Id, @concatenate("not denied: ", Message)) :-
    ismsa_test_expectDenied(Id, Transition, Message),
    ismsa_test_soaFixture(Id, Card),
    not transitionDenied(Card, Transition, Message).

ismsa_test_failure(Id, @concatenate("denied: ", Message)) :-
    ismsa_test_expectNotDenied(Id, Transition, Message),
    ismsa_test_soaFixture(Id, Card),
    transitionDenied(Card, Transition, Message).

ismsa_test_failure(Id, @concatenate("denied: ", Message)) :-
    ismsa_test_expectAllowed(Id, Transition),
    ismsa_test_soaFixture(Id, Card),
    transitionDenied(Card, Transition, Message).

result((Subject, Reason)) :- ismsa_test_failure(Subject, Reason).
