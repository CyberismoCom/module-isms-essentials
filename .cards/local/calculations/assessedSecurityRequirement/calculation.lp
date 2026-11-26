%
% Rules for calculating the Stage, the Assessment, and the Assessment explanation
% of an assessed security requirement.
%
% An assessed security requirement is a technical requirement for a product,
% solution, or service. It is in scope by default, as an assessed compliance
% requirement is. Its status is calculated from its reviews, its implementation
% work, and its verifications, not set by moving it in a workflow.
%
% The stage is the position of the requirement in its life cycle. It is decided in
% this order:
%    1. Out of scope: not applicable.
%    2. Failed policy checks: not OK.
%    3. A review asks for changes: not OK.
%    4. No review role has answered: not started.
%    5. Some review roles have answered, but not all: review in progress.
%    6. A verification is failing: not OK.
%    7. Verified: OK.
%    8. A verification is not ready: verification in progress.
%    9. The implementation work is done: to be verified.
%   10. Implementation work is open: implementation in progress.
%   11. Nothing implements or verifies the requirement, or everything that
%       verifies it is not applicable: content ready.
%
% The stage is the only status that a person overrides. The assessment follows
% from it through ismsa_stageAssessment, so an overridden stage moves the
% assessment, the status indicator, and everything that reads the assessment.
% "Not started" and "In progress" follow the assessment values that ismsa #48 gave
% to internal controls and compliance requirements. "Not OK" is for failures only.
%
% ismsa_securityRequirementStage(Requirement, Stage, Explanation) pairs a stage
% with its explanation. The bodies of the rules are mutually exclusive, so that
% each requirement gets exactly one stage.
%
% Extension points for other modules:
%
%   ismsa_securityRequirementVerification(Requirement, Card)
%     Card verifies Requirement, for example a detailed requirement that refines it
%     or a test review. The assessment and the workflow state of Card count in the
%     same way as for the implementations of an assessed compliance requirement.
%     This module adds the documents and reviews linked with "evidences".
%
%   ismsa_securityRequirementImplementation(Requirement, Item)
%     Item is work that implements Requirement, for example a task or an issue in
%     an issue tracker. This module adds the cards linked with "implements".
%     ismsa_securityRequirementImplementationDone(Requirement, Item) says that the
%     work is finished, and Item is open until then.
%
%   ismsa_implementationWork(Identifier, Item, State)
%     Implementation work from a connector, keyed by the identifier of the
%     requirement. State is "open" or "done". Item is the key of the external item,
%     for example ("cyberismo-jira", "ISSUE-123"), so that a report can show its
%     title and its link. A connector that cannot tell whether the work is finished
%     emits nothing: a commit alone does not say that a requirement is implemented.
%
%   ismsa_testEvidence(Identifier, Run, Result, Date, Version)
%     A test result, for example from a connector that reads the test runs of CI.
%     Identifier is the identifier of the requirement. Result is "passed" or
%     "failed". Only the results of the latest Date count.
%
%     These rules compare Date as a string. They do not parse it. Date therefore
%     has a strict format, and all the facts of one Identifier must use the same
%     one:
%
%       - a date, "YYYY-MM-DD", for example "2026-11-20", or
%       - a time in UTC to the second, "YYYY-MM-DDThh:mm:ssZ", for example
%         "2026-11-20T11:00:00Z".
%
%     A local offset such as "+02:00" and fractional seconds such as ".500" are
%     not allowed, and neither is a mixture of the two formats. Such values sort
%     in the wrong order, and an older passing result then hides a newer failing
%     one. Convert the timestamps in the connector.
%

ismsa_securityRequirement(Requirement) :-
  base_projectCardType(Requirement, "ismsa/cardTypes/assessedSecurityRequirement").

ismsa_securityRequirementInScope(Requirement) :-
  ismsa_securityRequirement(Requirement),
  field(Requirement, "workflowState", "In scope").

ismsa_securityRequirementOutOfScope(Requirement) :-
  ismsa_securityRequirement(Requirement),
  field(Requirement, "workflowState", "Out of scope").

