page 50210 "WH Gate In Order SubForm"
{
    Caption = 'Warehouse Gate In Order Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "WH Gate In Line";

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
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                    ApplicationArea = All;

                }
                field("Unit Of Measure"; rec."Unit Of Measure")
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                    ApplicationArea = All;
                }
                field("Container Size"; Rec."Container Size")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Container Size field.';
                }
                field(Weight; Rec.Weight)
                {
                    ToolTip = 'Specifies the value of the Weight field.';
                    ApplicationArea = All;

                }
                field(CBM; Rec.CBM)
                {
                    ToolTip = 'Specifies the value of the CBM field.';
                    ApplicationArea = All;

                }
                field("Weight/CBM"; rec."Weight/CBM")
                {
                    ToolTip = 'Specifies the value of the Weight/CBM field.';
                    ApplicationArea = All;
                }
                field(TEUs; rec.TEUs)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the TEUs field.';
                }
                field("Chargable CBM/Weight"; Rec."Chargable CBM/Weight")
                {
                    ToolTip = 'Specifies the value of the CBM/weight field.';
                    ApplicationArea = All;
                }
                field("Additional Remarks"; Rec."Additional Remarks")
                {
                    ToolTip = 'Specifies the value of the Additional remarks field.';
                    ApplicationArea = All;
                }


            }
        }
    }
}