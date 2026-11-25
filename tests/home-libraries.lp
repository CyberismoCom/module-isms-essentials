% Run with: cyberismo calc run tests/home-libraries.lp
% The test passes when "results" is empty and "error" is null. Each result is one failure.
% The fixtures are in cardRoot, under "Test content" > "ISMS home library tests":
%
% The test homes keep the identifier "ismsa_home" of the template, because it is the extension
% point of the libraries. So the test names them by card key with ismsa_testHomeKey/2.
%
% - Test home L1 (ismsa_test_lib_home-1) has the core and all libraries. All its controls are in
%   the control register, and its processes are in the process register. Its access
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
% - Test home L7 (ismsa_test_lib_home-7) was created on 2026-11-23 from the templates of that
%   version, with all libraries, and with "yes" to all six questions. No evidence is created. It
%   checks that every NIS2 requirement finds all its planned controls in a home with all
%   libraries. The controls "Manage human resources security" and "Measure the effectiveness of
%   security" were added to it by hand on 2026-11-24, as copies of the template cards. It
%   answers "no" to the AI question, which was added on 2026-11-25.
% - Test home L8 (ismsa_test_lib_home-8) was created on 2026-11-25 from the templates of that
%   version, with "yes" only to the AI question. It has the AI use basics library (all three
%   parts), the asset and risk registers, and the asset and risk management controls. It has no
%   AI responsible and no evidence. Its register "AI tools" has three AI assets: one assessed,
%   one without an assessment, and one with a prohibited use.
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
ismsa_expectLibControl("ismsa_test_lib_home-1", "ismsa_control_manage-risks", "inProgress", "The control is in scope, but the linked evidence is not ready yet", 2).
ismsa_expectLibControl("ismsa_test_lib_home-1", "ismsa_control_manage-assets", "notStarted", "The control is in scope, but no evidence has been linked yet", 1).
ismsa_expectLibControl("ismsa_test_lib_home-1", "ismsa_control_training-and-awareness", "ok", "The training is run by the parent company, and its records were checked on 19 November 2026.", 0).
ismsa_expectLibControl("ismsa_test_lib_home-1", "ismsa_control_continuity-and-recovery", "notApplicable", "The control has been marked out of scope", 0).
ismsa_expectLibControl("ismsa_test_lib_home-1", "ismsa_control_operate-security-monitoring", "notStarted", "The control is in scope, but no evidence has been linked yet", 0).
ismsa_expectLibControl("ismsa_test_lib_home-2", "ismsa_control_notify-about-vulnerabilities-and-incidents", "notStarted", "The control is in scope, but no evidence has been linked yet", 0).
% All planned evidence is linked, but a check of the register fails
ismsa_expectLibControl("ismsa_test_lib_home-4", "ismsa_control_manage-assets", "notOk", "The control has failed policy checks", 2).
% Missing evidence comes before the checks
ismsa_expectLibControl("ismsa_test_lib_home-4", "ismsa_control_manage-risks", "notStarted", "The control is in scope, but no evidence has been linked yet", 0).
% The business context analysis in the process register is the evidence of the scope control
ismsa_expectLibControl("ismsa_test_lib_home-4", "ismsa_control_isms-scope-and-context", "inProgress", "The control is in scope, but the linked evidence is not ready yet", 1).
ismsa_expectLibControl("ismsa_test_lib_home-5", "ismsa_control_manage-risks", "notStarted", "The control is in scope, but no evidence has been linked yet", 0).

% The controls added on 2026-11-23 (E10-D12), without evidence
ismsa_expectLibControl("ismsa_test_lib_home-7", "ismsa_control_apply-basic-security-practices", "notStarted", "The control is in scope, but no evidence has been linked yet", 0).
ismsa_expectLibControl("ismsa_test_lib_home-7", "ismsa_control_manage-vulnerabilities-and-updates", "notStarted", "The control is in scope, but no evidence has been linked yet", 0).
ismsa_expectLibControl("ismsa_test_lib_home-7", "ismsa_control_manage-supplier-security", "notStarted", "The control is in scope, but no evidence has been linked yet", 0).
ismsa_expectLibControl("ismsa_test_lib_home-7", "ismsa_control_human-resources-security", "notStarted", "The control is in scope, but no evidence has been linked yet", 0).
ismsa_expectLibControl("ismsa_test_lib_home-7", "ismsa_control_measure-security-effectiveness", "notStarted", "The control is in scope, but no evidence has been linked yet", 0).

