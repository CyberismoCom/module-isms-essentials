% Copyright © Cyberismo Ltd and contributors 2025
%
% License: https://github.com/CyberismoCom/module-isms-essentials/blob/main/LICENSE
% The use of the Cyberismo trademark: https://cyberismo.com/trademark-policy/
% This content is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
% FITNESS FOR A PARTICULAR PURPOSE.

policyCheckFailure(Card, "ISMS", "Due date is a required field", "Due date has not been defined for this target. Set this field..") :-
    field(Card, "cardType", "ismsa/cardTypes/securityTarget"),
    not field(Card, "base/fieldTypes/dueDate", _).

transitionDenied(Card, "Approve target", "Fix policy failures before approving target" ):-
    field(Card, "cardType", "ismsa/cardTypes/securityTarget"),
    policyCheckFailure(Card, _, _, _).