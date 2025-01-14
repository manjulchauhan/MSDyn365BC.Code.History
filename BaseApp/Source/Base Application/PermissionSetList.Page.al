page 9851 "Permission Set List"
{
    Caption = 'Permission Set List';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    Permissions = TableData "Permission Set Link" = d,
                  TableData "Aggregate Permission Set" = rimd;
    SourceTable = "Permission Set Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Permission Set';
                field(PermissionSet; "Role ID")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Permission Set';
                    Editable = false;
                    ToolTip = 'Specifies the permission set.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the name of the record.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Enabled = false;
                }
                field("App Name"; Rec."App Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Extension Name';
                    Editable = false;
                    ToolTip = 'Specifies the name of the extension.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        FillRecordBuffer();
    end;

    procedure GetSelectionFilter(var AggregatePermissionSet: Record "Aggregate Permission Set")
    begin
        AggregatePermissionSet.Reset();
        CurrPage.SetSelectionFilter(Rec);
        if FindSet() then
            repeat
                if AggregatePermissionSet.Get(Scope, "App ID", "Role ID") then
                    AggregatePermissionSet.Mark(true);
            until Next() = 0;
        Reset();
        AggregatePermissionSet.MarkedOnly(true);
    end;
}