%
% Reviews: one result field for each review role
%

ismsa_securityRequirementReviewField("ismsa/fieldTypes/architectureReview").
ismsa_securityRequirementReviewField("ismsa/fieldTypes/testReview").
ismsa_securityRequirementReviewField("ismsa/fieldTypes/securityReview").
ismsa_securityRequirementReviewField("ismsa/fieldTypes/productOwnerReview").

ismsa_securityRequirementReviewDone(Requirement, Field) :-
  ismsa_securityRequirement(Requirement),
  ismsa_securityRequirementReviewField(Field),
  field(Requirement, Field, Result),
  Result != "open".

ismsa_securityRequirementReviewOpen(Requirement) :-
  ismsa_securityRequirement(Requirement),
  ismsa_securityRequirementReviewField(Field),
  not ismsa_securityRequirementReviewDone(Requirement, Field).

% A requirement that at least one review role has answered is under review, even
% when the other roles have not answered yet (E1-D23).

ismsa_securityRequirementReviewStarted(Requirement) :-
  ismsa_securityRequirementReviewDone(Requirement, _).

ismsa_securityRequirementReviewChangesNeeded(Requirement) :-
  ismsa_securityRequirement(Requirement),
  ismsa_securityRequirementReviewField(Field),
  field(Requirement, Field, "deviation").

%
% Implementation work: the cards and the external items that implement the
% requirement
%
% A security requirement that implements another one is a refinement, and a
% refinement verifies the requirement instead. See
% ismsa_securityRequirementVerification above.

ismsa_securityRequirementImplementation(Requirement, Card) :-
  ismsa_securityRequirement(Requirement),
  link(Card, Requirement, "ismsa/linkTypes/implements"),
  not ismsa_securityRequirement(Card).

ismsa_securityRequirementImplementationDone(Requirement, Card) :-
  ismsa_securityRequirementImplementation(Requirement, Card),
  field(Card, "base/fieldTypes/assessment", "ok").

ismsa_securityRequirementImplementationDone(Requirement, Card) :-
  ismsa_securityRequirementImplementation(Requirement, Card),
  not field(Card, "base/fieldTypes/assessment", _),
  field(Card, "workflowStateCategory", "closed").

ismsa_securityRequirementImplementationExcluded(Requirement, Card) :-
  ismsa_securityRequirementImplementation(Requirement, Card),
  field(Card, "base/fieldTypes/assessment", "notApplicable").

ismsa_securityRequirementImplementation(Requirement, Item) :-
  ismsa_securityRequirement(Requirement),
  field(Requirement, "base/fieldTypes/identifier", Identifier),
  ismsa_implementationWork(Identifier, Item, _).

ismsa_securityRequirementImplementationDone(Requirement, Item) :-
  ismsa_securityRequirement(Requirement),
  field(Requirement, "base/fieldTypes/identifier", Identifier),
  ismsa_implementationWork(Identifier, Item, "done").

ismsa_securityRequirementImplementationOpen(Requirement, Item) :-
  ismsa_securityRequirementImplementation(Requirement, Item),
  not ismsa_securityRequirementImplementationDone(Requirement, Item),
  not ismsa_securityRequirementImplementationExcluded(Requirement, Item).

%
% Verifications: cards that verify the requirement
%

ismsa_securityRequirementVerification(Requirement, Card) :-
  ismsa_securityRequirement(Requirement),
  link(Card, Requirement, "ismsa/linkTypes/evidences").

ismsa_securityRequirementVerificationComplete(Requirement, Card) :-
  ismsa_securityRequirementVerification(Requirement, Card),
  field(Card, "base/fieldTypes/assessment", "ok").

ismsa_securityRequirementVerificationComplete(Requirement, Card) :-
  ismsa_securityRequirementVerification(Requirement, Card),
  not field(Card, "base/fieldTypes/assessment", _),
  field(Card, "workflowStateCategory", "closed").

