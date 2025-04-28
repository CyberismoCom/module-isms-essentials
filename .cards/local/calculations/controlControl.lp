% Copyright © Cyberismo Ltd and contributors 2025
%
% License: https://github.com/CyberismoCom/module-isms-essentials/blob/main/LICENSE
% The use of the Cyberismo trademark: https://cyberismo.com/trademark-policy/
% This content is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
% FITNESS FOR A PARTICULAR PURPOSE.

transitionDenied(Card, "Not applicable", "Fill justification for not applying the control" ):-
    field(Card, "cardType", "ismsa/cardTypes/control"),
    not field(Card, "ismsa/fieldTypes/controlJustification", _).

transitionDenied(Card, "Not applicable", "Set Status field to N/A" ):-
    field(Card, "cardType", "ismsa/cardTypes/control"),
    not field(Card, "ismsa/fieldTypes/controlStatus","notApplicable").

transitionDenied(Card, "Complete plan", "Fix policy failures before completing plan" ):-
    field(Card, "cardType", "ismsa/cardTypes/control"),
    policyCheckFailure(Card, _, _, _).

editingContentDenied(Card, "You can't edit closed controls" ):-
    field(Card, "cardType", "ismsa/cardTypes/control"),
    field(Card, "workflowState", "Closed as not applicable").

transitionDenied(Card, "Not applicable", "Fill justification for not applying the control" ):-
    field(Card, "cardType", "ismsa/cardTypes/control"),
    not field(Card, "ismsa/fieldTypes/controlJustification", _).

transitionDenied(Card, "Ready for verification", "Set Status field to Implemented" ):-
    field(Card, "cardType", "ismsa/cardTypes/control"),
    not field(Card, "ismsa/fieldTypes/controlStatus","implemented").

transitionDenied(Card, "Ready for verification", "Fill in Justification field" ):-
    field(Card, "cardType", "ismsa/cardTypes/control"),
    not field(Card, "ismsa/fieldTypes/controlJustification",_).

transitionDenied(Card, "Ready for verification", "Fill in 'Implementation summary' field" ):-
    field(Card, "cardType", "ismsa/cardTypes/control"),
    not field(Card, "ismsa/fieldTypes/controlSummary",_).
