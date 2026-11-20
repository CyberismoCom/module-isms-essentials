% Run with: cyberismo calc run tests/home-libraries.lp
% The test passes when "results" is empty and "error" is null. Each result is one failure.
% The fixtures are in cardRoot, under "Test content" > "ISMS home library tests":
%
% The test homes keep the identifier "ismsa_home" of the template, because it is the extension
% point of the libraries. So the test names them by card key with ismsa_testHomeKey/2.
%
% - Test home L1 (ismsa_test_lib_home-1) has the core and all libraries. All its controls are in
%   the central control register, and its processes are in the process register. Its access
%   rights review is passed, its review of the risk register is a draft, the training control
%   has an overridden assessment, and the business continuity control is out of scope. Its risk
%   has a treatment plan and its asset is evaluated, so the checks of the asset and risk
%   controls pass.
% - Test home L2 (ismsa_test_lib_home-2) has the core without the incident register, and the
%   NIS2 library.
% - Test home L4 (ismsa_test_lib_home-4) was created from the templates of this version: the core
%   and all libraries, each library with its two buttons. Its risk register has an open risk and
%   an analysed risk without a treatment plan, and its asset register has an asset that is not
%   evaluated.
% - Test home L5 (ismsa_test_lib_home-5) has the core and the asset and risk management
%   controls, without the asset and risk registers.
% - Test home L6 (ismsa_test_lib_home-6) was created from the core of this version, without
%   libraries. It has no internal controls.
%
% Homes L1 to L5 were made before the six central controls became the security response and
% compliance basics library. They have those controls and the incident management process, so
% that library counts as added.
%
% The fallback to the home card is checked with Test home A of the central control tests,
% which has no process register.

%
% Expectations
%

% ismsa_expectLibControl(HomeId, ControlId, Assessment, Explanation, EvidenceLinks)
ismsa_expectLibControl("ismsa_test_lib_home-1", "ismsa_control_review-access-rights", "ok", "The control is in scope and there is valid evidence", 1).
ismsa_expectLibControl("ismsa_test_lib_home-1", "ismsa_control_manage-risks", "notOk", "The control is in scope but the linked evidence is not ready", 2).
ismsa_expectLibControl("ismsa_test_lib_home-1", "ismsa_control_manage-assets", "notOk", "The control is in scope but required evidence has not been linked", 1).
ismsa_expectLibControl("ismsa_test_lib_home-1", "ismsa_control_training-and-awareness", "ok", "The training is run by the parent company, and its records were checked on 19 November 2026.", 0).
ismsa_expectLibControl("ismsa_test_lib_home-1", "ismsa_control_continuity-and-recovery", "notApplicable", "The control has been marked out of scope", 0).
ismsa_expectLibControl("ismsa_test_lib_home-1", "ismsa_control_operate-security-monitoring", "notOk", "The control is in scope but required evidence has not been linked", 0).
ismsa_expectLibControl("ismsa_test_lib_home-2", "ismsa_control_notify-about-vulnerabilities-and-incidents", "notOk", "The control is in scope but required evidence has not been linked", 0).
% All planned evidence is linked, but a check of the register fails
ismsa_expectLibControl("ismsa_test_lib_home-4", "ismsa_control_manage-assets", "notOk", "The control has failed policy checks", 2).
% Missing evidence comes before the checks
ismsa_expectLibControl("ismsa_test_lib_home-4", "ismsa_control_manage-risks", "notOk", "The control is in scope but required evidence has not been linked", 0).
ismsa_expectLibControl("ismsa_test_lib_home-5", "ismsa_control_manage-risks", "notOk", "The control is in scope but required evidence has not been linked", 0).

% ismsa_expectInScope(HomeId, ControlId): a library control is in scope when it is created
ismsa_expectInScope("ismsa_test_lib_home-1", "ismsa_control_isms-scope-and-context").
ismsa_expectInScope("ismsa_test_lib_home-1", "ismsa_control_manage-assets").
ismsa_expectInScope("ismsa_test_lib_home-1", "ismsa_control_operate-security-monitoring").
ismsa_expectInScope("ismsa_test_lib_home-4", "ismsa_control_isms-scope-and-context").
ismsa_expectInScope("ismsa_test_lib_home-4", "ismsa_control_manage-risks").
ismsa_expectInScope("ismsa_test_lib_home-4", "ismsa_control_continuity-and-recovery").
ismsa_expectInScope("ismsa_test_lib_home-5", "ismsa_control_manage-assets").

