%
% Libraries of the ISMS home (ismsa/templates/moduleHome2)
%
% This calculation holds facts only. The rules that use them are in
% ismsa/calculations/centralControls (evidence, evidence locations, and scoping),
% ismsa/calculations/extensions (installation), and
% ismsa/calculations/assessedComplianceRequirement (planned implementation).
%
% An extension module adds a library with the same facts, for example the CRA programme
% library of eucra or the ISO/IEC 27001 library of ismsb.
%

%
% Installation
%
% Each part of a library is a template. Its button is shown on the home card of the new home,
% and the part is ticked when a card with the example identifier is in the home.
%

% A library brings its controls to the central control register, its registers to the home
% card, and its processes to the process register. Until one button can create cards in several
% places, a library has one button for each part. The report ismsa/reports/installLibraries shows
% all the buttons on the home card, grouped by library.

% The security response and compliance basics library has the six basic central controls. A
% team under an existing ISMS that already does them can leave this library out.

ismsa_installableExtension(
    "ismsa_register_central-controls",
    "the security response and compliance basics library",
    "ismsa/templates/securityResponseAndComplianceControls",
    "Add the security response and compliance basics controls",
    "ismsa_control_receive-security-issue-notifications"
).

ismsa_installableExtension(
    "ismsa_register_processes",
    "the security response and compliance basics library",
    "ismsa/templates/incidentManagementProcess",
    "Add the incident management process",
    "ismsa_document_incident-management-process"
).

ismsa_installableExtension(
    "ismsa_register_central-controls",
    "the information security management library",
    "ismsa/templates/informationSecurityManagementControls",
    "Add the information security management controls",
    "ismsa_control_isms-scope-and-context"
).

ismsa_installableExtension(
    "ismsa_home",
    "the information security management library",
    "ismsa/templates/informationSecurityManagementRegisters",
    "Add the information security management registers",
    "ismsa_register_security-targets"
).

ismsa_installableExtension(
    "ismsa_register_central-controls",
    "the asset and risk management library",
    "ismsa/templates/assetAndRiskManagementControls",
    "Add the asset and risk management controls",
    "ismsa_control_manage-assets"
).

ismsa_installableExtension(
    "ismsa_home",
    "the asset and risk management library",
    "ismsa/templates/assetAndRiskRegisters",
    "Add the asset and risk registers",
    "ismsa_register_assets"
).

% The processes of the asset and risk management library are planned evidence of its controls.
% The buttons in the controls create them too.

ismsa_installableExtension(
    "ismsa_register_processes",
    "the asset and risk management library",
    "ismsa/templates/assetManagementProcess",
    "Add the asset management process",
    "ismsa_document_asset-management-process"
).

ismsa_installableExtension(
    "ismsa_register_processes",
    "the asset and risk management library",
    "ismsa/templates/riskManagementProcess",
    "Add the risk management process",
    "ismsa_document_risk-management-process"
).

ismsa_installableExtension(
    "ismsa_register_central-controls",
    "the security operations library",
    "ismsa/templates/securityOperations",
    "Add the security operations library",
    "ismsa_control_operate-security-monitoring"
).

ismsa_installableExtension(
    "ismsa_register_compliance",
    "the NIS2 library",
    "ismsa/templates/nis2Requirements",
    "Add the NIS2 library",
    "ismsa_register_nis2"
).

% The order of the libraries on the home card. A library without this fact comes after them.

ismsa_libraryRank("the security response and compliance basics library", 1).
ismsa_libraryRank("the information security management library", 2).
ismsa_libraryRank("the asset and risk management library", 3).
ismsa_libraryRank("the security operations library", 4).
ismsa_libraryRank("the NIS2 library", 5).

% The compliance register of the old home template has the same identifier as in the new home.
% A library that needs the controls of the new home is offered only in a home that has a
% central control register, so that the old homes do not change.

