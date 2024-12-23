cismsAsset(Card) :-
    field(Card, "cardType", "ismsa/cardTypes/asset").

cismsAsset(Card) :-
    field(Card, "cardType", "ismsa/cardTypes/assetInformationSystem").

cismsAsset(Card) :-
    field(Card, "cardType", "ismsa/cardTypes/assetData").

cismsAsset(Card) :-
    field(Card, "cardType", "ismsa/cardTypes/assetDevice").

cismsAsset(Card) :-
    field(Card, "cardType", "ismsa/cardTypes/assetSupplier").

% Criticality and risk evaluation need are mandatory for all assets
policyCheckFailure(Asset, "ISMS", "'Criticality for operations' is a required field", "'Criticality for operations' has not been defined for this asset. Set this field.") :-
    cismsAsset(Asset),
    not field(Asset, "ismsa/fieldTypes/assetCriticalityForOperations", _).

policyCheckFailure(Asset, "ISMS", "'Risk evaluation needed' is a required field", "'Risk evaluation needed' has not been defined for this asset. Set this field.") :-
    cismsAsset(Asset),
    not field(Asset, "ismsa/fieldTypes/assetRiskEvaluationNeeded", _).


% Access control, backup(s), security updates and logging & monitoring are mandatory for information systems
policyCheckFailure(Asset, "ISMS", "'Access control' is a required field", "'Access control' has not been defined for this asset. Set this field.") :-
    field(Asset, "cardType", "ismsa/cardTypes/assetInformationSystem"),
    not field(Asset, "ismsa/fieldTypes/assetAccessControl", _).

policyCheckFailure(Asset, "ISMS", "'Security updates' is a required field", "'Security updates' has not been defined for this asset. Set this field.") :-
    field(Asset, "cardType", "ismsa/cardTypes/assetInformationSystem"),
    not field(Asset, "ismsa/fieldTypes/assetUpdates", _).

policyCheckFailure(Asset, "ISMS", "'Backup(s)' is a required field", "'Backup(s)' has not been defined for this asset. Set this field.") :-
    field(Asset, "cardType", "ismsa/cardTypes/assetInformationSystem"),
    not field(Asset, "ismsa/fieldTypes/assetBackups", _).

policyCheckFailure(Asset, "ISMS", "'Logging and monitoring' is a required field", "'Logging and monitoring' has not been defined for this asset. Set this field.") :-
    field(Asset, "cardType", "ismsa/cardTypes/assetInformationSystem"),
    not field(Asset, "ismsa/fieldTypes/assetLoggingAndMonitoring", _).

% Integrity, availability and personal data classification and location are mandatory for data assets
policyCheckFailure(Asset, "ISMS", "'Integrity' is a required field", "'Integrity' has not been defined for this asset. Set this field.") :-
    field(Asset, "cardType", "ismsa/cardTypes/assetData"),
    not field(Asset, "ismsa/fieldTypes/assetIntegrity", _).

policyCheckFailure(Asset, "ISMS", "'Availability' is a required field", "'Availability' has not been defined for this asset. Set this field.") :-
    field(Asset, "cardType", "ismsa/cardTypes/assetData"),
    not field(Asset, "ismsa/fieldTypes/assetAvailability", _).

policyCheckFailure(Asset, "ISMS", "'Contains personal information' is a required field", "'Contains personal information' has not been defined for this asset. Set this field.") :-
    field(Asset, "cardType", "ismsa/cardTypes/assetData"),
    not field(Asset, "ismsa/fieldTypes/assetPersonalInformation", _).

policyCheckFailure(Asset, "ISMS", "'Location' is a required field", "'Location' has not been defined for this asset. Set this field.") :-
    field(Asset, "cardType", "ismsa/cardTypes/assetData"),
    not field(Asset, "ismsa/fieldTypes/assetLocation", _).

% Access control, backup(s) and security updates are mandatory for devices
policyCheckFailure(Asset, "ISMS", "'Access control' is a required field", "'Access control' has not been defined for this asset. Set this field.") :-
    field(Asset, "cardType", "ismsa/cardTypes/assetDevice"),
    not field(Asset, "ismsa/fieldTypes/assetAccessControl", _).

policyCheckFailure(Asset, "ISMS", "'Backup(s)' is a required field", "'Backup(s)' has not been defined for this asset. Set this field.") :-
    field(Asset, "cardType", "ismsa/cardTypes/assetDevice"),
    not field(Asset, "ismsa/fieldTypes/assetBackups", _).

policyCheckFailure(Asset, "ISMS", "'Security updates' is a required field", "'Security updates' has not been defined for this asset. Set this field.") :-
    field(Asset, "cardType", "ismsa/cardTypes/assetDevice"),
    not field(Asset, "ismsa/fieldTypes/assetUpdates", _).

% Provided service and contact details are mandatory for suppliers
policyCheckFailure(Asset, "ISMS", "'Provided services' is a required field", "'Provided services' has not been defined for this asset. Set this field.") :-
    field(Asset, "cardType", "ismsa/cardTypes/assetSupplier"),
    not field(Asset, "ismsa/fieldTypes/assetProvidedServices", _).

policyCheckFailure(Asset, "ISMS", "'Contact details' is a required field", "'Contact details' has not been defined for this asset. Set this field.") :-
    field(Asset, "cardType", "ismsa/cardTypes/assetSupplier"),
    not field(Asset, "ismsa/fieldTypes/assetContactDetails", _).