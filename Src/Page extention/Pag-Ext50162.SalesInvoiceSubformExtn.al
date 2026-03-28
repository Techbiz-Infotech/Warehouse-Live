pageextension 50162 SalesInvoiceSubformExtn extends "Sales Invoice Subform"
{
    layout
    {
        addafter("Shortcut Dimension 1 Code")
        {
            field("Invoice Type"; rec."Invoice Type")
            {
                ApplicationArea = all;
                Editable = LineFieldVisible;
                ToolTip = 'Specifies the Invoice Type';
            }
            field("Chargeable warehouse Periods"; Rec."Chargeable warehouse Periods")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Chargeable warehouse Periods field.';
            }
            field("Chargeable Rewarehouse Periods"; Rec."Chargeable Rewarehouse Periods")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Chargeable warehouse Periods field.';
            }
            field("Invoicing CBM/Weight"; Rec."Invoicing CBM/Weight")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Invoicing CBM/Weight field.';
                Editable = false;
            }
            field("Invoicing Quantity"; Rec."Invoicing Quantity")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Invoicing Quantity field.';
                Editable = false;

            }
            field("Customs Entry No."; Rec."Customs Entry No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies theCustoms Entry No.';
            }
            field("Consignment Value"; Rec."Consignment Value")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the Consignment Value';
            }
            field("Invoicing WH Stripped Qty"; Rec."Invoicing WH Stripped Qty")
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
                ToolTip = 'Specifies how many units of the item on the line have been invoiced in warehouse processes. This field is used for integration with warehouse management processes and is updated when items are invoiced in a warehouse process.';

            }
            
        }

    }
    procedure LineVisible()
    begin
        if (UserId <> 'GROUP.AUDIT') and (UserId <> 'TECHBIZINFOTECH') then
            LineFieldVisible := false
        else
            LineFieldVisible := true;
    end;

    var

    var
        LineFieldEditable, LineFieldVisible : Boolean;




}
