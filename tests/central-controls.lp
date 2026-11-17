% Run with: cyberismo calc run tests/central-controls.lp
% The test passes when "results" is empty and "error" is null. Each result is one failure.
% The fixtures are in cardRoot, under "Test content" > "Central control assessment tests".
% Keep the expectations and the checks the same as in ismsa/reports/testingCentralControls/query.lp.hbs.

%
% ismsa_expectCentral(Scope, ControlIdentifier, Assessment, Explanation, EvidenceLinks)
% Scope is the identifier of the test home, or of the register for controls outside a home.

ismsa_expectCentral("ismsa_test_cc_home-a", "ismsa_control_receive-security-issue-notifications", "ok", "The control is in scope and there is valid evidence", 1).
ismsa_expectCentral("ismsa_test_cc_home-a", "ismsa_control_notify-about-vulnerabilities-and-incidents", "ok", "The control is in scope and there is valid evidence", 2).
ismsa_expectCentral("ismsa_test_cc_home-a", "ismsa_control_contact-with-authorities", "notOk", "The control is in scope but the linked evidence is not ready", 1).
ismsa_expectCentral("ismsa_test_cc_home-a", "ismsa_control_follow-changes-in-regulation", "notOk", "The control has failed policy checks", 1).
ismsa_expectCentral("ismsa_test_cc_home-a", "ismsa_control_protect-records", "notApplicable", "The control has been marked out of scope", 0).
ismsa_expectCentral("ismsa_test_cc_home-a", "ismsa_control_assign-central-security-roles", "open", "The control has not been scoped yet", 0).
ismsa_expectCentral("ismsa_test_cc_home-b", "ismsa_control_receive-security-issue-notifications", "notOk", "The control is in scope but required evidence has not been linked", 0).
ismsa_expectCentral("ismsa_test_cc_home-b", "ismsa_control_notify-about-vulnerabilities-and-incidents", "notOk", "The control is in scope but required evidence has not been linked", 1).
ismsa_expectCentral("ismsa_test_cc_home-b", "ismsa_control_assign-central-security-roles", "ok", "The control is in scope and there is valid evidence", 1).
ismsa_expectCentral("ismsa_test_cc_no-home", "ismsa_control_receive-security-issue-notifications", "notOk", "The control is in scope but required evidence has not been linked", 0).

% ismsa_expectProgress(HomeIdentifier, Progress) for the central control register of the home
ismsa_expectProgress("ismsa_test_cc_home-a", 50).
ismsa_expectProgress("ismsa_test_cc_home-b", 33).

% ismsa_expectOwner(HomeIdentifier, ControlIdentifier, Owner): the owner is inherited from the home
ismsa_expectOwner("ismsa_test_cc_home-a", "ismsa_control_receive-security-issue-notifications", "home-a@example.com").
ismsa_expectOwner("ismsa_test_cc_home-b", "ismsa_control_assign-central-security-roles", "home-b@example.com").


ismsa_testScope(ScopeId, Scope) :-
    ismsa_expectCentral(ScopeId, _, _, _, _),
    field(Scope, "base/fieldTypes/identifier", ScopeId).

% A control in a test home
ismsa_testControl(ScopeId, ControlId, Control) :-
    ismsa_expectCentral(ScopeId, ControlId, _, _, _),
    ismsa_testScope(ScopeId, Scope),
    base_projectCardType(Scope, "ismsa/cardTypes/moduleHome"),
    ismsa_closestHome(Control, Scope),
    field(Control, "base/fieldTypes/identifier", ControlId),
    base_projectCardType(Control, "ismsa/cardTypes/internalControl").

% A control under a test register that is not in a home
ismsa_testControl(ScopeId, ControlId, Control) :-
    ismsa_expectCentral(ScopeId, ControlId, _, _, _),
    ismsa_testScope(ScopeId, Scope),
    not base_projectCardType(Scope, "ismsa/cardTypes/moduleHome"),
    ancestor(Control, Scope),
    field(Control, "base/fieldTypes/identifier", ControlId),
    base_projectCardType(Control, "ismsa/cardTypes/internalControl").

ismsa_testControlCount(ScopeId, ControlId, N) :-
    ismsa_expectCentral(ScopeId, ControlId, _, _, _),
    N = #count { Control : ismsa_testControl(ScopeId, ControlId, Control) }.

ismsa_testLinkCount(Control, N) :-
    ismsa_testControl(_, _, Control),
    N = #count { Evidence : link(Evidence, Control, "ismsa/linkTypes/evidences") }.

ismsa_testAssessmentCount(Control, N) :-
    ismsa_testControl(_, _, Control),
    N = #count { Assessment : field(Control, "base/fieldTypes/assessment", Assessment) }.

ismsa_testPass(Control) :-
    ismsa_testControl(ScopeId, ControlId, Control),
    ismsa_expectCentral(ScopeId, ControlId, Assessment, Explanation, Links),
    ismsa_testControlCount(ScopeId, ControlId, 1),
    ismsa_testAssessmentCount(Control, 1),
    field(Control, "base/fieldTypes/assessment", Assessment),
    field(Control, "base/fieldTypes/assessmentExplanation", Explanation),
    ismsa_testLinkCount(Control, Links).

ismsa_testProgressPass(HomeId) :-
    ismsa_expectProgress(HomeId, Progress),
    field(Home, "base/fieldTypes/identifier", HomeId),
    field(Register, "base/fieldTypes/identifier", "ismsa_register_central-controls"),
    ismsa_closestHome(Register, Home),
    field(Register, "base/fieldTypes/progress", Progress).

ismsa_testOwnerPass(HomeId, ControlId) :-
    ismsa_expectOwner(HomeId, ControlId, Owner),
    ismsa_testControl(HomeId, ControlId, Control),
    field(Control, "base/fieldTypes/owner", Owner).

result(("FAIL", ScopeId, ControlId)) :-
    ismsa_testControl(ScopeId, ControlId, Control),
    not ismsa_testPass(Control).

result(("MISSING", ScopeId, ControlId)) :-
    ismsa_expectCentral(ScopeId, ControlId, _, _, _),
    not ismsa_testControl(ScopeId, ControlId, _).

result(("DUPLICATE", ScopeId, ControlId)) :-
    ismsa_testControlCount(ScopeId, ControlId, N),
    N > 1.

result(("FAIL progress", HomeId)) :-
    ismsa_expectProgress(HomeId, _),
    not ismsa_testProgressPass(HomeId).

result(("FAIL owner", HomeId, ControlId)) :-
    ismsa_expectOwner(HomeId, ControlId, _),
    not ismsa_testOwnerPass(HomeId, ControlId).

% No eucra templates are installed in this project, so the CRA guidance must be off.
result(("FAIL CRA guidance is on without eucra")) :-
    ismsa_craGuidance.
