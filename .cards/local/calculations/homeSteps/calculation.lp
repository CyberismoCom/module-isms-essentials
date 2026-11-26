%
% Steps of the ISMS home
%
% The home card shows the steps in two places: the checklist "All steps"
% (ismsa/reports/gettingStarted) and the dashboard (ismsa/reports/homeDashboard). Both use the facts
% of this calculation, so that they always agree.
%
% The steps are only for the homes made from ismsa/templates/moduleHome2 (ismsa_newHome/1 in
% ismsa/calculations/homeControl).
%

%
% Set-up steps
%
% The home is set up when these steps are done. They are the checks of the transition "Content
% ready" (ismsa/calculations/homeControl), and the libraries that the answers need.
%
% ismsa_homeSetUpStep(Ordinal, Text)
%

ismsa_homeSetUpStep(1, "Write the scope of the home in the title").
ismsa_homeSetUpStep(2, "Describe the scope").
ismsa_homeSetUpStep(3, "Set the owner of the home").
ismsa_homeSetUpStep(4, "Answer the questions about the libraries").
ismsa_homeSetUpStep(5, "Add the libraries that the answers need").

ismsa_homeSetUpStepDone(Home, 1) :-
    ismsa_newHome(Home),
    field(Home, "title", Title),
    Title != "ISMS home for (scope)".

ismsa_homeSetUpStepDone(Home, 2) :-
    ismsa_newHome(Home),
    field(Home, "ismsa/fieldTypes/homeScopeDescription", _).

ismsa_homeSetUpStepDone(Home, 3) :-
    ismsa_newHome(Home),
    field(Home, "base/fieldTypes/owner", _).

ismsa_homeSetUpStepDone(Home, 4) :-
    ismsa_newHome(Home),
    ismsa_homeQuestionsAnswered(Home).

ismsa_homeSetUpStepDone(Home, 5) :-
    ismsa_newHome(Home),
    ismsa_libraryChoiceComplete(Home).

ismsa_homeSetUp(Home) :-
    ismsa_newHome(Home),
    ismsa_homeSetUpStepDone(Home, N) : ismsa_homeSetUpStep(N, _).

% The next set-up step is the first one that is not done.

ismsa_homeSetUpStepNext(Home, N) :-
    ismsa_newHome(Home),
    not ismsa_homeSetUp(Home),
    N = #min { M : ismsa_homeSetUpStep(M, _), not ismsa_homeSetUpStepDone(Home, M) }.

%
% The libraries in the set-up
%
% The set-up shows one button: the next part of the libraries that the answers need. The parts
% come in the order of the libraries (ismsa_libraryRank/2), and within a library the controls
% first, then the registers on the home card, the requirements, and the other parts. Some parts
% can be added only after an earlier part, because their target is a register of the earlier
% part.
%
% ismsa_libraryPartKind(Home, Template, Kind): 1 controls, 2 registers, 3 requirements, 4 other
%

ismsa_homeMissingPart(Home, Library, Template, Label, Target) :-
    ismsa_newHome(Home),
    ismsa_libraryRequired(Home, Library),
    ismsa_libraryPart(Home, Library, Template, Label, Target),
    not ismsa_libraryPartInstalled(Home, Template).

ismsa_libraryPartKind(Home, Template, 1) :-
    ismsa_homeMissingPart(Home, _, Template, _, Target),
    field(Target, "base/fieldTypes/identifier", "ismsa_register_central-controls").

ismsa_libraryPartKind(Home, Template, 2) :-
    ismsa_homeMissingPart(Home, _, Template, _, Home).

ismsa_libraryPartKind(Home, Template, 3) :-
    ismsa_homeMissingPart(Home, _, Template, _, Target),
    field(Target, "base/fieldTypes/identifier", "ismsa_register_compliance").

ismsa_libraryPartKind(Home, Template, 4) :-
    ismsa_homeMissingPart(Home, _, Template, _, _),
    not ismsa_libraryPartKind(Home, Template, 1),
    not ismsa_libraryPartKind(Home, Template, 2),
    not ismsa_libraryPartKind(Home, Template, 3).

ismsa_homeMissingPartOrder(Home, Template, Key) :-
    ismsa_homeMissingPart(Home, Library, Template, _, _),
    ismsa_libraryRank(Library, Rank),
    ismsa_libraryPartKind(Home, Template, Kind),
    Key = 10 * Rank + Kind.

