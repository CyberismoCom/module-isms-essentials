% Rules for calculating the Assessment and Assessment explanation

field(Control, "ismsa/fieldTypes/assessment", "open") :-
  field(Control, "cardType", "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "Open").

field(Control, "ismsa/fieldTypes/assessmentExplanation", "The control has not been scoped yet") :-
  field(Control, "cardType", "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "Open").

field(Control, "ismsa/fieldTypes/assessment", "notApplicable") :-
  field(Control, "cardType", "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "Out of scope").

field(Control, "ismsa/fieldTypes/assessmentExplanation", "The control has been marked out of scope") :-
  field(Control, "cardType", "ismsa/cardTypes/internalControl"),
  field(Control, "workflowState", "Out of scope").

