page 50217 "WH Gate Out Order SubForm"
{
    Caption = 'Order Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "WH Gate Out Line";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Invoice No."; Rec."Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Invoice No. field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Invoice Date"; Rec."Invoice Date")
                {
                    ToolTip = 'Specifies the value of the Invoice Date field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Invoiced Quantity"; Rec."Invoiced Quantity")
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Invoiced CBM/Weight"; Rec."Invoiced CBM/Weight")
                {
                    ToolTip = 'Specifies the value of the CBM/Weight field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Invoiced WH Stripped Qty"; Rec."Invoiced WH Stripped Qty")
                {
                    ToolTip = 'Specifies the value of the Invoiced WH Stripped Qty field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Receipt No."; rec."Receipt No.")
                {
                    ToolTip = 'Specifies the value of the Receipt No. field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.';
                    ApplicationArea = All;
                    Editable = false;
                }


                field("Shelf No."; Rec."Shelf No.")
                {
                    ToolTip = 'Specifies the value of the Shelf No. field.';
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Description Of The Goods"; Rec."Description Of The Goods")
                {
                    ToolTip = 'Specifies the value of the Description Of The Goods field.';
                    ApplicationArea = All;
                }
                field("Customs No."; Rec."Customs No.")
                {
                    ToolTip = 'Specifies the value of the Customs Entry No. field.';
                    ApplicationArea = All;
                }
                field("Chargeable warehouse Periods"; Rec."Chargeable warehouse Periods")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Chargeable warehouse Periods field.';
                }
                field("Consignment Value"; Rec."Consignment Value")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Consignment Valu field.';
                }
                field("Releasing CBM/Weight"; Rec."Releasing CBM/Weight")
                {
                    ToolTip = 'Specifies the value of the Releasing CBM/Weight field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Gate Out No."; Rec."Gate Out No.")
                {
                    ToolTip = 'Specifies the value of the Gate Out No. field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Gate Out Line No. field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Additional Remarks"; Rec."Additional Remarks")
                {
                    ToolTip = 'Specifies the value of the Additional Remarks field.';
                    ApplicationArea = All;
                }
                field("Trailer No."; Rec."Trailer No.")
                {
                    ToolTip = 'Specifies the value of the Trailer No. field.';
                    Visible = false;
                    ApplicationArea = all;
                }
                field("Transporter/Driver Name"; Rec."Transporter/Driver Name")
                {
                    ToolTip = 'Specifies the value of the Transporter/Driver Name field.';
                    ApplicationArea = All;
                }
                field("Driver ID"; Rec."Driver ID")
                {
                    ToolTip = 'Specifies the value of the Driver ID field.';
                    ApplicationArea = All;
                }
                field("Truck No."; Rec."Truck No.")
                {
                    ToolTip = 'Specifies the value of the Truck No. field.';
                    ApplicationArea = All;
                }

                field("Gate In Reference No."; Rec."Gate In Reference No.")
                {
                    ToolTip = 'Specifies the value of the Gate In Reference No. field.';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Gate In Reference Line No."; Rec."Gate In Reference Line No.")
                {
                    ToolTip = 'Specifies the value of the Gate In Line No. field.';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Agent Name"; Rec."Agent Name")
                {
                    ToolTip = 'Specifies the value of the Gate In Line No. field.';
                    ApplicationArea = All;

                }
                field("Agent Port Pass"; rec."Agent Port Pass")
                {
                    ToolTip = 'Specifies the value of the Agent Port Pass field.';
                    ApplicationArea = All;
                }

            }
        }
    }
}