report 50160 "Pending WH GateOut Line"
{
    //ApplicationArea = All;
    Caption = 'Pending Warehouse GateOut Line';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Src/Reports/Layouts/Pending Warehouse GateOut Line.rdlc';
    dataset
    {
        dataitem("Gate Out Header"; "WH Gate Out Header")

        {
            RequestFilterFields = "Gate Out No.";
            column(CompanyLogo; CompanyInfo.Picture) { }
            column(CompanyName; CompanyInfo.Name) { }
            column(Location_Type; "Location Type") { }
            column(CpatnLbl; CpatnLbl) { }
            column(PhoneNo; CompanyInfo."Phone No.") { }
            column(Postcode; CompanyInfo."Post Code") { }
            column(GateOutNoCptnLbl; GateOutNoCptnLbl) { }
            column(Gate_Out_No_; "Gate Out No.") { }
            column(DateCptnLbl; DateCptnLbl) { }
            column(Gate_Out_Date; "Activity Date") { }
            column(ConsigneeNoCptnlbl; ConsigneeNoCptnlbl) { }
            column(Consignee_No_; "Consignee No.") { }
            column(ConsigneeNameCptnlbl; ConsigneeNameCptnlbl) { }
            column(Consignee_Name; "Consignee Name") { }
            column(ConsignmentValueCptnlbl; ConsignmentValueCptnlbl) { }
            column(Consignment_Value; "Consignment Value to release") { }
            column(ClearingAgentCptnlbl; ClearingAgentCptnlbl) { }
            column(Clearing_Agent_; "Clearing Agent") { }
            column(ClearingAgentNameCptnlbl; ClearingAgentNameCptnlbl) { }
            column(Clearing_Agent_Name; "Clearing Agent Name") { }
            column(CustomsNoCptnlbl; CustomsNoCptnlbl) { }
            column(Customs_No_; "Customs No.") { }
            column(TransporterCptnlbl; TransporterCptnlbl) { }
            column(Transporter; Transporter) { }
            column(Text001; Text001) { }
            column(text002; text002) { }
            column(text003; text003) { }
            column(text004; text004) { }
            column(text005; text005) { }
            column(text006; text006) { }

            dataitem("Gate Out Line"; "WH Gate Out Line")
            {
                DataItemLinkReference = "Gate Out Header";
                DataItemLink = "Gate Out No." = field("Gate Out No.");
                column(Item_No_; "Item No.") { }
                column(Description_Of_The_Goods; "Description Of The Goods") { }
                column(Gate_Out_No_Line; "Gate Out No.") { }
                column(Location_Code; "Location Code") { }
                column(Shelf_No_; "Shelf No.") { }
                column(Driver_ID; "Driver ID") { }
                column(Tranporter_Driver_Name; "Transporter/Driver Name") { }
                column(Truck_No_; "Truck No.") { }
                column(Agent_Port_Pass; "Agent Port Pass") { }
                column(Quantity; "Invoiced Quantity") { }
                column(Weight; "Gate In Weight") { }
                column(CBM; "Invoiced CBM/Weight") { }
                column(Invoice_No_; "Invoice No.") { }
                column(Gate_In_CBM; "Gate In CBM") { }
                column(Additional_Remarks; "Additional Remarks") { }
                column(Receipt_No_; "Receipt No.") { }

            }
            trigger OnAfterGetRecord()
            var
            begin
                if "Gate Out Header"."Location Type" = "Gate Out Header"."Location Type"::"Bonded Warehouse" then
                    CpatnLbl := 'Bonded Warehouse Gate pass Out';
                if "Gate Out Header"."Location Type" = "Gate Out Header"."Location Type"::"Free Warehouse" then
                    CpatnLbl := 'Free warehouse Gate Pass Out';
            end;


        }
    }
    var
        CompanyInfo: Record "Company Information";
        Text001: Label 'WH - Gate Pass';
        CpatnLbl: Text[50];
        text002: Label 'Released To';
        text003: Label 'Prepared By';
        text004: Label 'Authorized By';
        text005: Label 'Customs Release';
        text006: Label 'Releasing Officer';
        PrintedOn: DateTime;
        GateOutNoCptnLbl: Label 'Gate Out No. :';
        DateCptnLbl: Label 'Gate Out Date :';
        ConsigneeNoCptnlbl: Label 'Consignee No. :';
        ConsigneeNameCptnlbl: Label 'Consignee Name :';
        ConsignmentValueCptnlbl: Label 'Consignment Value To Release :';
        ClearingAgentCptnlbl: Label 'Clearing Agent :';
        ClearingAgentNameCptnlbl: Label 'Clearing Agent Name :';
        CustomsNoCptnlbl: Label 'Customs No. :';
        TransporterCptnlbl: Label 'Transporter :';

    trigger OnInitReport()
    begin
        CompanyInfo.get;
        CompanyInfo.CalcFields(Picture)
    end;
}




