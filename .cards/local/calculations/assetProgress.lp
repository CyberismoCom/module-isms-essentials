field(X, "base/fieldTypes/progress", 100 * Ok / Total) :-
    label(X, "asset-progress"),
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
        field(Register, "workflowState", "Approved"),
        not hiddenInTreeView(Register)
    }.