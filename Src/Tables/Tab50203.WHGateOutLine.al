table 50203 "WH Gate Out Line"
{
    Caption = 'Warehouse Gate Out Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Gate Out No."; Code[20])
        {
            Caption = 'Gate Out No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
            TableRelation = Item;
        }
        field(4; "Description Of The Goods"; Text[250])
        {
            Caption = 'Description Of The Goods';
            DataClassification = ToBeClassified;
        }
        field(5; "Invoiced Quantity"; Decimal)
        {
            Caption = 'Invoiced Quantity';
            DataClassification = ToBeClassified;
        }
        field(6; "Shelf No."; Code[20])
        {
            Caption = 'Shelf No.';
            DataClassification = ToBeClassified;
        }
        field(7; "Gate In Weight"; Decimal)
        {
            Caption = 'Gate In Weight';
            DataClassification = ToBeClassified;
        }
        field(8; "Gate In CBM"; Decimal)
        {
            Caption = 'Gate In CBM';
            DataClassification = ToBeClassified;
        }
        field(9; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(10; "Gate In Reference No."; Code[20])
        {
            Caption = 'Gate In Reference No.';
            DataClassification = ToBeClassified;
        }
        field(11; "Gate In Reference Line No."; Integer)
        {
            Caption = 'Gate In Reference Line No.';
            DataClassification = ToBeClassified;
        }
        field(12; "Invoiced CBM/Weight"; Decimal)
        {
            Caption = 'Invoiced CBM/Weight';
            DataClassification = ToBeClassified;
        }
        field(13; "Additional Remarks"; Text[250])
        {
            Caption = 'Additional Remarks';
            DataClassification = ToBeClassified;
        }
        field(14; "Gate In Quantity"; Decimal)
        {
            Caption = 'Gate In Quantity';
            DataClassification = ToBeClassified;
        }
        field(15; "Activity Date"; Date)
        {
            Caption = 'Activity Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(16; "Activity Time"; Time)
        {
            Caption = 'Activity Time';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(17; "Gate Out Status"; Enum "Active/In-Active Enum")
        {
            Caption = 'Gate Out Status';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(18; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(19; "Invoice Date"; Date)
        {
            Caption = 'Invoice Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(20; "Receipt No."; Code[20])
        {
            Caption = 'Receipt No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(21; "Truck No."; Code[20])
        {
            Caption = 'Truck No.';
            DataClassification = ToBeClassified;
        }
        field(22; "Agent Name"; Text[20])
        {
            Caption = 'Agent Name';
            DataClassification = ToBeClassified;
        }
        field(23; "Agent Port Pass"; Code[20])
        {
            Caption = 'Agent Port Pass';
            DataClassification = ToBeClassified;
        }
        field(24; "Transporter/Driver Name"; Text[40])
        {
            Caption = 'Transporter/Driver Name';
            DataClassification = ToBeClassified;
        }
        field(25; "Trailer No."; Code[20])
        {
            Caption = 'Trailer No.';
            DataClassification = ToBeClassified;
        }
        field(26; Released; Boolean)
        {
            Caption = 'Released';
            DataClassification = ToBeClassified;
            //Editable = false;
        }
        field(27; "Released Date"; Date)
        {
            Caption = 'Released Date';
            DataClassification = ToBeClassified;
            //Editable = false;
        }
        field(28; "Released Time"; Time)
        {
            Caption = 'Released Time';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(29; "Expired Date"; Date)
        {
            Caption = 'Expired Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(30; "Expired Time"; Time)
        {
            Caption = 'Expired Time';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(31; "Driver ID"; Text[20])
        {
            Caption = 'Driver ID';
            DataClassification = ToBeClassified;
            //Editable = false;
        }

        field(33; "Customs No."; Code[20])
        {
            Caption = 'Customs Entry No.';
            DataClassification = ToBeClassified;
        }
        field(34; "Posted"; Boolean)
        {
            Caption = 'Posted';
            DataClassification = ToBeClassified;
        }
        field(35; "Consignment Value"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Consignment Value';
        }
        field(36; "Releasing CBM/Weight"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Releasing CBM/Weight';
        }
        field(37; "Chargeable warehouse Periods"; Integer)
        {
            Caption = 'Chargeable warehouse Periods';
            DataClassification = ToBeClassified;
        }


    }
    keys
    {
        key(PK; "Gate Out No.", "Line No.")
        {
            Clustered = true;
        }
    }
    procedure PostWarehouseGateOut()
    var
        WHLedgerEntry1, WHLedgerEntry : Record "Warehouse Item Ledger Entry";
        GateOutLine: Record "WH Gate Out Line";
        WHGateOut: Record "WH Gate out Header";
        EntryNo: Integer;
        InvoicingGateIn: Record "Invoicing Gate Ins";
    begin
        if Confirm('Do you want to release ?', false) then begin
            WHGateOut.Reset();
            WHGateOut.SetRange("Gate Out No.", rec."Gate Out No.");
            if WHGateOut.FindFirst() then;
            GateOutLine.Reset();
            GateOutLine.SetRange("Gate Out No.", rec."Gate Out No.");
            GateOutLine.SetRange("Line No.", Rec."Line No.");
            if GateOutLine.FindFirst() then begin
                repeat
                    WHLedgerEntry1.Reset();
                    if WHLedgerEntry1.FindLast() then
                        EntryNo := WHLedgerEntry1."Entry No." + 1
                    else
                        EntryNo := 1;
                    WHLedgerEntry.Init();
                    WHLedgerEntry.Validate("Entry No.", EntryNo);
                    WHLedgerEntry.Validate("Warehouse Entry Type", WHLedgerEntry."Warehouse Entry Type"::Outward);
                    WHLedgerEntry.Validate("Posting Date", GateOutLine."Activity Date");
                    WHLedgerEntry.Validate("Document No.", GateOutLine."Gate Out No.");
                    WHLedgerEntry.Validate("Location Code", GateOutLine."Location Code");
                    WHLedgerEntry.Validate("Consignee No.", WHGateOut."Consignee No.");
                    WHLedgerEntry.Validate("Consignee Name", WHGateOut."Consignee Name");
                    WHLedgerEntry.Validate("Consignment Value", -WHGateOut."Consignment Value to release");
                    WHLedgerEntry.Validate("Location Type", WHGateOut."Location Type");
                    WHLedgerEntry.Validate("Document Line No.", GateOutLine."Line No.");
                    WHLedgerEntry.Validate("Clearing Agent", WHGateOut."Clearing Agent");
                    WHLedgerEntry.Validate("Clearing Agent Name", WHGateOut."Clearing Agent Name");
                    WHLedgerEntry.Validate("Location Type", WHGateOut."Location Type");
                    WHLedgerEntry.Validate("Shelf No.", GateOutLine."Shelf No.");
                    WHLedgerEntry.Validate("Customs No.", GateOutLine."Customs No.");
                    WHLedgerEntry.Validate(Quantity, GateOutLine."Invoiced Quantity");
                    WHLedgerEntry.Validate("Applied Document No.", GateOutLine."Gate In Reference No.");
                    WHLedgerEntry.Validate("Applied Document Line No.", GateOutLine."Gate In Reference Line No.");
                    WHLedgerEntry.Validate(Quantity, -GateOutLine."Invoiced Quantity");
                    //SH 02/25/2025
                    WHLedgerEntry.Validate("Weight/CBM", -GateOutLine."Releasing CBM/Weight");
                    WHLedgerEntry.Validate("Invoiced CBM/Weight", -GateOutLine."Invoiced CBM/Weight");
                    //SH 02/25/2025
                    //2/27/2025
                    WHLedgerEntry.Validate("Remaining Bond value", WHGateOut."Remaining Bond value");
                    WHLedgerEntry.Validate("Chargeable warehouse Periods", GateOutLine."Chargeable warehouse Periods");
                    //2/27/2025
                    WHLedgerEntry.Insert();
                    InvoicingGateIn.Reset();
                    InvoicingGateIn.SetRange("Posted Invoice No.", GateOutLine."Invoice No.");
                    InvoicingGateIn.SetRange("Gate In No.", GateOutLine."Gate In Reference No.");
                    InvoicingGateIn.SetRange("Gate In Line No.", GateOutLine."Gate In Reference Line No.");
                    if InvoicingGateIn.FindFirst() then
                        repeat
                            InvoicingGateIn."Gate Out Date" := WHGateOut."Activity Date";
                            InvoicingGateIn."Gate Out No." := WHGateOut."Gate Out No.";
                            InvoicingGateIn."Consignment Value Released" := WHGateOut."Consignment Value to Release";
                            InvoicingGateIn."Gated Out" := true;
                            InvoicingGateIn.Modify();
                        until InvoicingGateIn.Next() = 0;
                until GateOutLine.Next() = 0;
                Rec.Released := true;
                Rec."Released Date" := today();
                Rec."Released Time" := Time;
                Rec.Modify();
                Message('Warehouse Gate Out Line Released successfully');
            end;
        end;
    end;

    procedure GetReceiptNo()
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        ApplyCustLedgEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry.Reset();
        CustLedgEntry.SetRange("Document No.", "Invoice No.");
        CustLedgEntry.SetRange(Open, false);
        IF CustLedgEntry.FindFirst() then begin
            ApplyCustLedgEntry.Reset();
            ApplyCustLedgEntry.SetRange("Entry No.", CustLedgEntry."Closed by Entry No.");
            if ApplyCustLedgEntry.FindFirst() then begin
                "Receipt No." := ApplyCustLedgEntry."Document No.";
                Modify();
            end;
        end else
            error('Receipt No. not found');
    end;

}