page 50205 WarehouseDetails
{
    ApplicationArea = All;
    Caption = 'WarehouseDetails';
    PageType = List;
    SourceTable = Warehouseinvoicedetails;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Gate In No."; Rec."Gate In No.")
                {
                    ToolTip = 'Specifies the value of the Gate In No. field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Gate In Line No."; Rec."Gate In Line No.")
                {
                    ToolTip = 'Specifies the value of the Gate In Line No. field.', Comment = '%';
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Unit price"; Rec."Unit price")
                {
                    ToolTip = 'Specifies the value of the Unit price field.', Comment = '%';
                    ApplicationArea = all;
                }

                field("Line Amount"; Rec."Line Amount")
                {
                    ToolTip = 'Specifies the value of the Line Amount field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ToolTip = 'Specifies the value of the Line Discount Amount field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Charge ID"; Rec."Charge ID")
                {
                    ToolTip = 'Specifies the value of the Charge ID field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Invoicing CBM"; Rec."Invoicing CBM")
                {
                    ToolTip = 'Specifies the value of the Invoicing CBM field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Invoicing Qty"; rec."Invoicing Qty")
                {
                    ToolTip = 'Specifies the value of the Invoicing Quantity field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Invoice Type"; Rec."Invoice Type")
                {
                    ToolTip = 'Specifies the value of the Invoice Type field.', Comment = '%';
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
        if IMSSetup."Warehouse Activated" = false then
            Error('Warehouse functionality is not activated for %1', CompanyName);
    end;
}
