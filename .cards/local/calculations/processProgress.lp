field(X, "base/fieldTypes/progress", 100 * Ok / Total) :-
    label(X, "process-progress"),
    Total = #count {
        card(Process):
        field(Process, "cardType", "ismsa/cardTypes/controlledDocument"),
        ancestor(Process, X),
        not hiddenInTreeView(Process)
    },
    Total > 0,
    Ok = #count {
        card(Process):
        field(Process, "cardType", "ismsa/cardTypes/controlledDocument"),
        ancestor(Process, X),
        field(Process, "workflowState", "Approved"),
        not hiddenInTreeView(Process)
    }.