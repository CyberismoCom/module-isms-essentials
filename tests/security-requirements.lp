%* Assertion tests for the stage and the assessment of assessed security
requirements (ismsa/calculations/assessedSecurityRequirement)

Run from the project root:

    cyberismo calc run tests/security-requirements.lp

The tests pass when "results" is empty. Each result is one failed assertion.
The fixtures are under "Test content" > "Security requirement assessment
tests". Each fixture has an identifier of the form ismsa_test_sr_<case>.
*%

% The scope of a connector fact is the card key of the requirement or of a card
% above it. Most facts below use the page that holds the fixtures. One uses
% "Test content", two levels up, and one uses the requirement itself.

% Test evidence, as a connector would emit it:
% ismsa_testEvidence(Scope, Identifier, Run, Result, Date, Version)
ismsa_testEvidence(ismsa_wmbvomzv, "ismsa_test_sr_test-passed", "run-1", "passed", "2026-11-20", "1.0.0").
ismsa_testEvidence(ismsa_op4u735f, "ismsa_test_sr_test-failed-latest", "run-1", "passed", "2026-11-01", "1.0.0").
ismsa_testEvidence(ismsa_op4u735f, "ismsa_test_sr_test-failed-latest", "run-2", "failed", "2026-11-20", "1.1.0").
ismsa_testEvidence(ismsa_op4u735f, "ismsa_test_sr_test-fixed", "run-1", "failed", "2026-11-01", "1.0.0").
ismsa_testEvidence(ismsa_op4u735f, "ismsa_test_sr_test-fixed", "run-2", "passed", "2026-11-20", "1.0.1").
ismsa_testEvidence(ismsa_z4hq1afa, "ismsa_test_sr_test-mixed-same-date", "run-1", "passed", "2026-11-20", "1.0.0").
ismsa_testEvidence(ismsa_z4hq1afa, "ismsa_test_sr_test-mixed-same-date", "run-2", "failed", "2026-11-20", "1.0.0").
ismsa_testEvidence(ismsa_op4u735f, "ismsa_test_sr_verified-implementation-open", "run-1", "passed", "2026-11-20", "1.0.0").

% Implementation work, as a connector would emit it:
% ismsa_implementationWork(Scope, Identifier, Item, State)
ismsa_implementationWork(ismsa_op4u735f, "ismsa_test_sr_implementation-done", ("test-tracker", "ISSUE-1"), "done").
ismsa_implementationWork(ismsa_op4u735f, "ismsa_test_sr_implementation-done", ("test-tracker", "ISSUE-2"), "done").
ismsa_implementationWork(ismsa_op4u735f, "ismsa_test_sr_verified-implementation-open", ("test-tracker", "ISSUE-3"), "open").

% Facts of another scope must not count. The scope here is another fixture, which
% is not above "ismsa_test_sr_other-scope" in the card tree.
ismsa_testEvidence(ismsa_xif2ks2f, "ismsa_test_sr_other-scope", "run-1", "passed", "2026-11-20", "1.0.0").
ismsa_implementationWork(ismsa_xif2ks2f, "ismsa_test_sr_other-scope", ("test-tracker", "ISSUE-4"), "open").

% Verifications and implementation work, as another module would add them:
% a requirement that asks for changes verifies "verification-failing", and a
% requirement that is out of scope implements "implementation-not-applicable".
ismsa_securityRequirementVerification(Requirement, Card) :-
    ismsa_test_srFixture("ismsa_test_sr_verification-failing", Requirement),
    ismsa_test_srFixture("ismsa_test_sr_changes-needed", Card).

ismsa_securityRequirementImplementation(Requirement, Card) :-
    ismsa_test_srFixture("ismsa_test_sr_implementation-not-applicable", Requirement),
    ismsa_test_srFixture("ismsa_test_sr_out-of-scope", Card).

