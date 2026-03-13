tableextension 50151 "Charge Group LineExt" extends "Charge ID Group Line"
{
    fields
    {
        field(50116; "WH Calculation Days"; Decimal)
        {
            Caption = 'Warehouse Charges Calculation Days';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Rec.TestStatusOpen();
            end;
        }
        field(50117; "Storage Minimum Charges"; Decimal)
        {
            Caption = 'Storage Minimum Charges';

            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Rec.TestStatusOpen();
            end;
        }
        field(50118; "Calculation Type"; Enum "Calculation Type")
        {
            Caption = 'Calculation Type';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Rec.TestStatusOpen();
            end;
        }
        field(50119; "Container Size"; Enum "Container Size")
        {
            Caption = 'Container Size';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Rec.TestStatusOpen();
            end;
        }
    }
}
