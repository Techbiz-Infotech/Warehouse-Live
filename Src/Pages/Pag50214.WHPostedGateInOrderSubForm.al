page 50214 "Posted Gate In Order SubForm"
{
    Caption = 'Posted Warehouse Gate In Order Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    AutoSplitKey = true;
    SourceTable = "WH Gate In Line";
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Editable = true;
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                    Visible = false;
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Description Of The Goods"; Rec."Description Of The Goods")
                {
                    ToolTip = 'Specifies the value of the Description Of The Goods field.';
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

                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Unit Of Measure"; rec."Unit Of Measure")
                {
                    ToolTip = 'Specifies the value of the  Unit Of Measure field.';
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Container Size"; Rec."Container Size")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Container Size field.';
                    Editable = false;
                }
                field(Weight; Rec.Weight)
                {
                    ToolTip = 'Specifies the value of the Weight field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(CBM; Rec.CBM)
                {
                    ToolTip = 'Specifies the value of the CBM field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Weight/CBM"; rec."Weight/CBM")
                {
                    ToolTip = 'Specifies the value of the Weight/CBM field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Chargable CBM/Weight"; Rec."Chargable CBM/Weight")
                {
                    ToolTip = 'Specifies the value of the CBM/weight field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(TEUs; rec.TEUs)
                {
                    ToolTip = 'Specifies the value of the TEUs field.';
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Additional Remarks"; Rec."Additional Remarks")
                {
                    ToolTip = 'Specifies the value of the Additional remarks field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("WH Stripped Quantity "; Rec."WH Stripped Quantity ")
                {
                    ToolTip = 'Specifies the value of the Stripped Unit field.';
                    ApplicationArea = All;
                    Editable = IsStrippedQtyChanged;
                }

            }
        }
    }
    trigger OnOpenPage()
    var
    begin
        StrippedQtyEditable();
    end;

    trigger OnAfterGetCurrRecord()
    var
    begin
        StrippedQtyEditable();
    end;

    trigger OnAfterGetRecord()
    var
    begin
        StrippedQtyEditable();
    end;

    var
        IsStrippedQtyChanged: Boolean;

    procedure StrippedQtyEditable()
    var
    begin
        if Rec."Stripped Qty Updated" = true then
            IsStrippedQtyChanged := false
        else
            IsStrippedQtyChanged := true;


    end;
}