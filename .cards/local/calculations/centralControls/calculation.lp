%
% Central controls of the ISMS home
%
% The central controls are internal controls (ismsa/cardTypes/internalControl) that a
% central team does once for the whole organisation. They live in the central control
% register of an ISMS home (ismsa/templates/moduleHome2). Their evidence is found by
% identifier in the same home, so that the evidence links work in every copy of the home.
%

%
% Planned evidence
%
% ismsa_centralEvidence(ControlIdentifier, EvidenceIdentifier, EvidenceTitle) declares that
% a card with EvidenceIdentifier is planned evidence of the control with ControlIdentifier.
% Other modules can add facts for their own central controls.
%

ismsa_centralEvidence(
    "ismsa_control_receive-security-issue-notifications",
    "ismsa_document_cvd-policy",
    "Coordinated vulnerability disclosure policy"
).

ismsa_centralEvidence(
    "ismsa_control_notify-about-vulnerabilities-and-incidents",
    "ismsa_document_cvd-policy",
    "Coordinated vulnerability disclosure policy"
).

ismsa_centralEvidence(
    "ismsa_control_notify-about-vulnerabilities-and-incidents",
    "ismsa_document_incident-management-process",
    "Incident management process"
).

ismsa_centralEvidence(
    "ismsa_control_contact-with-authorities",
    "ismsa_document_authority-contacts",
    "Authority contacts"
).

ismsa_centralEvidence(
    "ismsa_control_follow-changes-in-regulation",
    "ismsa_review_regulation-changes",
    "Review of changes in regulation"
).

ismsa_centralEvidence(
    "ismsa_control_protect-records",
    "ismsa_document_records-retention-plan",
    "Records retention plan"
).

ismsa_centralEvidence(
    "ismsa_control_assign-central-security-roles",
    "ismsa_review_central-role-assignments",
    "Central security role assignments"
).

% The evidence and the control must be in the same ISMS home. A card that is not in a home
% gets no evidence links from these rules.

link(Evidence, Control, "ismsa/linkTypes/evidences") :-
    ismsa_centralEvidence(ControlIdentifier, EvidenceIdentifier, _),
    field(Control, "base/fieldTypes/identifier", ControlIdentifier),
    field(Evidence, "base/fieldTypes/identifier", EvidenceIdentifier),
    ismsa_closestHome(Control, Home),
    ismsa_closestHome(Evidence, Home).

% A central control misses evidence also when some, but not all, of its planned evidence is
% linked. The rule in ismsa/calculations/internalControl covers the case of no links at all.

ismsa_internalControlMissingEvidence(Control) :-
    ismsa_centralEvidence(ControlIdentifier, EvidenceIdentifier, _),
    field(Control, "base/fieldTypes/identifier", ControlIdentifier),
    base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
    link(_, Control, "ismsa/linkTypes/evidences"),
    not field(Evidence, "base/fieldTypes/identifier", EvidenceIdentifier) :
        link(Evidence, Control, "ismsa/linkTypes/evidences").

%
% Where planned evidence is created
%
% Planned evidence is not created under its control. It is created in the register of the
% same home that owns its topic, for example the compliance register or the asset register.
% ismsa_evidenceLocation(EvidenceIdentifier, RegisterIdentifier) names that register. Evidence
% without this fact is created in the process register of the home. The process register has
% the same identifier as in the old home template (ismsa/templates/moduleHome).
%
% ismsa_evidenceTarget(Control, EvidenceIdentifier, Card) gives the card under which the
% button of ismsa/reports/createEvidence creates the evidence of the control:
%
% 1. the register that owns the evidence, in the same home as the control, if the evidence has
%    an ismsa_evidenceLocation fact
% 2. otherwise, or if the home does not have that register, the process register of the home
% 3. if the home does not have that register either (for example an old home), the home card
%
% A control that is not in a home has no target, and the report shows no button.
%

ismsa_evidenceLocation("ismsa_review_regulation-changes", "ismsa_register_compliance").

ismsa_plannedEvidenceInHome(Control, EvidenceIdentifier, Home) :-
    ismsa_centralEvidence(ControlIdentifier, EvidenceIdentifier, _),
    field(Control, "base/fieldTypes/identifier", ControlIdentifier),
    base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
    ismsa_closestHome(Control, Home).

