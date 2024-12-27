cismsRiskLessThan("veryLow", "low").
cismsRiskLessThan("veryLow", "moderate").
cismsRiskLessThan("veryLow", "high").
cismsRiskLessThan("veryLow", "veryHigh").
cismsRiskLessThan("low", "moderate").
cismsRiskLessThan("low", "high").
cismsRiskLessThan("low", "veryHigh").
cismsRiskLessThan("moderate", "high").
cismsRiskLessThan("moderate", "veryHigh").
cismsRiskLessThan("high", "veryHigh").

transitionDenied(Card, "Complete analysis", "Fill needed metadata fields for this risk before completing analysis" ):-
    field(Card, "cardType", "ismsa/cardTypes/risk"),
    not field(Card, "base/fieldTypes/owner", _).

transitionDenied(Card, "Complete analysis", "Fill needed metadata fields for this risk before completing analysis" ):-
    field(Card, "cardType", "ismsa/cardTypes/risk"),
    not field(Card, "base/fieldTypes/informationClassification", _).

policyCheckFailure(Card, "ISMS", "'Initial likelihood' is a required field", "'Initial likelihood' has not been defined for this risk. Set this field.") :-
    field(Card, "cardType", "ismsa/cardTypes/risk"),
    not field(Card, "ismsa/fieldTypes/riskInitialLikelihood", _).

transitionDenied(Card, "Complete analysis", "Fill needed metadata fields for this risk before completing analysis" ):-
    field(Card, "cardType", "ismsa/cardTypes/risk"),
    not field(Card, "ismsa/fieldTypes/riskInitialLikelihood", _).

policyCheckFailure(Card, "ISMS", "'Initial impact' is a required field", "'Initial impact' has not been defined for this risk. Set this field.") :-
    field(Card, "cardType", "ismsa/cardTypes/risk"),
    not field(Card, "ismsa/fieldTypes/riskInitialImpact", _).

transitionDenied(Card, "Complete analysis", "Fill needed metadata fields for this risk before completing analysis" ):-
    field(Card, "cardType", "ismsa/cardTypes/risk"),
    not field(Card, "ismsa/fieldTypes/riskInitialImpact", _).

policyCheckFailure(Card, "ISMS", "'Initial risk level' is a required field", "'Initial risk level' has not been defined for this risk. Set this field.") :-
    field(Card, "cardType", "ismsa/cardTypes/risk"),
    not field(Card, "ismsa/fieldTypes/riskInitialRisk", _).

transitionDenied(Card, "Complete analysis", "Fill needed metadata fields for this risk before completing analysis" ):-
    field(Card, "cardType", "ismsa/cardTypes/risk"),
    not field(Card, "ismsa/fieldTypes/riskInitialRisk", _).

policyCheckFailure(Card, "ISMS", "Mitigation strategy is a required field", "Mitigation strategy has not been defined for this risk. Set this field.") :-
    field(Card, "cardType", "ismsa/cardTypes/risk"),
    not field(Card, "ismsa/fieldTypes/riskMitigationStrategy", _).

transitionDenied(Card, "Complete analysis", "Fill needed metadata fields for this risk before completing analysis" ):-
    field(Card, "cardType", "ismsa/cardTypes/risk"),
    not field(Card, "ismsa/fieldTypes/riskMitigationStrategy", _).

notification(Card, "ISMS", "Progress mismatch", "You have analysed the risk, but not started the progress. Progress risk by pressing complete analysis.") :-
    field(Card, "cardType", "ismsa/cardTypes/risk"),
    field(Card, "ismsa/fieldTypes/riskInitialLikelihood", _),
    field(Card, "ismsa/fieldTypes/riskInitialImpact", _),
    field(Card, "ismsa/fieldTypes/riskMitigationStrategy", _),
    field(Card, "workflowState", "Open").

policyCheckFailure(Card, "ISMS", "Controls must be identified unless risk level is acceptable",
    "Controls have not been identified, even though the initial risk level is not acceptable. Link this risk to one or more controls or tasks.") :-
    ancestor(Card, RiskRegister),
    field(RiskRegister, "cardType", "ismsa/cardTypes/riskRegister"),
    field(RiskRegister, "ismsa/fieldTypes/acceptableRiskLevel", AcceptableRiskLevel),
    field(Card, "cardType", "ismsa/cardTypes/risk"),
    field(Card, "ismsa/fieldTypes/riskInitialRisk", InitialRisk),
    cismsRiskLessThan(AcceptableRiskLevel, InitialRisk),
    not link(_, Card, "ismsa/linkTypes/mitigates").

policyCheckFailure(Card, "ISMS", "Lowering residual risk requires that controls have been identified",
    "Residual risk is lower than inherent risk, even though controls have not been identified. Link this risk to one or more controls or tasks.") :-
    field(Card, "cardType", "ismsa/cardTypes/risk"),
    field(Card, "ismsa/fieldTypes/riskInitialRisk", InitialRisk),
    field(Card, "ismsa/fieldTypes/riskResidualRisk", ResidualRisk),
    cismsRiskLessThan(ResidualRisk, InitialRisk),
    not link(_, Card, "ismsa/linkTypes/mitigates").

policyCheckFailure(Card, "ISMS", "Risks can only be accepted if the risk level is acceptable",
    "This risk has been accepted, even though the residual risk is higher than the acceptable risk level. Implement more controls to lower the residual risk or change the risk to the status 'Needs monitoring'.") :-
    ancestor(Card, RiskRegister),
    field(RiskRegister, "cardType", "ismsa/cardTypes/riskRegister"),
    field(Card, "workflowState", "Closed as accepted"),
    field(RiskRegister, "ismsa/fieldTypes/acceptableRiskLevel", AcceptableRiskLevel),
    field(Card, "cardType", "ismsa/cardTypes/risk"),
    field(Card, "ismsa/fieldTypes/riskResidualRisk", ResidualRisk),
    cismsRiskLessThan(AcceptableRiskLevel, ResidualRisk).

transitionDenied(Card, "Complete treatment", "Fill Residual likelihood, impact and risk level for this risk before completing analysis" ):-
    field(Card, "cardType", "ismsa/cardTypes/risk"),
    not field(Card, "ismsa/fieldTypes/riskResidualLikelihood", _).

transitionDenied(Card, "Complete treatment", "Fill Residual likelihood, impact and risk level for this risk before completing analysis" ):-
    field(Card, "cardType", "ismsa/cardTypes/risk"),
    not field(Card, "ismsa/fieldTypes/riskResidualImpact", _).

transitionDenied(Card, "Complete treatment", "Fill Residual likelihood, impact and risk level for this risk before completing analysis" ):-
    field(Card, "cardType", "ismsa/cardTypes/risk"),
    not field(Card, "ismsa/fieldTypes/riskResidualRisk", _).