% ismsa_expectCheck(HomeId, ControlId, Title): the control has a failing check with this title.
% ismsa_expectNoCheck(HomeId, ControlId): the control has no failing checks of its register.
ismsa_expectCheck("ismsa_test_lib_home-4", "ismsa_control_manage-assets", "Some assets have not been evaluated").
ismsa_expectCheck("ismsa_test_lib_home-4", "ismsa_control_manage-risks", "Some risks have not been analysed").
ismsa_expectCheck("ismsa_test_lib_home-4", "ismsa_control_manage-risks", "Some risks have no treatment plan").
ismsa_expectCheck("ismsa_test_lib_home-5", "ismsa_control_manage-assets", "No assets have been identified").
ismsa_expectCheck("ismsa_test_lib_home-5", "ismsa_control_manage-risks", "No risks have been identified").
ismsa_expectNoCheck("ismsa_test_lib_home-1", "ismsa_control_manage-assets").
ismsa_expectNoCheck("ismsa_test_lib_home-1", "ismsa_control_manage-risks").

% ismsa_expectRequirement(HomeId, RequirementId, Assessment, Explanation, ImplementsLinks)
ismsa_expectRequirement("ismsa_test_lib_home-1", "ismsa_nis2_art-20-2", "ok", "The requirement is in scope and the linked implementation is acceptable", 1).
ismsa_expectRequirement("ismsa_test_lib_home-1", "ismsa_nis2_art-21-2-b", "notOk", "The requirement is in scope but the linked implementation is not acceptable", 3).
ismsa_expectRequirement("ismsa_test_lib_home-1", "ismsa_nis2_art-21-2-c", "open", "The requirement is in scope but everything that was linked to it is out of scope", 1).
ismsa_expectRequirement("ismsa_test_lib_home-1", "ismsa_nis2_art-21-2-d", "open", "The requirement is in scope but nothing has been linked to implement it", 0).
ismsa_expectRequirement("ismsa_test_lib_home-1", "ismsa_nis2_art-23", "notOk", "The requirement is in scope but the linked implementation is not acceptable", 2).
ismsa_expectRequirement("ismsa_test_lib_home-2", "ismsa_nis2_art-20-2", "open", "The requirement is in scope but a planned control is not in this home", 0).
ismsa_expectRequirement("ismsa_test_lib_home-2", "ismsa_nis2_art-21-2-b", "notOk", "The requirement is in scope but the linked implementation is not acceptable", 1).
ismsa_expectRequirement("ismsa_test_lib_home-2", "ismsa_nis2_art-21-2-g", "open", "The requirement is in scope but a planned control is not in this home", 0).
ismsa_expectRequirement("ismsa_test_lib_home-2", "ismsa_nis2_art-21-2-h", "open", "The requirement is in scope but nothing has been linked to implement it", 0).

