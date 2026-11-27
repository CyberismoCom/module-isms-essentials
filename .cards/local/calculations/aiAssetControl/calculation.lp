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

% A high-risk use always needs a risk evaluation. The other AI assets need a risk only when the
% owner sets "Risk evaluation needed" to "Yes", so an AI feature of an everyday service does not
% need a risk card (2026-11-27).

policyCheckFailure(Asset, "ISMS", "A high-risk use needs a risk evaluation",
        "The EU AI Act risk category is 'High risk', but 'Risk evaluation needed' is 'No'. Set 'Risk evaluation needed' to 'Yes', and add the risks of this use.",
        "ismsa/fieldTypes/assetRiskEvaluationNeeded") :-
    ismsa_aiAsset(Asset),
    not ismsa_disableAssetControl(Asset),
    field(Asset, "ismsa/fieldTypes/assetAiRiskCategory", "highRisk"),
    field(Asset, "ismsa/fieldTypes/assetRiskEvaluationNeeded", "no").

% Personal data in an AI tool (2026-11-27). The field "Data categories" tells it.

ismsa_aiAssetWithPersonalData(Asset) :-
    ismsa_aiAsset(Asset),
    field(Asset, "ismsa/fieldTypes/dataCategories", "personalData").

ismsa_aiAssetWithPersonalData(Asset) :-
    ismsa_aiAsset(Asset),
    field(Asset, "ismsa/fieldTypes/dataCategories", "sensitivePersonalData").

notification(Asset, "ISMS", "The tool processes personal data",
        "Add the processing to the record of processing activities (GDPR Article 30). Check whether a data protection impact assessment is needed (GDPR Article 35), and whether the supplier needs a data processing agreement.") :-
    ismsa_aiAssetWithPersonalData(Asset),
    not ismsa_disableAssetControl(Asset).

% The register "AI tools" is on the home card when the home had no asset register. When the
% home gets one later, the register belongs under the supporting assets.

notification(Register, "ISMS", "Move this register to the supporting assets",
        "This home now has an asset register. Move this register under \"Supporting assets\", so that the AI tools are with the other assets. The controls and the reviews work in both places.") :-
    field(Register, "base/fieldTypes/identifier", "ismsa_register_ai-tools"),
    parent(Register, Home),
    base_projectCardType(Home, "ismsa/cardTypes/moduleHome"),
    field(Assets, "base/fieldTypes/identifier", "ismsa_register_supporting-assets"),
    ismsa_closestHome(Assets, Home).

% Article 26 of the EU AI Act is for the deployers of high-risk AI systems. A home without a
% high-risk use marks the requirement out of scope. The check tells when the requirement is out
% of scope and the home still has a high-risk AI tool that is not deactivated (2026-11-27).

policyCheckFailure(Requirement, "Compliance requirement", "The home has a high-risk AI tool",
        "This requirement is out of scope, but an AI tool of this home has the EU AI Act risk category 'High risk'. Mark the requirement in scope, or correct the risk category of the tool.") :-
    field(Requirement, "base/fieldTypes/identifier", "ismsa_aiact_art-26"),
    field(Requirement, "workflowState", "Out of scope"),
    ismsa_closestHome(Requirement, Home),
    ismsa_aiAsset(Asset),
    ismsa_closestHome(Asset, Home),
    not ismsa_disableAssetControl(Asset),
    not field(Asset, "workflowState", "Inactive"),
    field(Asset, "ismsa/fieldTypes/assetAiRiskCategory", "highRisk").
