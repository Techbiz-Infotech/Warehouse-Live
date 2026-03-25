report 50179 "Monthly Warehouse Volumes"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Monthly Warehouse Volumes';
    ProcessingOnly = true;

    dataset
    {

    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Filter Options';
                    field(StartDate; StartDate) { ApplicationArea = All; }
                    field(EndDate; EndDate) { ApplicationArea = All; }
                }
            }
        }

        trigger OnOpenPage()
        begin
            if StartDate = 0D then
                StartDate := CalcDate('<-CY>', Today);
            if EndDate = 0D then
                EndDate := Today;
        end;
    }

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        ManifestLine: Record "WH Gate In Line";
        WarehouseGateinHeader: Record "WH Gate In Header";
        StartDate: Date;
        EndDate: Date;

        MonthList: List of [Text];
        CustomerList: List of [Code[100]];
        ClearingAgentList: List of [Code[100]];
        SalesPersonList: List of [Code[100]];

        CustomerMatrix: Dictionary of [Code[100], Dictionary of [Text, Decimal]];
        AgentMatrix: Dictionary of [Code[100], Dictionary of [Text, Decimal]];
        SalesMatrix: Dictionary of [Code[100], Dictionary of [Text, Decimal]];

        CustomerSales: Dictionary of [Code[100], Code[100]];
        AgentSales: Dictionary of [Code[100], Code[100]];

    trigger OnPostReport()
    begin
        BuildMonths();
        ExcelBuf.CreateNewBook('Customer Analysis');

        Clear(CustomerList);
        Clear(CustomerMatrix);
        Clear(CustomerSales);
        BuildCustomerData();
        CreateCustomerSheet();
        ExcelBuf.WriteSheet('Customer Analysis', CompanyName, UserId);
        ExcelBuf.DeleteAll();
        ExcelBuf.ClearNewRow();

        Clear(ClearingAgentList);
        Clear(AgentMatrix);
        Clear(AgentSales);
        BuildAgentData();
        CreateAgentSheet();
        ExcelBuf.WriteSheet('Clearing Agent Analysis', CompanyName, UserId);
        ExcelBuf.DeleteAll();
        ExcelBuf.ClearNewRow();

        Clear(SalesPersonList);
        Clear(SalesMatrix);
        BuildSalesData();
        CreateSalesSheet();
        ExcelBuf.WriteSheet('Salesperson Analysis', CompanyName, UserId);

        ExcelBuf.CloseBook();
        ExcelBuf.OpenExcel();
    end;



    local procedure GetContainerWeight(Var WHheader: record "WH Gate In Header"): Decimal
    begin
        ManifestLine.reset;
        ManifestLine.SetRange("Gate In No.", WHheader."Gate In No.");
        if ManifestLine.find then
            exit(2);
        exit(1);
    end;

    local procedure BuildMonths()
    var
        CurrDate: Date;
        MonthTxt: Text[7];
    begin
        Clear(MonthList);
        CurrDate := StartDate;

        while CurrDate <= EndDate do begin
            MonthTxt := Format(CurrDate, 0, '<Year4>-<Month,2>');
            if not MonthList.Contains(MonthTxt) then
                MonthList.Add(MonthTxt);
            CurrDate := CalcDate('<+1M>', CurrDate);
        end;
    end;

    // ---------------- DATA BUILDERS ----------------

    local procedure BuildCustomerData()
    var
        MonthTxt: Text[7];
    begin

        WarehouseGateinHeader.SetRange("Activity Date", StartDate, EndDate);
        if WarehouseGateinHeader.FindSet() then
            repeat
                ManifestLine.Reset();
                ManifestLine.SetRange("Gate In No.", WarehouseGateinHeader."Gate In No.");
                if ManifestLine.FindSet() then
                    repeat
                        MonthTxt := Format(WarehouseGateinHeader."Activity Date", 0, '<Year4>-<Month,2>');
                        AddToCustomerMatrix(
                            WarehouseGateinHeader."Consignee Name",
                            MonthTxt,
                            ManifestLine.Quantity,
                            WarehouseGateinHeader."Shortcut Dimension 3 Code");
                    until ManifestLine.Next() = 0;
            until WarehouseGateinHeader.Next() = 0;
    end;

    local procedure BuildAgentData()
    var
        MonthTxt: Text[7];
    begin
        WarehouseGateinHeader.SetRange("Activity Date", StartDate, EndDate);
        if WarehouseGateinHeader.FindSet() then
            repeat
                ManifestLine.Reset();
                ManifestLine.SetRange("Gate In No.", WarehouseGateinHeader."Gate In No.");
                if ManifestLine.FindSet() then
                    repeat
                        MonthTxt := Format(WarehouseGateinHeader."Activity Date", 0, '<Year4>-<Month,2>');
                        AddToAgentMatrix(
                            WarehouseGateinHeader."Clearing Agent",
                            MonthTxt,
                            ManifestLine.Quantity,
                            WarehouseGateinHeader."Shortcut Dimension 3 Code");
                    until ManifestLine.Next() = 0;
            until WarehouseGateinHeader.Next() = 0;
    end;

    local procedure BuildSalesData()
    var
        MonthTxt: Text[7];
    begin
        WarehouseGateinHeader.SetRange("Activity Date", StartDate, EndDate);
        if WarehouseGateinHeader.FindSet() then
            repeat
                ManifestLine.Reset();
                ManifestLine.SetRange("Gate In No.", WarehouseGateinHeader."Gate In No.");
                if ManifestLine.FindSet() then
                    repeat
                        MonthTxt := Format(WarehouseGateinHeader."Activity Date", 0, '<Year4>-<Month,2>');
                        AddToSalesMatrix(WarehouseGateinHeader."Shortcut Dimension 3 Code",
                            MonthTxt,
                            ManifestLine.Quantity
                           );
                    until ManifestLine.Next() = 0;
            until WarehouseGateinHeader.Next() = 0;

    end;

    // ---------------- MATRIX ----------------

    local procedure AddToCustomerMatrix(Cust: Code[100]; MonthTxt: Text; Weight: Decimal; Sales: Code[100])
    var
        RowDict: Dictionary of [Text, Decimal];
        Val: Decimal;
    begin
        if not CustomerList.Contains(Cust) then CustomerList.Add(Cust);
        if not CustomerMatrix.Get(Cust, RowDict) then begin
            Clear(RowDict);
            CustomerMatrix.Add(Cust, RowDict);
        end;

        if RowDict.Get(MonthTxt, Val) then Val += Weight else Val := Weight;
        RowDict.Set(MonthTxt, Val);

        if not CustomerSales.ContainsKey(Cust) then
            CustomerSales.Add(Cust, Sales);
    end;

    local procedure AddToAgentMatrix(Agent: Code[100]; MonthTxt: Text; Weight: Decimal; Sales: Code[100])
    var
        RowDict: Dictionary of [Text, Decimal];
        Val: Decimal;
    begin
        if not ClearingAgentList.Contains(Agent) then ClearingAgentList.Add(Agent);
        if not AgentMatrix.Get(Agent, RowDict) then begin
            Clear(RowDict);
            AgentMatrix.Add(Agent, RowDict);
        end;

        if RowDict.Get(MonthTxt, Val) then Val += Weight else Val := Weight;
        RowDict.Set(MonthTxt, Val);

        if not AgentSales.ContainsKey(Agent) then
            AgentSales.Add(Agent, Sales);
    end;

    local procedure AddToSalesMatrix(Sales: Code[100]; MonthTxt: Text; Weight: Decimal)
    var
        RowDict: Dictionary of [Text, Decimal];
        Val: Decimal;
    begin
        if not SalesPersonList.Contains(Sales) then SalesPersonList.Add(Sales);
        if not SalesMatrix.Get(Sales, RowDict) then begin
            Clear(RowDict);
            SalesMatrix.Add(Sales, RowDict);
        end;

        if RowDict.Get(MonthTxt, Val) then Val += Weight else Val := Weight;
        RowDict.Set(MonthTxt, Val);
    end;

    // ---------------- SHEETS ----------------

    local procedure CreateCustomerSheet()
    var
        Customer: Code[100];
        MonthTxt: Text;
        RowDict: Dictionary of [Text, Decimal];
        Val, Total : Decimal; Sales: Code[100];
    begin
        ExcelBuf.SelectOrAddSheet('Customer Analysis');

        ExcelBuf.AddColumn('Consignee', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Salesperson', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        foreach MonthTxt in MonthList do
            ExcelBuf.AddColumn(MonthTxt, false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();

        foreach Customer in CustomerList do begin
            Total := 0;
            ExcelBuf.AddColumn(Customer, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            CustomerSales.Get(Customer, Sales);
            ExcelBuf.AddColumn(Sales, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);

            if CustomerMatrix.Get(Customer, RowDict) then
                foreach MonthTxt in MonthList do begin
                    if RowDict.Get(MonthTxt, Val) then begin
                        ExcelBuf.AddColumn(Val, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
                        Total += Val;
                    end else
                        ExcelBuf.AddColumn(0, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
                end;

            ExcelBuf.AddColumn(Total, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.NewRow();
        end;
    end;

    local procedure CreateAgentSheet()
    var
        Agent: Code[100];
        MonthTxt: Text;
        RowDict: Dictionary of [Text, Decimal];
        Val, Total : Decimal; Sales: Code[100];
    begin
        ExcelBuf.SelectOrAddSheet('Clearing Agent Analysis');

        ExcelBuf.AddColumn('Clearing Agent', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Salesperson', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        foreach MonthTxt in MonthList do
            ExcelBuf.AddColumn(MonthTxt, false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();

        foreach Agent in ClearingAgentList do begin
            Total := 0;
            ExcelBuf.AddColumn(Agent, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            AgentSales.Get(Agent, Sales);
            ExcelBuf.AddColumn(Sales, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);

            if AgentMatrix.Get(Agent, RowDict) then
                foreach MonthTxt in MonthList do begin
                    if RowDict.Get(MonthTxt, Val) then begin
                        ExcelBuf.AddColumn(Val, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
                        Total += Val;
                    end else
                        ExcelBuf.AddColumn(0, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
                end;

            ExcelBuf.AddColumn(Total, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.NewRow();
        end;
    end;

    local procedure CreateSalesSheet()
    var
        Sales: Code[100];
        MonthTxt: Text;
        RowDict: Dictionary of [Text, Decimal];
        Val, Total : Decimal;
    begin
        ExcelBuf.SelectOrAddSheet('Salesperson Analysis');

        ExcelBuf.AddColumn('Month', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        foreach Sales in SalesPersonList do
            ExcelBuf.AddColumn(Sales, false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();

        foreach MonthTxt in MonthList do begin
            ExcelBuf.AddColumn(MonthTxt, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            foreach Sales in SalesPersonList do begin
                if SalesMatrix.Get(Sales, RowDict) and RowDict.Get(MonthTxt, Val) then
                    ExcelBuf.AddColumn(Val, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number)
                else
                    ExcelBuf.AddColumn(0, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
            end;
            ExcelBuf.NewRow();
        end;

        // Total row for all salespersons
        ExcelBuf.AddColumn('Total', true, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        foreach Sales in SalesPersonList do begin
            Total := 0;
            if SalesMatrix.Get(Sales, RowDict) then
                foreach MonthTxt in MonthList do
                    if RowDict.Get(MonthTxt, Val) then
                        Total += Val;
            ExcelBuf.AddColumn(Total, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
        end;
        ExcelBuf.NewRow();
    end;
}