% ismsa_expectTarget(HomeId, ControlId, EvidenceId, TargetId): where the button creates the
% evidence. TargetId is the identifier of a register, or of the home for the fallback.
ismsa_expectTarget("ismsa_test_lib_home-1", "ismsa_control_receive-security-issue-notifications", "ismsa_document_cvd-policy", "ismsa_register_processes").
ismsa_expectTarget("ismsa_test_lib_home-1", "ismsa_control_notify-about-vulnerabilities-and-incidents", "ismsa_document_incident-management-process", "ismsa_register_processes").
ismsa_expectTarget("ismsa_test_lib_home-1", "ismsa_control_follow-changes-in-regulation", "ismsa_review_regulation-changes", "ismsa_register_compliance").
ismsa_expectTarget("ismsa_test_lib_home-1", "ismsa_control_assign-central-security-roles", "ismsa_review_central-role-assignments", "ismsa_register_processes").
ismsa_expectTarget("ismsa_test_lib_home-1", "ismsa_control_plan-and-review-isms", "ismsa_review_management-review", "ismsa_register_security-reviews").
ismsa_expectTarget("ismsa_test_lib_home-1", "ismsa_control_information-security-policy", "ismsa_document_information-security-policy", "ismsa_register_processes").
ismsa_expectTarget("ismsa_test_lib_home-1", "ismsa_control_manage-assets", "ismsa_review_asset-register", "ismsa_register_assets").
ismsa_expectTarget("ismsa_test_lib_home-1", "ismsa_control_manage-assets", "ismsa_document_asset-management-process", "ismsa_register_processes").
ismsa_expectTarget("ismsa_test_lib_home-1", "ismsa_control_manage-risks", "ismsa_document_risk-management-process", "ismsa_register_processes").
ismsa_expectTarget("ismsa_test_lib_home-1", "ismsa_control_manage-risks", "ismsa_review_risk-register", "ismsa_register_risks").
ismsa_expectTarget("ismsa_test_lib_home-1", "ismsa_control_exercise-incident-response", "ismsa_review_incident-response-exercise", "ismsa_register_incidents").
ismsa_expectTarget("ismsa_test_lib_home-1", "ismsa_control_review-access-rights", "ismsa_review_access-rights", "ismsa_register_processes").
% Home L2 has no incident register. The incident management process is in the process register
% in every home.
ismsa_expectTarget("ismsa_test_lib_home-2", "ismsa_control_notify-about-vulnerabilities-and-incidents", "ismsa_document_incident-management-process", "ismsa_register_processes").
% No process register in Test home A: the home card is used
ismsa_expectTarget("ismsa_test_cc_home-a", "ismsa_control_receive-security-issue-notifications", "ismsa_document_cvd-policy", "ismsa_test_cc_home-a").

% ismsa_expectLibProgress(HomeId, RegisterId, Progress)
% 16 controls: 2 OK and 1 not applicable
ismsa_expectLibProgress("ismsa_test_lib_home-1", "ismsa_register_central-controls", 18).
ismsa_expectLibProgress("ismsa_test_lib_home-1", "ismsa_register_nis2", 15).

% ismsa_expectInstalled(HomeId, Template) and ismsa_expectNotInstalled(HomeId, Template)
ismsa_expectInstalled("ismsa_test_lib_home-1", "ismsa/templates/informationSecurityManagementControls").
ismsa_expectInstalled("ismsa_test_lib_home-1", "ismsa/templates/informationSecurityManagementRegisters").
ismsa_expectInstalled("ismsa_test_lib_home-1", "ismsa/templates/assetAndRiskManagementControls").
ismsa_expectInstalled("ismsa_test_lib_home-1", "ismsa/templates/assetAndRiskRegisters").
ismsa_expectInstalled("ismsa_test_lib_home-1", "ismsa/templates/securityOperations").
ismsa_expectInstalled("ismsa_test_lib_home-1", "ismsa/templates/nis2Requirements").
ismsa_expectInstalled("ismsa_test_lib_home-2", "ismsa/templates/nis2Requirements").
ismsa_expectNotInstalled("ismsa_test_lib_home-2", "ismsa/templates/informationSecurityManagementControls").
ismsa_expectNotInstalled("ismsa_test_lib_home-2", "ismsa/templates/informationSecurityManagementRegisters").
ismsa_expectNotInstalled("ismsa_test_lib_home-2", "ismsa/templates/assetAndRiskManagementControls").
ismsa_expectNotInstalled("ismsa_test_lib_home-2", "ismsa/templates/assetAndRiskRegisters").
ismsa_expectNotInstalled("ismsa_test_lib_home-2", "ismsa/templates/securityOperations").
ismsa_expectInstalled("ismsa_test_lib_home-4", "ismsa/templates/informationSecurityManagementControls").
ismsa_expectInstalled("ismsa_test_lib_home-4", "ismsa/templates/informationSecurityManagementRegisters").
ismsa_expectInstalled("ismsa_test_lib_home-4", "ismsa/templates/assetAndRiskManagementControls").
ismsa_expectInstalled("ismsa_test_lib_home-4", "ismsa/templates/assetAndRiskRegisters").
ismsa_expectInstalled("ismsa_test_lib_home-5", "ismsa/templates/assetAndRiskManagementControls").
ismsa_expectNotInstalled("ismsa_test_lib_home-5", "ismsa/templates/assetAndRiskRegisters").
ismsa_expectInstalled("ismsa_test_lib_home-4", "ismsa/templates/assetManagementProcess").
ismsa_expectInstalled("ismsa_test_lib_home-4", "ismsa/templates/securityResponseAndComplianceControls").
ismsa_expectInstalled("ismsa_test_lib_home-4", "ismsa/templates/incidentManagementProcess").

