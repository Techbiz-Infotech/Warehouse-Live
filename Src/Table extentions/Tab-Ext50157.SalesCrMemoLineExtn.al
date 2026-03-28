tableextension 50157 "Sales Cr.Memo Line Extn" extends "Sales Cr.Memo Line"
{
    fields
    {
        field(50124; "Business Type"; Enum "Business Type")
        {
            Caption = 'Business Type';
            dataclassification = ToBeClassified;
        }
        field(50125; "Gate In No."; Code[20])
        {
            Caption = 'Gate In No.';
            DataClassification = ToBeClassified;
            TableRelation = "WH Gate In Header" where("Consignee No." = field("Sell-to Customer No."), Posted = const(true));
        }
        field(50126; "Gate In Line No."; Integer)
        {
            Caption = 'Gate In Line No.';
            DataClassification = ToBeClassified;
            //TableRelation = "WH Gate In Header" where("Consignee No." = field("Sell-to Customer No."),Posted = const(true));
        }
        field(50127; "Invoicing Quantity"; Decimal)
        {
            Caption = 'Invoicing Quantity';
            DataClassification = ToBeClassified;
        }
        field(50128; "Invoicing CBM/Weight"; Decimal)
        {
            Caption = 'Invoicing CBM/Weight';
            DataClassification = ToBeClassified;
        }
        field(50129; Warehouse; Boolean)
        {
            Caption = 'Warehouse';
            dataclassification = ToBeClassified;
        }
        field(50130; "Invoice Type"; Enum "Invoice Type")
        {
            Caption = 'Invoice Type';
            DataClassification = ToBeClassified;
        }
        field(50131; "Container Size"; Enum "Container Size")
        {
            Caption = 'Container Size';
            DataClassification = ToBeClassified;
        }
        field(50132; "Chargeable warehouse Periods"; Integer)
        {
            Caption = 'Chargeable warehouse Periods';
            DataClassification = ToBeClassified;
        }
        field(50133; "Chargeable ReWarehouse Periods"; Integer)
        {
            Caption = 'Chargeable Re-warehouse Periods';
            DataClassification = ToBeClassified;
        }
        field(50134; "Consignment Value"; Decimal)
        {
            Caption = 'Consigenment Value';
            DataClassification = ToBeClassified;
        }
        field(50135; "Customs Entry No."; Code[20])
        {
            Caption = 'Customs Entry No.';
            DataClassification = ToBeClassified;
        }
        
        field(50136; "Invoicing WH Stripped Qty"; Integer)
        {
            Caption = 'Invoicing WH Stripped Qty';
            DataClassification = ToBeClassified;
            Editable = false;
        }
       
    }
}
