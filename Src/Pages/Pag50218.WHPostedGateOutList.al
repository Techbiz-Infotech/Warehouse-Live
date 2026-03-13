page 50218 "Posted WH Gate Out Order List"
{
    ApplicationArea = All;
    Caption = 'Posted Warehouse Gate Out Orders';
    PageType = List;
    SourceTable = "WH Gate Out Header";
    Editable = false;
    UsageCategory = Lists;
    SourceTableView = sorting("Gate Out No.") order(descending) where(Posted = filter(true));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Gate In No."; Rec."Gate Out No.")
                {
                    ToolTip = 'Specifies the value of the Gate In No. field.';
                    ApplicationArea = All;
                }
                field("Activity Date"; Rec."Activity Date")
                {
                    ToolTip = 'Specifies the value of the Gate In Date field.';
                    ApplicationArea = All;
                }

                field("Consignee No."; Rec."Consignee No.")
                {
                    ToolTip = 'Specifies the value of the Consignee No. field.';
                    ApplicationArea = All;
                }
                field("Consignee Name "; Rec."Consignee Name")
                {
                    ToolTip = 'Specifies the value of the Consignee Name field.';
                    ApplicationArea = All;
                }

                field("Clearing Agent"; Rec."Clearing Agent")
                {
                    ToolTip = 'Specifies the value of the Clearing Agent field.';
                    ApplicationArea = All;
                }
                field("Clearing Agent Name"; Rec."Clearing Agent Name")
                {
                    ToolTip = 'Specifies the value of the Clearing Agent Name field.';
                    ApplicationArea = All;
                }
                // field("Customs No."; Rec."Customs No.")
                // {
                //     ToolTip = 'Specifies the value of the Customs No.field.';
                //     ApplicationArea = All;
                // }
                field(Transporter; Rec.Transporter)
                {
                    ToolTip = 'Specifies the value of the Transporter field.';
                    ApplicationArea = All;
                }

            }
        }
    }
    trigger OnOpenPage()
    var
        IMSSetup: Record "IMS Setup";
    begin
        IMSSetup.Get();
        if IMSSetup."Warehouse Activated" = false then
            Error('Warehouse functionality is not activated for %1', CompanyName);
    end;
}
