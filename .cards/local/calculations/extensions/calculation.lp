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
% identifiers as the ExtensibleCard. Each of these cards renders ismsa/reports/installExtension,
% which shows a button for each library that has not been installed yet.
%
% "ismsa_home"                        The home card. Use it for the registers of a library, for
%                                     example the asset register and the risk register.
% "ismsa_register_central-controls"   The central control register. Use it for the internal
%                                     controls of a library. All controls of the home are in this
%                                     register.
% "ismsa_register_processes"          The process register. Use it for the processes, policies,
%                                     and plans of a library that are not planned evidence of a
%                                     control. Planned evidence is created with the buttons in
%                                     the controls.
% "ismsa_register_incidents"          The incident register.
% "ismsa_register_compliance"         The compliance register. Use it for a library of assessed
%                                     compliance requirements, for example NIS2 or ISO/IEC 27001.
%
% The old home template uses the identifiers "ismsa_register_incidents" and
% "ismsa_register_compliance" too, and its compliance register renders the same report. So a
% library for these two registers is offered in the old homes as well.
%
% Use a card type as the ExtensibleCard only if the library also fits the old home template
% (ismsa/templates/moduleHome), because both templates use the same card types.
%
% A library can have a template for each extension point, for example one for its controls and
% one for its registers. The libraries of this module are registered in
% ismsa/calculations/homeLibraries. For example:
%
% ismsa_installableExtension(
%     "ismsa_register_central-controls",
%     "the security operations library",
%     "ismsa/templates/securityOperations",
%     "Add the security operations library",
%     "ismsa_control_operate-security-monitoring"
% ).
