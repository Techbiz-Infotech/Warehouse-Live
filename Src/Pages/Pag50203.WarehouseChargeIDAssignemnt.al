page 50203 "Warehouse Charge ID Assignemnt"
{
    //ApplicationArea = All;
    Caption = 'Warehouse Charge ID Assignemnt';
    PageType = List;
    SourceTable = "Warehouse ChargeID Assignment";
    //UsageCategory = Lists; 


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Charge Id Group Code"; Rec."Charge Id Group Code")
                {
                    ToolTip = 'Specifies the value of the Charge Id Group Code field.';
                    ApplicationArea = All;
                }
                field("Charge Type"; rec."Charge Type")
                {
                    ToolTip = 'Specifies the value of the Charge Type field.';
                    ApplicationArea = all;
                }
                field("Business Type"; Rec."Business Type")
                {
                    ToolTip = 'Specifies the value of the Business Type field.';
                    ApplicationArea = All;
                }
                field("Effective From Date"; Rec."Effective From Date")
                {
                    ToolTip = 'Specifies the value of the Effective From Date field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        myInt: Integer;
                        ChargeAssignment: Record "Warehouse ChargeID Assignment";
                    begin
                        ChargeAssignment.Reset();
                        ChargeAssignment.SetRange("Customer No.", rec."Customer No.");
                        ChargeAssignment.SetRange("Clearing Agent Code", Rec."Clearing Agent Code");
                        ChargeAssignment.SetFilter("Effective From Date", '<=%1', Rec."Effective From Date");
                        ChargeAssignment.SetFilter("Effective To Date", '>=%1', Rec."Effective From Date");
                        if ChargeAssignment.FindFirst() then
                            Error('Period already exist.\ Please check and enter correct Date.!');
                    end;
                }
                field("Effective To Date"; Rec."Effective To Date")
                {
                    ToolTip = 'Specifies the value of the Effective To Date field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        myInt: Integer;
                        ChargeAssignment: Record "Warehouse ChargeID Assignment";
                    begin
                        ChargeAssignment.Reset();
                        ChargeAssignment.SetRange("Customer No.", rec."Customer No.");
                        ChargeAssignment.SetFilter("Effective From Date", '>=%1', Rec."Effective to Date");
                        ChargeAssignment.SetFilter("Effective To Date", '<=%1', Rec."Effective to Date");
                        if ChargeAssignment.FindFirst() then
                            Error('Date period already exist./ Please check and enter correct Date.!');
                    end;
                }
                field("Clearing Agent Code"; rec."Clearing Agent Code")
                {
                    Caption = 'Clearing Agent Code';
                    ApplicationArea = all;
                    trigger OnValidate()
                    var

                        ChargeAssignment: Record "Warehouse ChargeID Assignment";
                    begin
                        //SH
                        ChargeAssignment.Reset();
                        ChargeAssignment.SetRange("Customer No.", rec."Customer No.");
                        ChargeAssignment.SetFilter("Effective From Date", '=%1', Rec."Effective From Date");
                        ChargeAssignment.SetFilter("Effective To Date", '=%1', Rec."Effective to Date");
                        ChargeAssignment.SetRange("Clearing Agent Code", Rec."Clearing Agent Code");
                        if ChargeAssignment.FindFirst() then
                            Error('Combination with same clearing agent is already exist. / Please check and enter Clearing agent again.!');
                        //SH
                    end;
                }
                field(Status; Rec.Status)
                {
                    Caption = 'Charge group Approval Status';
                    ApplicationArea = All;
                }
                field("Assignment Status"; Rec."Assignment Status")
                {
                    Caption = 'Charge ID Assignment Status';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Send Approval Request")
            {
                ApplicationArea = all;
                Caption = 'Send Approval Request';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = SendApprovalRequest;
                trigger OnAction()
                var
                    EventsCU: Codeunit "Warehouse Event Handler";

                begin
                    UpdateChargeType();
                    Rec.TestField("Charge Id Group Code");
                    Rec.TestField("Business Type");
                    Rec.TestField("Effective From Date");
                    Rec.TestField("Effective To Date");
                    Rec.CalcFields(Status);
                    Rec.TestField(Status, Rec.Status::Released);
                    rec.TestField("Clearing Agent Code");
                    //Rec.TestField("Assignment Status", Rec."Assignment Status"::Open);
                    if Rec."Charge Type" = Rec."Charge Type"::" " then
                        Error('Charge type must have a value');
                    if Rec."Charge Type" = Rec."Charge Type"::Standard then begin
                        Rec."Assignment Status" := Rec."Assignment Status"::Released;
                        Rec.Modify();
                    end;
                    EventsCU.OnSendWHChargeAssignmentforApproval(Rec);
                end;
            }
            group(Action21)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action(Release)
                {
                    ApplicationArea = Suite;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    Visible = true;
                    ShortCutKey = 'Ctrl+F9';
                    ToolTip = 'Release the document to the next stage of processing. You must reopen the document before you can make changes to it.';

                    trigger OnAction()
                    begin
                        if (UserId <> 'GROUP.AUDIT') and (UserId <> 'TECHBIZINFOTECH') then begin
                            Error('You are not Authorised. Please Contact Group Audit');
                        end else begin
                            Rec."Assignment Status" := Rec."Assignment Status"::Released;
                            Rec.Modify();
                        end;
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Re&open';
                    Enabled = Rec."Assignment Status" <> Rec."Assignment Status"::Open;
                    Image = ReOpen;
                    Promoted = true;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';

                    trigger OnAction()
                    begin
                        if rec."Assignment Status" <> Rec."Assignment Status"::"Pending Approval" then begin
                            Rec."Assignment Status" := Rec."Assignment Status"::Open;
                            Rec.Modify();
                        end;
                    end;
                }
                action(UpdateChargeType1)
                {
                    ApplicationArea = Suite;
                    Caption = 'Update Charge Type';
                    Image = ReleaseDoc;
                    Promoted = true;
                    Visible = true;
                    ShortCutKey = 'Ctrl+F9';
                    ToolTip = 'Release the document to the next stage of processing. You must reopen the document before you can make changes to it.';

                    trigger OnAction()
                    var
                        ChargeGroup: Record "Charge ID Group Header";
                        ChargeIDAssign: Record "Charge ID Assignment";
                    begin

                        ChargeIDAssign.Reset();
                        if ChargeIDAssign.FindFirst() then
                            repeat
                                if ChargeGroup.Get(ChargeIDAssign."Charge Id Group Code") then begin
                                    ChargeIDAssign."Charge Type" := ChargeGroup."Charge Type";
                                    ChargeIDAssign.Modify();
                                end;
                            until ChargeIDAssign.Next() = 0;

                    end;
                }
            }
        }
    }

    local procedure UpdateChargeType()
    var
        ChargeGroup: Record "Charge ID Group Header";
        ChargeIDAssign: Record "Charge ID Assignment";
    begin

        ChargeIDAssign.Reset();
        if ChargeIDAssign.FindFirst() then
            repeat
                if ChargeGroup.Get(ChargeIDAssign."Charge Id Group Code") then begin
                    ChargeIDAssign."Charge Type" := ChargeGroup."Charge Type";
                    ChargeIDAssign.Modify();
                end;
            until ChargeIDAssign.Next() = 0;

    end;
}

