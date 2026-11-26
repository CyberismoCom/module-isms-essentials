% Run with: cyberismo calc run tests/home-first-use.lp
% The test passes when "results" is empty and "error" is null. Each result is one failure.
%
% Tests of the first use of the home (E10 P1 to P4): the set-up steps and the switch of the views
% of the home card, the registers in the tree, the areas of work and the next steps of the
% dashboard, and the recommended answers. The rules are in ismsa/calculations/homeSteps and
% ismsa/calculations/libraryChoice.
%
% The fixtures are the test homes of tests/home-libraries.lp, under "Test content" > "ISMS home
% library tests", and one more home:
%
% - Test home L9 (ismsa_test_lib_home-9) was created on 2026-11-26 from the templates of that
%   version. It answers "yes" to NIS2, and "no" to the CRA and AI. The questions about the work
%   are not answered, so they get the recommended answers. It has an owner and a scope
%   description, but no libraries. So only the last set-up step is left.
%
% The other homes used here:
%
% - L1 has a title, a scope description, an owner, all answers, and all libraries of its time.
%   It is set up.
% - L6 has a title and an owner, but no scope description, no answers, and no libraries.
% - L7 has all libraries, but no scope description.
% - L8 answers "no" to NIS2 and the CRA, so no question has a recommended answer.

ismsa_fuHome("L1", ismsa_g04dsanv).
ismsa_fuHome("L6", ismsa_ny30dov7).
ismsa_fuHome("L7", ismsa_tunfxhm0).
ismsa_fuHome("L8", ismsa_chi8jp44).
ismsa_fuHome("L9", ismsa_cgk8g484).

result(("FAIL fixture missing", Id)) :-
    ismsa_fuHome(Id, Home),
    not ismsa_newHome(Home).

%
% Set-up steps and the view of the home card (E10-D14)
%

ismsa_fuExpectSetUp("L1").
ismsa_fuExpectSetUp("L8").

result(("FAIL home should be set up", Id)) :-
    ismsa_fuExpectSetUp(Id),
    ismsa_fuHome(Id, Home),
    not ismsa_homeSetUp(Home).

result(("FAIL home should not be set up", Id)) :-
    ismsa_fuHome(Id, Home),
    not ismsa_fuExpectSetUp(Id),
    ismsa_homeSetUp(Home).

% ismsa_fuExpectNext(HomeId, Step): the next set-up step. Step 2 is the scope description.

ismsa_fuExpectNext("L6", 2).
ismsa_fuExpectNext("L7", 2).
ismsa_fuExpectNext("L9", 5).

result(("FAIL next set-up step", Id, Expected, Actual)) :-
    ismsa_fuExpectNext(Id, Expected),
    ismsa_fuHome(Id, Home),
    ismsa_homeSetUpStepNext(Home, Actual),
    Actual != Expected.

result(("FAIL no next set-up step", Id)) :-
    ismsa_fuExpectNext(Id, _),
    ismsa_fuHome(Id, Home),
    not ismsa_homeSetUpStepNext(Home, _).

result(("FAIL a set-up home has a next set-up step", Id)) :-
    ismsa_fuExpectSetUp(Id),
    ismsa_fuHome(Id, Home),
    ismsa_homeSetUpStepNext(Home, _).

% L9: the title, the scope description, and the owner are set, and the questions are answered
% with the recommended answers. The libraries are missing, so the home is not set up.

ismsa_fuExpectStep("L9", 1, done).
ismsa_fuExpectStep("L9", 2, done).
ismsa_fuExpectStep("L9", 3, done).
ismsa_fuExpectStep("L9", 4, done).
ismsa_fuExpectStep("L9", 5, open).

result(("FAIL set-up step should be done", Id, N)) :-
    ismsa_fuExpectStep(Id, N, done),
    ismsa_fuHome(Id, Home),
    not ismsa_homeSetUpStepDone(Home, N).