% ismsa_expectInScope(HomeId, ControlId): a library control is in scope when it is created
ismsa_expectInScope("ismsa_test_lib_home-7", "ismsa_control_apply-basic-security-practices").
ismsa_expectInScope("ismsa_test_lib_home-7", "ismsa_control_manage-vulnerabilities-and-updates").
ismsa_expectInScope("ismsa_test_lib_home-7", "ismsa_control_manage-supplier-security").
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
ismsa_expectCheck("ismsa_test_lib_home-7", "ismsa_control_manage-assets", "No assets have been identified").
ismsa_expectCheck("ismsa_test_lib_home-7", "ismsa_control_manage-risks", "No risks have been identified").
ismsa_expectNoCheck("ismsa_test_lib_home-1", "ismsa_control_manage-assets").
ismsa_expectNoCheck("ismsa_test_lib_home-1", "ismsa_control_manage-risks").

% ismsa_expectRequirement(HomeId, RequirementId, Assessment, Explanation, ImplementsLinks)
ismsa_expectRequirement("ismsa_test_lib_home-1", "ismsa_nis2_art-20-2", "ok", "The requirement is in scope and the linked implementation is acceptable", 1).
ismsa_expectRequirement("ismsa_test_lib_home-1", "ismsa_nis2_art-21-2-b", "inProgress", "The requirement is in scope, but the linked implementation is not ready yet", 3).
ismsa_expectRequirement("ismsa_test_lib_home-1", "ismsa_nis2_art-21-2-c", "notStarted", "The requirement is in scope, but everything that was linked to it is out of scope", 1).
ismsa_expectRequirement("ismsa_test_lib_home-1", "ismsa_nis2_art-21-2-d", "notStarted", "The requirement is in scope, but a planned control is not in this home yet", 0).
ismsa_expectRequirement("ismsa_test_lib_home-1", "ismsa_nis2_art-23", "inProgress", "The requirement is in scope, but the linked implementation is not ready yet", 2).
ismsa_expectRequirement("ismsa_test_lib_home-2", "ismsa_nis2_art-20-2", "notStarted", "The requirement is in scope, but a planned control is not in this home yet", 0).
ismsa_expectRequirement("ismsa_test_lib_home-2", "ismsa_nis2_art-21-2-b", "notStarted", "The requirement is in scope, but a planned control is not in this home yet", 1).
ismsa_expectRequirement("ismsa_test_lib_home-2", "ismsa_nis2_art-21-2-g", "notStarted", "The requirement is in scope, but a planned control is not in this home yet", 0).
ismsa_expectRequirement("ismsa_test_lib_home-2", "ismsa_nis2_art-21-2-h", "notStarted", "The requirement is in scope, but a planned control is not in this home yet", 0).

% ismsa_expectTarget(HomeId, ControlId, EvidenceId, TargetId): where the button creates the
% evidence. TargetId is the identifier of a register, or of the home for the fallback.
ismsa_expectTarget("ismsa_test_lib_home-1", "ismsa_control_receive-security-issue-notifications", "ismsa_document_cvd-policy", "ismsa_register_processes").
ismsa_expectTarget("ismsa_test_lib_home-1", "ismsa_control_notify-about-vulnerabilities-and-incidents", "ismsa_document_incident-management-process", "ismsa_register_processes").
ismsa_expectTarget("ismsa_test_lib_home-1", "ismsa_control_follow-changes-in-regulation", "ismsa_review_regulation-changes", "ismsa_register_compliance").
ismsa_expectTarget("ismsa_test_lib_home-1", "ismsa_control_assign-central-security-roles", "ismsa_review_central-role-assignments", "ismsa_register_processes").
ismsa_expectTarget("ismsa_test_lib_home-1", "ismsa_control_plan-and-review-isms", "ismsa_review_management-review", "ismsa_register_security-reviews").
ismsa_expectTarget("ismsa_test_lib_home-1", "ismsa_control_isms-scope-and-context", "ismsa_document_business-context-analysis", "ismsa_register_processes").
ismsa_expectTarget("ismsa_test_lib_home-1", "ismsa_control_information-security-policy", "ismsa_document_information-security-policy", "ismsa_register_processes").
ismsa_expectTarget("ismsa_test_lib_home-1", "ismsa_control_information-security-policy", "ismsa_document_cryptography-rules", "ismsa_register_processes").
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

ismsa_expectTarget("ismsa_test_lib_home-7", "ismsa_control_manage-supplier-security", "ismsa_review_supplier-security", "ismsa_register_assets").
ismsa_expectTarget("ismsa_test_lib_home-7", "ismsa_control_apply-basic-security-practices", "ismsa_review_basic-security-practices", "ismsa_register_processes").
ismsa_expectTarget("ismsa_test_lib_home-7", "ismsa_control_manage-vulnerabilities-and-updates", "ismsa_document_vulnerability-and-update-management-process", "ismsa_register_processes").

