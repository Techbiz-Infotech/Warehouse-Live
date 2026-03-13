pageextension 50152 "Charge ID group SubformExt" extends "Charge ID Group Subform"
{
    layout
    {
        addafter("Charge Category")
        {
            field("WH Calculation Days"; Rec."WH Calculation Days")
            {
                ToolTip = 'Specifies the value of the Calculation Days field.';
                ApplicationArea = All;
            }
            field("Storage Minimum Charges"; rec."Storage Minimum Charges")
            {
                ToolTip = 'Specifies the value of the Storage Minimum Charges field.';
                ApplicationArea = All;
            }
            field("CalCulation Type"; rec."CalCulation Type")
            {
                ToolTip = 'Specifies the value of the CalCulation Type field.';
                ApplicationArea = All;
            }
            // field("Container Size"; rec."Container Size")
            // {
            //     ToolTip = 'Specifies the value of the Container Size field.';
            //     ApplicationArea = All;
            // }
        }
    }
}
