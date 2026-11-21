%
% Choosing the libraries of an ISMS home
%
% The home card asks six yes or no questions. The answers are hidden fields of the home card
% type, edited with field macros in the section "Libraries" (ismsa/reports/homeLibrarySection).
% These rules decide which libraries the home needs, and why the other libraries are not needed.
%
% A "yes" to a question about the work of the home requires a library directly. The questions
% about the EU Cyber Resilience Act and NIS2 also imply other libraries, but only when no
% existing ISMS outside the home does the central security work.
%

% ismsa_homeQuestion(Question, Field)

ismsa_homeQuestion("existingIsms", "ismsa/fieldTypes/homeExistingIsms").
ismsa_homeQuestion("cra", "ismsa/fieldTypes/homeCra").
ismsa_homeQuestion("fullIsms", "ismsa/fieldTypes/homeFullIsms").
ismsa_homeQuestion("assetRisks", "ismsa/fieldTypes/homeAssetRisks").
ismsa_homeQuestion("ownServices", "ismsa/fieldTypes/homeOwnServices").
ismsa_homeQuestion("nis2", "ismsa/fieldTypes/homeNis2").

ismsa_homeAnswer(Home, Question, Answer) :-
    base_projectCardType(Home, "ismsa/cardTypes/moduleHome"),
    ismsa_homeQuestion(Question, Field),
    field(Home, Field, Answer).

ismsa_homeQuestionsAnswered(Home) :-
    base_projectCardType(Home, "ismsa/cardTypes/moduleHome"),
    ismsa_homeAnswer(Home, Question, _) : ismsa_homeQuestion(Question, _).

% The libraries that the questions decide, with their titles. Libraries of other modules are
% shown separately on the home card, without questions.

ismsa_choiceLibrary("the security response and compliance basics library", "Security response and compliance basics").
ismsa_choiceLibrary("the information security management library", "Information security management").
ismsa_choiceLibrary("the asset and risk management library", "Asset and risk management").
ismsa_choiceLibrary("the security operations library", "Security operations").
ismsa_choiceLibrary("the NIS2 library", "NIS2").

%
% Required libraries, with the reasons
%
% ismsa_libraryRequirement(Home, Library, Reason)
%

ismsa_libraryRequirement(Home, "the security response and compliance basics library",
        "no existing ISMS does the central security work for this home") :-
    ismsa_homeAnswer(Home, "existingIsms", "no").

ismsa_libraryRequirement(Home, "the information security management library",
        "the home needs a full ISMS") :-
    ismsa_homeAnswer(Home, "fullIsms", "yes").

ismsa_libraryRequirement(Home, "the asset and risk management library",
        "the home needs a full ISMS") :-
    ismsa_homeAnswer(Home, "fullIsms", "yes").

ismsa_libraryRequirement(Home, "the asset and risk management library",
        "the home manages the risks of the assets of the organisation") :-
    ismsa_homeAnswer(Home, "assetRisks", "yes").

ismsa_libraryRequirement(Home, "the security operations library",
        "the organisation runs IT or cloud services itself") :-
    ismsa_homeAnswer(Home, "ownServices", "yes").

ismsa_libraryRequirement(Home, "the NIS2 library", "NIS2 applies") :-
    ismsa_homeAnswer(Home, "nis2", "yes").

% Implied by the EU Cyber Resilience Act and NIS2, unless an existing ISMS does the work

ismsa_libraryRequirement(Home, "the security response and compliance basics library",
        "the products must meet the EU Cyber Resilience Act") :-
    ismsa_homeAnswer(Home, "cra", "yes"),
    not ismsa_homeAnswer(Home, "existingIsms", "yes").

ismsa_nis2NeedsLibrary("the security response and compliance basics library").
ismsa_nis2NeedsLibrary("the information security management library").
ismsa_nis2NeedsLibrary("the asset and risk management library").
ismsa_nis2NeedsLibrary("the security operations library").

ismsa_libraryRequirement(Home, Library, "NIS2 needs it") :-
    ismsa_homeAnswer(Home, "nis2", "yes"),
    not ismsa_homeAnswer(Home, "existingIsms", "yes"),
    ismsa_nis2NeedsLibrary(Library).