ismsa_homeNextPartKey(Home, Key) :-
    ismsa_homeMissingPartOrder(Home, _, _),
    Key = #min { K : ismsa_homeMissingPartOrder(Home, _, K) }.

ismsa_homeNextPartLabel(Home, Label) :-
    ismsa_homeNextPartKey(Home, Key),
    Label = #min { L : ismsa_homeMissingPartOrder(Home, T, Key), ismsa_homeMissingPart(Home, _, T, L, _) }.

% ismsa_homeNextLibraryPart(Home, Template, ButtonLabel, Target)

ismsa_homeNextLibraryPart(Home, Template, Label, Target) :-
    ismsa_homeNextPartKey(Home, Key),
    ismsa_homeNextPartLabel(Home, Label),
    ismsa_homeMissingPartOrder(Home, Template, Key),
    ismsa_homeMissingPart(Home, _, Template, Label, Target).

% The number of parts that are left, also the parts whose target is not in the home yet

ismsa_homePartLeft(Home, Template) :-
    ismsa_newHome(Home),
    ismsa_libraryRequired(Home, Library),
    ismsa_installableExtension(_, Library, Template, _, _),
    ismsa_libraryOfferedInHome(Template, Home),
    not ismsa_libraryPartInstalled(Home, Template).

ismsa_homeLibraryPartsLeft(Home, N) :-
    ismsa_newHome(Home),
    N = #count { T : ismsa_homePartLeft(Home, T) }.

%
% Control steps
%
% The steps after the set-up, in the order of the set-up tasks of the old home template
% (ismsa/templates/moduleHome). Each step is done with an internal control of the home. A home
% shows only the steps whose control is in the home, so the steps of libraries that are not added
% are left out.
%
% ismsa_homeStep(Group, Ordinal, ControlIdentifier, StepText)
%

ismsa_homeStep("start", 1, "ismsa_control_assign-central-security-roles", "Assign the security roles and responsibilities").
ismsa_homeStep("start", 2, "ismsa_control_isms-scope-and-context", "Analyse the business context, and define the scope of the ISMS").
ismsa_homeStep("start", 3, "ismsa_control_information-security-policy", "Create the information security policy and the cryptography rules").

ismsa_homeStep("central", 1, "ismsa_control_receive-security-issue-notifications", "Publish how to report security issues to the organisation").
ismsa_homeStep("central", 2, "ismsa_control_notify-about-vulnerabilities-and-incidents", "Document the incident management process, and how to notify about vulnerabilities and incidents").
ismsa_homeStep("central", 3, "ismsa_control_contact-with-authorities", "List the authorities and how to contact them").
ismsa_homeStep("central", 4, "ismsa_control_protect-records", "Plan how long records are kept, and how they are protected").
ismsa_homeStep("central", 5, "ismsa_control_follow-changes-in-regulation", "Review the changes in regulation").

ismsa_homeStep("assets", 1, "ismsa_control_manage-assets", "Document the asset management process, and identify and evaluate the assets").

ismsa_homeStep("risks", 1, "ismsa_control_manage-risks", "Document the risk management process, and identify, analyse, and treat the risks").

ismsa_homeStep("suppliers", 1, "ismsa_control_manage-supplier-security", "Set security requirements for the critical suppliers, and check them").

ismsa_homeStep("operations", 1, "ismsa_control_continuity-and-recovery", "Plan business continuity and recovery, and test the recovery").
ismsa_homeStep("operations", 2, "ismsa_control_exercise-incident-response", "Exercise incident response").
ismsa_homeStep("operations", 3, "ismsa_control_operate-security-monitoring", "Plan and operate security monitoring").
ismsa_homeStep("operations", 4, "ismsa_control_review-access-rights", "Review the access rights").
ismsa_homeStep("operations", 5, "ismsa_control_apply-basic-security-practices", "Check the basic security practices").
ismsa_homeStep("operations", 6, "ismsa_control_manage-vulnerabilities-and-updates", "Document how vulnerabilities are found and updates installed").

ismsa_homeStep("ai", 1, "ismsa_control_ai-policy", "Write the AI policy, and name the AI responsible").
ismsa_homeStep("ai", 2, "ismsa_control_manage-ai-tools", "Record and assess the AI tools in use").
ismsa_homeStep("ai", 3, "ismsa_control_ai-literacy", "Add AI literacy to the training plan").

