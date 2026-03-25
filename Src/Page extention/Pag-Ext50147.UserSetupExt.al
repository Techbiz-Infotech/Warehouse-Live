pageextension 50147 "User Setup Ext" extends "User Setup"
{
    layout
    {
        addafter("Gatepass Approval")
        {
            field("Warehouse Gatepass Approval"; Rec."Warehouse Gatepass Approval")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies The Warehouse Gatepass Approval field';
            }
            field("Edit Posted Warehouse GateIns"; Rec."Edit Posted Warehouse GateIns")
            {
                ApplicationArea = all;
            }
        }
    }
}
