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

% A library brings its controls to the control register and its registers to the home card.
% The planned evidence, such as the processes, is created with the buttons in the controls.
% Until one button can create cards in several places, a library has one button for each part.
% The report ismsa/reports/installLibraries shows the buttons of the libraries that the answers
% on the home card require (ismsa/calculations/libraryChoice).

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
    "ismsa_register_central-controls",
    "the information security management basics library",
    "ismsa/templates/informationSecurityManagementControls",
    "Add the information security management controls",
    "ismsa_control_isms-scope-and-context"
).

ismsa_installableExtension(
    "ismsa_home",
    "the information security management basics library",
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

ismsa_installableExtension(
    "ismsa_register_central-controls",
    "the security operations basics library",
    "ismsa/templates/securityOperations",
    "Add the security operations controls",
    "ismsa_control_operate-security-monitoring"
).

ismsa_installableExtension(
    "ismsa_register_compliance",
    "the NIS2 basics library",
    "ismsa/templates/nis2Requirements",
    "Add the NIS2 requirements",
    "ismsa_register_nis2"
).

% The order of the libraries on the home card. A library without this fact comes after them.

ismsa_libraryRank("the security response and compliance basics library", 1).
ismsa_libraryRank("the information security management basics library", 2).
ismsa_libraryRank("the asset and risk management library", 3).
ismsa_libraryRank("the security operations basics library", 4).
ismsa_libraryRank("the NIS2 basics library", 5).

% What each library covers, and where the rest comes from. The home card shows these in the
% section "Libraries", so that the user knows the limits of the home before choosing.
%
% ismsa_libraryCoverage(Library, Covers, NotCovered)

ismsa_libraryCoverage("the security response and compliance basics library",
    "The security roles, the channel for vulnerability reports, the notifications of vulnerabilities and incidents, the authority contacts, the records, and the changes in regulation. These are the duties of the organisation for the CRA and the reporting of NIS2.",
    "The duties for each product under the CRA, for example risk assessment, SBOM, technical documentation, and conformity assessment. Do them in the development projects of the secure development and EU CRA modules.").

ismsa_libraryCoverage("the information security management basics library",
    "A foundation for an ISMS: the scope and context, the security policy, the cryptography rules, the training, human resources security, the security targets, the security metrics, the security reviews, and a light management review.",
    "Certification to ISO/IEC 27001: the Statement of Applicability, the internal audit, the full management review, the corrective actions, the document control, and the full Annex A. Add the ISO/IEC 27001 extension for these.").

ismsa_libraryCoverage("the asset and risk management library",
    "The asset and risk registers, their processes, the yearly reviews of the registers, and the security of the suppliers.",
    "The link from the risk treatment to the controls of ISO/IEC 27001 Annex A, and in-depth supplier management. These are in the ISO/IEC 27001 extension.").

ismsa_libraryCoverage("the security operations basics library",
    "Basic security practices, vulnerabilities and updates, security monitoring, incident response exercises, business continuity and recovery, and access rights reviews.",
    "The full technical controls of ISO/IEC 27001 Annex A, for example full key management. These are in the ISO/IEC 27001 extension.").

ismsa_libraryCoverage("the NIS2 basics library",
    "A checklist of the requirements of NIS2 Articles 20, 21(2), and 23, at a basic level, linked to the controls of the home. A requirement stays open until its controls are in the home.",
    "The extra duties of the national law, for example the sector rules and the details of the registration. Check the national law.").

% The compliance register of the old home template has the same identifier as in the new home.
% A library that needs the controls of the new home is offered only in a home that has the
% control register of the new home ("ismsa_register_central-controls"), so that the old homes
% do not change.

ismsa_libraryForNewHomes("ismsa/templates/nis2Requirements").


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

ismsa_libraryControl("ismsa_control_isms-scope-and-context", "Define the scope and context of the ISMS", "the information security management basics library").
ismsa_libraryControl("ismsa_control_information-security-policy", "Set the information security policy", "the information security management basics library").
ismsa_libraryControl("ismsa_control_training-and-awareness", "Run security training and awareness", "the information security management basics library").
ismsa_libraryControl("ismsa_control_plan-and-review-isms", "Plan and review the ISMS", "the information security management basics library").
ismsa_libraryControl("ismsa_control_human-resources-security", "Manage human resources security", "the information security management basics library").
ismsa_libraryControl("ismsa_control_measure-security-effectiveness", "Measure the effectiveness of security", "the information security management basics library").

ismsa_libraryControl("ismsa_control_manage-assets", "Manage the assets of the organisation", "the asset and risk management library").
ismsa_libraryControl("ismsa_control_manage-risks", "Manage information security risks", "the asset and risk management library").
ismsa_libraryControl("ismsa_control_manage-supplier-security", "Manage the security of suppliers", "the asset and risk management library").

ismsa_libraryControl("ismsa_control_operate-security-monitoring", "Operate security monitoring", "the security operations basics library").
ismsa_libraryControl("ismsa_control_exercise-incident-response", "Exercise incident response", "the security operations basics library").
ismsa_libraryControl("ismsa_control_continuity-and-recovery", "Plan business continuity and recovery", "the security operations basics library").
ismsa_libraryControl("ismsa_control_review-access-rights", "Review access rights", "the security operations basics library").
ismsa_libraryControl("ismsa_control_apply-basic-security-practices", "Apply basic security practices", "the security operations basics library").
ismsa_libraryControl("ismsa_control_manage-vulnerabilities-and-updates", "Manage vulnerabilities and updates", "the security operations basics library").

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
ismsa_centralEvidence("ismsa_control_information-security-policy", "ismsa_document_cryptography-rules", "Cryptography rules").
ismsa_centralEvidence("ismsa_control_training-and-awareness", "ismsa_document_training-and-awareness-plan", "Training and awareness plan").
ismsa_centralEvidence("ismsa_control_plan-and-review-isms", "ismsa_review_management-review", "Management review").
ismsa_evidenceLocation("ismsa_review_management-review", "ismsa_register_security-reviews").
ismsa_centralEvidence("ismsa_control_human-resources-security", "ismsa_review_human-resources-security", "Human resources security review").
ismsa_evidenceLocation("ismsa_review_human-resources-security", "ismsa_register_security-reviews").
ismsa_centralEvidence("ismsa_control_measure-security-effectiveness", "ismsa_review_security-metrics", "Security metrics report").
ismsa_evidenceLocation("ismsa_review_security-metrics", "ismsa_register_security-targets").

ismsa_centralEvidence("ismsa_control_manage-assets", "ismsa_document_asset-management-process", "Asset management process").
ismsa_centralEvidence("ismsa_control_manage-assets", "ismsa_review_asset-register", "Review of the asset register").
ismsa_evidenceLocation("ismsa_review_asset-register", "ismsa_register_assets").

ismsa_centralEvidence("ismsa_control_manage-risks", "ismsa_document_risk-management-process", "Risk management process").
ismsa_centralEvidence("ismsa_control_manage-risks", "ismsa_review_risk-register", "Review of the risk register").
ismsa_evidenceLocation("ismsa_review_risk-register", "ismsa_register_risks").

ismsa_centralEvidence("ismsa_control_manage-supplier-security", "ismsa_review_supplier-security", "Supplier security review").
ismsa_evidenceLocation("ismsa_review_supplier-security", "ismsa_register_assets").

ismsa_centralEvidence("ismsa_control_operate-security-monitoring", "ismsa_document_security-monitoring-plan", "Security monitoring plan").
ismsa_centralEvidence("ismsa_control_exercise-incident-response", "ismsa_review_incident-response-exercise", "Incident response exercise").
ismsa_evidenceLocation("ismsa_review_incident-response-exercise", "ismsa_register_incidents").
ismsa_centralEvidence("ismsa_control_continuity-and-recovery", "ismsa_document_continuity-and-recovery-plan", "Business continuity and recovery plan").
ismsa_centralEvidence("ismsa_control_continuity-and-recovery", "ismsa_review_recovery-test", "Recovery test").
ismsa_centralEvidence("ismsa_control_review-access-rights", "ismsa_review_access-rights", "Access rights review").
ismsa_centralEvidence("ismsa_control_apply-basic-security-practices", "ismsa_review_basic-security-practices", "Basic security practices review").
ismsa_centralEvidence("ismsa_control_manage-vulnerabilities-and-updates", "ismsa_document_vulnerability-and-update-management-process", "Process for managing vulnerabilities and updates").

%
% Planned implementation of the NIS2 requirements
%
% ismsa_plannedImplementation(RequirementIdentifier, ControlIdentifier): the control implements
% the requirement. Every NIS2 requirement of the library has a planned control (E10-D12,
% 2026-11-23). The organisation can also link its own controls to a requirement.
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
ismsa_plannedImplementation("ismsa_nis2_art-21-2-d", "ismsa_control_manage-supplier-security").
ismsa_plannedImplementation("ismsa_nis2_art-21-2-e", "ismsa_control_receive-security-issue-notifications").
ismsa_plannedImplementation("ismsa_nis2_art-21-2-e", "ismsa_control_manage-vulnerabilities-and-updates").
ismsa_plannedImplementation("ismsa_nis2_art-21-2-f", "ismsa_control_plan-and-review-isms").
ismsa_plannedImplementation("ismsa_nis2_art-21-2-f", "ismsa_control_measure-security-effectiveness").
ismsa_plannedImplementation("ismsa_nis2_art-21-2-g", "ismsa_control_training-and-awareness").
ismsa_plannedImplementation("ismsa_nis2_art-21-2-g", "ismsa_control_apply-basic-security-practices").
ismsa_plannedImplementation("ismsa_nis2_art-21-2-g", "ismsa_control_manage-vulnerabilities-and-updates").
ismsa_plannedImplementation("ismsa_nis2_art-21-2-h", "ismsa_control_apply-basic-security-practices").
ismsa_plannedImplementation("ismsa_nis2_art-21-2-h", "ismsa_control_information-security-policy").
ismsa_plannedImplementation("ismsa_nis2_art-21-2-i", "ismsa_control_review-access-rights").
ismsa_plannedImplementation("ismsa_nis2_art-21-2-i", "ismsa_control_manage-assets").
ismsa_plannedImplementation("ismsa_nis2_art-21-2-i", "ismsa_control_human-resources-security").
ismsa_plannedImplementation("ismsa_nis2_art-21-2-j", "ismsa_control_apply-basic-security-practices").
ismsa_plannedImplementation("ismsa_nis2_art-21-2-j", "ismsa_control_review-access-rights").
ismsa_plannedImplementation("ismsa_nis2_art-21-2-j", "ismsa_control_continuity-and-recovery").
ismsa_plannedImplementation("ismsa_nis2_art-23", "ismsa_control_notify-about-vulnerabilities-and-incidents").
ismsa_plannedImplementation("ismsa_nis2_art-23", "ismsa_control_contact-with-authorities").
