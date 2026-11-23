%
% Tests for the framework libraries of other modules (ismsa_frameworkLibrary/3 in
% ismsa/calculations/libraryChoice)
%
% Run with: cyberismo calc run tests/framework-library.lp
% The test passes when the result is empty.
%
% This file declares a library as another module would, for example eucra for the CRA. It is a
% separate file, because the library changes the library choice of the test homes of
% tests/home-libraries.lp.
%

ismsa_frameworkLibrary("cra", "the test CRA library", "Test CRA library").
ismsa_libraryRank("the test CRA library", 9).
ismsa_libraryCoverage("the test CRA library", "The test requirements.", "Nothing else.").

% The test homes of the library tests:
% L1 answers "no" to the CRA, L4 and L5 answer "yes", and L6 has no answers.

ismsa_fwTestHome("L1", ismsa_g04dsanv).
ismsa_fwTestHome("L4", ismsa_l866q2o1).
ismsa_fwTestHome("L5", ismsa_qu1v00mj).
ismsa_fwTestHome("L6", ismsa_ny30dov7).

% ismsa_fwExpect(Home, State, Reason)

ismsa_fwExpect("L1", "notNeeded", "The CRA does not apply.").
ismsa_fwExpect("L4", "required", "the CRA applies").
ismsa_fwExpect("L5", "required", "the CRA applies").
ismsa_fwExpect("L6", "undecided", "").

% ismsa_fwState(Home, State, Reason)

ismsa_fwState(Id, "required", Reason) :-
    ismsa_fwTestHome(Id, Home),
    ismsa_libraryRequirement(Home, "the test CRA library", Reason).

ismsa_fwState(Id, "notNeeded", Reason) :-
    ismsa_fwTestHome(Id, Home),
    ismsa_libraryNotNeeded(Home, "the test CRA library", Reason).

ismsa_fwState(Id, "undecided", "") :-
    ismsa_fwTestHome(Id, Home),
    ismsa_libraryUndecided(Home, "the test CRA library").

result(("FAIL test home not found", Id)) :-
    ismsa_fwTestHome(Id, Home),
    not base_projectCardType(Home, "ismsa/cardTypes/moduleHome").

result(("FAIL framework library state", Id, State, Reason)) :-
    ismsa_fwExpect(Id, State, Reason),
    not ismsa_fwState(Id, State, Reason).

result(("FAIL unexpected framework library state", Id, State, Reason)) :-
    ismsa_fwState(Id, State, Reason),
    not ismsa_fwExpect(Id, State, Reason).

% The framework library is a choice library with its title

result(("FAIL framework library is not a choice library")) :-
    not ismsa_choiceLibrary("the test CRA library", "Test CRA library").

% A required library that is not in the home keeps the library choice open

result(("FAIL library choice complete without the framework library")) :-
    ismsa_libraryChoiceComplete(ismsa_l866q2o1).

% The framework library adds nothing to the NIS2 question

result(("FAIL framework library added by another question", Question)) :-
    ismsa_questionAdds(Question, "the test CRA library", _),
    Question != "cra".