ismsa_securityRequirementVerificationExcluded(Requirement, Card) :-
  ismsa_securityRequirementVerification(Requirement, Card),
  field(Card, "base/fieldTypes/assessment", "notApplicable").

ismsa_securityRequirementVerificationFailing(Requirement, Card) :-
  ismsa_securityRequirementVerification(Requirement, Card),
  field(Card, "base/fieldTypes/assessment", "notOk").

ismsa_securityRequirementVerificationFailing(Requirement, Card) :-
  ismsa_securityRequirementVerification(Requirement, Card),
  base_policyCheckFailure(Card, _, _, _).

ismsa_securityRequirementVerificationPending(Requirement, Card) :-
  ismsa_securityRequirementVerification(Requirement, Card),
  not ismsa_securityRequirementVerificationComplete(Requirement, Card),
  not ismsa_securityRequirementVerificationExcluded(Requirement, Card),
  not ismsa_securityRequirementVerificationFailing(Requirement, Card).

%
% Test evidence keyed by the identifier of the requirement
%

ismsa_testEvidenceLater(Identifier, Date) :-
  ismsa_testEvidence(Identifier, _, _, Date, _),
  ismsa_testEvidence(Identifier, _, _, LaterDate, _),
  LaterDate > Date.

ismsa_securityRequirementLatestTest(Requirement, Result) :-
  ismsa_securityRequirement(Requirement),
  field(Requirement, "base/fieldTypes/identifier", Identifier),
  ismsa_testEvidence(Identifier, _, Result, Date, _),
  not ismsa_testEvidenceLater(Identifier, Date).

ismsa_securityRequirementTestFailing(Requirement) :-
  ismsa_securityRequirementLatestTest(Requirement, "failed").

ismsa_securityRequirementTestPassing(Requirement) :-
  ismsa_securityRequirementLatestTest(Requirement, "passed"),
  not ismsa_securityRequirementTestFailing(Requirement).

%
% Summary predicates
%

ismsa_securityRequirementFailing(Requirement) :-
  ismsa_securityRequirementVerificationFailing(Requirement, _).

ismsa_securityRequirementFailing(Requirement) :-
  ismsa_securityRequirementTestFailing(Requirement).

ismsa_securityRequirementVerified(Requirement) :-
  ismsa_securityRequirementVerificationComplete(Requirement, _).

ismsa_securityRequirementVerified(Requirement) :-
  ismsa_securityRequirementTestPassing(Requirement).

ismsa_securityRequirementHasVerification(Requirement) :-
  ismsa_securityRequirementVerification(Requirement, _).

ismsa_securityRequirementHasVerification(Requirement) :-
  ismsa_securityRequirementLatestTest(Requirement, _).

ismsa_securityRequirementHasImplementation(Requirement) :-
  ismsa_securityRequirementImplementation(Requirement, Item),
  not ismsa_securityRequirementImplementationExcluded(Requirement, Item).

ismsa_securityRequirementImplementationPending(Requirement) :-
  ismsa_securityRequirementImplementationOpen(Requirement, _).

% The requirement is in scope, has no policy check failures, and its reviews are
% done without requests for changes. Only then do the implementation work and the
% verifications decide.

ismsa_securityRequirementReviewed(Requirement) :-
  ismsa_securityRequirementInScope(Requirement),
  not base_policyCheckFailure(Requirement, _, _, _),
  not ismsa_securityRequirementReviewChangesNeeded(Requirement),
  not ismsa_securityRequirementReviewOpen(Requirement).

%
% The stage
%

ismsa_securityRequirementStage(Requirement, "notApplicable", "The requirement has been marked out of scope") :-
  ismsa_securityRequirementOutOfScope(Requirement).

ismsa_securityRequirementStage(Requirement, "notOk", "The requirement has failed policy checks") :-
  ismsa_securityRequirementInScope(Requirement),
  base_policyCheckFailure(Requirement, _, _, _).

ismsa_securityRequirementStage(Requirement, "notOk", "A review of the requirement asks for changes") :-
  ismsa_securityRequirementInScope(Requirement),
  not base_policyCheckFailure(Requirement, _, _, _),
  ismsa_securityRequirementReviewChangesNeeded(Requirement).

