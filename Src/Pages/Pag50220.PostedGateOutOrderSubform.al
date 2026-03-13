page 50220 "Posted Gate Out Order SubForm"
{
    Caption = 'Order Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "WH Gate Out Line";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {

                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Description Of The Goods"; Rec."Description Of The Goods")
                {
                    ToolTip = 'Specifies the value of the Description Of The Goods field.';
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.';
                    ApplicationArea = All;
                }
                field("Shelf No."; Rec."Shelf No.")
                {
                    ToolTip = 'Specifies the value of the Shelf No. field.';
                    ApplicationArea = All;
                }
                field("Invoiced Quantity"; Rec."Invoiced Quantity")
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                    ApplicationArea = All;
                }
                field("Invoiced CBM/Weight"; Rec."Invoiced CBM/Weight")
                {
                    ToolTip = 'Specifies the value of the CBM field.';
                    ApplicationArea = All;
                }
                field("Gate In Weight"; Rec."Gate In Weight")
                {
                    ToolTip = 'Specifies the value of the Weight field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Customs No."; Rec."Customs No.")
                {
                    ToolTip = 'Specifies the value of the Customs Entry No. field.';
                    ApplicationArea = All;
                }


            }
        }
    }
}