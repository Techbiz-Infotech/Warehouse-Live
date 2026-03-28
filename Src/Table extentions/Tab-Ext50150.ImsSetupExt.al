tableextension 50150 ImsSetupExt extends "IMS Setup"
{
    fields
    {       
         field(50139; "Gate In Nos."; Code[20])
        {
            Caption = 'Gate In Nos.';
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
        }
        field(50140; "Gate Out Nos."; Code[20])
        {
            Caption = 'Gate Out Nos.';
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
        }
        field(50141; "Default Item No. WH"; Code[20])
        {
            Caption = 'Default Item No. for Warehouse';
            TableRelation = item;
            DataClassification = ToBeClassified;
        }
        field(50142; "Warehouse Allowed Limit"; Decimal)
        {
            Caption = 'Warehouse Allowed Limit';
            DataClassification = ToBeClassified;
        }
        field(50143; "Warehouse Available Limit"; Decimal)
        {
            Caption = 'Warehouse Available Limit';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50144; "Category for Bond Acceptance"; Code[20])
        {
            Caption = 'Category Code for Bond Acceptance';
            TableRelation = "Item Category";
            DataClassification = ToBeClassified;
        }
        field(50145; "Category for Re-Warehouse"; Code[20])
        {
            Caption = 'Category Code for Re-Warehouse';
            TableRelation = "Item Category";
            DataClassification = ToBeClassified;
        }

        field(50146; "Re WareHousing Days"; Integer)
        {
            Caption = 'Re-Warehousing Days';
            DataClassification = ToBeClassified;
        }
        field(50147; "Category for Warehouse Storage"; Code[20])
        {
            Caption = 'Category Code for Warehouse Storage';
            TableRelation = "Item Category";
            DataClassification = ToBeClassified;
        }
        field(50148; "Category for Bond Cancellation"; Code[20])
        {
            Caption = 'Category Code for Bond Cancellation';
            TableRelation = "Item Category";
            DataClassification = ToBeClassified;
        }

        field(50149; "20FT"; Decimal)
        {
            Caption = '20FT CBM';
            DataClassification = ToBeClassified;
        }
        field(50150; "Warehouse Activated"; Boolean)
        {
            Caption = 'Warehouse Activated';
            DataClassification = ToBeClassified;
        }
         field(50151; "Category for Customs Exam"; Code[20])
        {
            Caption = 'Category Code for Customs Examination';
            TableRelation = "Item Category";
            DataClassification = ToBeClassified;
        }
        //   field(50152; "40FT CBM"; Decimal)
        // {
        //     Caption = '40FT CBM';
        //     DataClassification = ToBeClassified;
        // }
 field(50153; "Rewarehouse Per Entry Charge"; Decimal)
        {
            Caption = 'Rewarehouse Per Entry Charge';
            DataClassification = ToBeClassified;
        }
field(50154; "BIF"; Integer)
        {
            Caption = 'BIF';
            DataClassification = ToBeClassified;
        }
    }
    procedure UpdateWHValues()
    var
        Qty, CRQty, CBMWt, CRCBMWt, ConsignValue, CRConsignValue, InConValue, OutConValue : Decimal;
        WHLedgerEntry1, WHLedgerEntry2, WHLedgerEntry3, WHLedgerEntry4 : Record "Warehouse Item Ledger Entry";
        PostedgateInheader: Record "WH Gate In Header";
        PostedGateoutheader: Record "WH Gate Out Header";
        IMSSetup: Record "IMS Setup";
    begin
        WHLedgerEntry1.Reset();
        WHLedgerEntry1.SetRange("Warehouse Entry Type", WHLedgerEntry1."Warehouse Entry Type"::Inward);
        if WHLedgerEntry1.FindFirst() then
            repeat
                Clear(Qty);
                Clear(CBMWt);
                Clear(ConsignValue);

                WHLedgerEntry2.Reset();
                WHLedgerEntry2.SetRange("Warehouse Entry Type", WHLedgerEntry2."Warehouse Entry Type"::Outward);
                WHLedgerEntry2.SetRange("Applied Document No.", WHLedgerEntry1."Document No.");
                WHLedgerEntry2.SetRange("Applied Document Line No.", WHLedgerEntry1."Document Line No.");
                if WHLedgerEntry2.FindFirst() then
                    repeat
                        Qty += WHLedgerEntry2.Quantity;
                        CBMWt += WHLedgerEntry2."Weight/CBM";
                        ConsignValue += WHLedgerEntry2."Consignment Value";
                    until WHLedgerEntry2.Next() = 0;
                Clear(CRQty);
                clear(CRCBMWt);
                Clear(CRConsignValue);
                WHLedgerEntry3.Reset();
                WHLedgerEntry3.SetRange("Warehouse Entry Type", WHLedgerEntry3."Warehouse Entry Type"::"Credit Memo");
                WHLedgerEntry3.SetRange("Applied Document No.", WHLedgerEntry1."Document No.");
                WHLedgerEntry3.SetRange("Applied Document Line No.", WHLedgerEntry1."Document Line No.");
                if WHLedgerEntry3.FindFirst() then
                    repeat
                        CRQty += WHLedgerEntry3.Quantity;
                        CRCBMWt += WHLedgerEntry3."Weight/CBM";
                        CRConsignValue += WHLedgerEntry3."Consignment Value";
                    until WHLedgerEntry3.Next() = 0;

                WHLedgerEntry1."Remaining Quantity" := WHLedgerEntry1.Quantity + Qty + CRQty;
                WHLedgerEntry1."Remaining WH Stripped Qty" := WHLedgerEntry1."Stripped Qty" - WHLedgerEntry1."Invoicing WH Stripped Qty";
                WHLedgerEntry1."Remaining CBM/Weight" := WHLedgerEntry1."Weight/CBM" + CBMWt + CRCBMWt;
                WHLedgerEntry1."Remaining Consignment Value" := WHLedgerEntry1."Consignment Value" + ConsignValue + CRConsignValue;
                WHLedgerEntry1."Age in No. of Days" := WorkDate() - WHLedgerEntry1."Posting Date";
                WHLedgerEntry1.Modify();
            until WHLedgerEntry1.Next() = 0;

        Clear(OutConValue);
        Clear(InConValue);
        PostedgateInheader.Reset();
        PostedgateInheader.SetRange("Location Type", PostedgateInheader."Location Type"::"Bonded Warehouse");
        PostedgateInheader.SetRange(Posted, true);
        if PostedgateInheader.FindFirst() then
            repeat
                InConValue += PostedgateInheader."Consignment Value";
            until PostedgateInheader.Next() = 0;
        Postedgateoutheader.Reset();
        Postedgateoutheader.SetRange("Location Type", Postedgateoutheader."Location Type"::"Bonded Warehouse");
        PostedGateoutheader.SetRange(Reversed, false);
        PostedGateoutheader.SetRange(Posted, true);
        if Postedgateoutheader.FindFirst() then
            repeat
                OutConValue += Postedgateoutheader."Consignment Value to Release";
            until Postedgateoutheader.Next() = 0;
        IMSSetup.Get();
        IMSSetup."Warehouse Available Limit" := (IMSSetup."Warehouse Allowed Limit" - InConValue) + OutConValue;
        IMSSetup.Modify();
    end;

}
 
    
    