% ismsa_test_expectSr(Identifier, Stage, Explanation)
ismsa_test_expectSr("ismsa_test_sr_out-of-scope", "notApplicable", "The requirement has been marked out of scope").
ismsa_test_expectSr("ismsa_test_sr_out-of-scope-no-justification", "notApplicable", "The requirement has been marked out of scope").
ismsa_test_expectSr("ismsa_test_sr_not-reviewed", "notStarted", "The requirement is in scope, but no review role has answered yet").
ismsa_test_expectSr("ismsa_test_sr_partly-reviewed", "reviewInProgress", "The requirement is under review, but the review roles have not all answered yet").
ismsa_test_expectSr("ismsa_test_sr_changes-needed", "notOk", "A review of the requirement asks for changes").
ismsa_test_expectSr("ismsa_test_sr_not-verified", "contentReady", "The requirement has been reviewed, but nothing implements or verifies it yet").
ismsa_test_expectSr("ismsa_test_sr_archived-document", "contentReady", "The requirement has been reviewed, but everything that verifies it is not applicable").
ismsa_test_expectSr("ismsa_test_sr_implementation-open", "implementationInProgress", "The requirement has been reviewed, and the implementation work is under way").
ismsa_test_expectSr("ismsa_test_sr_implementation-done", "toBeVerified", "The implementation work is done, but nothing verifies the requirement yet").
ismsa_test_expectSr("ismsa_test_sr_test-passed", "ok", "The requirement has been reviewed and verified").
ismsa_test_expectSr("ismsa_test_sr_test-failed-latest", "notOk", "The requirement has been reviewed, but a verification is failing").
ismsa_test_expectSr("ismsa_test_sr_test-fixed", "ok", "The requirement has been reviewed and verified").
ismsa_test_expectSr("ismsa_test_sr_review-pending", "verificationInProgress", "The requirement has been reviewed, but a verification is not ready yet").
ismsa_test_expectSr("ismsa_test_sr_review-passed", "ok", "The requirement has been reviewed and verified").
ismsa_test_expectSr("ismsa_test_sr_verification-failing", "notOk", "The requirement has been reviewed, but a verification is failing").
ismsa_test_expectSr("ismsa_test_sr_implementation-task-done", "toBeVerified", "The implementation work is done, but nothing verifies the requirement yet").
ismsa_test_expectSr("ismsa_test_sr_implementation-not-applicable", "contentReady", "The requirement has been reviewed, but nothing implements or verifies it yet").
ismsa_test_expectSr("ismsa_test_sr_verified-implementation-open", "implementationInProgress", "The requirement has been reviewed, and the implementation work is under way").
ismsa_test_expectSr("ismsa_test_sr_test-mixed-same-date", "notOk", "The requirement has been reviewed, but a verification is failing").
ismsa_test_expectSr("ismsa_test_sr_other-scope", "contentReady", "The requirement has been reviewed, but nothing implements or verifies it yet").
ismsa_test_expectSr("ismsa_test_sr_review-record-missing", "notOk", "The requirement has failed policy checks").
ismsa_test_expectSr("ismsa_test_sr_review-comment-missing", "notOk", "The requirement has failed policy checks").

% An overridden stage keeps its value and has no calculated explanation.
% ismsa_test_expectSrOverride(Identifier, Stage)
ismsa_test_expectSrOverride("ismsa_test_sr_override-without-explanation", "ok").
ismsa_test_expectSrOverride("ismsa_test_sr_override-agrees", "contentReady").
ismsa_test_expectSrOverride("ismsa_test_sr_override-disagrees", "ok").

% ismsa_test_expectSrPolicy(Identifier, PolicyTitle): the fixture has this failing
% policy check. Fixtures in ismsa_test_expectSr have no failing policy checks,
% unless they are listed here.
ismsa_test_expectSrPolicy("ismsa_test_sr_out-of-scope-no-justification", "Justification missing").
ismsa_test_expectSrPolicy("ismsa_test_sr_override-without-explanation", "Explanation not given for overridden stage").
ismsa_test_expectSrPolicy("ismsa_test_sr_review-record-missing", "Reviewer missing").
ismsa_test_expectSrPolicy("ismsa_test_sr_review-record-missing", "Review date missing").
ismsa_test_expectSrPolicy("ismsa_test_sr_review-comment-missing", "Review comment missing").

% ismsa_test_expectSrNotification(Identifier, Title): the fixture has this
% notification. A fixture that is not listed here has none.
ismsa_test_expectSrNotification("ismsa_test_sr_override-disagrees", "The stage has been overridden").