% ismsa_expectLibProgress(HomeId, RegisterId, Progress)
% 16 controls: 2 OK and 1 not applicable
ismsa_expectLibProgress("ismsa_test_lib_home-1", "ismsa_register_central-controls", 18).
% 13 NIS2 requirements: only Article 20(2) is OK. Article 21(2)(g) is open, because L1 does not
% have the controls that were added on 2026-11-23.
ismsa_expectLibProgress("ismsa_test_lib_home-1", "ismsa_register_nis2", 7).

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
ismsa_expectInstalled("ismsa_test_lib_home-4", "ismsa/templates/securityResponseAndComplianceControls").

% ismsa_expectParts(HomeId, Total, Added): the number of library parts offered in the home, and
% how many of them have been added. The section "Libraries" of the home card shows these.
% The AI use basics library adds three parts (2026-11-25). Its register "AI tools" is offered
% only in a home with the supporting assets of the asset register, so L5 and L6 have nine parts.
ismsa_expectParts("ismsa_test_lib_home-1", 10, 7).
ismsa_expectParts("ismsa_test_lib_home-4", 10, 6).
ismsa_expectParts("ismsa_test_lib_home-5", 9, 2).
ismsa_expectParts("ismsa_test_lib_home-6", 9, 0).
ismsa_expectParts("ismsa_test_lib_home-8", 10, 5).

% The library choice from the answers on the home card (ismsa/calculations/libraryChoice)
%
% L1: no existing ISMS, full ISMS, own assets, own services, and NIS2. All five libraries are
%     required and added.
% L4: no existing ISMS and the CRA, nothing else. Only security response and compliance basics
%     is required. The other libraries are in the home, but not needed.
% L5: an existing ISMS, the CRA, own assets, and NIS2. NIS2 and asset and risk management are
%     required directly. The implied libraries are dropped.
% L6: no answers. Every library is undecided.
%
% ismsa_expectLibrary(HomeId, LibraryTitle, State), where State is "required", "notNeeded", or
% "undecided". ismsa_expectAdded(HomeId, LibraryTitle, "added" | "partly" | "none").
% ismsa_expectComplete(HomeId) and ismsa_expectNotComplete(HomeId).
ismsa_expectLibrary("ismsa_test_lib_home-1", "Security response and compliance basics", "required").
ismsa_expectLibrary("ismsa_test_lib_home-1", "Information security management basics", "required").
ismsa_expectLibrary("ismsa_test_lib_home-1", "Asset and risk management", "required").
ismsa_expectLibrary("ismsa_test_lib_home-1", "Security operations basics", "required").
ismsa_expectLibrary("ismsa_test_lib_home-1", "NIS2 basics", "required").
ismsa_expectComplete("ismsa_test_lib_home-1").

ismsa_expectLibrary("ismsa_test_lib_home-4", "Security response and compliance basics", "required").
ismsa_expectLibrary("ismsa_test_lib_home-4", "Information security management basics", "notNeeded").
ismsa_expectLibrary("ismsa_test_lib_home-4", "Asset and risk management", "notNeeded").
ismsa_expectLibrary("ismsa_test_lib_home-4", "Security operations basics", "notNeeded").
ismsa_expectLibrary("ismsa_test_lib_home-4", "NIS2 basics", "notNeeded").
ismsa_expectComplete("ismsa_test_lib_home-4").

ismsa_expectLibrary("ismsa_test_lib_home-5", "Security response and compliance basics", "notNeeded").
ismsa_expectLibrary("ismsa_test_lib_home-5", "Information security management basics", "notNeeded").
ismsa_expectLibrary("ismsa_test_lib_home-5", "Asset and risk management", "required").
ismsa_expectLibrary("ismsa_test_lib_home-5", "Security operations basics", "notNeeded").
ismsa_expectLibrary("ismsa_test_lib_home-5", "NIS2 basics", "required").
ismsa_expectAdded("ismsa_test_lib_home-5", "Asset and risk management", "partly").
ismsa_expectAdded("ismsa_test_lib_home-5", "NIS2 basics", "none").
ismsa_expectAdded("ismsa_test_lib_home-5", "Security response and compliance basics", "added").
ismsa_expectNotComplete("ismsa_test_lib_home-5").

ismsa_expectLibrary("ismsa_test_lib_home-6", "Security response and compliance basics", "undecided").
ismsa_expectLibrary("ismsa_test_lib_home-6", "NIS2 basics", "undecided").
ismsa_expectNotComplete("ismsa_test_lib_home-6").