result(("FAIL set-up step should not be done", Id, N)) :-
    ismsa_fuExpectStep(Id, N, open),
    ismsa_fuHome(Id, Home),
    ismsa_homeSetUpStepDone(Home, N).

%
% The registers in the tree (E10-D16)
%

% Hidden until the set-up is done or a library is added

ismsa_fuExpectHidden("L6").
ismsa_fuExpectHidden("L9").

result(("FAIL register should be hidden", Id, Card)) :-
    ismsa_fuExpectHidden(Id),
    ismsa_fuHome(Id, Home),
    parent(Card, Home),
    not hiddenInTreeView(Card).

result(("FAIL register should be in the tree", Id, Card)) :-
    ismsa_fuHome(Id, Home),
    not ismsa_fuExpectHidden(Id),
    parent(Card, Home),
    hiddenInTreeView(Card).

result(("FAIL home card should be in the tree", Id)) :-
    ismsa_fuHome(Id, Home),
    hiddenInTreeView(Home).

% An empty register of a new home shows no percentage (E13 B10). The incident register of L7 has
% no incidents.

result(("FAIL empty register has a percentage", Card, Value)) :-
    ismsa_fuHome("L7", Home),
    parent(Card, Home),
    field(Card, "base/fieldTypes/identifier", "ismsa_register_incidents"),
    field(Card, "progress", Value).

result(("FAIL incident register of L7 missing")) :-
    ismsa_fuHome("L7", Home),
    not ismsa_fuIncidentRegister(Home).

ismsa_fuIncidentRegister(Home) :-
    parent(Card, Home),
    field(Card, "base/fieldTypes/identifier", "ismsa_register_incidents").

%
% Dashboard (E10-D15)
%

% L1 has the controls of four areas, and no AI controls.

ismsa_fuExpectArea("L1", "central").
ismsa_fuExpectArea("L1", "management").
ismsa_fuExpectArea("L1", "assetsRisks").
ismsa_fuExpectArea("L1", "operations").

result(("FAIL area missing", Id, Area)) :-
    ismsa_fuExpectArea(Id, Area),
    ismsa_fuHome(Id, Home),
    not ismsa_homeAreaProgress(Home, Area, _, _, _).

result(("FAIL unexpected area", Id, Area)) :-
    ismsa_fuHome(Id, Home),
    Id = "L1",
    ismsa_homeAreaProgress(Home, Area, _, _, _),
    not ismsa_fuExpectArea(Id, Area).

result(("FAIL area value out of range", Id, Area, Value)) :-
    ismsa_fuHome(Id, Home),
    ismsa_homeAreaProgress(Home, Area, _, _, Value),
    not 0 <= Value <= 100.

% Each tile opens a control of its area, in the same home.

result(("FAIL tile has no control", Id, Area)) :-
    ismsa_fuHome(Id, Home),
    ismsa_homeAreaProgress(Home, Area, _, _, _),
    not ismsa_fuAreaControl(Home, Area).

ismsa_fuAreaControl(Home, Area) :-
    ismsa_homeAreaControl(Home, Area, Control),
    ismsa_closestHome(Control, Home),
    base_projectCardType(Control, "ismsa/cardTypes/internalControl").

result(("FAIL tile has two controls", Id, Area)) :-
    ismsa_fuHome(Id, Home),
    ismsa_homeAreaControl(Home, Area, C1),
    ismsa_homeAreaControl(Home, Area, C2),
    C1 < C2.

% The next steps are numbered 1, 2, 3, ... without gaps, and each one is an open step. The access
% rights review of L1 is OK, so it is not a next step.

result(("FAIL next steps have a gap", Id, Index)) :-
    ismsa_fuHome(Id, Home),
    ismsa_homeNextStep(Home, Index, _, _),
    Index > 1,
    not ismsa_fuNextIndex(Home, Index - 1).

ismsa_fuNextIndex(Home, Index) :-
    ismsa_homeNextStep(Home, Index, _, _).