ismsa_libraryRequired(Home, Library) :-
    ismsa_libraryRequirement(Home, Library, _).

%
% Libraries that are not needed, with the reason
%
% ismsa_libraryNotNeeded(Home, Library, Reason) is derived only when the answers that decide the
% library are given and none of them requires it. The reasons are in
% ismsa_libraryNotNeededReason/3.
%

ismsa_nis2DoesNotAdd(Home) :-
    ismsa_homeAnswer(Home, "nis2", "no").

ismsa_nis2DoesNotAdd(Home) :-
    ismsa_homeAnswer(Home, "nis2", "yes"),
    ismsa_homeAnswer(Home, "existingIsms", "yes").

ismsa_nis2Note(Home, "") :-
    ismsa_homeAnswer(Home, "nis2", "no").

ismsa_nis2Note(Home, " The existing ISMS does the work that NIS2 needs.") :-
    ismsa_homeAnswer(Home, "nis2", "yes"),
    ismsa_homeAnswer(Home, "existingIsms", "yes").

ismsa_libraryNotNeededReason(Home, "the security response and compliance basics library",
        "An existing ISMS already does the central security work for this home.") :-
    ismsa_homeAnswer(Home, "existingIsms", "yes").

ismsa_libraryNotNeededReason(Home, "the information security management library",
        @concatenate("The home does not need a full ISMS.", Note)) :-
    ismsa_homeAnswer(Home, "fullIsms", "no"),
    ismsa_nis2DoesNotAdd(Home),
    ismsa_nis2Note(Home, Note).

ismsa_libraryNotNeededReason(Home, "the asset and risk management library",
        @concatenate("The home does not need a full ISMS, and it does not manage the risks of the assets of the organisation.", Note)) :-
    ismsa_homeAnswer(Home, "fullIsms", "no"),
    ismsa_homeAnswer(Home, "assetRisks", "no"),
    ismsa_nis2DoesNotAdd(Home),
    ismsa_nis2Note(Home, Note).

ismsa_libraryNotNeededReason(Home, "the security operations library",
        @concatenate("The organisation does not run IT or cloud services itself.", Note)) :-
    ismsa_homeAnswer(Home, "ownServices", "no"),
    ismsa_nis2DoesNotAdd(Home),
    ismsa_nis2Note(Home, Note).

ismsa_libraryNotNeededReason(Home, "the NIS2 library", "NIS2 does not apply.") :-
    ismsa_homeAnswer(Home, "nis2", "no").

% A required library is never "not needed", even if a reason above matches.

ismsa_libraryNotNeeded(Home, Library, Reason) :-
    ismsa_libraryNotNeededReason(Home, Library, Reason),
    not ismsa_libraryRequired(Home, Library).

% A library is undecided while it is neither required nor known to be not needed.

ismsa_libraryUndecided(Home, Library) :-
    base_projectCardType(Home, "ismsa/cardTypes/moduleHome"),
    ismsa_choiceLibrary(Library, _),
    not ismsa_libraryRequired(Home, Library),
    not ismsa_libraryNotNeeded(Home, Library, _).

%
% The state of each library in a home
%
% A library is added when all its parts are in the home (see ismsa_libraryPart/5 in
% ismsa/calculations/extensions), and partly added when only some are.
%

ismsa_libraryInHome(Home, Library) :-
    ismsa_libraryPart(Home, Library, _, _, _).

ismsa_libraryAdded(Home, Library) :-
    ismsa_libraryInHome(Home, Library),
    ismsa_libraryPartInstalled(Home, Template) : ismsa_libraryPart(Home, Library, Template, _, _).

ismsa_libraryPartlyAdded(Home, Library) :-
    ismsa_libraryInHome(Home, Library),
    not ismsa_libraryAdded(Home, Library),
    ismsa_libraryPart(Home, Library, Template, _, _),
    ismsa_libraryPartInstalled(Home, Template).

% The choice is complete when every question is answered and every required library is added.

ismsa_libraryChoiceComplete(Home) :-
    ismsa_homeQuestionsAnswered(Home),
    ismsa_libraryAdded(Home, Library) : ismsa_libraryRequired(Home, Library).
