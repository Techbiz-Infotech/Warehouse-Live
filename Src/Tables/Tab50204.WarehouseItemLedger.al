table 50204 "Warehouse Item Ledger Entry"
{
    Caption = 'Warehouse Item Ledger Entry';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(4; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(5; "Shelf No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Customs No."; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
        field(8; Weight; Decimal)
        {
            Caption = 'Weight';
            DataClassification = ToBeClassified;
        }
        field(9; CBM; Decimal)
        {
            Caption = 'CBM';
            DataClassification = ToBeClassified;
        }
        field(10; "Open"; Boolean)
        {
            Caption = 'Open';
            DataClassification = ToBeClassified;
        }
        field(11; "Consignee No."; Code[20])
        {
            Caption = 'Consignee No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(12; "Consignee Name"; Text[100])
        {
            Caption = 'Consignee Name ';
            DataClassification = ToBeClassified;
        }
        field(13; "Consignment Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Clearing Agent"; Code[20])
        {
            Caption = 'Clearing Agent';
            TableRelation = "Clearing Agent";
            DataClassification = ToBeClassified;
        }
        field(15; "Clearing Agent Name"; Text[100])
        {
            Caption = 'Clearing Agent Name';
            DataClassification = ToBeClassified;
        }
        field(16; "Location Type"; enum "Location Type")
        {
            Caption = 'Location Type';
            DataClassification = ToBeClassified;
        }
        field(17; "Warehouse Entry Type"; enum "Warehouse Entry Type")
        {
            Caption = 'Warehouse Entry Type';
            DataClassification = ToBeClassified;
        }
        field(18; "Chargable CBM/Weight"; Decimal)
        {
            Caption = 'Chargable CBM/Weight';
            DataClassification = ToBeClassified;
        }
        field(19; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            DataClassification = ToBeClassified;
        }
        field(20; "Remaining Quantity"; Decimal)
        {
            Caption = 'Remaining Quantity';
            DataClassification = ToBeClassified;

        }
        field(21; "Remaining CBM/Weight"; Decimal)
        {
            Caption = 'Remaining CBM/Weight';
            DataClassification = ToBeClassified;
        }
        field(22; "Invoicing Quantity"; Decimal)
        {
            Caption = 'Invoicing Quantity';
            DataClassification = ToBeClassified;
        }
        field(23; "Invoicing CBM/Weight"; Decimal)
        {
            Caption = 'Invoicing CBM/Weight';
            DataClassification = ToBeClassified;
        }
        field(24; "Positive"; Boolean)
        {
            Caption = 'Positive';
            DataClassification = ToBeClassified;
        }
        field(25; "Applied Document No."; Code[20])
        {
            Caption = 'Applied Document No.';
            DataClassification = ToBeClassified;
        }
        field(26; "Applied Document Line No."; Integer)
        {
            Caption = 'Applied Document Line No.';
            DataClassification = ToBeClassified;
        }
        field(27; "Description Of The Goods"; Text[250])
        {
            Caption = 'Description Of The Goods';
            DataClassification = ToBeClassified;
        }
        field(28; "Age in No. of Days"; Integer)
        {
            Caption = 'Age in No. of Days';
            DataClassification = ToBeClassified;
        }
        field(29; "Remaining Consignment Value"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Remaining Consignment Value';

        }
        field(30; "Weight/CBM"; Decimal)
        {
            Caption = 'Weight/CBM';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(31; TEUs; Integer)
        {
            Caption = 'TEUs';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(32; "Container Size"; Enum "Container Size")
        {
            Caption = 'Container Size';
            DataClassification = ToBeClassified;
        }
        field(33; "Invoiced CBM/Weight"; Decimal)
        {
            Caption = 'Invoiced CBM/Weight';
            DataClassification = ToBeClassified;
        }
        field(34; "Remaining Bond value"; Decimal)
        {
            Caption = 'Remaining Bond value';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(35; "Chargeable warehouse Periods"; Integer)
        {
            Caption = 'Chargeable warehouse Periods';
            DataClassification = ToBeClassified;
        }
        field(36; "Stripped Qty"; Decimal)
        {
            Caption = 'Stripped Qty';
            DataClassification = ToBeClassified;
        }
        field(37; "Invoicing WH Stripped Qty"; Decimal)
        {
            Caption = 'Invoicing WH Stripped Qty';
            DataClassification = ToBeClassified;
        }
        field(38; "Remaining WH Stripped Qty"; Decimal)
        {
            Caption = 'Remaining WH Stripped Qty';
            DataClassification = ToBeClassified;
        }
        
        field(40; "Invoiced WH Stripped Qty"; Decimal)
        {
            Caption = 'Invoiced WH Stripped Qty';
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