result(("FAIL next step is done", Id, Group, Ordinal)) :-
    ismsa_fuHome(Id, Home),
    ismsa_homeNextStep(Home, _, Group, Ordinal),
    ismsa_homeStepDone(Home, Group, Ordinal).

result(("FAIL L1 has no first next step")) :-
    ismsa_fuHome("L1", Home),
    not ismsa_homeNextStep(Home, 1, _, _).

result(("FAIL done step is a next step", "L1", "operations", 4)) :-
    ismsa_fuHome("L1", Home),
    ismsa_homeNextStep(Home, _, "operations", 4).

result(("FAIL access rights review of L1 should be done")) :-
    ismsa_fuHome("L1", Home),
    not ismsa_homeStepDone(Home, "operations", 4).

% The NIS2 tile: L7 has the NIS2 basics library, and L6 does not.

result(("FAIL NIS2 tile missing", "L7")) :-
    ismsa_fuHome("L7", Home),
    not ismsa_homeNis2Progress(Home, _).

result(("FAIL unexpected NIS2 tile", "L6")) :-
    ismsa_fuHome("L6", Home),
    ismsa_homeNis2Progress(Home, _).

%
% Recommended answers (E10-D17)
%

% L9 answers "yes" to NIS2. NIS2 recommends the four questions about the work. The ISMS includes
% the asset risks, so that question has no default and shows "Included in the ISMS".

ismsa_fuExpectDefault("L9", "centralWork").
ismsa_fuExpectDefault("L9", "fullIsms").
ismsa_fuExpectDefault("L9", "ownServices").

result(("FAIL recommended answer missing", Id, Question)) :-
    ismsa_fuExpectDefault(Id, Question),
    ismsa_fuHome(Id, Home),
    not ismsa_homeAnswer(Home, Question, "yes").

result(("FAIL answer should be the default", Id, Question)) :-
    ismsa_fuExpectDefault(Id, Question),
    ismsa_fuHome(Id, Home),
    not ismsa_answerIsDefault(Home, Question).

result(("FAIL unexpected default", Id, Question)) :-
    ismsa_fuHome(Id, Home),
    ismsa_answerIsDefault(Home, Question),
    not ismsa_fuExpectDefault(Id, Question).

result(("FAIL asset risks should be included", "L9")) :-
    ismsa_fuHome("L9", Home),
    not ismsa_questionIncluded(Home, "assetRisks", _).

result(("FAIL included question has an answer", "L9")) :-
    ismsa_fuHome("L9", Home),
    ismsa_homeAnswer(Home, "assetRisks", _).

% The default answers add the libraries to the list of the libraries that the home needs.

ismsa_fuExpectRequired("L9", "the security response and compliance basics library").
ismsa_fuExpectRequired("L9", "the information security management basics library").
ismsa_fuExpectRequired("L9", "the asset and risk management library").
ismsa_fuExpectRequired("L9", "the security operations basics library").
ismsa_fuExpectRequired("L9", "the NIS2 basics library").

result(("FAIL library should be required", Id, Library)) :-
    ismsa_fuExpectRequired(Id, Library),
    ismsa_fuHome(Id, Home),
    not ismsa_libraryRequired(Home, Library).

result(("FAIL library should not be required", Id, Library)) :-
    ismsa_fuHome(Id, Home),
    Id = "L9",
    ismsa_libraryRequired(Home, Library),
    not ismsa_fuExpectRequired(Id, Library).

% A stored answer is an override and wins over the recommendation. L1 and L7 answer all questions
% themselves, so they have no default answers (checked above), and their answers stay.

result(("FAIL stored answer lost", Id, Question)) :-
    ismsa_fuHome(Id, Home),
    ismsa_homeQuestion(Question, Field),
    fieldOverride(Home, Field, Value),
    not ismsa_homeAnswer(Home, Question, Value).
