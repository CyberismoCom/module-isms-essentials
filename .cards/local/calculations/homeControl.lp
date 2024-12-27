transitionDenied(Card, "Content ready", "Fix policy failures before marking content ready" ):-
    field(Card, "cardType", "ismsa/cardTypes/moduleHome"),
    policyCheckFailure(Card, _, _, _).

transitionDenied(Card, "Content ready", "Fix policy failures in child cards before marking content ready" ):-
    field(Card, "cardType", "ismsa/cardTypes/moduleHome"),
    parent(SubCard,Card),
    policyCheckFailure(SubCard, _, _, _).