% ismsa_expectParts(HomeId, Total, Added): the number of library parts offered in the home, and
% how many of them have been added. The section "Libraries" of the home card shows these.
ismsa_expectParts("ismsa_test_lib_home-1", 10, 10).
ismsa_expectParts("ismsa_test_lib_home-4", 10, 8).
ismsa_expectParts("ismsa_test_lib_home-5", 10, 3).
ismsa_expectParts("ismsa_test_lib_home-6", 10, 0).

% ismsa_expectNoControls(HomeId): the home has no internal controls.
ismsa_expectNoControls("ismsa_test_lib_home-6").
ismsa_expectNotInstalled("ismsa_test_lib_home-4", "ismsa/templates/riskManagementProcess").

%
% Checks
%

ismsa_testHomeKey("ismsa_test_lib_home-1", ismsa_g04dsanv).
ismsa_testHomeKey("ismsa_test_lib_home-2", ismsa_zg41p0fp).
ismsa_testHomeKey("ismsa_test_lib_home-4", ismsa_l866q2o1).
ismsa_testHomeKey("ismsa_test_lib_home-5", ismsa_qu1v00mj).
ismsa_testHomeKey("ismsa_test_lib_home-6", ismsa_ny30dov7).

ismsa_testHome(HomeId, Home) :-
    ismsa_testHomeKey(HomeId, Home),
    base_projectCardType(Home, "ismsa/cardTypes/moduleHome").

ismsa_testHome(HomeId, Home) :-
    field(Home, "base/fieldTypes/identifier", HomeId),
    HomeId != "ismsa_home",
    base_projectCardType(Home, "ismsa/cardTypes/moduleHome").

ismsa_testCard(HomeId, Identifier, Card) :-
    ismsa_testHome(HomeId, Home),
    ismsa_closestHome(Card, Home),
    field(Card, "base/fieldTypes/identifier", Identifier).

ismsa_testCardCount(HomeId, Identifier, N) :-
    ismsa_testHome(HomeId, _),
    ismsa_testCard(HomeId, Identifier, _),
    N = #count { Card : ismsa_testCard(HomeId, Identifier, Card) }.

% Controls

ismsa_testLibControlPass(HomeId, ControlId) :-
    ismsa_expectLibControl(HomeId, ControlId, Assessment, Explanation, Links),
    ismsa_testCardCount(HomeId, ControlId, 1),
    ismsa_testCard(HomeId, ControlId, Control),
    field(Control, "base/fieldTypes/assessment", Assessment),
    field(Control, "base/fieldTypes/assessmentExplanation", Explanation),
    Links = #count { Evidence : link(Evidence, Control, "ismsa/linkTypes/evidences") }.

result(("FAIL control", HomeId, ControlId)) :-
    ismsa_expectLibControl(HomeId, ControlId, _, _, _),
    not ismsa_testLibControlPass(HomeId, ControlId).

result(("FAIL not in scope by default", HomeId, ControlId)) :-
    ismsa_expectInScope(HomeId, ControlId),
    not field(Control, "workflowState", "In scope") : ismsa_testCard(HomeId, ControlId, Control).

% The stored state shows what happened when the fixture was created. This checks the rule that
% marks a new control in scope.

result(("FAIL no in-scope rule for a new control", HomeId, ControlId)) :-
    ismsa_expectInScope(HomeId, ControlId),
    ismsa_testCard(HomeId, ControlId, Control),
    not onTransitionExecuteTransition(Control, "Create", Control, "Mark in scope").

result(("MISSING library control", HomeId, ControlId)) :-
    ismsa_expectInScope(HomeId, ControlId),
    not ismsa_testCard(HomeId, ControlId, _).

% Checks of the registers