ismsa_evidenceTargetCandidate(Control, EvidenceIdentifier, 1, Register) :-
    ismsa_plannedEvidenceInHome(Control, EvidenceIdentifier, Home),
    ismsa_evidenceLocation(EvidenceIdentifier, RegisterIdentifier),
    field(Register, "base/fieldTypes/identifier", RegisterIdentifier),
    ismsa_closestHome(Register, Home).

ismsa_evidenceTargetCandidate(Control, EvidenceIdentifier, 2, Register) :-
    ismsa_plannedEvidenceInHome(Control, EvidenceIdentifier, Home),
    field(Register, "base/fieldTypes/identifier", "ismsa_register_processes"),
    ismsa_closestHome(Register, Home).

ismsa_evidenceTargetCandidate(Control, EvidenceIdentifier, 3, Home) :-
    ismsa_plannedEvidenceInHome(Control, EvidenceIdentifier, Home).

ismsa_evidenceTargetLevel(Control, EvidenceIdentifier, Level) :-
    ismsa_plannedEvidenceInHome(Control, EvidenceIdentifier, _),
    Level = #min { L : ismsa_evidenceTargetCandidate(Control, EvidenceIdentifier, L, _) }.

% If a home has two registers with the same identifier, the first card key is used.

ismsa_evidenceTarget(Control, EvidenceIdentifier, Card) :-
    ismsa_evidenceTargetLevel(Control, EvidenceIdentifier, Level),
    Card = #min { C : ismsa_evidenceTargetCandidate(Control, EvidenceIdentifier, Level, C) }.

%
% Scoping
%
% The controls of the libraries are in scope when they are created, because installing a library
% is the decision to use its controls. A home that does not need a control marks it out of
% scope, with a justification.
%

% The facts ismsa_controlInScopeByDefault are in ismsa/calculations/homeLibraries.

onTransitionExecuteTransition(Control, "Create", Control, "Mark in scope") :-
    base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
    field(Control, "base/fieldTypes/identifier", Identifier),
    ismsa_controlInScopeByDefault(Identifier).

%
% Owners
%
% In an ISMS home that has a central control register, a card whose owner is calculated and
% overridable gets the owner of its parent card. So the owner of the home is the owner of the
% registers and the central controls, until someone overrides it. The old home template
% (ismsa/templates/moduleHome) has no central control register, so its cards do not change.
%

ismsa_homeWithCentralControls(Home) :-
    field(Register, "base/fieldTypes/identifier", "ismsa_register_central-controls"),
    ismsa_closestHome(Register, Home).

fieldCalculated(Card, "base/fieldTypes/owner", Owner) :-
    ismsa_closestHome(Card, Home),
    ismsa_homeWithCentralControls(Home),
    parent(Card, Parent),
    field(Parent, "base/fieldTypes/owner", Owner),
    base_projectCardType(Card, CardType),
    calculatedField(CardType, "base/fieldTypes/owner"),
    overridableField(CardType, "base/fieldTypes/owner").

%
% Progress of a register of internal controls
%
% A register with the progress label "internal-control-progress" shows the percentage of
% its internal controls that are assessed as OK or not applicable.
%

ismsa_internalControlInRegister(Register, Control) :-
    field(Register, "ismsa/fieldTypes/progress", "internal-control-progress"),
    ancestor(Control, Register),
    base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
    not hiddenInTreeView(Control).

field(Register, "progress", (100 * Done) / Total) :-
    field(Register, "ismsa/fieldTypes/progress", "internal-control-progress"),
    Total = #count { Control : ismsa_internalControlInRegister(Register, Control) },
    Total > 0,
    Done = #count {
        Control :
            ismsa_internalControlInRegister(Register, Control),
            field(Control, "base/fieldTypes/assessment", "ok");
        Control :
            ismsa_internalControlInRegister(Register, Control),
            field(Control, "base/fieldTypes/assessment", "notApplicable")
    }.

%
% Guidance for the EU Cyber Resilience Act
%
% The bodies of the central controls show the CRA guidance only when the EU CRA module
% (eucra) is installed. The module is detected from its templates. The EU CRA module can
% also declare the fact "ismsa_craGuidance." itself.
%

ismsa_euCraTemplate("eucra/templates/design2").
ismsa_euCraTemplate("eucra/templates/implementation2").
ismsa_euCraTemplate("eucra/templates/securityAdvisory").
ismsa_euCraTemplate("eucra/templates/supportPeriod").

ismsa_craGuidance :-
    ismsa_euCraTemplate(Template),
    template(Template).
