ismsTask(Task) :-
    field(Task, "cardType", "base/cardTypes/task").

ismsTask(Task) :-
    field(Task, "cardType", "base/cardTypes/recurringTask").

field(X, "base/fieldTypes/progress", ((100 * (Ok + NotRequired) + 20 * InProgress) + (100 * OkTargets + 20 * InProgressTargets)) / (Total + TotalTargets)) :-
    label(X, "task-progress"),
    Total = #count {
        card(Task):
        ismsTask(Task),
        ancestor(Task, X),
        not hiddenInTreeView(Task)
    },
    TotalTargets = #count {
        card(Target):
        field(Target, "cardType", "ismsa/cardTypes/securityTarget"),
        ancestor(Target, X),
        not hiddenInTreeView(Target)
    },
    Total + TotalTargets > 0,
    Ok = #count {
        card(Task):
        ismsTask(Task),
        ancestor(Task, X),
        field(Task, "workflowState", "Closed as done"),
        not hiddenInTreeView(Task)
    },
    InProgress = #count {
        card(Task):
        ismsTask(Task),
        ancestor(Task, X),
        field(Task, "workflowState", "In progress"),
        not hiddenInTreeView(Task)
    },
    NotRequired = #count {
        card(Task):
        ismsTask(Task),
        ancestor(Task, X),
        field(Task, "workflowState", "Closed as not applicable"),
        not hiddenInTreeView(Task)
    },
    OkTargets = #count {
        card(Target):
        field(Target, "cardType", "ismsa/cardTypes/securityTarget"),
        ancestor(Target, X),
        field(Target, "workflowState", "Closed as done"),
        not hiddenInTreeView(Target)
    },
    InProgressTargets = #count {
        card(Target):
        field(Target, "cardType", "ismsa/cardTypes/securityTarget"),
        ancestor(Target, X),
        field(Target, "workflowState", "Executing"),
        not hiddenInTreeView(Target)
    }.

field(X, "base/fieldTypes/progress", 0) :-
    label(X, "task-progress"),
    Total = #count {
        card(Task):
        ismsTask(Task),
        ancestor(Task, X),
        not hiddenInTreeView(Task)
    },
    TotalTargets = #count {
        card(Target):
        field(Target, "cardType", "ismsa/cardTypes/securityTarget"),
        ancestor(Target, X),
        not hiddenInTreeView(Target)
    },
    Total + TotalTargets = 0.