ismsa_testRegisterCheck("No assets have been identified").
ismsa_testRegisterCheck("Some assets have not been evaluated").
ismsa_testRegisterCheck("No risks have been identified").
ismsa_testRegisterCheck("Some risks have not been analysed").
ismsa_testRegisterCheck("Some risks have no treatment plan").

result(("FAIL check missing", HomeId, ControlId, Title)) :-
    ismsa_expectCheck(HomeId, ControlId, Title),
    not policyCheckFailure(Control, _, Title, _) : ismsa_testCard(HomeId, ControlId, Control).

result(("MISSING control of a check", HomeId, ControlId)) :-
    ismsa_expectCheck(HomeId, ControlId, _),
    not ismsa_testCard(HomeId, ControlId, _).

result(("FAIL unexpected check", HomeId, ControlId, Title)) :-
    ismsa_testCard(HomeId, ControlId, Control),
    ismsa_testRegisterCheck(Title),
    policyCheckFailure(Control, _, Title, _),
    not ismsa_expectCheck(HomeId, ControlId, Title).

result(("FAIL check on a control that is not in a home", Control, Title)) :-
    ismsa_testRegisterCheck(Title),
    policyCheckFailure(Control, _, Title, _),
    not ismsa_closestHome(Control, _).

result(("MISSING control without checks", HomeId, ControlId)) :-
    ismsa_expectNoCheck(HomeId, ControlId),
    not ismsa_testCard(HomeId, ControlId, _).

% Library parts

ismsa_testPartsPass(HomeId) :-
    ismsa_expectParts(HomeId, Total, Added),
    ismsa_testHome(HomeId, Home),
    Total = #count { T : ismsa_libraryPart(Home, _, T, _, _) },
    Added = #count { T : ismsa_libraryPartInstalled(Home, T) }.

result(("FAIL library parts", HomeId)) :-
    ismsa_expectParts(HomeId, _, _),
    not ismsa_testPartsPass(HomeId).

% Each part of a home has exactly one target card.

result(("FAIL library part target count", Home, Template)) :-
    ismsa_libraryPart(Home, _, Template, _, _),
    not 1 = #count { T : ismsa_libraryPart(Home, _, Template, _, T) }.

result(("FAIL controls in a home without libraries", HomeId, Control)) :-
    ismsa_expectNoControls(HomeId),
    ismsa_testHome(HomeId, Home),
    ismsa_closestHome(Control, Home),
    base_projectCardType(Control, "ismsa/cardTypes/internalControl").

% Requirements

ismsa_testRequirementPass(HomeId, RequirementId) :-
    ismsa_expectRequirement(HomeId, RequirementId, Assessment, Explanation, Links),
    ismsa_testCardCount(HomeId, RequirementId, 1),
    ismsa_testCard(HomeId, RequirementId, Requirement),
    field(Requirement, "base/fieldTypes/assessment", Assessment),
    field(Requirement, "base/fieldTypes/assessmentExplanation", Explanation),
    Links = #count { Control : link(Control, Requirement, "ismsa/linkTypes/implements") }.

result(("FAIL requirement", HomeId, RequirementId)) :-
    ismsa_expectRequirement(HomeId, RequirementId, _, _, _),
    not ismsa_testRequirementPass(HomeId, RequirementId).

% Evidence locations

ismsa_testTargetPass(HomeId, ControlId, EvidenceId) :-
    ismsa_expectTarget(HomeId, ControlId, EvidenceId, TargetId),
    ismsa_testCard(HomeId, ControlId, Control),
    ismsa_evidenceTarget(Control, EvidenceId, Target),
    ismsa_testTargetId(Target, TargetId),
    1 = #count { T : ismsa_evidenceTarget(Control, EvidenceId, T) }.

result(("FAIL evidence target", HomeId, ControlId, EvidenceId)) :-
    ismsa_expectTarget(HomeId, ControlId, EvidenceId, _),
    not ismsa_testTargetPass(HomeId, ControlId, EvidenceId).

ismsa_testTargetId(Target, TargetId) :-
    field(Target, "base/fieldTypes/identifier", TargetId),
    TargetId != "ismsa_home".

ismsa_testTargetId(Target, TargetId) :-
    ismsa_testHome(TargetId, Target).

