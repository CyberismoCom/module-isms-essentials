%
% Choosing the libraries of an ISMS home
%
% The home card asks six yes or no questions. The answers are hidden fields of the home card
% type, edited with field macros in the section "Libraries" (ismsa/reports/homeLibrarySection).
% These rules decide which libraries the home needs, and why the other libraries are not needed.
%
% A "yes" always adds and a "no" always removes (E10-D11, 2026-11-23):
%
% - The four questions about the work of the home each add their libraries.
% - The two questions about the frameworks (the EU Cyber Resilience Act and NIS2) add only the
%   requirement checklist of the framework. They do not add other libraries. They recommend
%   answers to the questions about the work, and the user decides. When a recommended library
%   is left out, the requirements of the framework show the gap.
% - The checklist of a framework can come from another module. That module declares
%   ismsa_frameworkLibrary/3 (see below), for example eucra for the CRA.
%

% ismsa_homeQuestion(Question, Field)

ismsa_homeQuestion("centralWork", "ismsa/fieldTypes/homeCentralWork").
ismsa_homeQuestion("cra", "ismsa/fieldTypes/homeCra").
ismsa_homeQuestion("fullIsms", "ismsa/fieldTypes/homeFullIsms").
ismsa_homeQuestion("assetRisks", "ismsa/fieldTypes/homeAssetRisks").
ismsa_homeQuestion("ownServices", "ismsa/fieldTypes/homeOwnServices").
ismsa_homeQuestion("nis2", "ismsa/fieldTypes/homeNis2").

ismsa_homeAnswer(Home, Question, Answer) :-
    base_projectCardType(Home, "ismsa/cardTypes/moduleHome"),
    ismsa_homeQuestion(Question, Field),
    field(Home, Field, Answer).

% A question is included in another question when a "yes" to the other question already adds
% its libraries. The home card shows the text in place of the answer, and the question needs no
% answer. A "yes" to the ISMS question adds the asset and risk management library.
%
% ismsa_questionIncluded(Home, Question, Text)

ismsa_questionIncluded(Home, "assetRisks", "Included in the ISMS") :-
    ismsa_homeAnswer(Home, "fullIsms", "yes").

ismsa_homeQuestionDone(Home, Question) :-
    ismsa_homeAnswer(Home, Question, _).

ismsa_homeQuestionDone(Home, Question) :-
    ismsa_questionIncluded(Home, Question, _).

ismsa_homeQuestionsAnswered(Home) :-
    base_projectCardType(Home, "ismsa/cardTypes/moduleHome"),
    ismsa_homeQuestionDone(Home, Question) : ismsa_homeQuestion(Question, _).

% The libraries that the questions decide, with their titles. Libraries of other modules are
% shown separately on the home card, without questions.

ismsa_choiceLibrary("the security response and compliance basics library", "Security response and compliance basics").
ismsa_choiceLibrary("the information security management basics library", "Information security management basics").
ismsa_choiceLibrary("the asset and risk management library", "Asset and risk management").
ismsa_choiceLibrary("the security operations basics library", "Security operations basics").
ismsa_choiceLibrary("the NIS2 basics library", "NIS2 basics").

%
% What a "yes" adds
%
% ismsa_questionAdds(Question, Library, Reason): a "yes" to the question adds the library. The
% reason completes the sentence "Needed because ..." on the home card.
%

ismsa_questionAdds("centralWork", "the security response and compliance basics library",
        "you do the central security work in this home").
ismsa_questionAdds("fullIsms", "the information security management basics library",
        "you want an ISMS in this home").
ismsa_questionAdds("fullIsms", "the asset and risk management library",
        "you want an ISMS in this home").
ismsa_questionAdds("assetRisks", "the asset and risk management library",
        "you manage the risks of your assets in this home").
ismsa_questionAdds("ownServices", "the security operations basics library",
        "you manage the security of your own IT or cloud services in this home").
ismsa_questionAdds("nis2", "the NIS2 basics library", "you follow NIS2").

