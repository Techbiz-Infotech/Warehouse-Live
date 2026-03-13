report 50203 SalesCrMemoWH
{
    ApplicationArea = All;
    Caption = 'Sales Credit Memo WH';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Src/Reports/Layouts/SalesCrMemoWH.rdlc';
    PreviewMode = PrintLayout;
    dataset
    {
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales CrMemo';
            column(No_SalesCrHeader; "No.")
            { }
            column(Created_By_User_ID; "Created By User ID")
            { }
            column(VATAmount; VATAmount)
            { }
            column(VAT_Registration_No_; "VAT Registration No.") { }
            column(SystemCreatedAt; SystemCreatedAt) { }
            column(SystemCreatedBy; "User ID") { }
            column(CBM; CBM) { }
            column(Weight_G; Weight_G) { }


            column(CurrencyCap; CurrencyCap)
            { }
            column(TotalAmt; TotalAmt)
            { }
            column(RateExh; RateExh)
            { }
            column(VATFCY; VATFCY)
            { }

            column(Sell_to_Customer_Name_SalesCrMemoHeader; "Sell-to Customer Name")
            {

            }
            column(GateInNoCptnlbl; GateInNoCptnlbl) { }
            column(CustomsNoCptnlbl; CustomsNoCptnlbl) { }
            column(ConsignmentValueCptnlbl; ConsignmentValueCptnlbl) { }
            column(Gate_In_No; WHGateinheaderRec."Gate In No.") { }
            column(Customs_No; "Customs Entry No.") { }
            column(Consignment_Value; "Consignment Value") { }
            column(Posting_Date; "Posting Date")
            { }
            column(Amount; Amount)
            {
                // AutoFormatExpression = GetCurrencySymbol();
                // AutoFormatType = 1;
            }
            column(Amount_Including_VAT; "Amount Including VAT")
            {
            }
            //23/11/
            column(CompanyAddress1; CompanyInfo.Address) { }
            column(CompanyAddress2; CompanyInfo."Address 2")
            { }
            column(CompanyPhone; CompanyInfo."Phone No.")
            { }
            column(CompanyEmail; CompanyInfo."E-Mail")
            { }
            column(CompanyVATNo; CompanyInfo."VAT Registration No.")
            { }
            //**
            column(ClearingAgent; WHGateinheaderRec."Clearing Agent Name")
            { }
            column(Consignee_Name; WHGateinheaderRec."Consignee Name")
            { }
            column(CompanyLogo; CompanyInfo.Picture)
            { }
            column(CaptionKsh; CaptionKsh)
            { }
            column(LineDiscAmount; LineDiscAmount)
            { }
            column(ValueKsh; ValueKsh)
            { }




            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Sales Cr.Memo Header";
                DataItemTableView = sorting("Document No.", "Line No.");
                column(Description_SalesCrLine; Description)
                { }
                column(Unit_Price_SalesCrLine; "Unit Price")
                { }
                column(Quantity; Quantity)
                { }
                column(Line_Discount_Amount; "Line Discount Amount")
                { }
                // column(Amount;Amount){}
                column(VAT_Base_Amount; "VAT Base Amount")
                { }
                column(Line_Amount; "Line Amount")
                { }


                column(VAT__; "VAT %")
                { }
                column(ItemNo; "No.")
                { }

                column(Totalwaiver; Totalwaiver)
                { }
                column(Rate; Rate)
                { }
                column(Charge_ID; "Charge ID")
                { }
                column(HSCode; HSCode)
                { }

                trigger OnAfterGetRecord()
                begin
                    GateinheaderRec.Reset();
                    GateinheaderRec.SetRange("Gate In No.", "Sales Cr.Memo Header"."Gate In No.");
                    if GateinheaderRec.FindFirst() then;
                    ManifestLineinfo.Reset();
                    ManifestLineinfo.SetRange("Global Dimension 1 Code", "Sales Cr.Memo Line"."Shortcut Dimension 1 Code");
                    if ManifestLineinfo.FindFirst() then;
                    IMSSetup.Get();
                    if ("Sales Cr.Memo Line".Type = "Sales Cr.Memo Line".Type::Item) or ("Sales Cr.Memo Line".Type = "Sales Cr.Memo Line".Type::"G/L Account") then begin
                        IF "Sales Cr.Memo Line"."VAT Prod. Posting Group" = 'EXEMPT' then
                            HSCode := IMSSetup."Default HS Code";
                        IF "Sales Cr.Memo Line"."VAT Prod. Posting Group" = 'ZERO' then
                            HSCode := IMSSetup."Default HS Code Zero rated";
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                VATAmount := "Amount Including VAT" - Amount;
                Clear(LineDiscAmount);
                SalesCrMemoLine.Reset();
                SalesCrMemoLine.SetRange("Document No.", "Sales Cr.Memo Header"."No.");
                if SalesCrMemoLine.FindFirst() then
                    repeat
                        LineDiscAmount += SalesCrMemoLine."Line Discount Amount";
                    until SalesCrMemoLine.next = 0;
                WHGateinheaderRec.Reset();
                WHGateinheaderRec.SetRange("Consignee No.", "Sales Cr.Memo Header"."Bill-to Customer No.");
                WHGateinheaderRec.SetRange("Gate In No.", "Sales Cr.Memo Header"."Gate In No.");
                if WHGateinheaderRec.FindFirst() then;
            end;
        }


    }

    var
        myInt: Integer;
        //manifestheaderInfo: Record "Manifest Header";
        manifestLineInfo: Record "Manifest Line";
        GateinheaderRec: Record "WH Gate In Header";
        CompanyInfo: Record "Company Information";
        GLsetUp: Record "General Ledger Setup";
        TotalKSHToPAy: Decimal;
        TotalUSDtopay: Decimal;
        Totalwaiver: decimal;
        Rate: Decimal;
        GrossUSD: Decimal;
        GrossKshs: Decimal;
        VATInKshs: Decimal;
        VATAmount: Decimal;
        VATInUSD: Decimal;
        RateExh: Decimal;
        ManifestLine: Record "Manifest Line";
        GroupByContainerID: code[20];
        CountOfContainer: integer;
        CurrencyCap: Code[20];
        TotalAmt: Decimal;
        CustomerRec: Record Customer;
        CurrencyExc: Record "Currency Exchange Rate";
        GROSSGROSSFCYF: Decimal;
        GROSSLCY: Decimal;
        LineDiscAmount: Decimal;
        Weight_G: Decimal;
        CBM: Decimal;
        WHGateinheaderRec: Record "WH Gate In Header";
        GateInNoCptnlbl: Label 'Gate In No:';
        CustomsNoCptnlbl: Label 'Customs No:';
        ConsignmentValueCptnlbl: Label 'Consignment Value:';

        VATLCY: Decimal;
        VATFCY: Decimal;

        CaptionKsh: text[50];
        ValueKsh: Text[50];
        IMSSetup: Record "IMS Setup";
        HSCode: Code[20];
        SalesCrMemoLine: Record "Sales Cr.Memo Line";


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