ismsa_homeStep("improvement", 1, "ismsa_control_training-and-awareness", "Create the training and awareness plan").
ismsa_homeStep("improvement", 2, "ismsa_control_human-resources-security", "Agree on security for joiners, role changes, and leavers, and check it").
ismsa_homeStep("improvement", 3, "ismsa_control_measure-security-effectiveness", "Choose the security metrics, and measure them").
ismsa_homeStep("improvement", 4, "ismsa_control_plan-and-review-isms", "Set the yearly targets, plan the annual wheel, and hold the management review").

% ismsa_homeStepGroup(Group, Rank, Heading): the groups of the checklist, in order.

ismsa_homeStepGroup("start", 1, "Get started").
ismsa_homeStepGroup("central", 2, "Set up the central controls").
ismsa_homeStepGroup("assets", 3, "Manage the assets that need protection").
ismsa_homeStepGroup("risks", 4, "Manage the risks").
ismsa_homeStepGroup("suppliers", 5, "Manage the suppliers").
ismsa_homeStepGroup("operations", 6, "Run security operations and plan business continuity").
ismsa_homeStepGroup("ai", 7, "Use AI safely").
ismsa_homeStepGroup("improvement", 8, "Plan continuous improvement").

% The control of a step in a home. If a home has two controls with the same identifier, the first
% card key is used.

ismsa_homeStepCandidate(Home, Identifier, Control) :-
    ismsa_homeStep(_, _, Identifier, _),
    ismsa_closestHome(Control, Home),
    base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
    field(Control, "base/fieldTypes/identifier", Identifier).

ismsa_homeStepControl(Home, Group, Ordinal, Control) :-
    ismsa_homeStep(Group, Ordinal, Identifier, _),
    ismsa_homeStepCandidate(Home, Identifier, _),
    Control = #min { C : ismsa_homeStepCandidate(Home, Identifier, C) }.

% A step is done when its control is OK or out of scope.

ismsa_homeStepDoneValue("ok").
ismsa_homeStepDoneValue("notApplicable").

ismsa_homeStepDone(Home, Group, Ordinal) :-
    ismsa_homeStepControl(Home, Group, Ordinal, Control),
    field(Control, "base/fieldTypes/assessment", Assessment),
    ismsa_homeStepDoneValue(Assessment).

ismsa_homeStepOpen(Home, Group, Ordinal) :-
    ismsa_homeStepControl(Home, Group, Ordinal, _),
    not ismsa_homeStepDone(Home, Group, Ordinal).

% The position of a step in the order of all steps of the home.

ismsa_homeStepKey(Group, Ordinal, Key) :-
    ismsa_homeStep(Group, Ordinal, _, _),
    ismsa_homeStepGroup(Group, Rank, _),
    Key = Rank * 100 + Ordinal.

% The next open steps of the home, numbered from 1 in the order of all steps.

ismsa_homeStepOpenKey(Home, Key) :-
    ismsa_homeStepOpen(Home, Group, Ordinal),
    ismsa_homeStepKey(Group, Ordinal, Key).

ismsa_homeNextStep(Home, Index, Group, Ordinal) :-
    ismsa_homeStepOpen(Home, Group, Ordinal),
    ismsa_homeStepKey(Group, Ordinal, Key),
    Before = #count { K : ismsa_homeStepOpenKey(Home, K), K < Key },
    Index = Before + 1.

%
% Areas of work
%
% The dashboard shows one progress tile for each area of work that has a step in the home. The
% areas follow the libraries, so that a typical home has at most six tiles, and each tile has
% more than one control.
%
% ismsa_homeArea(Group, Area, Rank, Label)
%

ismsa_homeArea("central", "central", 1, "Central work").
ismsa_homeArea("start", "management", 2, "Management").
ismsa_homeArea("improvement", "management", 2, "Management").
ismsa_homeArea("assets", "assetsRisks", 3, "Assets and risks").
ismsa_homeArea("risks", "assetsRisks", 3, "Assets and risks").
ismsa_homeArea("suppliers", "assetsRisks", 3, "Assets and risks").
ismsa_homeArea("operations", "operations", 4, "Operations").
ismsa_homeArea("ai", "ai", 5, "AI").