ismsa_libraryForNewHomes("ismsa/templates/nis2Requirements").

% The old home template has a process register with the same identifier, and it renders
% ismsa/reports/installExtension. The process parts are offered only in new homes.

ismsa_libraryForNewHomes("ismsa/templates/incidentManagementProcess").
ismsa_libraryForNewHomes("ismsa/templates/assetManagementProcess").
ismsa_libraryForNewHomes("ismsa/templates/riskManagementProcess").

ismsa_libraryOfferedInHome(Template, Home) :-
    ismsa_installableExtension(_, _, Template, _, _),
    base_projectCardType(Home, "ismsa/cardTypes/moduleHome"),
    not ismsa_libraryForNewHomes(Template).

ismsa_libraryOfferedInHome(Template, Home) :-
    ismsa_libraryForNewHomes(Template),
    ismsa_homeWithCentralControls(Home).

%
% The internal controls of the home
%
% ismsa_libraryControl(ControlIdentifier, Title, Library) names each control of the libraries,
% and the library that brings it. The report ismsa/reports/plannedImplementation
% uses these facts to tell which library is missing from a home.
%

ismsa_libraryControl("ismsa_control_assign-central-security-roles", "Assign the central security roles", "the security response and compliance basics library").
ismsa_libraryControl("ismsa_control_receive-security-issue-notifications", "Receive notifications of security issues", "the security response and compliance basics library").
ismsa_libraryControl("ismsa_control_notify-about-vulnerabilities-and-incidents", "Notify about vulnerabilities and incidents", "the security response and compliance basics library").
ismsa_libraryControl("ismsa_control_contact-with-authorities", "Contact with authorities", "the security response and compliance basics library").
ismsa_libraryControl("ismsa_control_protect-records", "Protect records", "the security response and compliance basics library").
ismsa_libraryControl("ismsa_control_follow-changes-in-regulation", "Follow changes in regulation", "the security response and compliance basics library").

ismsa_libraryControl("ismsa_control_isms-scope-and-context", "Define the scope and context of the ISMS", "the information security management library").
ismsa_libraryControl("ismsa_control_information-security-policy", "Set the information security policy", "the information security management library").
ismsa_libraryControl("ismsa_control_training-and-awareness", "Run security training and awareness", "the information security management library").
ismsa_libraryControl("ismsa_control_plan-and-review-isms", "Plan and review the ISMS", "the information security management library").

ismsa_libraryControl("ismsa_control_manage-assets", "Manage the assets of the organisation", "the asset and risk management library").
ismsa_libraryControl("ismsa_control_manage-risks", "Manage information security risks", "the asset and risk management library").

ismsa_libraryControl("ismsa_control_operate-security-monitoring", "Operate security monitoring", "the security operations library").
ismsa_libraryControl("ismsa_control_exercise-incident-response", "Exercise incident response", "the security operations library").
ismsa_libraryControl("ismsa_control_continuity-and-recovery", "Plan business continuity and recovery", "the security operations library").
ismsa_libraryControl("ismsa_control_review-access-rights", "Review access rights", "the security operations library").

% Installing a library is the decision to use its controls, so they are in scope when they are
% created. A home that does not need one of them marks it out of scope, with a justification.

ismsa_controlInScopeByDefault(Control) :-
    ismsa_libraryControl(Control, _, _).

%
% Planned evidence of the library controls, and where it is created
%
% Without an ismsa_evidenceLocation fact, the evidence is created in the process register of
% the home.
%

ismsa_centralEvidence("ismsa_control_isms-scope-and-context", "ismsa_document_business-context-analysis", "Business context analysis").
ismsa_centralEvidence("ismsa_control_information-security-policy", "ismsa_document_information-security-policy", "Information security policy").
ismsa_centralEvidence("ismsa_control_training-and-awareness", "ismsa_document_training-and-awareness-plan", "Training and awareness plan").
ismsa_centralEvidence("ismsa_control_plan-and-review-isms", "ismsa_review_management-review", "Management review").
ismsa_evidenceLocation("ismsa_review_management-review", "ismsa_register_security-reviews").