ismsa_securityRequirementStage(Requirement, "notStarted", "The requirement is in scope, but no review role has answered yet") :-
  ismsa_securityRequirementInScope(Requirement),
  not base_policyCheckFailure(Requirement, _, _, _),
  not ismsa_securityRequirementReviewChangesNeeded(Requirement),
  ismsa_securityRequirementReviewOpen(Requirement),
  not ismsa_securityRequirementReviewStarted(Requirement).

ismsa_securityRequirementStage(Requirement, "reviewInProgress", "The requirement is under review, but the review roles have not all answered yet") :-
  ismsa_securityRequirementInScope(Requirement),
  not base_policyCheckFailure(Requirement, _, _, _),
  not ismsa_securityRequirementReviewChangesNeeded(Requirement),
  ismsa_securityRequirementReviewOpen(Requirement),
  ismsa_securityRequirementReviewStarted(Requirement).

ismsa_securityRequirementStage(Requirement, "notOk", "The requirement has been reviewed, but a verification is failing") :-
  ismsa_securityRequirementReviewed(Requirement),
  ismsa_securityRequirementFailing(Requirement).

ismsa_securityRequirementStage(Requirement, "ok", "The requirement has been reviewed and verified") :-
  ismsa_securityRequirementReviewed(Requirement),
  not ismsa_securityRequirementFailing(Requirement),
  not ismsa_securityRequirementVerificationPending(Requirement, _),
  ismsa_securityRequirementVerified(Requirement).

ismsa_securityRequirementStage(Requirement, "verificationInProgress", "The requirement has been reviewed, but a verification is not ready yet") :-
  ismsa_securityRequirementReviewed(Requirement),
  not ismsa_securityRequirementFailing(Requirement),
  ismsa_securityRequirementVerificationPending(Requirement, _).

ismsa_securityRequirementStage(Requirement, "toBeVerified", "The implementation work is done, but nothing verifies the requirement yet") :-
  ismsa_securityRequirementReviewed(Requirement),
  not ismsa_securityRequirementFailing(Requirement),
  not ismsa_securityRequirementVerificationPending(Requirement, _),
  not ismsa_securityRequirementVerified(Requirement),
  ismsa_securityRequirementHasImplementation(Requirement),
  not ismsa_securityRequirementImplementationPending(Requirement).

ismsa_securityRequirementStage(Requirement, "implementationInProgress", "The requirement has been reviewed, and the implementation work is under way") :-
  ismsa_securityRequirementReviewed(Requirement),
  not ismsa_securityRequirementFailing(Requirement),
  not ismsa_securityRequirementVerificationPending(Requirement, _),
  not ismsa_securityRequirementVerified(Requirement),
  ismsa_securityRequirementImplementationPending(Requirement).

ismsa_securityRequirementStage(Requirement, "contentReady", "The requirement has been reviewed, but everything that verifies it is not applicable") :-
  ismsa_securityRequirementReviewed(Requirement),
  not ismsa_securityRequirementFailing(Requirement),
  not ismsa_securityRequirementVerificationPending(Requirement, _),
  not ismsa_securityRequirementVerified(Requirement),
  not ismsa_securityRequirementHasImplementation(Requirement),
  ismsa_securityRequirementHasVerification(Requirement).

ismsa_securityRequirementStage(Requirement, "contentReady", "The requirement has been reviewed, but nothing implements or verifies it yet") :-
  ismsa_securityRequirementReviewed(Requirement),
  not ismsa_securityRequirementFailing(Requirement),
  not ismsa_securityRequirementVerificationPending(Requirement, _),
  not ismsa_securityRequirementVerified(Requirement),
  not ismsa_securityRequirementHasImplementation(Requirement),
  not ismsa_securityRequirementHasVerification(Requirement).

%
% The assessment follows from the stage
%

