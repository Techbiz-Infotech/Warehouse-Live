report 50207 "Sales-Invoice-WH"
{
    Caption = 'Sales-Invoice-WH';
    DefaultLayout = RDLC;
    RDLCLayout = './Src/Reports/Layouts/SalesInvoiceWH.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    PreviewMode = PrintLayout;
    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales Invoice';
            column(No_SalesInvHeader; "No.")
            { }
            column(Gate_In_No_; "Gate In No.") { }

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

            column(Sell_to_Customer_Name_SalesInvoiceHeader; "Sell-to Customer Name")
            {

            }
            column(GateInNoCptnlbl; GateInNoCptnlbl) { }
            column(CustomsNoCptnlbl; CustomsNoCptnlbl) { }
            column(ConsignmentValueCptnlbl; ConsignmentValueCptnlbl) { }
            column(Gate_In_No; WHGateinhaederRec."Gate In No.") { }
            column(Customs_No; "Customs Entry No.") { }
            column(Consignment_Value; "Consignment Value") { }
            column(Posting_Date; "Posting Date")
            { }
            column(ISBonedwarehouse; ISBonedwarehouse) { }
            column(Amount; Amount)
            {
                AutoFormatExpression = GetCurrencySymbol();
                AutoFormatType = 1;
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

            column(ClearingAgent; WHGateinhaederRec."Clearing Agent Name")
            { }
            column(Consignee_Name; WHGateinhaederRec."Consignee Name")
            { }
            column(CompanyLogo; CompanyInfo.Picture)
            { }
            column(CaptionKsh; CaptionKsh)
            { }
            column(LineDiscAmount; LineDiscAmount)
            { }
            column(ValueKsh; ValueKsh)
            { }




            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Sales Invoice Header";
                DataItemTableView = sorting("Document No.", "Line No.");
                column(Description_SalesInvoiceLine; Description)
                { }
                column(Unit_Price_SalesInvoiceLine; "Unit Price")
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
                column(Line_No_; "Line No.") { }
                column(Gate_In_No_line; "Gate In No.") { }
                column(Charge_ID; "Charge ID")
                { }
                column(HSCode; HSCode)
                { }

                trigger OnAfterGetRecord()
                begin
                    GateinheaderRec.Reset();
                    GateinheaderRec.SetRange("Gate In No.", "Sales Invoice Header"."Gate In No.");
                    if GateinheaderRec.FindFirst() then;
                    ManifestLineinfo.Reset();
                    ManifestLineinfo.SetRange("Global Dimension 1 Code", "Sales Invoice Line"."Shortcut Dimension 1 Code");
                    if ManifestLineinfo.FindFirst() then;
                    IMSSetup.Get();
                    if ("Sales Invoice Line".Type = "Sales Invoice Line".Type::Item) or ("Sales Invoice Line".Type = "Sales Invoice Line".Type::"G/L Account") then begin
                        IF "Sales Invoice Line"."VAT Prod. Posting Group" = 'EXEMPT' then
                            HSCode := IMSSetup."Default HS Code";
                        IF "Sales Invoice Line"."VAT Prod. Posting Group" = 'ZERO' then
                            HSCode := IMSSetup."Default HS Code Zero rated";
                    end;
                    ISBonedwarehouse := "Sales Invoice Header"."Location Type" = "Sales Invoice Header"."Location Type"::"Bonded Warehouse";
                end;
            }
            // trigger OnPreDataItem()
            // begin
            //     GLsetUp.get;
            // end;


            trigger OnAfterGetRecord()
            begin
                VATAmount := "Amount Including VAT" - Amount;
                Clear(LineDiscAmount);
                SaleInvLine.Reset();
                SaleInvLine.SetRange("Document No.", "Sales Invoice Header"."No.");
                if SaleInvLine.FindFirst() then
                    repeat
                        LineDiscAmount += SaleInvLine."Line Discount Amount";
                    until SaleInvLine.next = 0;
                WHGateinhaederRec.Reset();
                WHGateinhaederRec.SetRange("Consignee No.", "Sales Invoice Header"."Bill-to Customer No.");
                WHGateinhaederRec.SetRange("Gate In No.", "Sales Invoice Header"."Gate In No.");
                if WHGateinhaederRec.FindFirst() then;
            end;
        }


    }

    var
        myInt: Integer;
      //  manifestheaderInfo: Record "Manifest Header";
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
        SalesInvoiceLine: Record "Sales Invoice Line";
        GroupByContainerID: code[20];
        SaleInvLine: Record "Sales Invoice Line";
        SaleInvHeader: Record "Sales Invoice Header";
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
        WHGateinhaederRec: Record "WH Gate In Header";
        GateInNoCptnlbl: Label 'Gate In No:';
        CustomsNoCptnlbl: Label 'Customs No:';
        ConsignmentValueCptnlbl: Label 'Consignment Value:';

        VATLCY: Decimal;
        VATFCY: Decimal;

        CaptionKsh: text[50];
        ValueKsh: Text[50];
        IMSSetup: Record "IMS Setup";
        HSCode: Code[20];
        ISBonedwarehouse: Boolean;

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
