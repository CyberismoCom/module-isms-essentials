% Copyright © Cyberismo Ltd and contributors 2025
%
% License: https://github.com/CyberismoCom/module-isms-essentials/blob/main/LICENSE
% The use of the Cyberismo trademark: https://cyberismo.com/trademark-policy/
% This content is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
% FITNESS FOR A PARTICULAR PURPOSE.

link(Asset, Risk, "ismsa/linkTypes/presentsRisk") :-
    ismsa_asset(Asset),
    field(Risk, "cardType", "ismsa/cardTypes/risk"),
    parent(Risk, Asset).

link(Control, Risk, "ismsa/linkTypes/mitigates") :-
    field(Risk, "cardType", "ismsa/cardTypes/risk"),
    field(Control, "cardType", "ismsa/cardTypes/control"),
    parent(Control, Risk).