ismsa_expectLibrary("ismsa_test_lib_home-7", "Security operations basics", "required").
ismsa_expectLibrary("ismsa_test_lib_home-7", "NIS2 basics", "required").
ismsa_expectComplete("ismsa_test_lib_home-7").

% ismsa_expectReason(HomeId, LibraryTitle, Reason): a reason why the library is required or
% not needed
ismsa_expectReason("ismsa_test_lib_home-4", "Security response and compliance basics", "you do the central security work in this home").
ismsa_expectReason("ismsa_test_lib_home-1", "Security operations basics", "you manage the security of your own IT or cloud services in this home").
ismsa_expectReason("ismsa_test_lib_home-5", "Information security management basics", "You do not want an ISMS in this home.").
ismsa_expectReason("ismsa_test_lib_home-5", "Security response and compliance basics", "You do the central security work outside this home.").

% Recommendations of the frameworks (E10-D11). A framework question adds no other library: in
% L5, NIS2 and the CRA apply, but the security operations basics library is not needed, because
% the answer about own IT services is "no".
%
% ismsa_expectRecommended(HomeId, Question, Reason), ismsa_expectAgainst(HomeId, Question), and
% ismsa_expectNotAgainst(HomeId, Question).
ismsa_expectRecommended("ismsa_test_lib_home-5", "centralWork", "the CRA requires a way to receive vulnerability reports and to notify about vulnerabilities and incidents").
ismsa_expectRecommended("ismsa_test_lib_home-5", "centralWork", "NIS2 requires incident reporting and contact with authorities").
ismsa_expectRecommended("ismsa_test_lib_home-5", "ownServices", "NIS2 requires basic security practices, continuity, and access control").
ismsa_expectAgainst("ismsa_test_lib_home-5", "centralWork").
ismsa_expectAgainst("ismsa_test_lib_home-5", "ownServices").
ismsa_expectAgainst("ismsa_test_lib_home-5", "fullIsms").
ismsa_expectNotAgainst("ismsa_test_lib_home-5", "assetRisks").
ismsa_expectRecommended("ismsa_test_lib_home-4", "centralWork", "the CRA requires a way to receive vulnerability reports and to notify about vulnerabilities and incidents").
ismsa_expectNotAgainst("ismsa_test_lib_home-4", "centralWork").
ismsa_expectNotRecommended("ismsa_test_lib_home-4", "ownServices").
ismsa_expectNotAgainst("ismsa_test_lib_home-1", "centralWork").

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
ismsa_testHomeKey("ismsa_test_lib_home-7", ismsa_tunfxhm0).
ismsa_testHomeKey("ismsa_test_lib_home-8", ismsa_chi8jp44).

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
ismsa_testRegisterCheck("Some AI assets have not been assessed").
ismsa_testRegisterCheck("No AI tools have been recorded").
ismsa_testRegisterCheck("Some AI tools have not been assessed").
ismsa_testRegisterCheck("A prohibited use of AI is active").

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

% Library choice

ismsa_testLibrary(HomeId, Title, Library) :-
    ismsa_choiceLibrary(Library, Title),
    ismsa_testHome(HomeId, _).

ismsa_testLibraryState(HomeId, Title, "required") :-
    ismsa_testLibrary(HomeId, Title, Library), ismsa_testHome(HomeId, Home),
    ismsa_libraryRequired(Home, Library).

ismsa_testLibraryState(HomeId, Title, "notNeeded") :-
    ismsa_testLibrary(HomeId, Title, Library), ismsa_testHome(HomeId, Home),
    ismsa_libraryNotNeeded(Home, Library, _).

ismsa_testLibraryState(HomeId, Title, "undecided") :-
    ismsa_testLibrary(HomeId, Title, Library), ismsa_testHome(HomeId, Home),
    ismsa_libraryUndecided(Home, Library).

ismsa_testAdded(HomeId, Title, "added") :-
    ismsa_testLibrary(HomeId, Title, Library), ismsa_testHome(HomeId, Home),
    ismsa_libraryAdded(Home, Library).

ismsa_testAdded(HomeId, Title, "partly") :-
    ismsa_testLibrary(HomeId, Title, Library), ismsa_testHome(HomeId, Home),
    ismsa_libraryPartlyAdded(Home, Library).

ismsa_testAdded(HomeId, Title, "none") :-
    ismsa_testLibrary(HomeId, Title, Library), ismsa_testHome(HomeId, Home),
    not ismsa_libraryAdded(Home, Library),
    not ismsa_libraryPartlyAdded(Home, Library).

result(("FAIL library state", HomeId, Title, State)) :-
    ismsa_expectLibrary(HomeId, Title, State),
    not ismsa_testLibraryState(HomeId, Title, State).

