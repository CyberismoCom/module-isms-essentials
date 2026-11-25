%
% AI assets (2026-11-25)
%
% An AI asset is an AI tool or service that the organisation uses, or an AI feature in another
% service. The card type moved from ismsb/cardTypes/aiAsset to ismsa/cardTypes/aiAsset, so that
% the AI use basics library of the ISMS home works without ismsb. The enum values of the fields
% are the same as in ismsb.
%
% ismsa_aiAsset(Card): the card is an AI asset. Another module can declare this for its own
% card type, for example ismsb for the deprecated ismsb/cardTypes/aiAsset. An AI asset is also an
% asset (ismsa_asset/2 in ismsa/calculations/assetControl), so the checks of all assets apply.
%

ismsa_aiAsset(Card) :-
    base_projectCardType(Card, "ismsa/cardTypes/aiAsset").

% The fields that the assessment of an AI asset needs, from the AI policy. The AI system role
% and the AI impact assessment are optional: the AI use basics library covers the use of AI,
% so the organisation is the deployer.
%
% ismsa_aiAssessmentField(Field, CheckTitle, CheckText)

ismsa_aiAssessmentField("ismsa/fieldTypes/assetAiAllowedInformation",
    "'Information allowed' is a required field",
    "'Information allowed' has not been defined for this AI asset. Set this field.").
ismsa_aiAssessmentField("ismsa/fieldTypes/assetAiTrainingDataUsage",
    "'Training data use' is a required field",
    "'Training data use' has not been defined for this AI asset. Set this field.").
ismsa_aiAssessmentField("ismsa/fieldTypes/assetAiRiskCategory",
    "'EU AI Act risk category' is a required field",
    "'EU AI Act risk category' has not been defined for this AI asset. Set this field.").
ismsa_aiAssessmentField("ismsa/fieldTypes/assetAiHumanOversight",
    "'Human oversight' is a required field",
    "'Human oversight' has not been defined for this AI asset. Set this field.").

policyCheckFailure(Asset, "ISMS", CheckTitle, CheckText, Field) :-
    ismsa_aiAsset(Asset),
    not ismsa_disableAssetControl(Asset),
    ismsa_aiAssessmentField(Field, CheckTitle, CheckText),
    not field(Asset, Field, _).

% An AI asset is assessed when all the fields of the assessment are set. The control "Manage
% the assets of the organisation" is not OK while an AI asset is not assessed.

ismsa_aiAssetAssessed(Asset) :-
    ismsa_aiAsset(Asset),
    field(Asset, Field, _) : ismsa_aiAssessmentField(Field, _, _).

% The answers that the AI policy does not allow, or that need an action

policyCheckFailure(Asset, "ISMS", "The use is prohibited",
        "The EU AI Act risk category is 'Prohibited'. Article 5 of the EU AI Act prohibits this use. Stop the use, and deactivate this card.",
        "ismsa/fieldTypes/assetAiRiskCategory") :-
    ismsa_aiAsset(Asset),
    not ismsa_disableAssetControl(Asset),
    field(Asset, "ismsa/fieldTypes/assetAiRiskCategory", "unacceptable"),
    not field(Asset, "workflowState", "Inactive").

notification(Asset, "ISMS", "High-risk use needs the approval of the management",
        "The EU AI Act risk category is 'High risk'. The management approves the use before it starts, and the deployer obligations of Article 26 apply.") :-
    ismsa_aiAsset(Asset),
    not ismsa_disableAssetControl(Asset),
    field(Asset, "ismsa/fieldTypes/assetAiRiskCategory", "highRisk").

notification(Asset, "ISMS", "The training data use is not known",
        "Find out from the terms of use or from the supplier whether the data of the organisation is used to train AI models.") :-
    ismsa_aiAsset(Asset),
    not ismsa_disableAssetControl(Asset),
    field(Asset, "ismsa/fieldTypes/assetAiTrainingDataUsage", "unknown").

notification(Asset, "ISMS", "The data can be used for training",
        "The AI policy allows this only when the owner of the data approves it. Record the approval in the assessment of this card, or change the settings.") :-
    ismsa_aiAsset(Asset),
    not ismsa_disableAssetControl(Asset),
    field(Asset, "ismsa/fieldTypes/assetAiTrainingDataUsage", "mayBeUsed").
