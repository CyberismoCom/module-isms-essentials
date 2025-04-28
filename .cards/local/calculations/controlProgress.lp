% Copyright © Cyberismo Ltd and contributors 2025
%
% License: https://github.com/CyberismoCom/module-isms-essentials/blob/main/LICENSE
% The use of the Cyberismo trademark: https://cyberismo.com/trademark-policy/
% This content is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
% FITNESS FOR A PARTICULAR PURPOSE.

field(X, "base/fieldTypes/progress", (100 * (Ok + NotRequired) + 95 * ToBeVerified + 50 * Adopting + 25 * Planned )/ Total) :-
    field(X, "ismsa/fieldTypes/progress", "control-progress"),
    Total = #count {
        card(Control):
        field(Control, "cardType", "ismsa/cardTypes/control"),
        ancestor(Control, X),
        not hiddenInTreeView(Control)
    },
    Total > 0,
    Ok = #count {
        card(Control):
        field(Control, "cardType", "ismsa/cardTypes/control"),
        ancestor(Control, X),
        field(Control, "workflowState", "Closed as verified"),
        not hiddenInTreeView(Control)
    },
    Planned = #count {
        card(Control):
        field(Control, "cardType", "ismsa/cardTypes/control"),
        ancestor(Control, X),
        field(Control, "workflowState", "Planned"),
        not hiddenInTreeView(Control)
    },
    Adopting = #count {
        card(Control):
        field(Control, "cardType", "ismsa/cardTypes/control"),
        ancestor(Control, X),
        field(Control, "workflowState", "Adopting"),
        not hiddenInTreeView(Control)
    },
    ToBeVerified = #count {
        card(Control):
        field(Control, "cardType", "ismsa/cardTypes/control"),
        ancestor(Control, X),
        field(Control, "workflowState", "To be verified"),
        not hiddenInTreeView(Control)
    },
    NotRequired = #count {
        card(Control):
        field(Control, "cardType", "ismsa/cardTypes/control"),
        ancestor(Control, X),
        field(Control, "workflowState", "Closed as not applicable"),
        not hiddenInTreeView(Control)
    }.

    field(X, "base/fieldTypes/progress", 0) :-
    field(X, "ismsa/fieldTypes/progress", "control-progress"),
    Total = #count {
        card(Control):
        field(Control, "cardType", "ismsa/cardTypes/control"),
        ancestor(Control, X),
        not hiddenInTreeView(Control)
    },
    Total = 0.