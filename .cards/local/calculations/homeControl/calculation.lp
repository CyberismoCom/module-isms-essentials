transitionDenied(Card, "Content ready", "Fix policy failures before marking content ready" ):-
    base_projectCardType(Card, "ismsa/cardTypes/moduleHome"),
    base_policyCheckFailure(Card, _, _, _).

transitionDenied(Card, "Content ready", "Fix policy failures in child cards before marking content ready" ):-
    base_projectCardType(Card, "ismsa/cardTypes/moduleHome"),
    parent(SubCard,Card),
    base_policyCheckFailure(SubCard, _, _, _).

ismsa_closestHome(Card, Home) :-
    base_projectCardType(Home, "ismsa/cardTypes/moduleHome"),
    ancestor(Card, Home),
    not base_projectCardType(MiddleAncestor, "ismsa/cardTypes/moduleHome") :
    ancestor(MiddleAncestor, Home),
    ancestor(Card, MiddleAncestor).


%
% The home is ready only when the user has filled in the home card (2026-11-24).
% Only for homes made from ismsa/templates/moduleHome2, which have the identifier "ismsa_home".
% The old home template has no such fields on its card.
%

ismsa_newHome(Home) :-
    base_projectCardType(Home, "ismsa/cardTypes/moduleHome"),
    field(Home, "base/fieldTypes/identifier", "ismsa_home").

transitionDenied(Home, "Content ready", "Write the scope of the home in the title") :-
    ismsa_newHome(Home),
    field(Home, "title", "ISMS home for (scope)").

transitionDenied(Home, "Content ready", "Write the scope description") :-
    ismsa_newHome(Home),
    not field(Home, "ismsa/fieldTypes/homeScopeDescription", _).

transitionDenied(Home, "Content ready", "Set the owner of the home") :-
    ismsa_newHome(Home),
    not field(Home, "base/fieldTypes/owner", _).

transitionDenied(Home, "Content ready", "Answer all questions in the section Libraries") :-
    ismsa_newHome(Home),
    not ismsa_homeQuestionsAnswered(Home).
