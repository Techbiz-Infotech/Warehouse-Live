page 50211 "WH Gate In Order List"
{
    ApplicationArea = All;
    Caption = 'Warehouse Gate In Orders';
    PageType = List;
    SourceTable = "WH Gate In Header";
    CardPageId = "WH Gate In Order";
    UsageCategory = Lists;
    Editable = false;
    SourceTableView = sorting("Gate In No.") order(descending) where(Posted = filter(false));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Gate In No."; Rec."Gate In No.")
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
                field("Clearing Agent "; Rec."Clearing Agent")
                {
                    ToolTip = 'Specifies the value of the Clearing Agent field.';
                    ApplicationArea = All;
                }
                field("Clearing Agent Name"; Rec."Clearing Agent Name")
                {
                    ToolTip = 'Specifies the value of the Clearing Agent Name field.';
                    ApplicationArea = All;
                }
                field("Customs No."; Rec."Customs No.")
                {
                    ToolTip = 'Specifies the value of the Customs No. field.';
                    ApplicationArea = All;
                }
                field("Truck No."; Rec."Truck No.")
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
