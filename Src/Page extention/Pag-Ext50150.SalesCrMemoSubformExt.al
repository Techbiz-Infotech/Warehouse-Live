pageextension 50150 SalesCrMemoSubformExt extends "Sales Cr. Memo Subform"
{
    layout
    {
        addafter("Shortcut Dimension 1 Code")
        {
            field("Invoice Type"; rec."Invoice Type")
            {
                ApplicationArea = all;
                // Editable = LineFieldVisible;
                ToolTip = 'Specifies the Invoice Type';
            }
            field("Container Size"; Rec."Container Size")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Container Size field.';
            }
            field("Chargeable warehouse Periods"; Rec."Chargeable warehouse Periods")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Chargeable warehouse Periods field.';
            }
            field("Chargeable ReWarehouse Periods";Rec."Chargeable ReWarehouse Periods")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Chargeable Rewarehouse Periods field.'; 
            }
             field("Customs Entry No."; Rec."Customs Entry No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the Customs Entry No.';
            }

        }
    }
}
