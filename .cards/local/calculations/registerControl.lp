% Copyright © Cyberismo Ltd and contributors 2025
%
% License: https://github.com/CyberismoCom/module-isms-essentials/blob/main/LICENSE
% The use of the Cyberismo trademark: https://cyberismo.com/trademark-policy/
% This content is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
% FITNESS FOR A PARTICULAR PURPOSE.

transitionDenied(Card, "Content ready", "Fix policy failures for this register before marking content ready" ):-
    field(Card, "cardType", "ismsa/cardTypes/register"),
    policyCheckFailure(Card, _, _, _).

transitionDenied(Card, "Content ready", "Register should contain at least one item before marking content ready" ):-
    field(Card, "cardType", "ismsa/cardTypes/register"),
    Total = #count{
        card(SubCard):
        parent(SubCard,Card),
        not hiddenInTreeView(SubCard)
        },
    Total = 0.

transitionDenied(Card, "Content ready", "Fix policy failures in child cards before marking content ready" ):-
    field(Card, "cardType", "ismsa/cardTypes/register"),
    parent(SubCard,Card),
    policyCheckFailure(SubCard, _, _, _).