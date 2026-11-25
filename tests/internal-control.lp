%* Assertion tests for the assessment of internal controls and compliance
requirements (ismsa/calculations/internalControl and
ismsa/calculations/assessedComplianceRequirement)

Run from the project root:

    cyberismo calc run tests/internal-control.lp

The tests pass when "results" is empty. Each result is one failed assertion.
The fixtures are under "Test content" > "Internal control tests" and
"Compliance requirement tests". The fixtures have no identifier field, so the
tests find each fixture by its title.
*%

% ismsa_test_expectAssessment(Title, Assessment)

ismsa_test_expectAssessment("Internal control 1: Draft document evidence", "inProgress").
ismsa_test_expectAssessment("Internal control 2: No evidence", "notStarted").
ismsa_test_expectAssessment("Internal control 3: Valid document evidence", "ok").
ismsa_test_expectAssessment("Internal control 4: Evidence has policy failures", "notOk").
ismsa_test_expectAssessment("Internal control 5: Both valid and draft evidence", "inProgress").
ismsa_test_expectAssessment("Internal control 6: Two valid pieces of evidence", "ok").
ismsa_test_expectAssessment("Internal control 7: One valid piece of evidence and another with failed checks", "notOk").
ismsa_test_expectAssessment("Internal control 8: Out of scope", "notApplicable").
ismsa_test_expectAssessment("Internal control 9: Control has a policy check failure", "notOk").
ismsa_test_expectAssessment("Internal control 10: Expired document", "notOk").
ismsa_test_expectAssessment("Internal control 11: Two reviews, old and new", "ok").
ismsa_test_expectAssessment("Internal control 12: Expired review", "notOk").
ismsa_test_expectAssessment("Internal control 13: Scoping has not been done", "open").
ismsa_test_expectAssessment("Internal control 14: No evidence and policy check failure", "notStarted").
ismsa_test_expectAssessment("Internal control 15: Assessment overridden with an explanation", "ok").
ismsa_test_expectAssessment("Internal control 16: Assessment overridden without an explanation", "ok").

ismsa_test_expectAssessment("Requirement 1: Nothing has been linked", "open").
ismsa_test_expectAssessment("Requirement 2: Implemented by a control with valid evidence", "ok").
ismsa_test_expectAssessment("Requirement 3: Implemented by a control that has no evidence", "open").
ismsa_test_expectAssessment("Requirement 4: Implemented by a control that has a policy check failure", "notOk").
ismsa_test_expectAssessment("Requirement 5: Implemented by a control that is out of scope", "open").
ismsa_test_expectAssessment("Requirement 6: Implemented by a control that has not been scoped", "open").
ismsa_test_expectAssessment("Requirement 7: Evidenced directly by a review", "ok").
ismsa_test_expectAssessment("Requirement 8: Out of scope with a justification", "notApplicable").
ismsa_test_expectAssessment("Requirement 9: Manually attested with an explanation", "ok").
ismsa_test_expectAssessment("Requirement 10: Assessment overridden without an explanation", "ok").
ismsa_test_expectAssessment("Requirement 11: Out of scope without a justification", "notApplicable").

% ismsa_test_expectStatus(Title, Status indicator)

ismsa_test_expectStatus("Internal control 1: Draft document evidence", "active").
ismsa_test_expectStatus("Internal control 2: No evidence", "initial").
ismsa_test_expectStatus("Internal control 13: Scoping has not been done", "initial").
ismsa_test_expectStatus("Internal control 14: No evidence and policy check failure", "error").

% Fixtures

ismsa_test_expected(Title) :- ismsa_test_expectAssessment(Title, _).
ismsa_test_expected(Title) :- ismsa_test_expectStatus(Title, _).

ismsa_test_fixture(Title, Card) :-
    ismsa_test_expected(Title),
    field(Card, "title", Title).

% Assertions

ismsa_test_failure(Title, "missing") :-
    ismsa_test_expected(Title),
    not ismsa_test_fixture(Title, _).

ismsa_test_failure(Title, @concatenate("assessment is not ", Expected)) :-
    ismsa_test_expectAssessment(Title, Expected),
    ismsa_test_fixture(Title, Card),
    not field(Card, "base/fieldTypes/assessment", Expected).

ismsa_test_failure(Title, "assessment count") :-
    ismsa_test_expectAssessment(Title, _),
    ismsa_test_fixture(Title, Card),
    #count { A : field(Card, "base/fieldTypes/assessment", A) } != 1.

ismsa_test_failure(Title, @concatenate("status indicator is not ", Expected)) :-
    ismsa_test_expectStatus(Title, Expected),
    ismsa_test_fixture(Title, Card),
    not field(Card, "statusIndicator", Expected).

% Every internal control fixture has an expected assessment.

ismsa_test_failure(Title, "internal control fixture without an expected assessment") :-
    base_projectCardType(Card, "ismsa/cardTypes/internalControl"),
    parent(Card, ismsa_9r7airhi),
    field(Card, "title", Title),
    not ismsa_test_expectAssessment(Title, _).

result((Subject, Reason)) :- ismsa_test_failure(Subject, Reason).
