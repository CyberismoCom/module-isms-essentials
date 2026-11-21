% extension modules can define installable extensions to cards with following kinds of facts:
%
% ismsa_installableExtension(
%     ExtensibleCard,             % identifier or card type of the card that can be extended
%     ModuleDescription,          % display name of the module that introduces an extension
%     Template,                   % the template that includes the extensions
%     ButtonLabel,                % button label for instantiating the extensions
%     ExampleIdentifier           % an example of an identifier of an extension, for checking whether the extension has been installed
% ).
%
% Extension points of the ISMS home (ismsa/templates/moduleHome2)
%
% A library of the home is a template. Install it with a fact that names one of these
% identifiers as the ExtensibleCard. In the new home, all buttons are on the home card:
% ismsa/reports/installLibraries groups the facts by their module description, and shows a button
% for each part that has not been installed yet. The button creates the template under the
% extension point. The registers of the new home do not show buttons.
%
% "ismsa_home"                        The home card. Use it for the registers of a library, for
%                                     example the asset register and the risk register.
% "ismsa_register_central-controls"   The control register. Use it for the internal
%                                     controls of a library. All controls of the home are in this
%                                     register.
% "ismsa_register_processes"          The process register. Use it for the processes, policies,
%                                     and plans of a library, for example the processes of the
%                                     asset and risk management library. The buttons in the
%                                     controls also create their planned evidence there.
% "ismsa_register_incidents"          The incident register.
% "ismsa_register_compliance"         The compliance register. Use it for a library of assessed
%                                     compliance requirements, for example NIS2 or ISO/IEC 27001.
%
% The old home template uses the identifiers "ismsa_register_incidents" and
% "ismsa_register_compliance" too, and the old home renders ismsa/reports/installExtension on
% its home card and registers. So a library for these registers is offered in the old homes as
% well, unless it has an ismsa_libraryForNewHomes fact. The old process register also has the
% identifier "ismsa_register_processes".
%
% Use a card type as the ExtensibleCard only if the library also fits the old home template
% (ismsa/templates/moduleHome), because both templates use the same card types.
%
% A library can have a template for each extension point, for example one for its controls, one
% for its registers, and one for each process. Give each fact of the library the same module
% description, so that the buttons are shown together. ismsa_libraryRank(ModuleDescription, N)
% sets the order of the libraries on the home card. The libraries of this module are registered in
% ismsa/calculations/homeLibraries. For example:
%
% ismsa_installableExtension(
%     "ismsa_register_central-controls",
%     "the security operations library",
%     "ismsa/templates/securityOperations",
%     "Add the security operations library",
%     "ismsa_control_operate-security-monitoring"
% ).

%
% Library parts of a home
%
% These rules are used by the reports ismsa/reports/installLibraries and
% ismsa/reports/homeLibrarySection on the home card.
%
% ismsa_libraryPart(Home, Library, Template, ButtonLabel, Target): a part of a library that can
% be installed in the home. Target is the card under which the button creates the template: the
% home card, or the card of the home with the identifier of the extension point. Library is the
% module description of the ismsa_installableExtension fact.
% ismsa_libraryPartInstalled(Home, Template): a card with the example identifier of the part is
% in the home.
%

ismsa_libraryPointInHome(Point, Home, Home) :-
    ismsa_installableExtension(Point, _, _, _, _),
    base_projectCardType(Home, "ismsa/cardTypes/moduleHome"),
    field(Home, "base/fieldTypes/identifier", Point).

ismsa_libraryPointInHome(Point, Home, Home) :-
    ismsa_installableExtension(Point, _, _, _, _),
    base_projectCardType(Home, Point).

ismsa_libraryPointInHome(Point, Home, Card) :-
    ismsa_installableExtension(Point, _, _, _, _),
    ismsa_closestHome(Card, Home),
    field(Card, "base/fieldTypes/identifier", Point).

% If the home has two cards with the identifier, the first card key is used.

ismsa_libraryPointTarget(Point, Home, Card) :-
    ismsa_libraryPointInHome(Point, Home, _),
    Card = #min { C : ismsa_libraryPointInHome(Point, Home, C) }.

ismsa_libraryPart(Home, Library, Template, Label, Target) :-
    ismsa_installableExtension(Point, Library, Template, Label, _),
    ismsa_libraryOfferedInHome(Template, Home),
    ismsa_libraryPointTarget(Point, Home, Target).

ismsa_libraryPartInstalled(Home, Template) :-
    ismsa_libraryPart(Home, _, Template, _, _),
    ismsa_installableExtension(_, _, Template, _, ExampleIdentifier),
    field(Example, "base/fieldTypes/identifier", ExampleIdentifier),
    ismsa_closestHome(Example, Home).