ismsa_homeAreaStep(Home, Area, Key) :-
    ismsa_homeStepControl(Home, Group, Ordinal, _),
    ismsa_homeArea(Group, Area, _, _),
    ismsa_homeStepKey(Group, Ordinal, Key).

ismsa_homeAreaStepDone(Home, Area, Key) :-
    ismsa_homeAreaStep(Home, Area, Key),
    ismsa_homeStepKey(Group, Ordinal, Key),
    ismsa_homeStepDone(Home, Group, Ordinal).

% ismsa_homeAreaProgress(Home, Area, Rank, Label, Value): the share of the steps that are done, in
% per cent.

ismsa_homeAreaProgress(Home, Area, Rank, Label, Value) :-
    ismsa_homeAreaStep(Home, Area, _),
    ismsa_homeArea(_, Area, Rank, Label),
    Total = #count { K : ismsa_homeAreaStep(Home, Area, K) },
    Done = #count { K : ismsa_homeAreaStepDone(Home, Area, K) },
    Value = 100 * Done / Total.

% The control that a tile opens: the first open control of the area, or its first control when all
% are done.

ismsa_homeAreaKey(Home, Area, Key) :-
    ismsa_homeAreaProgress(Home, Area, _, _, _),
    Key = #min { K : ismsa_homeAreaStep(Home, Area, K), not ismsa_homeAreaStepDone(Home, Area, K) },
    Key != #sup.

ismsa_homeAreaKey(Home, Area, Key) :-
    ismsa_homeAreaProgress(Home, Area, _, _, 100),
    Key = #min { K : ismsa_homeAreaStep(Home, Area, K) }.

ismsa_homeAreaControl(Home, Area, Control) :-
    ismsa_homeAreaKey(Home, Area, Key),
    ismsa_homeStepKey(Group, Ordinal, Key),
    ismsa_homeStepControl(Home, Group, Ordinal, Control).

%
% NIS2 requirements
%
% When the home has the NIS2 basics library, the dashboard also shows the share of the NIS2
% requirements in scope that are met.
%

ismsa_homeNis2Register(Home, Register) :-
    ismsa_newHome(Home),
    ismsa_closestHome(Register, Home),
    field(Register, "base/fieldTypes/identifier", "ismsa_register_nis2").

ismsa_homeNis2Requirement(Home, Requirement) :-
    ismsa_homeNis2Register(Home, Register),
    parent(Requirement, Register),
    base_projectCardType(Requirement, "ismsa/cardTypes/assessedComplianceRequirement").

ismsa_homeNis2Progress(Home, Value) :-
    ismsa_homeNis2Requirement(Home, _),
    Total = #count { R : ismsa_homeNis2Requirement(Home, R), not field(R, "base/fieldTypes/assessment", "notApplicable") },
    Total > 0,
    Done = #count { R : ismsa_homeNis2Requirement(Home, R), field(R, "base/fieldTypes/assessment", "ok") },
    Value = 100 * Done / Total.

%
% The registers in the tree
%
% A new home shows only the home card in the tree until the set-up is done or the first library is
% added (E10-D16). Before that, the registers are empty. They stay reachable by link and by search.
%
% The rule does not wait for the whole set-up. A hidden card also hides its descendants, and
% many calculations leave out hidden cards, for example the checks of the asset and risk
% controls. A home with content can go back to the set-up, for example when a new "yes" answer
% needs a library, and its registers and checks must not change then. Libraries are not removed,
% so a home with a library keeps its registers in the tree.
%
% Old homes (the deprecated template ismsa/templates/moduleHome) have no identifier "ismsa_home",
% so they do not change.
%

ismsa_homeHasLibrary(Home) :-
    ismsa_newHome(Home),
    ismsa_libraryPartInstalled(Home, _).

hiddenInTreeView(Card) :-
    ismsa_newHome(Home),
    not ismsa_homeSetUp(Home),
    not ismsa_homeHasLibrary(Home),
    parent(Card, Home).

% A card in a new home. A register of a new home that has no content shows no percentage in the
% tree (E13 B10): the progress calculations leave out the value 0 for these registers.

ismsa_inNewHome(Card) :-
    ismsa_closestHome(Card, Home),
    ismsa_newHome(Home).