% A library has exactly one state

result(("FAIL library has several states", HomeId, Title)) :-
    ismsa_testLibrary(HomeId, Title, _),
    ismsa_testHomeKey(HomeId, _),
    not 1 = #count { S : ismsa_testLibraryState(HomeId, Title, S) }.

result(("FAIL library added state", HomeId, Title, State)) :-
    ismsa_expectAdded(HomeId, Title, State),
    not ismsa_testAdded(HomeId, Title, State).

result(("FAIL choice not complete", HomeId)) :-
    ismsa_expectComplete(HomeId),
    ismsa_testHome(HomeId, Home),
    not ismsa_libraryChoiceComplete(Home).

result(("FAIL choice complete", HomeId)) :-
    ismsa_expectNotComplete(HomeId),
    ismsa_testHome(HomeId, Home),
    ismsa_libraryChoiceComplete(Home).

ismsa_testReason(HomeId, Title, Reason) :-
    ismsa_testLibrary(HomeId, Title, Library), ismsa_testHome(HomeId, Home),
    ismsa_libraryRequirement(Home, Library, Reason).

ismsa_testReason(HomeId, Title, Reason) :-
    ismsa_testLibrary(HomeId, Title, Library), ismsa_testHome(HomeId, Home),
    ismsa_libraryNotNeeded(Home, Library, Reason).

result(("FAIL reason", HomeId, Title, Reason)) :-
    ismsa_expectReason(HomeId, Title, Reason),
    not ismsa_testReason(HomeId, Title, Reason).

% Every NIS2 requirement has a planned control (E10-D12), and in a home with all libraries no
% planned control is missing.

result(("FAIL NIS2 requirement without a planned control", Identifier)) :-
    ismsa_testCard(_, Identifier, _),
    ismsa_assessedRequirement(Requirement),
    field(Requirement, "base/fieldTypes/identifier", Identifier),
    not ismsa_plannedImplementation(Identifier, _).

result(("FAIL planned control missing in a home with all libraries", Identifier)) :-
    ismsa_testHome("ismsa_test_lib_home-7", Home),
    ismsa_assessedRequirement(Requirement),
    ismsa_closestHome(Requirement, Home),
    field(Requirement, "base/fieldTypes/identifier", Identifier),
    ismsa_assessedRequirementMissingPlannedControl(Requirement).

result(("FAIL NIS2 requirements in home L7", N)) :-
    ismsa_testHome("ismsa_test_lib_home-7", Home),
    N = #count { R : ismsa_assessedRequirement(R), ismsa_closestHome(R, Home) },
    N != 13.

result(("FAIL no answer against a recommendation in home L7", Question)) :-
    ismsa_testHome("ismsa_test_lib_home-7", Home),
    ismsa_answerAgainstRecommendation(Home, Question).

% Every library control has planned evidence.

result(("FAIL library control without planned evidence", Control)) :-
    ismsa_libraryControl(Control, _, _),
    not ismsa_centralEvidence(Control, _, _).

% Recommendations

result(("FAIL recommendation missing", HomeId, Question, Reason)) :-
    ismsa_expectRecommended(HomeId, Question, Reason),
    ismsa_testHome(HomeId, Home),
    not ismsa_questionRecommended(Home, Question, Reason).

result(("FAIL unexpected recommendation", HomeId, Question)) :-
    ismsa_expectNotRecommended(HomeId, Question),
    ismsa_testHome(HomeId, Home),
    ismsa_questionRecommended(Home, Question, _).

result(("FAIL answer not against the recommendation", HomeId, Question)) :-
    ismsa_expectAgainst(HomeId, Question),
    ismsa_testHome(HomeId, Home),
    not ismsa_answerAgainstRecommendation(Home, Question).

result(("FAIL answer against the recommendation", HomeId, Question)) :-
    ismsa_expectNotAgainst(HomeId, Question),
    ismsa_testHome(HomeId, Home),
    ismsa_answerAgainstRecommendation(Home, Question).

% A "yes" only adds: no library is required unless a question that adds it is answered "yes"

result(("FAIL library required without a yes", Home, Library)) :-
    ismsa_libraryRequired(Home, Library),
    not ismsa_homeAnswer(Home, Question, "yes") : ismsa_questionAdds(Question, Library, _).

% Every choice library has a coverage statement

result(("FAIL library without coverage", Library)) :-
    ismsa_choiceLibrary(Library, _),
    not ismsa_libraryCoverage(Library, _, _).

% Every library of this module is decided by the questions

result(("FAIL library without a question", Library)) :-
    ismsa_libraryControl(_, _, Library),
    not ismsa_choiceLibrary(Library, _).

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

