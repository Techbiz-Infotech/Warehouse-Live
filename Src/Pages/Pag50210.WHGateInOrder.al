page 50209 "WH Gate In Order"
{
    //ApplicationArea = All;
    Caption = 'Warehouse Gate In Order';
    PageType = Document;
    SourceTable = "WH Gate In Header";
    UsageCategory = Tasks;


    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Gate In No."; Rec."Gate In No.")
                {
                    ToolTip = 'Specifies the value of the Gate In No. field.';
                    ApplicationArea = All;
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Activity Date"; Rec."Activity Date")
                {
                    ToolTip = 'Specifies the value of the Gate In Date field.';
                    ApplicationArea = All;
                    //Editable = false;
                }
                field("Location Type"; Rec."Location Type")
                {
                    ToolTip = 'Specifies the value of the Location Type field.';
                    ApplicationArea = All;
                }
                field("Consignee No."; Rec."Consignee No.")
                {
                    ToolTip = 'Specifies the value of the Consignee No. field.';
                    ApplicationArea = All;
                }
                field("Consignee Name "; Rec."Consignee Name")
                {
                    ToolTip = 'Specifies the value of the Consignee Name field.';
                    ApplicationArea = All;
                }
                field("Consignment Value"; Rec."Consignment Value")
                {
                    ToolTip = 'Specifies the value of the Consignment Value field.';
                    ApplicationArea = All;
                    Enabled = Rec."Location Type" = Rec."Location Type"::"Bonded Warehouse";
                }

                field("Clearing Agent "; Rec."Clearing Agent")
                {
                    ToolTip = 'Specifies the value of the Clearing Agent field.';
                    ApplicationArea = All;
                    Enabled = Rec."Location Type" = Rec."Location Type"::"Bonded Warehouse";
                }
                field("Clearing Agent Name"; Rec."Clearing Agent Name")
                {
                    ToolTip = 'Specifies the value of the Clearing Agent Name field.';
                    ApplicationArea = All;
                    Enabled = Rec."Location Type" = Rec."Location Type"::"Bonded Warehouse";
                    Editable = false;
                }
                field("Customs No."; Rec."Customs No.")
                {
                    ToolTip = 'Specifies the value of the Customs No. field.';
                    ApplicationArea = All;
                }
                field("Truck No."; Rec."Truck No.")
                {
                    ToolTip = 'Specifies the value of the Transporter field.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; rec."Shortcut Dimension 3 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                    ApplicationArea = All;
                }

            }
            part(GateInLines; "WH Gate In Order SubForm")
            {
                ApplicationArea = Basic, Suite;
                UpdatePropagation = Both;
                SubPageLink = "Gate In No." = field("Gate In No.");
            }
        }

    }
    actions
    {
        area(Navigation)
        {
            action("Print GatePass")
            {
                Caption = 'Print Gate In Order';
                ApplicationArea = All;
                trigger OnAction()
                var
                    GatePass: Record "WH Gate In Header";
                    GatepassLine: Record "WH Gate In Line";
                    CustRec: Record customer;
                begin
                    GatePass.Reset();
                    GatePass.SetRange("Gate In No.", Rec."Gate In No.");
                    IF GatePass.FindFirst() then begin
                        report.RunModal(report::"Warehouse - GateIn", true, true, GatePass);
                        //Rec."Gate Pass Printed" := true;
                        //rec.Modify();
                    end;
                end;
            }
            action(Post)
            {
                ApplicationArea = all;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    Rec.TestField("Activity Date");
                    Rec.PostWarehouseGateIn();
                    CurrPage.Update();
                end;
            }

        }
    }
    trigger OnOpenPage()
    var
        IMSSetup: Record "IMS Setup";
    begin
        IMSSetup.Get();
        if IMSSetup."Warehouse Activated" <> true then
            Error('Warehouse functionality is not activated for %1', CompanyName);
    end;
}
