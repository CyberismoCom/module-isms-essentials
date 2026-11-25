%* Assertion tests for the acceptance of risks
(ismsa/calculations/riskControl)

Run from the project root:

    cyberismo calc run tests/risk-acceptance.lp

The tests pass when "results" is empty. Each result is one failed assertion.

The fixtures are facts in this file. They copy the layout of the module home:
the risk register and the asset register are siblings under the home, and
the asset templates create risks under the asset. A second home has a more tolerant
register, so the tests also check that a risk uses the register of its own
home.
*%

% Homes, registers, and assets

ismsa_test_card(ismsa_test_home1, "ismsa/cardTypes/moduleHome").
ismsa_test_card(ismsa_test_register1, "ismsa/cardTypes/riskRegister").
ismsa_test_card(ismsa_test_assetRegister1, "ismsa/cardTypes/register").
ismsa_test_card(ismsa_test_device1, "ismsa/cardTypes/assetDevice").
ismsa_test_card(ismsa_test_home2, "ismsa/cardTypes/moduleHome").
ismsa_test_card(ismsa_test_register2, "ismsa/cardTypes/riskRegister").
ismsa_test_card(ismsa_test_assetRegister2, "ismsa/cardTypes/register").
ismsa_test_card(ismsa_test_device2, "ismsa/cardTypes/assetDevice").

parent(ismsa_test_register1, ismsa_test_home1).
parent(ismsa_test_assetRegister1, ismsa_test_home1).
parent(ismsa_test_device1, ismsa_test_assetRegister1).
parent(ismsa_test_register2, ismsa_test_home2).
parent(ismsa_test_assetRegister2, ismsa_test_home2).
parent(ismsa_test_device2, ismsa_test_assetRegister2).

field(ismsa_test_register1, "ismsa/fieldTypes/acceptableRiskLevel", "low").
field(ismsa_test_register2, "ismsa/fieldTypes/acceptableRiskLevel", "veryHigh").

% ismsa_test_risk(Risk, Parent, Initial risk, Residual risk, Policy failure expected)

ismsa_test_risk(ismsa_test_risk_underRegister_high, ismsa_test_register1, "high", "high", yes).
ismsa_test_risk(ismsa_test_risk_underAsset_high, ismsa_test_device1, "high", "high", yes).
ismsa_test_risk(ismsa_test_risk_underAsset_low, ismsa_test_device1, "high", "low", no).
ismsa_test_risk(ismsa_test_risk_otherHome_high, ismsa_test_device2, "high", "high", no).

ismsa_test_card(Risk, "ismsa/cardTypes/risk") :- ismsa_test_risk(Risk, _, _, _, _).
parent(Risk, Parent) :- ismsa_test_risk(Risk, Parent, _, _, _).
field(Risk, "workflowState", "Closed as accepted") :- ismsa_test_risk(Risk, _, _, _, _).
field(Risk, "ismsa/fieldTypes/riskInitialRisk", I) :- ismsa_test_risk(Risk, _, I, _, _).
field(Risk, "ismsa/fieldTypes/riskResidualRisk", R) :- ismsa_test_risk(Risk, _, _, R, _).

projectCard(Card) :- ismsa_test_card(Card, _).
field(Card, "cardType", Type) :- ismsa_test_card(Card, Type).

% Assertions

ismsa_test_failsAcceptance(Risk) :-
    ismsa_test_risk(Risk, _, _, _, _),
    policyCheckFailure(Risk, "ISMS", "Risks can only be accepted if the risk level is acceptable", _).

ismsa_test_failure(Risk, "the acceptance passes, but the residual risk is above the acceptable level") :-
    ismsa_test_risk(Risk, _, _, _, yes),
    not ismsa_test_failsAcceptance(Risk).

ismsa_test_failure(Risk, "the acceptance fails, but the residual risk is acceptable") :-
    ismsa_test_risk(Risk, _, _, _, no),
    ismsa_test_failsAcceptance(Risk).

result((Subject, Reason)) :- ismsa_test_failure(Subject, Reason).