% A library for new homes is offered in a new home, and not in an old-style home without the
% control register of the new home (Test home L3).

ismsa_testHomeKey("ismsa_test_lib_home-3", ismsa_6c54egay).

result(("FAIL NIS2 library not offered in a new home", HomeId)) :-
    ismsa_testHomeKey(HomeId, Home),
    HomeId != "ismsa_test_lib_home-3",
    not ismsa_libraryOfferedInHome("ismsa/templates/nis2Requirements", Home).

result(("FAIL NIS2 library offered in an old home")) :-
    ismsa_libraryOfferedInHome("ismsa/templates/nis2Requirements", ismsa_6c54egay).

% Every library of this module has a place in the order on the home card.

result(("FAIL library without a rank", Library)) :-
    ismsa_installableExtension(_, Library, Template, _, _),
    ismsa_libraryControl(_, _, Library),
    not ismsa_libraryRank(Library, _).

result(("FAIL other library not offered in an old home")) :-
    not ismsa_libraryOfferedInHome("ismsa/templates/securityOperations", ismsa_6c54egay).

% The dashboard of the home (ismsa/reports/dashboard) reads the built-in field "progress". Most
% progress calculations of ismsa still compute the deprecated field "base/fieldTypes/progress",
% and core maps it to "progress" with a compatibility rule (INTDEV-666). This check fails if the
% two values differ, for example if core removes the rule before the calculations are moved to
% "progress".

result(("FAIL progress not mapped to the built-in field", Card, Old)) :-
    field(Card, "base/fieldTypes/progress", Old),
    not field(Card, "progress", Old).

result(("FAIL built-in progress differs", Card, Old, New)) :-
    field(Card, "base/fieldTypes/progress", Old),
    field(Card, "progress", New),
    New != Old.

%
% The home card must be filled in before "Content ready" (2026-11-24)
%
% ismsa_expectHomeDenial(HomeId, Message): "Content ready" is denied with this message. A home
% gets no other denial of these rules. L1 is filled in. L6 has no scope description and no
% answers. L7 has no scope description. The rules for the title and the owner were checked with
% mutations of L6.
%

ismsa_homeFillInMessage("Write the scope of the home in the title").
ismsa_homeFillInMessage("Write the scope description").
ismsa_homeFillInMessage("Set the owner of the home").
ismsa_homeFillInMessage("Answer all questions in the section Libraries").

ismsa_expectHomeDenial("ismsa_test_lib_home-6", "Write the scope description").
ismsa_expectHomeDenial("ismsa_test_lib_home-6", "Answer all questions in the section Libraries").
ismsa_expectHomeDenial("ismsa_test_lib_home-7", "Write the scope description").

ismsa_testHomeChecked("ismsa_test_lib_home-1").
ismsa_testHomeChecked("ismsa_test_lib_home-6").
ismsa_testHomeChecked("ismsa_test_lib_home-7").

result(("FAIL home fill-in denial missing", HomeId, Message)) :-
    ismsa_expectHomeDenial(HomeId, Message),
    ismsa_testHomeKey(HomeId, Home),
    not transitionDenied(Home, "Content ready", Message).

result(("FAIL unexpected home fill-in denial", HomeId, Message)) :-
    ismsa_testHomeChecked(HomeId),
    ismsa_testHomeKey(HomeId, Home),
    ismsa_homeFillInMessage(Message),
    transitionDenied(Home, "Content ready", Message),
    not ismsa_expectHomeDenial(HomeId, Message).

%
% Questions, roles, conflicts of duties, and owners (2026-11-24)
%
% A "yes" to the ISMS question includes the asset risk question (L7). Without it, the question
% needs its own answer (L4, L5).
% L7 has the controls that need the security operations and the supplier security roles, and no
% roles. L6 has no controls, so it needs no roles.
% L6 has a document whose owner is also its approver and its reviewer, and an incident without
% an owner, which gets the owner of the home through the incident register.
%

ismsa_expectIncluded("ismsa_test_lib_home-7", "assetRisks").
ismsa_expectNotIncluded("ismsa_test_lib_home-4", "assetRisks").
ismsa_expectNotIncluded("ismsa_test_lib_home-5", "assetRisks").

ismsa_expectRoleNeeded("ismsa_test_lib_home-7", "ismsa_role_security-operations").
ismsa_expectRoleNeeded("ismsa_test_lib_home-7", "ismsa_role_supplier-security").
ismsa_expectNoRoleNeeded("ismsa_test_lib_home-6").

