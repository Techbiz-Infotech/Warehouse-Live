page 50212 "Posted WH GateIn Order List"
{
    ApplicationArea = All;
    Caption = 'Posted Warehouse Gate In Orders';
    PageType = List;
    SourceTable = "WH Gate In Header";
    CardPageId = "Posted WH Gate In Order";
    UsageCategory = Lists;
    Editable = false;
    SourceTableView = sorting("Gate In No.") order(descending) where(Posted = filter(true));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Location Type"; Rec."Location Type")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                    ApplicationArea = All;
                }
                field("Gate In No."; Rec."Gate In No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                    ApplicationArea = All;
                }
                field("Gate In Date"; Rec."Activity Date")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                    ApplicationArea = All;
                }
                field("Consignee No."; Rec."Consignee No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                    ApplicationArea = All;
                }
                field("Consignee Name "; Rec."Consignee Name")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                    ApplicationArea = All;
                }
                field("Customs No."; Rec."Customs No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                    ApplicationArea = All;
                }
                field("Truck No."; Rec."Truck No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                    ApplicationArea = All;
                }
                field("Clearing Agent "; Rec."Clearing Agent")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                    ApplicationArea = All;
                }
                field("Clearing Agent Name"; Rec."Clearing Agent Name")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
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
