page 50216 "WH Gate Out Order"
{
    Caption = 'Warehouse Gate Out Order';
    PageType = Document;
    SourceTable = "WH Gate Out Header";


    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Gate In No."; Rec."Gate Out No.")
                {
                    ToolTip = 'Specifies the value of the Gate In No. field.';
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Gate In Date"; Rec."Activity Date")
                {
                    ToolTip = 'Specifies the value of the Gate In Date field.';
                    ApplicationArea = All;
                }
                field("Activity Time"; Rec."Activity Time")
                {
                    ToolTip = 'Specifies the value of the Gate In Date field.';
                    ApplicationArea = All;
                }
                field("Consignee No."; Rec."Consignee No.")
                {
                    ToolTip = 'Specifies the value of the Consignee No. field.';
                    ApplicationArea = All;
                }
                field("Consignee Name "; Rec."Consignee Name")
                {
                    ToolTip = 'Specifies the value of the Consignee Name  field.';
                    ApplicationArea = All;
                }
                field("Location Type"; rec."Location Type")
                {
                    ToolTip = 'Specifies the value of the Location Type field.';
                    ApplicationArea = All;
                }
                field("Consignment Value"; Rec."Consignment Value to Release")
                {
                    ToolTip = 'Specifies the value of the Consignment Value field.';
                    ApplicationArea = All;
                    Enabled = Rec."Location Type" = Rec."Location Type"::"Bonded Warehouse";
                }
                field("Clearing Agent"; Rec."Clearing Agent")
                {
                    ToolTip = 'Specifies the value of the Clearing Agent field.';
                    ApplicationArea = All;
                }
                field("Clearing Agent Name"; Rec."Clearing Agent Name")
                {
                    ToolTip = 'Specifies the value of the Clearing Agent Name field.';
                    ApplicationArea = All;
                    Editable = false;
                }

                // field("Customs No."; Rec."Customs No.")
                // {
                //     ToolTip = 'Specifies the value of the Customs No. field.';
                //     ApplicationArea = All;
                // }

                field("Shortcut Dimension 3 Code"; rec."Shortcut Dimension 3 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                    ApplicationArea = All;

                }
                field(Approved; Rec.Approved)
                {
                    ToolTip = 'Specifies the value of the Approved field.';
                    ApplicationArea = All;
                }
                field("Approved By"; Rec."Approved By")
                {
                    ToolTip = 'Specifies the value of the Approved By field.';
                    ApplicationArea = All;
                }
                field("Approved Date Time"; Rec."Approved Date Time")
                {
                    ToolTip = 'Specifies the value of the Approved Date Time field.';
                    ApplicationArea = all;
                }
                field("Remaining Bond value"; Rec."Remaining Bond value")
                {
                    ToolTip = 'Specifies the value of the Remaining Bond value field.';
                    ApplicationArea = all;

                }

            }
            part(GateOutLine; "WH Gate Out Order SubForm")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Gate Out No." = field("Gate Out No.");
                UpdatePropagation = Both;
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";

                action(GetLines)
                {
                    ApplicationArea = all;
                    Image = GetOrder;
                    Caption = 'Get Lines';
                    trigger OnAction()
                    begin
                        Rec.GetGateOutLines();
                        CurrPage.Update();
                    end;
                }
            }

            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Post)
                {
                    ApplicationArea = all;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    trigger OnAction()
                    var
                        GateOutLine: Record "WH Gate Out Line";
                    begin
                        rec.TestField("Location Type");
                        //rec.TestField("Customs No.");
                        rec.TestField("Shortcut Dimension 3 Code");
                        rec.TestField("Clearing Agent");
                        if rec."Location Type" = Rec."Location Type"::"Bonded Warehouse" then begin
                            rec.TestField("Consignment Value to Release");
                        end;
                        rec.TestField("Consignee No.");
                        rec.TestField("Activity Date");
                        if not rec.Printed then
                            Error('Please print the Gatepass before posting');
                        if Confirm('Do you want to post Gate Out?') then begin
                            Rec.Posted := true;
                            GateOutLine.Reset();
                            GateOutLine.SetRange("Gate Out No.", Rec."Gate Out No.");
                            if GateOutLine.FindFirst() then
                                repeat
                                    GateOutLine.Posted := true;
                                    GateOutLine.Modify();
                                until GateOutLine.Next() = 0;
                            Rec.Modify();
                            CurrPage.Update();
                            MESSAGE('Warehouse Gate Out Order Posted Successfully');
                        end else
                            exit;
                    end;
                }
            }

            action("Print GatePass")
            {
                Caption = 'Print Gate Out Order';
                ApplicationArea = All;
                Image = Print;


                trigger OnAction()
                var
                    GatePass: Record "WH Gate Out Header";
                    GatepassLine: Record "WH Gate Out Line";
                    CustRec: Record customer;
                begin
                    rec.TestField("Location Type");
                    //rec.TestField("Customs No.");
                    rec.TestField("Shortcut Dimension 3 Code");
                    rec.TestField("Clearing Agent");
                    if rec."Location Type" = Rec."Location Type"::"Bonded Warehouse" then begin
                        rec.TestField("Consignment Value to Release");
                    end;
                    rec.TestField("Consignee No.");
                    GatePass.Reset();
                    GatePass.SetRange("Gate Out No.", Rec."Gate Out No.");
                    IF GatePass.FindFirst() then begin
                        report.RunModal(report::"Warehouse - GateOut", true, true, GatePass);
                        GatePass.Printed := true;
                        GatePass.Modify();
                    end;
                end;
            }
            action(Approve)
            {
                ApplicationArea = All;
                Caption = 'Approve';
                //Visible = PageEdit;
                trigger OnAction()
                var
                    Usersetup: Record "User Setup";
                begin
                    if Rec.approved then
                        error('The document is aleady approved');
                    Usersetup.Get(UserId);
                    if not Usersetup."Warehouse Gatepass Approval" then
                        error('You do not have permission')
                    else begin
                        Rec.Approved := true;
                        Rec."Approved By" := UserId;
                        Rec."Approved Date Time" := CurrentDateTime;
                        Rec.Modify();
                    end;
                end;
            }

        }
        area(Promoted)
        {

            group(Category_Category6)
            {
                Caption = 'Get Lines', Comment = 'Generated from the PromotedActionCategories property index 6.';
                actionref(GetLines_Promoted; GetLines)
                {
                }
            }

            group(Category_Category7)
            {
                Caption = 'Print', Comment = 'Generated from the PromotedActionCategories property index 6.';
                actionref(Print_Promoted; "Print GatePass")
                {
                }
            }
            group(Category_Category11)
            {
                Caption = 'P&osting', Comment = 'Generated from the PromotedActionCategories property index 6.';
                actionref(Post_Promoted; Post)
                {
                }
            }
        }
    }

}

