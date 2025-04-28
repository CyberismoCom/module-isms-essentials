% Copyright © Cyberismo Ltd and contributors 2025
%
% License: https://github.com/CyberismoCom/module-isms-essentials/blob/main/LICENSE
% The use of the Cyberismo trademark: https://cyberismo.com/trademark-policy/
% This content is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
% FITNESS FOR A PARTICULAR PURPOSE.

field(X, "base/fieldTypes/progress", 100 * Ok / Total) :-
    field(X, "ismsa/fieldTypes/progress", "asset-progress"),
    Total = #count {
        card(Register):
        field(Register, "cardType", "ismsa/cardTypes/register"),
        ancestor(Register, X),
        not hiddenInTreeView(Register)
    },
    Total > 0,
    Ok = #count {
        card(Register):
        field(Register, "cardType", "ismsa/cardTypes/register"),
        ancestor(Register, X),
        field(Register, "workflowState", "Ready"),
        not hiddenInTreeView(Register)
    }.