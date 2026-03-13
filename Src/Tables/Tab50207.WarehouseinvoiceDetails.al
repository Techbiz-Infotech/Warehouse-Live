table 50207 WarehouseinvoiceDetails
{
    Caption = 'WarehouseinvoiceDetails';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(3; "Document Type"; Enum "Document Type")
        {
            Caption = 'Document Type';
        }
        field(4; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(5; "Gate In No."; Code[20])
        {
            Caption = 'Gate In No.';
        }
        field(6; "Gate In Line No."; Integer)
        {
            Caption = 'Gate In Line No.';
        }
        field(7; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(8; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
        }
        field(9; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
        }
        field(10; "Line Discount Amount"; Decimal)
        {
            Caption = 'Line Discount Amount';
        }
        field(11; "Charge ID"; Code[20])
        {
            Caption = 'Charge ID';
        }
        field(12; "Invoicing Qty"; Decimal)
        {
            Caption = 'Invoicing Qty';
        }
        field(13; "Invoicing CBM"; Decimal)
        {
            Caption = 'Invoicing CBM';
        }
        field(14; "Invoice Type"; Enum "Invoice Type")
        {
            Caption = 'Invoice Type';
        }
        field(15; "Container Size"; Enum "Container Size")
        {
            Caption = 'Conatiner Size';
            DataClassification = ToBeClassified;
            
        }
         field(16; "Chargeable warehouse Periods"; Integer)
        {
            Caption = 'Chargeable warehouse Periods';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