% Each piece of planned evidence of each control in a home has exactly one target.

result(("FAIL evidence target count", Control, EvidenceId, N)) :-
    ismsa_plannedEvidenceInHome(Control, EvidenceId, _),
    N = #count { T : ismsa_evidenceTarget(Control, EvidenceId, T) },
    N != 1.

% Progress

ismsa_testLibProgressPass(HomeId, RegisterId) :-
    ismsa_expectLibProgress(HomeId, RegisterId, Progress),
    ismsa_testCard(HomeId, RegisterId, Register),
    field(Register, "progress", Progress).

result(("FAIL progress", HomeId, RegisterId)) :-
    ismsa_expectLibProgress(HomeId, RegisterId, _),
    not ismsa_testLibProgressPass(HomeId, RegisterId).

% Installation, with the same logic as ismsa/reports/installExtension

ismsa_testPoint(HomeId, Home, Home) :-
    ismsa_testHome(HomeId, Home).

ismsa_testPoint(HomeId, Home, Point) :-
    ismsa_testHome(HomeId, Home),
    ismsa_closestHome(Point, Home).

ismsa_testInstalled(HomeId, Template) :-
    ismsa_installableExtension(PointId, _, Template, _, ExampleId),
    ismsa_testPoint(HomeId, _, Point),
    field(Point, "base/fieldTypes/identifier", PointId),
    field(Example, "base/fieldTypes/identifier", ExampleId),
    ancestor(Example, Point).

result(("FAIL not installed", HomeId, Template)) :-
    ismsa_expectInstalled(HomeId, Template),
    not ismsa_testInstalled(HomeId, Template).

result(("FAIL installed", HomeId, Template)) :-
    ismsa_expectNotInstalled(HomeId, Template),
    ismsa_testInstalled(HomeId, Template).

% Every library template that is installable exists

result(("FAIL missing library template", Template)) :-
    ismsa_installableExtension(_, _, Template, _, _),
    not template(Template).

% Links made by identifier never cross the border of a home

result(("FAIL evidence link between homes", Evidence, Control)) :-
    link(Evidence, Control, "ismsa/linkTypes/evidences"),
    ismsa_closestHome(Evidence, Home1),
    ismsa_closestHome(Control, Home2),
    Home1 != Home2.

result(("FAIL implements link between homes", Control, Requirement)) :-
    link(Control, Requirement, "ismsa/linkTypes/implements"),
    ismsa_closestHome(Control, Home1),
    ismsa_closestHome(Requirement, Home2),
    Home1 != Home2.

% A library for new homes is offered in a new home, and not in an old-style home without a
% central control register (Test home L3).

ismsa_testHomeKey("ismsa_test_lib_home-3", ismsa_6c54egay).

result(("FAIL NIS2 library not offered in a new home", HomeId)) :-
    ismsa_testHomeKey(HomeId, Home),
    HomeId != "ismsa_test_lib_home-3",
    not ismsa_libraryOfferedInHome("ismsa/templates/nis2Requirements", Home).

result(("FAIL NIS2 library offered in an old home")) :-
    ismsa_libraryOfferedInHome("ismsa/templates/nis2Requirements", ismsa_6c54egay).

% The process parts of the asset and risk management library are offered only in new homes,
% because the process register of the old home has the same identifier.

result(("FAIL process part offered in an old home", Template)) :-
    ismsa_installableExtension("ismsa_register_processes", _, Template, _, _),
    ismsa_libraryOfferedInHome(Template, ismsa_6c54egay).

result(("FAIL process part not offered in a new home", Template)) :-
    ismsa_installableExtension("ismsa_register_processes", _, Template, _, _),
    not ismsa_libraryOfferedInHome(Template, ismsa_l866q2o1).

% Every library of this module has a place in the order on the home card.

result(("FAIL library without a rank", Library)) :-
    ismsa_installableExtension(_, Library, Template, _, _),
    ismsa_libraryControl(_, _, Library),
    not ismsa_libraryRank(Library, _).

result(("FAIL other library not offered in an old home")) :-
    not ismsa_libraryOfferedInHome("ismsa/templates/securityOperations", ismsa_6c54egay).
