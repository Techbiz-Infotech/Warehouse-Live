report 50202 "Proforma-Invoice WH"
{
    Caption = 'Warehouse Proforma-Invoice';
    DefaultLayout = RDLC;
    RDLCLayout = './Src/Reports/Layouts/ProformaInvoiceWH.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    PreviewMode = PrintLayout;
    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";

            column(Sell_to_Customer_Name; "Sell-to Customer Name") { }
            column(MPESAAccount; CompanyInfo."MPESA Account")
            { }
            column(HeadCaptionLbl; HeadCaptionLbl) { }
            column(SystemCreatedAt; SystemCreatedAt) { }
            column(No_; "No.") { }
            column(Created_By_User_ID; "Created By User ID") { }
            column(GateInNoCptnlbl; GateInNoCptnlbl) { }
            column(CustomsNoCptnlbl; CustomsNoCptnlbl) { }
            column(ConsignmentValueCptnlbl; ConsignmentValueCptnlbl) { }
            column(Gate_In_No; "Sales Header"."Gate In No.") { }
            column(Customs_No; "Customs Entry No.") { }

            column(Consignment_Value; "Consignment Value") { }
            column(Posting_Date; "Posting Date") { }
            column(Amount_Including_VAT; "Amount Including VAT")
            {
                AutoFormatExpression = GetCurrencySymbol();
                AutoFormatType = 1;
            }
            column(Location_Type; "Location Type") { }
            column(Amount; Amount) { }
            column(ISBonedwarehouse; ISBonedwarehouse) { }

            column(CompanyLogo; CompanyInfo.Picture) { }
            column(BankAccountName; CompanyInfo."Bank Account Name") { }
            column(LCYAccount1; CompanyInfo."LCY Account 1") { }
            column(LCYAccount2; CompanyInfo."LCY Account 2") { }
            column(FCYAccount1; CompanyInfo."FCY Account 1") { }
            column(FCYAccount2; CompanyInfo."FCY Account 2") { }
            column(BankAccountNo; CompanyInfo."Bank Account No.") { }
            column(SwiftCode; CompanyInfo."SWIFT Code") { }
            column(BranchCode; CompanyInfo."Bank Branch No.") { }
            column(BankName; CompanyInfo."Bank Name") { }
            column(LineDiscAmount; LineDiscAmount) { }
            column(VATAmount; VATAmount) { }
            column(portDischarge; manifestLineInfo."Port of Discharge") { }
            column(TotalKSHToPAY; TotalKSHToPAY) { }
            column(GrossKshs; GrossKshs) { }
            column(GrossUSD; GrossUSD) { }
            column(VATInKshs; VATInKshs) { }
            column(TotalUSDtopay; TotalUSDtopay) { }
            column(VATInUSD; VATInUSD) { }
            column(Totalwaiver; Totalwaiver) { }
            column(Rate; Rate) { }
            column(Currency_Code; "Currency Code") { }
            column(CurrencyCap; CurrencyCap) { }
            column(TotalAmt; TotalAmt) { }
            column(RateExh; RateExh) { }
            column(Invoicing_Quantity; QTY) { }
            column(Invoicing_CBM_Weight; CBMwt) { }
            column(Activity_Date; InvoiceGateInsREc."Activity Date") { }
            column(ConsigneeName; WHGateinhaederRec."Consignee Name") { }
            column(ShortcutDimension1Code; SalesLineRec."Shortcut Dimension 1 Code") { }
            column(BLNo; "BL No.") { }
            column(Text001; Text001) { }
            column(text002; text002) { }
            column(Text003; Text003)
            { }
            column(Text004; Text004)
            { }
            column(Text005; Text005)
            { }
            column(Text006; Text006)
            { }
            column(Text007; Text007)
            { }
            column(Text008; Text008)
            { }
            column(Text009; Text009)
            { }
            column(Text010; Text010)
            { }
            column(Text011; Text011)
            { }
            column(text012; text012)
            { }
            column(Text013; Text013)
            { }
            column(Text014; Text014)
            { }
            column(Text015; Text015)
            { }
            column(ClearingAgent; WHGateinhaederRec."Clearing Agent Name")
            { }



            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLinkReference = "Sales Header";
                DataItemLink = "Document No." = field("No.");

                DataItemTableView = sorting("Document No.", "Line No.");
                column(Description_SalesInvoiceLine; Description)
                { }
                column(Unit_Price_SalesInvoiceLine; "Unit Price")
                { }
                column(Quantity; Quantity)
                { }
                column(Line_Discount_Amount; "Line Discount Amount")
                { }
                column(VAT_Base_Amount; "VAT Base Amount")
                { }
                column(Line_Amount; "Line Amount")
                { }
                column(Activity_Dateline; InvoiceGateInsREc."Activity Date") { }
                column(VAT__; "VAT %")
                { }
                column(InvBL_No; "BL No.")

                { }
                column(Gate_In_No_; "Gate In No.") { }

                column(Container_No__Chassis_No_; "Container No./Chassis No.")
                { }
                column(Shortcut_Dimension_1_Code; "Container No./Chassis No.")
                { }
                column(Shortcut_Dimension_5_Code; "Shortcut Dimension 5 Code")
                { }
                column(Free_Days; freedays)
                { }
                column(Storage_Days; storageDays)
                { }
                column(StorageStarts; StorageStarts)
                { }
                column(No_SalesLineNo; "No.")
                { }
                column(Weight; manifestlineinfo.Weight)
                { }
                column(Line_No_; "Line No.") { }
                column(DateReceived; manifestLineInfo."Date Received") { }
                column(CBM_Tonage; manifestLineInfo."CBM Tonage")
                { }
                column(Seal_Engine_No_; manifestlineinfo."Seal/Engine No.")
                { }
                column(Description; manifestlineinfo.Description)
                { }
                column(Consignee_Name; manifestlineinfo."Consignee Name")
                { }
                column(ItemNo; "No.")
                { }

                column(Charge_ID; "Charge ID")
                { }

            }

            trigger OnAfterGetRecord()
            var
            begin
                VATAmount := ("Amount Including VAT" - Amount);
                Clear(LineDiscAmount);
                SalesLineRec.Reset();
                SalesLineRec.SetRange("Document Type", "Document Type"::Order);
                SalesLineRec.SetRange("Document No.", "Sales Header"."No.");
                if SalesLineRec.FindFirst() then
                    repeat
                        LineDiscAmount += SalesLineRec."Line Discount Amount";
                    until SalesLineRec.next = 0;
                WHGateinhaederRec.Reset();
                WHGateinhaederRec.SetRange("Gate In No.", "Sales Header"."Gate In No.");
                if WHGateinhaederRec.FindFirst() then;

                Clear(QTY);
                Clear(CBMwt);

                InvoiceGateInsREc.Reset();
                InvoiceGateInsREc.SetRange("Proforma Invoice No.", "Sales Header"."No.");
                if "Sales Header"."Location Type" = "Sales Header"."Location Type"::"Free Warehouse" then begin
                    if "Sales Header"."Invoice Type" <> "Sales Header"."Invoice Type"::"Gate Out" then
                        InvoiceGateInsREc.SetRange("Gate In No.", "Sales Header"."Gate In No.");
                end else begin
                    if "Sales Header"."Location Type" = "Sales Header"."Location Type"::"Bonded Warehouse" then
                        InvoiceGateInsREc.SetRange("Gate In No.", "Sales Header"."Gate In No.");
                end;
                if InvoiceGateInsREc.Findset() then begin
                    repeat
                        QTY += InvoiceGateInsREc."Invoicing Quantity";
                        CBMwt += InvoiceGateInsREc."Invoicing CBM/Weight";
                    until InvoiceGateInsREc.Next() = 0;
                end;
                ISBonedwarehouse := "Sales Header"."Location Type" = "Sales Header"."Location Type"::"Bonded Warehouse";
            end;
        }

    }
    var

        WHGateinhaederRec: Record "WH Gate In Header";
        WHGateinLineRec: Record "WH Gate In Line";
        myInt: Integer;
        chargIDLine: Record "Charge ID Group Line";
        // manifestheaderInfo: Record "Manifest Header";
        manifestLineInfo: Record "Manifest Line";
        CompanyInfo: Record "Company Information";
        TotalKSHTOPAY: Decimal;
        TotalUSDTOPAY: Decimal;
        QTY: Decimal;
        CBMwt: Decimal;
        Totalwaiver: decimal;
        Rate: Decimal;
        GrossUSD: Code[20];
        GrossKshs: Decimal;
        VATInKshs: Decimal;
        VATAmount: Decimal;
        VATInUSD: Decimal;
        ActualStorageStarts, StorageStarts : Date;
        CountOfContainer: Integer;
        CountOfUnits: Integer;
        Countofloose: Decimal;

        GroupByContainerID: code[20];
        ExchangeRate: Decimal;
        RateExh: Decimal;
        StorageDays, Freedays : Decimal;
        CurrencyCap: Code[20];
        TotalAmt: Decimal;
        CurrencyExc: Record "Currency Exchange Rate";
        ChargeIDinfo: Record "Charge ID Group Header";
        SalesLine2, SalesLineRec : Record "Sales Line";
        Text001: label 'We advise that you make any';
        text002: Label 'Cash Deposits';
        Text003: Label 'or';
        InvoiceGateInsREc: Record "Invoicing Gate Ins";
        GateInNoCptnlbl: Label 'Gate In No :';
        CustomsNoCptnlbl: Label 'Customs No :';
        ConsignmentValueCptnlbl: Label 'Consignment Value :';

        LineDiscAmount: Decimal;

        Text004: Label 'RTGS';
        Text005: Label 'to the following bank accounts only. Deliver all other payments in';
        HeadCaptionLbl: Label '**This is not a Tax Invoice and should not be used to file KRA VAT returns';
        Text006: Label 'Bankers CHQ';
        Text007: Label 'to the cashier';
        Text008: Label 'Nairobi Inland Cargo Terminal Ltd';
        Text009: Label 'Transnational Bank (K) Ltd';
        Text010: Label 'City Hall Way';
        Text011: Label '0210397001';
        text012: Label '0210397002';
        Text013: Label 'TNBLKENA';
        Text014: Label '26';
        Text015: Label '001';
        ISBonedwarehouse: Boolean;
    //ExchangeRate: Record "Currency Exchange Rate";
    procedure GetClearingAgentName(Clearingagent: Code[20]) ClearingAgentName: text[100]
    var
        myInt: Integer;
        ClearingAgentRec: Record "Clearing Agent";
    begin
        if ClearingAgentRec.get(Clearingagent) then
            ClearingAgentName := ClearingAgentRec."Clearing Agent Name"
        else
            ClearingAgentName := '';
    end;

    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture)
    end;
}
