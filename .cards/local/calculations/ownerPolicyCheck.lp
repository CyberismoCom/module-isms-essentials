
policyCheckFailure(Card, "ISMS", "Owner is a required field", "Owner has not been defined for this card. Set the owner field.") :-
    field(Card, "cardType", _),
    not field(Card, "base/fieldTypes/owner", _).

policyCheckFailure(Card, "ISMS", "Classification is a required field", "Classification has not been defined for this card. Set the Classification field.") :-
    field(Card, "cardType", _),
    not field(Card, "base/fieldTypes/informationClassification", _).