% The stage drives the assessment. This pins the mapping itself, and the check
% below pins that the field follows it, overridden or not.
% ismsa_test_expectStageAssessment(Stage, Assessment)
ismsa_test_expectStageAssessment("notStarted", "notStarted").
ismsa_test_expectStageAssessment("reviewInProgress", "inProgress").
ismsa_test_expectStageAssessment("contentReady", "inProgress").
ismsa_test_expectStageAssessment("implementationInProgress", "inProgress").
ismsa_test_expectStageAssessment("toBeVerified", "inProgress").
ismsa_test_expectStageAssessment("verificationInProgress", "inProgress").
ismsa_test_expectStageAssessment("ok", "ok").
ismsa_test_expectStageAssessment("notOk", "notOk").
ismsa_test_expectStageAssessment("notApplicable", "notApplicable").

ismsa_test_failure(Stage, @concatenate("the stage does not give the assessment ", Assessment)) :-
    ismsa_test_expectStageAssessment(Stage, Assessment),
    not ismsa_stageAssessment(Stage, Assessment).

ismsa_test_failure(Stage, @concatenate("unexpected stage assessment: ", Assessment)) :-
    ismsa_stageAssessment(Stage, Assessment),
    not ismsa_test_expectStageAssessment(Stage, Assessment).


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

ismsa_test_failure(Id, @concatenate("stage is not ", Expected)) :-
    ismsa_test_expectSr(Id, Expected, _),
    ismsa_test_srFixture(Id, Card),
    not field(Card, "ismsa/fieldTypes/securityRequirementStage", Expected).

ismsa_test_failure(Id, @concatenate("explanation is not: ", Expected)) :-
    ismsa_test_expectSr(Id, _, Expected),
    ismsa_test_srFixture(Id, Card),
    not field(Card, "base/fieldTypes/assessmentExplanation", Expected).

ismsa_test_failure(Id, "more than one calculated stage") :-
    ismsa_test_srFixture(Id, Card),
    #count { Stage : ismsa_securityRequirementStage(Card, Stage, _) } > 1.

% The assessment follows the stage for every fixture, overridden or not.
ismsa_test_failure(Id, "the assessment does not follow the stage") :-
    ismsa_test_srFixture(Id, Card),
    field(Card, "ismsa/fieldTypes/securityRequirementStage", Stage),
    ismsa_stageAssessment(Stage, Assessment),
    not field(Card, "base/fieldTypes/assessment", Assessment).

ismsa_test_failure(Id, @concatenate("overridden stage is not ", Expected)) :-
    ismsa_test_expectSrOverride(Id, Expected),
    ismsa_test_srFixture(Id, Card),
    not field(Card, "ismsa/fieldTypes/securityRequirementStage", Expected).

ismsa_test_failure(Id, "overridden stage has a calculated explanation") :-
    ismsa_test_expectSrOverride(Id, _),
    ismsa_test_srFixture(Id, Card),
    fieldCalculated(Card, "base/fieldTypes/assessmentExplanation", _).

ismsa_test_failure(Id, @concatenate("policy check missing: ", Title)) :-
    ismsa_test_expectSrPolicy(Id, Title),
    ismsa_test_srFixture(Id, Card),
    not base_policyCheckFailure(Card, _, Title, _).

ismsa_test_failure(Id, @concatenate("unexpected policy check: ", Title)) :-
    ismsa_test_srExpected(Id),
    ismsa_test_srFixture(Id, Card),
    base_policyCheckFailure(Card, _, Title, _),
    not ismsa_test_expectSrPolicy(Id, Title).

ismsa_test_failure(Id, @concatenate("notification missing: ", Title)) :-
    ismsa_test_expectSrNotification(Id, Title),
    ismsa_test_srFixture(Id, Card),
    not notification(Card, _, Title, _).

ismsa_test_failure(Id, @concatenate("unexpected notification: ", Title)) :-
    ismsa_test_srExpected(Id),
    ismsa_test_srFixture(Id, Card),
    notification(Card, _, Title, _),
    not ismsa_test_expectSrNotification(Id, Title).

result((Subject, Reason)) :- ismsa_test_failure(Subject, Reason).
