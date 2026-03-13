page 50201 "Pending GateOut Lines"
{
    ApplicationArea = All;
    Caption = 'Pending Warehouse Gate Out Lines';
    PageType = List;
    SourceTable = "WH Gate Out Line";
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTableView = where(Released = const(false));
    //Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Gate Out No."; Rec."Gate Out No.")
                {
                    ToolTip = 'Specifies the value of the Gate Out No. field.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Gate Out Line No. field.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Description Of The Goods"; Rec."Description Of The Goods")
                {
                    ToolTip = 'Specifies the value of the Description Of The Goods field.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Invoiced Quantity"; Rec."Invoiced Quantity")
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Shelf No."; Rec."Shelf No.")
                {
                    ToolTip = 'Specifies the value of the Shelf No. field.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Gate In Weight"; Rec."Gate In Weight")
                {
                    ToolTip = 'Specifies the value of the Weight field.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Gate In CBM"; Rec."Gate In CBM")
                {
                    ToolTip = 'Specifies the value of the Gate In CBM field.', Comment = '%';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Gate In Reference No."; Rec."Gate In Reference No.")
                {
                    ToolTip = 'Specifies the value of the Gate In Reference No. field.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Gate In Reference Line No."; Rec."Gate In Reference Line No.")
                {
                    ToolTip = 'Specifies the value of the Gate In Line No. field.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Invoiced CBM/Weight"; Rec."Invoiced CBM/Weight")
                {
                    ToolTip = 'Specifies the value of the CBM field.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Additional Remarks"; Rec."Additional Remarks")
                {
                    ToolTip = 'Specifies the value of the Additional Remarks field.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Gate In Quantity"; Rec."Gate In Quantity")
                {
                    ToolTip = 'Specifies the value of the Gate In Quantity field.', Comment = '%';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Activity Date"; Rec."Activity Date")
                {
                    ToolTip = 'Specifies the value of the Activity Date field.', Comment = '%';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Activity Time"; Rec."Activity Time")
                {
                    ToolTip = 'Specifies the value of the Activity Time field.', Comment = '%';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Driver ID"; rec."Driver ID")
                {
                    ToolTip = 'Specifies the value of the Driver ID field.', Comment = '%';
                    ApplicationArea = all;
                    Editable = true;
                }
                field("Gate Out Status"; Rec."Gate Out Status")
                {
                    ToolTip = 'Specifies the value of the Gate Out Status field.', Comment = '%';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Invoice No. field.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Invoice Date"; Rec."Invoice Date")
                {
                    ToolTip = 'Specifies the value of the Invoice Date field.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Receipt No."; Rec."Receipt No.")
                {
                    ToolTip = 'Specifies the value of the Receipt No. field.', Comment = '%';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Truck No."; Rec."Truck No.")
                {
                    ToolTip = 'Specifies the value of the Truck No. field.', Comment = '%';
                    ApplicationArea = all;
                    Editable = true;
                }
                field("Agent Name"; Rec."Agent Name")
                {
                    ToolTip = 'Specifies the value of the Agent Name field.', Comment = '%';
                    ApplicationArea = all;

                }
                field("Agent Port Pass"; Rec."Agent Port Pass")
                {
                    ToolTip = 'Specifies the value of the Agent Port Pass field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Transporter/Driver Name"; Rec."Transporter/Driver Name")
                {
                    ToolTip = 'Specifies the value of the Transporter/Driver Name field.', Comment = '%';
                    ApplicationArea = all;
                    Editable = true;
                }
                field("Trailer No."; Rec."Trailer No.")
                {
                    ToolTip = 'Specifies the value of the Trailer No. field.', Comment = '%';
                    Visible = false;
                    ApplicationArea = all;
                }
                field("Releasing CBM/Weight"; Rec."Releasing CBM/Weight")
                {
                    ToolTip = 'Specifies the value of the Releasing CBM/Weight field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Customs No."; Rec."Customs No.")
                {
                    ToolTip = 'Specifies the value of the Customs Entry field.';
                    ApplicationArea = All;
                }


            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action("Release Consignment Line")
            {
                ApplicationArea = All;
                Caption = 'Release Consignment Line';
                trigger OnAction()
                var
                begin
                    rec.PostWarehouseGateOut;
                    CurrPage.Update(false);
                end;

            }
            action("Print GatePass")
            {
                Caption = 'Print Pendning Gate Out Order';
                ApplicationArea = All;
                Image = Print;


                trigger OnAction()
                var
                    GatePass: Record "WH Gate Out Header";
                    GatepassLine: Record "WH Gate Out Line";
                    CustRec: Record customer;
                begin
                    GatePass.Reset();
                    GatePass.SetRange("Gate Out No.", Rec."Gate Out No.");
                    IF GatePass.FindFirst() then begin
                        report.RunModal(report::"Pending WH GateOut Line", true, true, GatePass);
                        GatePass.Printed := true;
                        GatePass.Modify();
                    end;
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