ismsa_expectConflict("Test document L6: the owner approves and reviews it", "conflict-l6@example.com", "owns the document and also reviews it").
ismsa_expectConflict("Test document L6: the owner approves and reviews it", "conflict-l6@example.com", "owns the document and also approves it").

ismsa_expectInheritedOwner("Test incident L6: the owner comes from the home", "home-l6@example.com").

result(("FAIL question not included", HomeId, Question)) :-
    ismsa_expectIncluded(HomeId, Question),
    ismsa_testHomeKey(HomeId, Home),
    not ismsa_questionIncluded(Home, Question, _).

result(("FAIL question included", HomeId, Question)) :-
    ismsa_expectNotIncluded(HomeId, Question),
    ismsa_testHomeKey(HomeId, Home),
    ismsa_questionIncluded(Home, Question, _).

result(("FAIL included question still recommended", HomeId, Question)) :-
    ismsa_expectIncluded(HomeId, Question),
    ismsa_testHomeKey(HomeId, Home),
    ismsa_questionRecommended(Home, Question, _).

result(("FAIL role not needed", HomeId, Role)) :-
    ismsa_expectRoleNeeded(HomeId, Role),
    ismsa_testHomeKey(HomeId, Home),
    not ismsa_roleNeeded(Home, Role).

result(("FAIL role needed", HomeId, Role)) :-
    ismsa_expectNoRoleNeeded(HomeId),
    ismsa_testHomeKey(HomeId, Home),
    ismsa_roleNeeded(Home, Role).

result(("FAIL conflict missing", Title, Text)) :-
    ismsa_expectConflict(Title, Person, Text),
    not ismsa_testConflictFound(Title, Person, Text).

ismsa_testConflictFound(Title, Person, Text) :-
    ismsa_expectConflict(Title, Person, Text),
    field(Document, "title", Title),
    ismsa_dutyConflict(Document, Person, Text).

result(("FAIL unexpected conflict", Document, Person, Text)) :-
    ismsa_dutyConflict(Document, Person, Text),
    ismsa_testHomeKey("ismsa_test_lib_home-6", Home),
    ismsa_closestHome(Document, Home),
    field(Document, "title", Title),
    not ismsa_expectConflict(Title, Person, Text).

result(("FAIL owner not inherited", Title)) :-
    ismsa_expectInheritedOwner(Title, Owner),
    not ismsa_testOwnerFound(Title, Owner).

ismsa_testOwnerFound(Title, Owner) :-
    ismsa_expectInheritedOwner(Title, Owner),
    field(Card, "title", Title),
    field(Card, "base/fieldTypes/owner", Owner).

%
% The AI use basics library (2026-11-25)
%
% L8 answers "yes" only to the AI question. The AI question adds the AI use basics library and
% the asset and risk management library, because the AI tools are in the asset register.
%

ismsa_expectLibrary("ismsa_test_lib_home-8", "AI use basics", "required").
ismsa_expectLibrary("ismsa_test_lib_home-8", "Asset and risk management", "required").
ismsa_expectLibrary("ismsa_test_lib_home-8", "Security operations basics", "notNeeded").
ismsa_expectAdded("ismsa_test_lib_home-8", "AI use basics", "added").
ismsa_expectAdded("ismsa_test_lib_home-8", "Asset and risk management", "added").
ismsa_expectReason("ismsa_test_lib_home-8", "AI use basics", "you use AI tools in your work").
ismsa_expectReason("ismsa_test_lib_home-8", "Asset and risk management", "the AI tools are recorded in the asset register").
ismsa_expectLibrary("ismsa_test_lib_home-1", "AI use basics", "notNeeded").
ismsa_expectLibrary("ismsa_test_lib_home-6", "AI use basics", "undecided").

ismsa_expectInstalled("ismsa_test_lib_home-8", "ismsa/templates/aiUseControls").
ismsa_expectInstalled("ismsa_test_lib_home-8", "ismsa/templates/aiToolRegister").
ismsa_expectInstalled("ismsa_test_lib_home-8", "ismsa/templates/aiActRequirements").
ismsa_expectInScope("ismsa_test_lib_home-8", "ismsa_control_manage-ai-tools").

% The checks of the AI tools. The assessed AI asset passes, the one without an assessment fails
% in both controls, and the prohibited use fails in "Manage the AI tools in use".
ismsa_expectCheck("ismsa_test_lib_home-8", "ismsa_control_manage-ai-tools", "Some AI tools have not been assessed").
ismsa_expectCheck("ismsa_test_lib_home-8", "ismsa_control_manage-ai-tools", "A prohibited use of AI is active").
ismsa_expectCheck("ismsa_test_lib_home-8", "ismsa_control_manage-assets", "Some AI assets have not been assessed").
ismsa_expectCheck("ismsa_test_lib_home-8", "ismsa_control_manage-risks", "No risks have been identified").
ismsa_expectLibControl("ismsa_test_lib_home-8", "ismsa_control_manage-ai-tools", "notStarted", "The control is in scope, but no evidence has been linked yet", 0).

