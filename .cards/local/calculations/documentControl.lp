transitionDenied(Card, "Review as OK", "Fix policy failures before reviewing as OK" ):-
    field(Card, "cardType", "base/cardTypes/controlledDocument"),
    policyCheckFailure(Card, _, _, _).

transitionDenied(Card, "Approve", "Fill in approver before approving" ):-
    field(Card, "cardType", "base/cardTypes/controlledDocument"),
    not field(Card, "base/fieldTypes/approver", _).

transitionDenied(Card, "Approve", "Fill in approval date before approving" ):-
    field(Card, "cardType", "base/cardTypes/controlledDocument"),
    not field(Card, "base/fieldTypes/approvalDate", _).

editingContentDenied(Card, "You can't edit approved documents" ):-
    field(Card, "cardType", "base/cardTypes/controlledDocument"),
    field(Card, "workflowState", "Approved").
