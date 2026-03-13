report 50201 "Warehouse - GateIn"
{
    Caption = 'Warehouse - Gate In Order';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Src/Reports/Layouts/Warehouse - GateIn Report.rdlc';
    dataset
    {
        dataitem("WH Gate In Header"; "WH Gate In Header")
        {
            RequestFilterFields = "Gate In No.";
            column(CompanyLogo; CompanyInfo.Picture) { }
            column(CompanyName; CompanyInfo.Name) { }
            column(CpatnLbl; CpatnLbl) { }
            column(PhoneNo; CompanyInfo."Phone No.") { }
            column(salesPerson; "Shortcut Dimension 3 Code") { }
            column(Postcode; CompanyInfo."Post Code") { }
            column(SalesPersonCaptn; SalesPersonCaptn) { }
            column(GateInNoCptnLbl; GateInNoCptnLbl) { }
            column(Gate_In_No_; "Gate In No.") { }
            column(DateCptnLbl; DateCptnLbl) { }
            column(Gate_In_Date; "Activity Date") { }
            column(ConsigneeNoCptnlbl; ConsigneeNoCptnlbl) { }
            column(Consignee_No_; "Consignee No.") { }
            column(ConsigneeNameCptnlbl; ConsigneeNameCptnlbl) { }
            column(Consignee_Name; "Consignee Name") { }
            column(ConsignmentValueCptnlbl; ConsignmentValueCptnlbl) { }
            column(ConsignValue; "Consignment Value") { }
            column(ClearingAgentCptnlbl; ClearingAgentCptnlbl) { }
            column(Clearing_Agent; "Clearing Agent") { }
            column(ClearingAgentNameCptnlbl; ClearingAgentNameCptnlbl) { }
            column(Clearing_Agent_Name; "Clearing Agent Name") { }
            column(CustomsNoCptnlbl; CustomsNoCptnlbl) { }
            column(Customs_No_; "Customs No.") { }
            column(TruckNoCptnlbl; TruckNoCptnlbl) { }
            column(Truck_No_; "Truck No.") { }
            column(LocationTyprCptnlbl; LocationTyprCptnlbl) { }
            column(Location_Type; "Location Type") { }
            column(AdditionalRemarksCptnlbl; AdditionalRemarksCptnlbl) { }
            column(Text001; Text001) { }
            column(text002; text002) { }
            column(text003; text003) { }
            column(text004; text004) { }
            column(text005; text005) { }
            column(text006; text006) { }
            dataitem("Gate In Line"; "WH Gate In Line")
            {
                DataItemLinkReference = "WH Gate In Header";
                DataItemLink = "Gate In No." = field("Gate In No.");
                column(Item_No_; "Item No.") { }
                column(Description_Of_The_Goods; "Description Of The Goods") { }
                column(Chargable_CBM_Weight; "Chargable CBM/Weight") { }
                column(Location_Code; "Location Code") { }
                column(Shelf_No_; "Shelf No.") { }
                column(Quantity; Quantity) { }
                column(Weight; Weight) { }
                column(CBM; CBM) { }
                column(Additional_RemarksLine; "Additional Remarks") { }
            }
            trigger OnAfterGetRecord()
            var
            begin
                if "WH Gate In Header"."Location Type" = "WH Gate In Header"."Location Type"::"Bonded Warehouse" then
                    CpatnLbl := 'Bonded Warehouse Gate pass In';
                if "WH Gate In Header"."Location Type" = "WH Gate In Header"."Location Type"::"Free Warehouse" then
                    CpatnLbl := 'Free warehouse Gate Pass In';
            end;
        }
    }
    var
        CompanyInfo: Record "Company Information";
        Text001: Label 'WH - Gate Pass';
        text002: Label 'Released To';
        text003: Label 'Prepared By';
        text004: Label 'Authorized By';
        text005: Label 'Customs Release';
        text006: Label 'Releasing Officer';
        PrintedOn: DateTime;
        GateInNoCptnLbl: Label 'Gate In No. :';
        DateCptnLbl: Label 'Gate InDate :';
        BlNocptnlbl: Label 'BL No. :';
        ConsigneeNoCptnlbl: Label 'Consignee No. :';
        ConsigneeNameCptnlbl: Label 'Consignee Name :';
        ConsignmentValueCptnlbl: Label 'Consignment Value :';
        JobFIleNoCptnlbl: Label 'Job FIle No. :';
        CpatnLbl: Text[50];
        JobFileDateCptnlbl: Label 'Job File Date :';
        ClearingAgentCptnlbl: Label 'Clearing Agent :';
        ClearingAgentNameCptnlbl: Label 'Clearing Agent Name :';
        CustomsNoCptnlbl: Label 'Customs No. :';
        TruckNoCptnlbl: Label 'Truck No. :';
        LocationTyprCptnlbl: Label 'Location Type :';
        AdditionalRemarksCptnlbl: Label 'Additional Remarks :';
        SalesPersonCaptn: Label 'Sales Person:';

    trigger OnInitReport()
    begin
        CompanyInfo.get;
        CompanyInfo.CalcFields(Picture)
    end;
}
