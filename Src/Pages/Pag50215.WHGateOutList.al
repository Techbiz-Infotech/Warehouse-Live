page 50215 "WH GateOut Order List"
{
    ApplicationArea = All;
    Caption = 'Warehouse Gate Out Orders';
    PageType = List;
    SourceTable = "WH Gate Out Header";
    CardPageId = "WH Gate Out Order";
    UsageCategory = Lists;
    SourceTableView = sorting("Gate Out No.") order(descending) where(Posted = filter(false));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Gate In No."; Rec."Gate Out No.")
                {
                    ToolTip = 'Specifies the value of the CBM field.';
                    ApplicationArea = All;
                }
                field("Gate In Date"; Rec."Activity Date")
                {
                    ToolTip = 'Specifies the value of the Activity field.';
                    ApplicationArea = All;
                }
                field("Consignee No."; Rec."Consignee No.")
                {
                    ToolTip = 'Specifies the value of the CBM field.';
                    ApplicationArea = All;
                }
                field("Consignee Name "; Rec."Consignee Name")
                {
                    ToolTip = 'Specifies the value of the CBM field.';
                    ApplicationArea = All;
                }
                field("Clearing Agent"; Rec."Clearing Agent")
                {
                    ToolTip = 'Specifies the value of the CBM field.';
                    ApplicationArea = All;
                }
                field("Clearing Agent Name"; Rec."Clearing Agent Name")
                {
                    ToolTip = 'Specifies the value of the CBM field.';
                    ApplicationArea = All;
                }
                // field("Customs No."; Rec."Customs No.")
                // {
                //     ToolTip = 'Specifies the value of the CBM field.';
                //     ApplicationArea = All;
                // }
                field(Transporter; Rec.Transporter)
                {
                    ToolTip = 'Specifies the value of the CBM field.';
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
        if IMSSetup."Warehouse Activated" <> true then
            Error('Warehouse functionality is not activated for %1', CompanyName);
    end;
}
