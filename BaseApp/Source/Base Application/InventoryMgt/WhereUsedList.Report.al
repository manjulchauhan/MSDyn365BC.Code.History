report 809 "Where-Used List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './InventoryMgt/WhereUsedList.rdlc';
    ApplicationArea = Assembly;
    Caption = 'Where-Used List';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Item; Item)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Description";
            column(CompanyName; COMPANYPROPERTY.DisplayName())
            {
            }
            column(ItemTableCaption; TableCaption + ': ' + ItemFilter)
            {
            }
            column(ItemFilter; ItemFilter)
            {
            }
            column(No_Item; "No.")
            {
            }
            column(Description_Item; Description)
            {
            }
            column(WhereUsedListCaption; WhereUsedListCaptionLbl)
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            dataitem("BOM Component"; "BOM Component")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING(Type, "No.") WHERE(Type = CONST(Item));
                dataitem(Item2; Item)
                {
                    DataItemLink = "No." = FIELD("Parent Item No.");
                    DataItemTableView = SORTING("No.");
                    column(Position_BOMComponent; "BOM Component".Position)
                    {
                        IncludeCaption = true;
                    }
                    column(ParentItemNo_BOMComponent; "BOM Component"."Parent Item No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Description_Item2; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(Quantityper_BOMComponent; "BOM Component"."Quantity per")
                    {
                        DecimalPlaces = 0 : 5;
                        IncludeCaption = true;
                    }
                    column(BaseUnitofMeasure_Item2; "Base Unit of Measure")
                    {
                        IncludeCaption = true;
                    }
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        ItemFilter := Item.GetFilters();
    end;

    var
        ItemFilter: Text;
        WhereUsedListCaptionLbl: Label 'Where-Used List';
        PageCaptionLbl: Label 'Page';
}

