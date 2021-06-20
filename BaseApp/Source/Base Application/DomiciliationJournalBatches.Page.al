page 2000021 "Domiciliation Journal Batches"
{
    Caption = 'Domiciliation Journal Batches';
    DataCaptionExpression = DataCaption;
    PageType = List;
    SourceTable = "Domiciliation Journal Batch";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Name; Name)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the journal batch you are creating.';
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a description of the journal batch you are creating.';
                }
                field("Reason Code"; "Reason Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the entry.';
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies that to see the available status, click the AssistButton.';
                }
                field("Partner Type"; "Partner Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if the domiciliation journal batch is of type person or company.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Edit Journal")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Edit Journal';
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Return';
                ToolTip = 'Open a journal based on the journal batch.';

                trigger OnAction()
                begin
                    DomJnlManagement.TemplateSelectionFromBatch(Rec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        DomJnlManagement.OpenJnlBatch(Rec);
    end;

    var
        DomJnlManagement: Codeunit DomiciliationJnlManagement;

    local procedure DataCaption(): Text[250]
    var
        DomJnlTemplate: Record "Domiciliation Journal Template";
    begin
        if not CurrPage.LookupMode then
            if GetFilter("Journal Template Name") <> '' then
                if GetRangeMin("Journal Template Name") = GetRangeMax("Journal Template Name") then
                    if DomJnlTemplate.Get(GetRangeMin("Journal Template Name")) then
                        exit(DomJnlTemplate.Name + ' ' + DomJnlTemplate.Description);
    end;
}
