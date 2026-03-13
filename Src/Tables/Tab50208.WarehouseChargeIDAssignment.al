table 50208 "Warehouse ChargeID Assignment"
{
    Caption = 'Warehouse ChargeID Assignment';
    DataClassification = ToBeClassified;
    LookupPageId = "Warehouse Charge ID Assignemnt";
    DrillDownPageId = "Warehouse Charge ID Assignemnt";

    fields
    {
        field(1; "Customer No."; code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(2; "Charge Id Group Code"; Code[20])
        {
            Caption = 'Charge Id Group Code';
            DataClassification = ToBeClassified;
            TableRelation = "Charge ID Group Header";
            trigger OnValidate()
            var
                ChargeGroup: Record "Charge ID Group Header";
                chargeAssign: Record "Charge ID Assignment";
            begin
                Rec.TestStatusOpen();
                if ChargeGroup.get("Charge Id Group Code") then begin
                    if ChargeGroup.Status <> ChargeGroup.Status::Released then
                        Error('Charge Group is not approved');
                    if ChargeGroup."Charge Type" = ChargeGroup."Charge Type"::" " then
                        Error('Charge type should be there on Charge ID Group %1', ChargeGroup."Charge ID Group Code");
                    Rec.Validate("Charge Type", ChargeGroup."Charge Type");
                end;
            end;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Rec.TestStatusOpen();
            end;
        }

        field(8; "Effective From Date"; Date)
        {
            Caption = 'Effective From Date';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Rec.TestStatusOpen();
            end;
        }
        field(9; "Effective To Date"; Date)
        {
            Caption = 'Effective To Date';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Rec.TestStatusOpen();
            end;
        }
        field(10; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Rec.TestStatusOpen();
            end;
        }
        field(11; "Status"; Enum CGStatusEnum)
        {
            Caption = 'Status';
            FieldClass = FlowField;
            CalcFormula = lookup("Charge ID Group Header".Status where("Charge ID Group Code" = field("Charge Id Group Code")));
            Editable = false;
            trigger OnValidate()
            begin
                Rec.TestStatusOpen();
            end;
        }
        field(12; "Assignment Status"; Enum CGStatusEnum)
        {
            Caption = 'Assignment Approval Status';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "Charge Type"; Enum "Charge Type")
        {
            Caption = 'Charge Type';
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            begin
            end;
        }
        field(14; "Clearing Agent Code"; Code[20])
        {
            Caption = 'Clearing Agent Code';
            DataClassification = ToBeClassified;
            TableRelation = "Clearing Agent";
        }
        field(15; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No.")));
        }
        field(16; "Business Type"; Enum "Business Type")
        {
            Caption = 'Business Type';
            dataclassification = ToBeClassified;
        }
        field(43; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = ToBeClassified;
            TableRelation = User."User Name";
        }
    }
    keys
    {
        key(PK; "Customer No.", "Charge Id Group Code")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        myInt: Integer;
    begin
        Rec."User ID" := UserId;
    end;



    procedure TestStatusOpen()
    begin

        Rec.TestField("Assignment Status", "Assignment Status"::Open);
    end;
}




