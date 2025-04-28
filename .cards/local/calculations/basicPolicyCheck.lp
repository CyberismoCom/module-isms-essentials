% Copyright © Cyberismo Ltd and contributors 2025
%
% License: https://github.com/CyberismoCom/module-isms-essentials/blob/main/LICENSE
% The use of the Cyberismo trademark: https://cyberismo.com/trademark-policy/
% This content is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
% FITNESS FOR A PARTICULAR PURPOSE.

policyCheckFailure(Card, "ISMS", "Owner is a required field", "Owner has not been defined for this card. Set the owner field.") :-
    card(Card),
    field(Card, "cardType", CardType),
    customField(CardType, "base/fieldTypes/owner"),
    CardType != "base/cardTypes/controlledDocument",
    not field(Card, "workflowStateCategory", "initial"),
    not field(Card, "base/fieldTypes/owner", _).

policyCheckFailure(Card, "ISMS", "Classification is a required field", "Classification has not been defined for this card. Set the Classification field.") :-
    card(Card),
    field(Card, "cardType", CardType),
    customField(CardType, "base/fieldTypes/informationClassification"),
    not field(Card, "workflowStateCategory", "initial"),
    not field(Card, "base/fieldTypes/informationClassification", _).