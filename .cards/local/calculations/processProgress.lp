% Copyright © Cyberismo Ltd and contributors 2025
%
% License: https://github.com/CyberismoCom/module-isms-essentials/blob/main/LICENSE
% The use of the Cyberismo trademark: https://cyberismo.com/trademark-policy/
% This content is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
% FITNESS FOR A PARTICULAR PURPOSE.

field(X, "base/fieldTypes/progress", (100 * Ok + 60 * Reviewed) / (Total-Archived)) :-
    field(X, "ismsa/fieldTypes/progress", "process-progress"),
    Total = #count {
        card(Process):
        field(Process, "cardType", "base/cardTypes/controlledDocument"),
        ancestor(Process, X),
        not hiddenInTreeView(Process)
    },
    Total > 0,
    Ok = #count {
        card(Process):
        field(Process, "cardType", "base/cardTypes/controlledDocument"),
        ancestor(Process, X),
        field(Process, "workflowState", "Approved"),
        not hiddenInTreeView(Process)
    },
    Reviewed = #count {
        card(Process):
        field(Process, "cardType", "base/cardTypes/controlledDocument"),
        ancestor(Process, X),
        field(Process, "workflowState", "Reviewed"),
        not hiddenInTreeView(Process)
    },
    Archived = #count {
        card(Process):
        field(Process, "cardType", "base/cardTypes/controlledDocument"),
        ancestor(Process, X),
        field(Process, "workflowState", "Archived"),
        not hiddenInTreeView(Process)
    }.

    field(X, "base/fieldTypes/progress", 0) :-
    field(X, "ismsa/fieldTypes/progress", "process-progress"),
    Total = #count {
        card(Process):
        field(Process, "cardType", "base/cardTypes/controlledDocument"),
        ancestor(Process, X),
        not hiddenInTreeView(Process)
    },
    Archived = #count {
        card(Process):
        field(Process, "cardType", "base/cardTypes/controlledDocument"),
        ancestor(Process, X),
        field(Process, "workflowState", "Archived"),
        not hiddenInTreeView(Process)
    },
    (Total - Archived) = 0.
