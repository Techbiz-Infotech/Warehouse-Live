pageextension 50161 "Terminal role Center ext" extends "Terminal Role Center"
{
    actions
    {
        addafter(Stripping)
        {

            group("Warehouse")
            {
                Caption = 'Warehouse';
                Image = AdministrationSalesPurchases;
                //ToolTip = 'Manage purchase invoices and credit memos. Maintain vendors and their history.';
                action(WHGateIN)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Warehouse Gate Ins';
                    //Promoted = true;
                    //PromotedCategory = Process;
                    RunObject = Page "WH Gate In Order List";
                }
                action(WHGateOut)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Warehouse Gate Outs';
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
                    RunObject = Page ReleasedGatepassOutslist;
                }
                action(ReleasedGateOuts)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Released Warehouse Gate Outs';
                    //Promoted = true;
                    //PromotedCategory = Process;
                    RunObject = Page ReleasedGatepassOutslist;
                }

            }
        }
    }
}
