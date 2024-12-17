field(X, "base/fieldTypes/progress", (100 * Ok + 60 * Reviewed) / Total) :-
    label(X, "process-progress"),
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
    Total > 0,
    Reviewed = #count {
        card(Process):
        field(Process, "cardType", "base/cardTypes/controlledDocument"),
        ancestor(Process, X),
        field(Process, "workflowState", "Reviewed"),
        not hiddenInTreeView(Process)
    }.
