page 308 "Transaction Types"
{
    ApplicationArea = BasicEU, BasicNO;
    Caption = 'Transaction Types';
    PageType = List;
    SourceTable = "Transaction Type";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code"; Code)
                {
                    ApplicationArea = BasicEU, BasicNO;
                    ToolTip = 'Specifies a code for the transaction.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = BasicEU, BasicNO;
                    ToolTip = 'Specifies a description of the transaction type.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
    }
}