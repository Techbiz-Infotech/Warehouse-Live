pageextension 50153 "CS Role Center Ext" extends "CS Role Center"
{

    actions
    {

        addlast("IMS Billing")
        {
            action(warehouseproformaInvoices)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'WareHouse Proforma Invoices';
                //Promoted = true;
                //PromotedCategory = Process;
                RunObject = Page "WH Proforma Invoice list";
            }
            action(warehousesalesinvoice)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'WareHouse Sales Invoices';
                //Promoted = true;
                //PromotedCategory = Process;
                RunObject = Page "Warehouse Sales Invoice List";
            }
            action(ClosedWarehouseProformaInvoices)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Closed WareHouse Proforma Invoices';
                //Promoted = true;
                //PromotedCategory = Process;
                RunObject = Page "WH-Closed proforma Invoices";
            }
        }
        addafter("IMS Billing")
        {
            group(warehouse)

            {
                Caption = 'Warehouse';
                //Image = AdministrationSalesPurchases;
                //ToolTip = 'Manage purchase invoices and credit memos. Maintain vendors and their history.';
                action(WHGateIN)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Warehouse Gate In Orders';
                    //Promoted = true;
                    //PromotedCategory = Process;
                    RunObject = Page "WH Gate In Order List";
                }
                action(WHPostedGateIn)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Warehouse Gate In Orders';
                    //Promoted = true;
                    //PromotedCategory = Process;
                    RunObject = Page "Posted WH GateIn Order List";
                }
                action(WHGateOut)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Warehouse Gate Out Orders';
                    //Promoted = true;
                    //PromotedCategory = Process;
                    RunObject = Page "WH GateOut Order List";
                }
                action(PendingGateOuts)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Pending Warehouse Gate Outs';
                    //Promoted = true;
                    //PromotedCategory = Process;
                    RunObject = Page "Pending GateOut Lines";
                }
                action(ReleasedGateOuts)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Released Warehouse Gate Outs';
                    //Promoted = true;
                    //PromotedCategory = Process;
                    RunObject = Page "Released GateOut lines";
                }


            }
        }

    }




}

