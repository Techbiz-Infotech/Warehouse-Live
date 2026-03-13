page 50232 "WareHouse Additional Charges"
{
    //ApplicationArea = All;
    Caption = 'WareHouse Additional Charges';
    PageType = List;
    SourceTable = "WareHouse Additional Charges";
    UsageCategory = Lists;
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Gate In No."; rec."Gate In No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Container ID field.';
                    Editable = false;
                }
                field("Charges Code"; Rec."Charges Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Charges Code field.';
                }
                field("Invoice Type"; rec."Invoice Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Invoice Type field.';
                }
                field(Rate; Rec.Rate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Rate field.';
                }
            }
        }
    }
}

