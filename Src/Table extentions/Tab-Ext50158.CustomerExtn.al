tableextension 50158 "Customer Extn" extends Customer
{
    fields
    {
       field(50102; "Warehouse ChargeID Assignments"; Integer)
        {
            Caption = 'Warehouse Charge ID Assignments';
            FieldClass = FlowField;
            CalcFormula = count("Warehouse ChargeID Assignment" where("Customer No." = field("No.")));
            Editable = false;
        }
    }
}
