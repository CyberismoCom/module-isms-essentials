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
% "ismsa_register_central-controls"   The central control register. Use it for the internal
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
