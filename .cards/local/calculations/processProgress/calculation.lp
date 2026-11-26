field(X, "base/fieldTypes/progress", (100 * Ok + 60 * Reviewed) / (Total-Archived)) :-
    field(X, "ismsa/fieldTypes/progress", "process-progress"),
    Total = #count {
        card(Process):
        base_projectCardType(Process, "base/cardTypes/controlledDocument"),
        ancestor(Process, X),
        not hiddenInTreeView(Process)
    },
    Total > 0,
    Ok = #count {
        card(Process):
        base_projectCardType(Process, "base/cardTypes/controlledDocument"),
        ancestor(Process, X),
        field(Process, "workflowState", "Approved"),
        not hiddenInTreeView(Process)
    },
    Reviewed = #count {
        card(Process):
        base_projectCardType(Process, "base/cardTypes/controlledDocument"),
        ancestor(Process, X),
        field(Process, "workflowState", "Reviewed"),
        not hiddenInTreeView(Process)
    }, 
    Archived = #count {
        card(Process):
        base_projectCardType(Process, "base/cardTypes/controlledDocument"),
        ancestor(Process, X),
        field(Process, "workflowState", "Archived"),
        not hiddenInTreeView(Process)
    }.

    % A register of a new home with no content shows no percentage (E10 P2, E13 B10).
    field(X, "base/fieldTypes/progress", 0) :-
    field(X, "ismsa/fieldTypes/progress", "process-progress"),
    not ismsa_inNewHome(X),
    Total = #count {
        card(Process):
        base_projectCardType(Process, "base/cardTypes/controlledDocument"),
        ancestor(Process, X),
        not hiddenInTreeView(Process)
    },
    Archived = #count {
        card(Process):
        base_projectCardType(Process, "base/cardTypes/controlledDocument"),
        ancestor(Process, X),
        field(Process, "workflowState", "Archived"),
        not hiddenInTreeView(Process)
    },
    (Total - Archived) = 0.
