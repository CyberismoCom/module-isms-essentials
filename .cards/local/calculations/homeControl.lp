% Copyright © Cyberismo Ltd and contributors 2025
%
% License: https://github.com/CyberismoCom/module-isms-essentials/blob/main/LICENSE
% The use of the Cyberismo trademark: https://cyberismo.com/trademark-policy/
% This content is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
% FITNESS FOR A PARTICULAR PURPOSE.

transitionDenied(Card, "Content ready", "Fix policy failures before marking content ready" ):-
    field(Card, "cardType", "ismsa/cardTypes/moduleHome"),
    policyCheckFailure(Card, _, _, _).

transitionDenied(Card, "Content ready", "Fix policy failures in child cards before marking content ready" ):-
    field(Card, "cardType", "ismsa/cardTypes/moduleHome"),
    parent(SubCard,Card),
    policyCheckFailure(SubCard, _, _, _).

ismsa_closestHome(Card, Home) :-
    field(Home, "cardType", "ismsa/cardTypes/moduleHome"),
    ancestor(Card, Home),
    not field(MiddleAncestor, "cardType", "ismsa/cardTypes/moduleHome") :
    ancestor(MiddleAncestor, Home),
    ancestor(Card, MiddleAncestor).

