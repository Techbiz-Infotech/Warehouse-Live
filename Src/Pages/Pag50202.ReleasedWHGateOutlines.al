page 50202 "Released GateOut lines"
{
    ApplicationArea = All;
    Caption = 'Released Warehouse Gate Out lines';
    PageType = List;
    SourceTable = "WH Gate Out Line";
    UsageCategory = Lists;
    Editable = false;
    SourceTableView = where(Released = const(true));


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Gate Out No."; Rec."Gate Out No.")
                {
                    ToolTip = 'Specifies the value of the Gate Out No. field.';
                    ApplicationArea = all;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Gate Out Line No. field.';
                    ApplicationArea = all;
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                    ApplicationArea = all;
                }
                field("Description Of The Goods"; Rec."Description Of The Goods")
                {
                    ToolTip = 'Specifies the value of the Description Of The Goods field.';
                    ApplicationArea = all;
                }
                field("Invoiced Quantity"; Rec."Invoiced Quantity")
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                    ApplicationArea = all;
                }
                field("Shelf No."; Rec."Shelf No.")
                {
                    ToolTip = 'Specifies the value of the Shelf No. field.';
                    ApplicationArea = all;
                }
                field("Gate In Weight"; Rec."Gate In Weight")
                {
                    ToolTip = 'Specifies the value of the Weight field.';
                    ApplicationArea = all;
                }
                field("Gate In CBM"; Rec."Gate In CBM")
                {
                    ToolTip = 'Specifies the value of the Gate In CBM field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.';
                    ApplicationArea = all;
                }
                field("Gate In Reference No."; Rec."Gate In Reference No.")
                {
                    ToolTip = 'Specifies the value of the Gate In Reference No. field.';
                    ApplicationArea = all;
                }
                field("Gate In Reference Line No."; Rec."Gate In Reference Line No.")
                {
                    ToolTip = 'Specifies the value of the Gate In Line No. field.';
                    ApplicationArea = all;
                }
                field("Invoiced CBM/Weight"; Rec."Invoiced CBM/Weight")
                {
                    ToolTip = 'Specifies the value of the CBM field.';
                    ApplicationArea = all;
                }
                field("Additional Remarks"; Rec."Additional Remarks")
                {
                    ToolTip = 'Specifies the value of the Additional Remarks field.';
                    ApplicationArea = all;
                }
                field("Gate In Quantity"; Rec."Gate In Quantity")
                {
                    ToolTip = 'Specifies the value of the Gate In Quantity field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Activity Date"; Rec."Activity Date")
                {
                    ToolTip = 'Specifies the value of the Activity Date field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Activity Time"; Rec."Activity Time")
                {
                    ToolTip = 'Specifies the value of the Activity Time field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Gate Out Status"; Rec."Gate Out Status")
                {
                    ToolTip = 'Specifies the value of the Gate Out Status field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Invoice No. field.';
                    ApplicationArea = all;
                }
                field("Invoice Date"; Rec."Invoice Date")
                {
                    ToolTip = 'Specifies the value of the Invoice Date field.';
                    ApplicationArea = all;
                }
                field("Receipt No."; Rec."Receipt No.")
                {
                    ToolTip = 'Specifies the value of the Receipt No. field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Truck No."; Rec."Truck No.")
                {
                    ToolTip = 'Specifies the value of the Truck No. field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Agent Name"; Rec."Agent Name")
                {
                    ToolTip = 'Specifies the value of the Agent Name field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Agent Port Pass"; Rec."Agent Port Pass")
                {
                    ToolTip = 'Specifies the value of the Agent Port Pass field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Transporter/Driver Name"; Rec."Transporter/Driver Name")
                {
                    ToolTip = 'Specifies the value of the Transporter/Driver Name field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Trailer No."; Rec."Trailer No.")
                {
                    ToolTip = 'Specifies the value of the Trailer No. field.', Comment = '%';
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Customs No."; Rec."Customs No.")
                {
                    ToolTip = 'Specifies the value of the Customs Entry field.';
                    ApplicationArea = All;
                }
                field("Releasing CBM/Weight"; Rec."Releasing CBM/Weight")
                {
                    ToolTip = 'Specifies the value of the Releasing CBM/Weight field.', Comment = '%';
                    ApplicationArea = all;
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