% The evidence of the AI controls, and where it is created. The training and awareness plan is
% the evidence of the AI literacy control too.
ismsa_expectTarget("ismsa_test_lib_home-8", "ismsa_control_ai-policy", "ismsa_document_ai-policy", "ismsa_register_processes").
ismsa_expectTarget("ismsa_test_lib_home-8", "ismsa_control_manage-ai-tools", "ismsa_review_ai-tools", "ismsa_register_ai-tools").
ismsa_expectTarget("ismsa_test_lib_home-8", "ismsa_control_ai-literacy", "ismsa_document_training-and-awareness-plan", "ismsa_register_processes").

% Each EU AI Act requirement finds its planned controls in L8.
ismsa_expectRequirement("ismsa_test_lib_home-8", "ismsa_aiact_art-4", "inProgress", "The requirement is in scope, but the linked implementation is not ready yet", 1).
ismsa_expectRequirement("ismsa_test_lib_home-8", "ismsa_aiact_art-5", "notOk", "The requirement is in scope but the linked implementation is not acceptable", 2).
ismsa_expectRequirement("ismsa_test_lib_home-8", "ismsa_aiact_art-26", "notOk", "The requirement is in scope but the linked implementation is not acceptable", 1).
ismsa_expectRequirement("ismsa_test_lib_home-8", "ismsa_aiact_art-50", "inProgress", "The requirement is in scope, but the linked implementation is not ready yet", 1).

ismsa_expectRoleNeeded("ismsa_test_lib_home-8", "ismsa_role_ai-responsible").
% L8 has no central security role assignments, so the AI policy control creates the role in the
% process register. A home with the role assignments (home ismsa_0yp0y2y5 of the central control
% tests) gets no target, because the button is in the role assignments.
ismsa_expectRoleTarget("ismsa_test_lib_home-8", "ismsa_register_processes").

result(("FAIL role target", HomeId, TargetId)) :-
    ismsa_expectRoleTarget(HomeId, TargetId),
    ismsa_testHomeKey(HomeId, Home),
    not ismsa_testRoleTargetIs(Home, TargetId).

ismsa_testRoleTargetIs(Home, TargetId) :-
    ismsa_roleTarget(Home, Target),
    field(Target, "base/fieldTypes/identifier", TargetId).

result(("FAIL role target with role assignments", Home)) :-
    ismsa_homeHasRoleAssignments(Home),
    ismsa_roleTarget(Home, _).

result(("FAIL fixture home without role assignments")) :-
    not ismsa_homeHasRoleAssignments(ismsa_0yp0y2y5).
ismsa_expectComplete("ismsa_test_lib_home-8").

% The checks of an AI asset card

ismsa_expectAiAssetCheck("Assessed AI tool", none).
ismsa_expectAiAssetCheck("AI tool without assessment", "'Information allowed' is a required field").
ismsa_expectAiAssetCheck("AI tool without assessment", "'Human oversight' is a required field").
ismsa_expectAiAssetCheck("AI tool for a prohibited use", "The use is prohibited").

ismsa_testAiAsset(Title, Asset) :-
    ismsa_expectAiAssetCheck(Title, _),
    field(Asset, "title", Title),
    ismsa_aiAsset(Asset).

result(("FAIL AI asset missing", Title)) :-
    ismsa_expectAiAssetCheck(Title, _),
    not ismsa_testAiAsset(Title, _).

result(("FAIL AI asset check missing", Title, Check)) :-
    ismsa_expectAiAssetCheck(Title, Check),
    Check != none,
    ismsa_testAiAsset(Title, Asset),
    not policyCheckFailure(Asset, _, Check, _, _).

result(("FAIL AI asset has a check", Title, Check)) :-
    ismsa_expectAiAssetCheck(Title, none),
    ismsa_testAiAsset(Title, Asset),
    policyCheckFailure(Asset, _, Check, _, _).

result(("FAIL AI asset not assessed", Title)) :-
    ismsa_expectAiAssetCheck(Title, none),
    ismsa_testAiAsset(Title, Asset),
    not ismsa_aiAssetAssessed(Asset).

% An AI asset is an asset, and the old asset checks apply to it.

result(("FAIL AI asset is not an asset", Title)) :-
    ismsa_testAiAsset(Title, Asset),
    not ismsa_asset(Asset, "AI asset").
