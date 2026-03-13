tableextension 50154 "Sales Header Extn" extends "Sales Header"
{
    fields
    {
        field(50121; "Business Type"; Enum "Business Type")
        {
            Caption = 'Business Type';
            dataclassification = ToBeClassified;
        }
        field(50122; "Gate In No."; Code[20])
        {
            Caption = 'Gate In No.';
            DataClassification = ToBeClassified;
            TableRelation = "WH Gate In Header" where("Consignee No." = field("Sell-to Customer No."), Posted = const(true));
        }
        // field(50123; Warehouse; Boolean)
        // {
        //     Caption = 'Warehouse';
        //     dataclassification = ToBeClassified;
        // }
        field(50124; "Invoice Type"; Enum "Invoice Type")
        {
            Caption = 'Invoice Type';
            dataclassification = ToBeClassified;
        }
        field(50125; "Consignment Value"; Decimal)
        {
            Caption = 'Consignment Value';
            DataClassification = ToBeClassified;

        }
        field(50126; "Customs Entry No."; Code[20])
        {
            Caption = 'Customs Entry No.';
            DataClassification = ToBeClassified;

        }
        field(50127; "Location Type"; enum "Location Type")
        {
            Caption = 'Location Type';
            DataClassification = ToBeClassified;
        }


    }
    procedure GetGateInDetails()
    var
        WHLedger: Record "Warehouse Item Ledger Entry";
        SalesHead: Record "Sales Header";
        DimValRec: Record "Dimension Value";
    begin
        WHLedger.Reset();
        WHLedger.SetRange("Document No.", Rec."Gate In No.");
        if WHLedger.FindFirst() then begin
            rec."Gate In No." := WHLedger."Document No.";
            rec.Modify();
        end else begin
            rec."Gate In No." := '';
            rec.Modify();
        end;
    end;
}