ismsa_stageAssessment("notStarted", "notStarted").
ismsa_stageAssessment("reviewInProgress", "inProgress").
ismsa_stageAssessment("contentReady", "inProgress").
ismsa_stageAssessment("implementationInProgress", "inProgress").
ismsa_stageAssessment("toBeVerified", "inProgress").
ismsa_stageAssessment("verificationInProgress", "inProgress").
ismsa_stageAssessment("ok", "ok").
ismsa_stageAssessment("notOk", "notOk").
ismsa_stageAssessment("notApplicable", "notApplicable").

%
% The calculated fields
%

fieldCalculated(Requirement, "ismsa/fieldTypes/securityRequirementStage", Stage) :-
  ismsa_securityRequirementStage(Requirement, Stage, _).

% The body reads the field and not the calculated value, so that an overridden
% stage moves the assessment with it.

fieldCalculated(Requirement, "base/fieldTypes/assessment", Assessment) :-
  ismsa_securityRequirement(Requirement),
  field(Requirement, "ismsa/fieldTypes/securityRequirementStage", Stage),
  ismsa_stageAssessment(Stage, Assessment).

% An overridden stage has no calculated explanation. Overriding is how a team
% without a connector tracks the stage by hand, and how a requirement that was
% verified before these rules existed is attested. The policy check below asks for
% the explanation.

fieldCalculated(Requirement, "base/fieldTypes/assessmentExplanation", Explanation) :-
  ismsa_securityRequirementStage(Requirement, _, Explanation),
  not fieldOverride(Requirement, "ismsa/fieldTypes/securityRequirementStage", _).

policyCheckSuccess(Requirement, "Security requirement assessment", @concatenate("Requirement is acceptable: ", Explanation)) :-
  ismsa_securityRequirement(Requirement),
  field(Requirement, "base/fieldTypes/assessment", "ok"),
  field(Requirement, "base/fieldTypes/assessmentExplanation", Explanation).

policyCheckSuccess(Requirement, "Security requirement assessment", @concatenate("Requirement is acceptable: ", Explanation)) :-
  ismsa_securityRequirement(Requirement),
  field(Requirement, "base/fieldTypes/assessment", "notApplicable"),
  field(Requirement, "base/fieldTypes/assessmentExplanation", Explanation).

% An overridden stage hides what the rules calculate, so the reader is told what
% the rules say. An override without an explanation fails the policy check below
% instead, and that failure is itself what the rules would calculate, so the
% notification waits until the person has explained the override.

notification(
  Requirement,
  "Security requirement",
  "The stage has been overridden",
  @concatenate("The rules calculate a different stage. ", Explanation)
) :-
  ismsa_securityRequirement(Requirement),
  fieldOverride(Requirement, "ismsa/fieldTypes/securityRequirementStage", Override),
  fieldOverride(Requirement, "base/fieldTypes/assessmentExplanation", _),
  ismsa_securityRequirementStage(Requirement, Calculated, Explanation),
  Calculated != Override.

%
% A justification is required to mark the requirement out of scope
%

transitionDenied(
  Requirement,
  "Mark out of scope",
  "To mark this requirement as out of scope, you must first provide a justification. Fill in the scoping justification field."
) :-
  ismsa_securityRequirement(Requirement),
  not field(Requirement, "base/fieldTypes/justification", _).

policyCheckFailure(
  Requirement,
  "Security requirement",
  "Justification missing",
  "A scoping justification is mandatory for requirements that have been marked out of scope. Set this field",
  "base/fieldTypes/justification"
) :-
  ismsa_securityRequirementOutOfScope(Requirement),
  not field(Requirement, "base/fieldTypes/justification", _).

policyCheckFailure(
  Requirement,
  "Security requirement",
  "Assessment explanation not given for overridden stage",
  "The stage field has been overridden, but the assessment explanation has not been updated. Explain the stage by overriding the assessment explanation field.",
  "base/fieldTypes/assessmentExplanation"
) :-
  ismsa_securityRequirement(Requirement),
  fieldOverride(Requirement, "ismsa/fieldTypes/securityRequirementStage", _),
  not fieldOverride(Requirement, "base/fieldTypes/assessmentExplanation", _).
