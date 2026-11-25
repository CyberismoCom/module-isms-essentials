%
% Checks of the library controls
%
% Some library controls check the content of their registers, not only their planned evidence.
% These checks replace the set-up tasks of the old home template (ismsa/templates/moduleHome),
% such as "Identify assets", "Evaluate assets", "Analyse risks", and "Create risk treatment
% plans". A task is done once, but a check keeps working: when a new risk is not analysed, the
% control is not OK again.
%
% A check is a policy check of the control. While a check fails, the assessment of the control
% is "notOk" with the explanation "The control has failed policy checks", unless planned
% evidence is missing. The checks apply only to a control that is in scope, and they look only
% at the cards of the same ISMS home.
%

ismsa_checkedLibraryControl(Control, Identifier, Home) :-
    base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
    field(Control, "workflowState", "In scope"),
    field(Control, "base/fieldTypes/identifier", Identifier),
    ismsa_closestHome(Control, Home).

ismsa_riskInHome(Risk, Home) :-
    base_projectCardType(Risk, "ismsa/cardTypes/risk"),
    ismsa_closestHome(Risk, Home),
    not hiddenInTreeView(Risk).

ismsa_assetInHome(Asset, Home) :-
    ismsa_asset(Asset),
    ismsa_closestHome(Asset, Home),
    not hiddenInTreeView(Asset),
    not field(Asset, "workflowState", "Inactive").

%
% Manage the assets of the organisation
%

policyCheckFailure(
    Control,
    "Internal control",
    "No assets have been identified",
    "The asset register of this home has no assets. Identify the primary and supporting assets, and add them to the asset register."
) :-
    ismsa_checkedLibraryControl(Control, "ismsa_control_manage-assets", Home),
    not ismsa_assetInHome(_, Home).

policyCheckFailure(
    Control,
    "Internal control",
    "Some assets have not been evaluated",
    "Some assets in the asset register have no overall asset criticality. Evaluate each asset, and set its criticality."
) :-
    ismsa_checkedLibraryControl(Control, "ismsa_control_manage-assets", Home),
    ismsa_assetInHome(Asset, Home),
    not ismsa_disableAssetControl(Asset),
    not field(Asset, "ismsa/fieldTypes/assetCriticalityForOperations", _).

policyCheckFailure(
    Control,
    "Internal control",
    "Some AI assets have not been assessed",
    "Some AI assets in the asset register have no assessment. Set the information allowed, the training data use, the EU AI Act risk category, and the human oversight of each AI asset."
) :-
    ismsa_checkedLibraryControl(Control, "ismsa_control_manage-assets", Home),
    ismsa_assetInHome(Asset, Home),
    ismsa_aiAsset(Asset),
    not ismsa_disableAssetControl(Asset),
    not ismsa_aiAssetAssessed(Asset).

%
% Manage information security risks
%

policyCheckFailure(
    Control,
    "Internal control",
    "No risks have been identified",
    "The risk register of this home has no risks. Identify the risks of the assets, and add them to the risk register."
) :-
    ismsa_checkedLibraryControl(Control, "ismsa_control_manage-risks", Home),
    not ismsa_riskInHome(_, Home).

policyCheckFailure(
    Control,
    "Internal control",
    "Some risks have not been analysed",
    "Some risks in the risk register are still open. Analyse each risk, and complete its analysis."
) :-
    ismsa_checkedLibraryControl(Control, "ismsa_control_manage-risks", Home),
    ismsa_riskInHome(Risk, Home),
    field(Risk, "workflowState", "Open").

policyCheckFailure(
    Control,
    "Internal control",
    "Some risks have no treatment plan",
    "Some risks in the risk register have been analysed, but their treatment has not been planned. Plan the treatment of each risk."
) :-
    ismsa_checkedLibraryControl(Control, "ismsa_control_manage-risks", Home),
    ismsa_riskInHome(Risk, Home),
    field(Risk, "workflowState", "Analysed").

%
% Manage the AI tools in use (2026-11-25)
%

ismsa_aiAssetInHome(Asset, Home) :-
    ismsa_assetInHome(Asset, Home),
    ismsa_aiAsset(Asset).

policyCheckFailure(
    Control,
    "Internal control",
    "No AI tools have been recorded",
    "The asset register of this home has no AI assets. Record each AI tool in use in the register \"AI tools\", or mark this control out of scope if nobody uses AI."
) :-
    ismsa_checkedLibraryControl(Control, "ismsa_control_manage-ai-tools", Home),
    not ismsa_aiAssetInHome(_, Home).

policyCheckFailure(
    Control,
    "Internal control",
    "Some AI tools have not been assessed",
    "Some AI assets have no assessment. Set the information allowed, the training data use, the EU AI Act risk category, and the human oversight of each AI asset."
) :-
    ismsa_checkedLibraryControl(Control, "ismsa_control_manage-ai-tools", Home),
    ismsa_aiAssetInHome(Asset, Home),
    not ismsa_disableAssetControl(Asset),
    not ismsa_aiAssetAssessed(Asset).

policyCheckFailure(
    Control,
    "Internal control",
    "A prohibited use of AI is active",
    "An active AI asset has the EU AI Act risk category 'Prohibited'. Stop the use, and deactivate the AI asset."
) :-
    ismsa_checkedLibraryControl(Control, "ismsa_control_manage-ai-tools", Home),
    ismsa_aiAssetInHome(Asset, Home),
    field(Asset, "ismsa/fieldTypes/assetAiRiskCategory", "unacceptable").