%
% Framework libraries of other modules
%
% ismsa_frameworkLibrary(Framework, Library, Title): a "yes" to the framework question adds the
% library of another module. Framework is "cra" or "nis2". Library is the library name in the
% ismsa_installableExtension facts of the module, and Title is the name on the home card. The
% module also declares ismsa_libraryRank/2 and ismsa_libraryCoverage/3 for the library.
% Example, from eucra:
%
% ismsa_frameworkLibrary("cra", "the CRA programme library", "CRA programme").
%
% ismsa_frameworkApplies(Framework, Reason, NotNeededReason)

ismsa_frameworkApplies("cra", "the CRA applies", "The CRA does not apply.").
ismsa_frameworkApplies("nis2", "you follow NIS2", "You do not follow NIS2.").

ismsa_choiceLibrary(Library, Title) :-
    ismsa_frameworkLibrary(_, Library, Title).

ismsa_questionAdds(Framework, Library, Reason) :-
    ismsa_frameworkLibrary(Framework, Library, _),
    ismsa_frameworkApplies(Framework, Reason, _).

% ismsa_libraryRequirement(Home, Library, Reason)

ismsa_libraryRequirement(Home, Library, Reason) :-
    ismsa_homeAnswer(Home, Question, "yes"),
    ismsa_questionAdds(Question, Library, Reason).

ismsa_libraryRequired(Home, Library) :-
    ismsa_libraryRequirement(Home, Library, _).

%
% Recommendations of the frameworks
%
% ismsa_frameworkRecommends(Framework, Question, Reason): when the framework applies, a "yes" to
% the question is recommended. The CRA requirements of the organisation come with the CRA
% programme library of eucra (E9), through ismsa_frameworkLibrary/3.
%

ismsa_frameworkRecommends("cra", "centralWork", "the CRA requires a way to receive vulnerability reports and to notify about vulnerabilities and incidents").
ismsa_frameworkRecommends("nis2", "centralWork", "NIS2 requires incident reporting and contact with authorities").
ismsa_frameworkRecommends("nis2", "fullIsms", "NIS2 requires management approval, policies, and training").
ismsa_frameworkRecommends("nis2", "assetRisks", "NIS2 requires risk analysis").
ismsa_frameworkRecommends("nis2", "ownServices", "NIS2 requires basic security practices, continuity, and access control").

ismsa_questionRecommended(Home, Question, Reason) :-
    ismsa_homeAnswer(Home, Framework, "yes"),
    ismsa_frameworkRecommends(Framework, Question, Reason),
    not ismsa_questionIncluded(Home, Question, _).

% A "no" against a recommendation. The home card shows it, and the requirements show the gap.

ismsa_answerAgainstRecommendation(Home, Question) :-
    ismsa_questionRecommended(Home, Question, _),
    ismsa_homeAnswer(Home, Question, "no").

%
% Libraries that are not needed, with the reason
%
% ismsa_libraryNotNeeded(Home, Library, Reason) is derived only when every question that adds
% the library is answered "no". The reasons are in ismsa_libraryNotNeededReason/3.
%

ismsa_libraryNotNeededReason(Home, "the security response and compliance basics library",
        "You do the central security work outside this home.") :-
    ismsa_homeAnswer(Home, "centralWork", "no").

ismsa_libraryNotNeededReason(Home, "the information security management basics library",
        "You do not want an ISMS in this home.") :-
    ismsa_homeAnswer(Home, "fullIsms", "no").

ismsa_libraryNotNeededReason(Home, "the asset and risk management library",
        "You do not want an ISMS in this home, and you do not manage the risks of your assets here.") :-
    ismsa_homeAnswer(Home, "fullIsms", "no"),
    ismsa_homeAnswer(Home, "assetRisks", "no").

ismsa_libraryNotNeededReason(Home, "the security operations basics library",
        "You do not manage the security of your own IT or cloud services in this home.") :-
    ismsa_homeAnswer(Home, "ownServices", "no").

ismsa_libraryNotNeededReason(Home, "the NIS2 basics library", "You do not follow NIS2.") :-
    ismsa_homeAnswer(Home, "nis2", "no").

ismsa_libraryNotNeededReason(Home, Library, Reason) :-
    ismsa_frameworkLibrary(Framework, Library, _),
    ismsa_frameworkApplies(Framework, _, Reason),
    ismsa_homeAnswer(Home, Framework, "no").

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
