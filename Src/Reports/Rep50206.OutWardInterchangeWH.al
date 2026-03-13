report 50206 "OutWard Interchange - WH"
{
    Caption = 'OutWard Interchange - WH';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './Src/Reports/Layouts/OutWard Interchange-WH.rdlc';
    dataset
    {
        dataitem("WH Gate Out Header"; "WH Gate Out Header")
        {
            RequestFilterFields = "Gate Out No.";
            column(Gate_Out_No_; "Gate Out No.") { }
            column(Activity_Date; "Activity Date") { }
            column(Consignee_Name; "Consignee Name") { }
            column(Clearing_Agent_Name; "Clearing Agent Name") { }
            column(CompanyInflogo; CompanyInfo.Picture) { }
            // column(Clearing_Agent; GetClearingAgentName("Clearing Agent")) { }
            column(Customs_No; GatepassOutRec."Customs No.") { }
            dataitem("Gate Out Line"; "WH Gate Out Line")
            {
                DataItemLinkReference = "WH Gate Out Header";
                DataItemLink = "Gate Out No." = field("Gate Out No.");
                column(Description_Of_The_Goods; "Description Of The Goods") { }
                column(Location_Code; "Location Code") { }
                column(Shelf_No_; "Shelf No.") { }
                column(Invoice_No_; "Invoice No.") { }
                column(Additional_Remarks; "Additional Remarks") { }
                column(Quantity; "Invoiced Quantity") { }
                column(Weight; "Gate In Weight") { }
                column(CBM; "Invoiced CBM/Weight") { }
            }
        }
    }
    var
        CompanyInfo: Record "Company Information";
        GatepassOutRec: Record "WH Gate Out Header";
        GatepasslineRec: Record "WH Gate Out Line";

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    procedure GetClearingAgentName(ClearingAgent: Code[20]) ClearingAgentName: Text[100]
    var
        ClearingAgentRec: Record "Clearing Agent";
        GateOutRec: Record "WH Gate Out Header";
    begin
        IF GateOutRec."Location Type" = GateOutRec."Location Type"::"Bonded Warehouse" then
            ClearingAgentName := GateOutRec."Clearing Agent Name"
        else
            ClearingAgentName := '';
    end;



}
