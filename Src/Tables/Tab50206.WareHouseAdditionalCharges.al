table 50206 "WareHouse Additional Charges"
{
    Caption = 'WareHouse Additional Charges';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Gate In No."; Code[20])
        {
            Caption = 'Gate In No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Charges Code"; Code[20])
        {
            Caption = 'Charge Code';
            DataClassification = ToBeClassified;
            TableRelation = Item;
            trigger OnValidate()
            var
                WHAddChg: Record "WareHouse Additional Charges";
            begin

            end;
        }

        field(4; Rate; Decimal)
        {
            Caption = 'Rate';
            DataClassification = ToBeClassified;
        }
        field(5; "Invoice Type"; Enum "Invoice Type")
        {
            Caption = 'Invoice Type';
            DataClassification = ToBeClassified;

        }
    }
    keys
    {
        key(PK; "Gate In No.", "Line No.")
        {
            Clustered = true;
        }
    }
}


