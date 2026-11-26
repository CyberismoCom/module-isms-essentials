%* Assertion tests for the assessment of assessed security requirements
(ismsa/calculations/assessedSecurityRequirement)

Run from the project root:

    cyberismo calc run tests/security-requirements.lp

The tests pass when "results" is empty. Each result is one failed assertion.
The fixtures are under "Test content" > "Security requirement assessment
tests". Each fixture has an identifier of the form ismsa_test_sr_<case>.
*%

% Test evidence, as a connector would emit it:
% ismsa_testEvidence(Identifier, Run, Result, Date, Version)
ismsa_testEvidence("ismsa_test_sr_test-passed", "run-1", "passed", "2026-11-20", "1.0.0").
ismsa_testEvidence("ismsa_test_sr_test-failed-latest", "run-1", "passed", "2026-11-01", "1.0.0").
ismsa_testEvidence("ismsa_test_sr_test-failed-latest", "run-2", "failed", "2026-11-20", "1.1.0").
ismsa_testEvidence("ismsa_test_sr_test-fixed", "run-1", "failed", "2026-11-01", "1.0.0").
ismsa_testEvidence("ismsa_test_sr_test-fixed", "run-2", "passed", "2026-11-20", "1.0.1").

% ismsa_test_expectSr(Identifier, Assessment, Explanation)
ismsa_test_expectSr("ismsa_test_sr_out-of-scope", "notApplicable", "The requirement has been marked out of scope").
ismsa_test_expectSr("ismsa_test_sr_out-of-scope-no-justification", "notApplicable", "The requirement has been marked out of scope").
ismsa_test_expectSr("ismsa_test_sr_not-reviewed", "notStarted", "The requirement is in scope, but no review role has answered yet").
ismsa_test_expectSr("ismsa_test_sr_partly-reviewed", "inProgress", "The requirement is under review, but the review roles have not all answered yet").
ismsa_test_expectSr("ismsa_test_sr_changes-needed", "notOk", "A review of the requirement asks for changes").
ismsa_test_expectSr("ismsa_test_sr_not-verified", "notStarted", "The requirement has been reviewed, but it has not been verified yet").
ismsa_test_expectSr("ismsa_test_sr_test-passed", "ok", "The requirement has been reviewed and verified").
ismsa_test_expectSr("ismsa_test_sr_test-failed-latest", "notOk", "The requirement has been reviewed, but a verification is failing").
ismsa_test_expectSr("ismsa_test_sr_test-fixed", "ok", "The requirement has been reviewed and verified").
ismsa_test_expectSr("ismsa_test_sr_review-pending", "inProgress", "The requirement has been reviewed, but a verification is not ready yet").
ismsa_test_expectSr("ismsa_test_sr_review-passed", "ok", "The requirement has been reviewed and verified").
ismsa_test_expectSr("ismsa_test_sr_archived-document", "notStarted", "The requirement has been reviewed, but everything that verifies it is not applicable").

% An overridden assessment keeps its value and has no calculated explanation.
% ismsa_test_expectSrOverride(Identifier, Assessment)
ismsa_test_expectSrOverride("ismsa_test_sr_override-without-explanation", "ok").

% ismsa_test_expectSrPolicy(Identifier, PolicyTitle): the fixture has this failing
% policy check. Fixtures in ismsa_test_expectSr have no failing policy checks,
% unless they are listed here.
ismsa_test_expectSrPolicy("ismsa_test_sr_out-of-scope-no-justification", "Justification missing").
ismsa_test_expectSrPolicy("ismsa_test_sr_override-without-explanation", "Assessment explanation not given for overridden assessment").


ismsa_test_srFixture(Id, Card) :-
    ismsa_securityRequirement(Card),
    field(Card, "base/fieldTypes/identifier", Id).

ismsa_test_srExpected(Id) :- ismsa_test_expectSr(Id, _, _).
ismsa_test_srExpected(Id) :- ismsa_test_expectSrOverride(Id, _).

ismsa_test_failure(Id, "missing") :-
    ismsa_test_srExpected(Id),
    not ismsa_test_srFixture(Id, _).

ismsa_test_failure(Id, "identifier is not unique") :-
    ismsa_test_srExpected(Id),
    #count { Card : ismsa_test_srFixture(Id, Card) } > 1.

ismsa_test_failure(Id, @concatenate("assessment is not ", Expected)) :-
    ismsa_test_expectSr(Id, Expected, _),
    ismsa_test_srFixture(Id, Card),
    not field(Card, "base/fieldTypes/assessment", Expected).

ismsa_test_failure(Id, @concatenate("explanation is not: ", Expected)) :-
    ismsa_test_expectSr(Id, _, Expected),
    ismsa_test_srFixture(Id, Card),
    not field(Card, "base/fieldTypes/assessmentExplanation", Expected).

ismsa_test_failure(Id, "more than one calculated assessment") :-
    ismsa_test_srFixture(Id, Card),
    #count { A : ismsa_securityRequirementAssessment(Card, A, _) } > 1.

ismsa_test_failure(Id, @concatenate("overridden assessment is not ", Expected)) :-
    ismsa_test_expectSrOverride(Id, Expected),
    ismsa_test_srFixture(Id, Card),
    not field(Card, "base/fieldTypes/assessment", Expected).

ismsa_test_failure(Id, "overridden assessment has a calculated explanation") :-
    ismsa_test_expectSrOverride(Id, _),
    ismsa_test_srFixture(Id, Card),
    field(Card, "base/fieldTypes/assessmentExplanation", _).

ismsa_test_failure(Id, @concatenate("policy check missing: ", Title)) :-
    ismsa_test_expectSrPolicy(Id, Title),
    ismsa_test_srFixture(Id, Card),
    not base_policyCheckFailure(Card, _, Title, _).

ismsa_test_failure(Id, @concatenate("unexpected policy check: ", Title)) :-
    ismsa_test_srExpected(Id),
    ismsa_test_srFixture(Id, Card),
    base_policyCheckFailure(Card, _, Title, _),
    not ismsa_test_expectSrPolicy(Id, Title).

result((Subject, Reason)) :- ismsa_test_failure(Subject, Reason).
