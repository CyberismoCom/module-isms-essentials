transitionDenied(Card, "Content ready", "Fix policy failures for this register before marking content ready" ):-
    field(Card, "cardType", "ismsa/cardTypes/register"),
    policyCheckFailure(Card, _, _, _).

transitionDenied(Card, "Content ready", "Fix policy failures in ancestor cards before marking content ready" ):-
    field(Card, "cardType", "ismsa/cardTypes/register"),
    ancestor(SubCard, Card),
    policyCheckFailure(SubCard, _, _, _).