ismsa_centralEvidence("ismsa_control_manage-assets", "ismsa_document_asset-management-process", "Asset management process").
ismsa_centralEvidence("ismsa_control_manage-assets", "ismsa_review_asset-register", "Review of the asset register").
ismsa_evidenceLocation("ismsa_review_asset-register", "ismsa_register_assets").

ismsa_centralEvidence("ismsa_control_manage-risks", "ismsa_document_risk-management-process", "Risk management process").
ismsa_centralEvidence("ismsa_control_manage-risks", "ismsa_review_risk-register", "Review of the risk register").
ismsa_evidenceLocation("ismsa_review_risk-register", "ismsa_register_risks").

ismsa_centralEvidence("ismsa_control_operate-security-monitoring", "ismsa_document_security-monitoring-plan", "Security monitoring plan").
ismsa_centralEvidence("ismsa_control_exercise-incident-response", "ismsa_review_incident-response-exercise", "Incident response exercise").
ismsa_evidenceLocation("ismsa_review_incident-response-exercise", "ismsa_register_incidents").
ismsa_centralEvidence("ismsa_control_continuity-and-recovery", "ismsa_document_continuity-and-recovery-plan", "Business continuity and recovery plan").
ismsa_centralEvidence("ismsa_control_continuity-and-recovery", "ismsa_review_recovery-test", "Recovery test").
ismsa_centralEvidence("ismsa_control_review-access-rights", "ismsa_review_access-rights", "Access rights review").

%
% Planned implementation of the NIS2 requirements
%
% ismsa_plannedImplementation(RequirementIdentifier, ControlIdentifier): the control implements
% the requirement. A requirement without facts has no planned control (Article 21(2)(d), (h),
% and (j)), and the organisation links its own controls to it.
%

ismsa_plannedImplementation("ismsa_nis2_art-20-1", "ismsa_control_information-security-policy").
ismsa_plannedImplementation("ismsa_nis2_art-20-1", "ismsa_control_plan-and-review-isms").
ismsa_plannedImplementation("ismsa_nis2_art-20-2", "ismsa_control_training-and-awareness").
ismsa_plannedImplementation("ismsa_nis2_art-21-2-a", "ismsa_control_manage-risks").
ismsa_plannedImplementation("ismsa_nis2_art-21-2-a", "ismsa_control_information-security-policy").
ismsa_plannedImplementation("ismsa_nis2_art-21-2-b", "ismsa_control_notify-about-vulnerabilities-and-incidents").
ismsa_plannedImplementation("ismsa_nis2_art-21-2-b", "ismsa_control_operate-security-monitoring").
ismsa_plannedImplementation("ismsa_nis2_art-21-2-b", "ismsa_control_exercise-incident-response").
ismsa_plannedImplementation("ismsa_nis2_art-21-2-c", "ismsa_control_continuity-and-recovery").
ismsa_plannedImplementation("ismsa_nis2_art-21-2-e", "ismsa_control_receive-security-issue-notifications").
ismsa_plannedImplementation("ismsa_nis2_art-21-2-f", "ismsa_control_plan-and-review-isms").
ismsa_plannedImplementation("ismsa_nis2_art-21-2-g", "ismsa_control_training-and-awareness").
ismsa_plannedImplementation("ismsa_nis2_art-21-2-i", "ismsa_control_review-access-rights").
ismsa_plannedImplementation("ismsa_nis2_art-21-2-i", "ismsa_control_manage-assets").
ismsa_plannedImplementation("ismsa_nis2_art-23", "ismsa_control_notify-about-vulnerabilities-and-incidents").
ismsa_plannedImplementation("ismsa_nis2_art-23", "ismsa_control_contact-with-authorities").
