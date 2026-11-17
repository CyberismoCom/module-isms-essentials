% Run with: cyberismo calc run tests/cra-guidance.lp
% The test passes when "results" is empty and "error" is null.
% It adds a template of the EU CRA module, as if eucra were installed, and checks that the
% CRA guidance of the central controls is turned on.

template("eucra/templates/design2").

result(("FAIL CRA guidance is off with an eucra template")) :-
    not ismsa_craGuidance.
