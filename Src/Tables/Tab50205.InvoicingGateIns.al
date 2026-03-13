table 50205 "Invoicing Gate Ins"
{
    Caption = 'Invoicing Gate Ins';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Activity Date"; Date)
        {
            Caption = 'Activity Date';
            DataClassification = ToBeClassified;
        }
        field(3; "Gate In No."; Code[20])
        {
            Caption = 'Gate In No.';
            DataClassification = ToBeClassified;
            TableRelation = "Warehouse Item Ledger Entry";
        }
        field(4; "Gate In Line No."; Integer)
        {
            Caption = 'Gate In Line No.';
            DataClassification = ToBeClassified;
        }
        field(5; "Description Of The Goods"; Text[250])
        {
            Caption = 'Description Of The Goods';
            DataClassification = ToBeClassified;
        }
        field(7; "Proforma Invoice No."; Code[20])
        {
            Caption = 'Proforma Invoice No.';
            DataClassification = ToBeClassified;
        }
        field(8; "Posted Invoice No."; Code[20])
        {
            Caption = 'Posted Invoice No.';
            DataClassification = ToBeClassified;
        }
        field(9; "Consignee No."; Code[20])
        {
            Caption = 'Consignee No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
            trigger OnValidate()
            var
                CustomerRec: Record Customer;
            begin
                if CustomerRec.Get("Consignee No.") then
                    "Consignee Name" := CustomerRec.Name
                else
                    "Consignee Name" := '';
            end;
        }
        field(10; "Consignee Name"; Text[100])
        {
            Caption = 'Consignee Name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(12; Posted; Boolean)
        {
            Caption = 'Posted';
            DataClassification = ToBeClassified;
        }
        field(13; "Invoicing Quantity"; Decimal)
        {
            Caption = 'Invoicing Quantity';
            DataClassification = ToBeClassified;
        }
        field(14; "Invoicing CBM/Weight"; Decimal)
        {
            Caption = 'Invoicing CBM/Weight';
            DataClassification = ToBeClassified;
        }
        field(15; "Warehouse Entry No."; Integer)
        {
            Caption = 'Warehouse Entry No.';
            DataClassification = ToBeClassified;
        }
        field(16; "Reversed"; Boolean)
        {
            Caption = 'Reversed';
            DataClassification = ToBeClassified;
        }
        field(17; "Posted Credit Memo No."; Code[20])
        {
            Caption = 'Posted Credit Memo No.';
            DataClassification = ToBeClassified;
        }
        field(18; "Gated Out"; Boolean)
        {
            Caption = 'Gated Out';
            DataClassification = ToBeClassified;
        }
        field(19; "Gate Out No."; Code[20])
        {
            Caption = 'Gate Out No.';
            DataClassification = ToBeClassified;
        }
        field(20; "Gate Out Date"; Date)
        {
            Caption = 'Gate Out Date';
            DataClassification = ToBeClassified;
        }
        field(21; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(22; "Location Type"; enum "Location Type")
        {
            Caption = 'Location Type';
            DataClassification = ToBeClassified;
        }
        field(23; "Consignment Value Released"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Consignment Value Released';
        }
        field(24; "Invoice Type"; Enum "Invoice Type")
        {
            DataClassification = ToBeClassified;
            Caption = 'Invoice Type';
        }
        field(25; "Gate In Charges"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Gate In Charges';
        }
        field(26; "Gate Out Charges"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Gate Out Charges';
        }
        field(27; "Container Size"; Enum "Container Size")
        {
            Caption = 'Container Size';
            DataClassification = ToBeClassified;
        }
        field(28; "Chargeable warehouse Periods"; Integer)
        {
            Caption = 'Chargeable warehouse Periods';
            DataClassification = ToBeClassified;
        }
        field(29; "Chargeable ReWarehouse Periods"; Integer)
        {
            Caption = 'Chargeable Re-warehouse Periods';
            DataClassification = ToBeClassified;
        }
        field(30; "Customs Entry No."; Code[20])
        {
            Caption = 'Customs Entry No.';
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