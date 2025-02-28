codeunit 99000813 "Carry Out Action"
{
    Permissions = TableData "Prod. Order Capacity Need" = rid;
    TableNo = "Requisition Line";

    trigger OnRun()
    var
        IsHandled: Boolean;
    begin
        ProductionExist := true;
        AssemblyExist := true;
        case TrySourceType of
            TrySourceType::Purchase:
                CarryOutToReqWksh(Rec, TryWkshTempl, TryWkshName);
            TrySourceType::Transfer:
                CarryOutActionsFromTransOrder(Rec, "Planning Create Transfer Order".FromInteger(TryChoice), TryWkshTempl, TryWkshName);
            TrySourceType::Production:
                begin
                    IsHandled := false;
                    OnRunOnBeforeCalcProductionExist(Rec, TryChoice, TryWkshTempl, TryWkshName, ProductionExist, IsHandled);
                    if not IsHandled then
                        ProductionExist := CarryOutActionsFromProdOrder(Rec, "Planning Create Prod. Order".FromInteger(TryChoice), TryWkshTempl, TryWkshName);
                end;
            TrySourceType::Assembly:
                AssemblyExist := CarryOutActionsFromAssemblyOrder(Rec, "Planning Create Assembly Order".FromInteger(TryChoice));
        end;

        if Rec."Action Message" = Rec."Action Message"::Cancel then
            Rec.Delete(true);

        ReservEntry.SetCurrentKey(
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
          "Source Batch Name", "Source Prod. Order Line");
        Rec.SetReservationFilters(ReservEntry);
        ReservEntry.DeleteAll(true);

        if not (Rec."Action Message" = Rec."Action Message"::Cancel) then begin
            Rec.BlockDynamicTracking(true);
            if TrySourceType = TrySourceType::Production then
                Rec.BlockDynamicTrackingOnComp(true);
            if ProductionExist and AssemblyExist then
                DeleteRequisitionLine(Rec);
            Rec.BlockDynamicTracking(false);
        end;
    end;

    var
        TempProductionOrder: Record "Production Order" temporary;
        LastTransHeader: Record "Transfer Header";
        TempTransHeaderToPrint: Record "Transfer Header" temporary;
        ReservEntry: Record "Reservation Entry";
        TempDocumentEntry: Record "Document Entry" temporary;
        TempAsmOrderToPrint: Record "Assembly Header" temporary;
        CarryOutAction: Codeunit "Carry Out Action";
        CalcProdOrder: Codeunit "Calculate Prod. Order";
        ReservMgt: Codeunit "Reservation Management";
        ReqLineReserve: Codeunit "Req. Line-Reserve";
        ReservePlanningComponent: Codeunit "Plng. Component-Reserve";
        CheckDateConflict: Codeunit "Reservation-Check Date Confl.";
        PrintOrder: Boolean;
        SplitTransferOrders: Boolean;
        ProductionExist: Boolean;
        AssemblyExist: Boolean;
        TrySourceType: Enum "Planning Create Source Type";
        TryChoice: Option;
        TryWkshTempl: Code[10];
        TryWkshName: Code[10];
        LineNo: Integer;
        CouldNotChangeSupplyTxt: Label 'The supply type could not be changed in order %1, order line %2.', Comment = '%1 - Production Order No. or Assembly Header No. or Purchase Header No., %2 - Production Order Line or Assembly Line No. or Purchase Line No.';

    procedure TryCarryOutAction(SourceType: Enum "Planning Create Source Type"; var ReqLine: Record "Requisition Line"; Choice: Option; WkshTempl: Code[10]; WkshName: Code[10]): Boolean
    begin
        CarryOutAction.SetSplitTransferOrders(SplitTransferOrders);
        CarryOutAction.SetParameters(SourceType, Choice, WkshTempl, WkshName);
        exit(CarryOutAction.Run(ReqLine));
    end;

#if not CLEAN21
    [Obsolete('Replaced by procedure SetParameters()', '21.0')]
    procedure SetTryParameters(SourceType: Option Purchase,Transfer,Production,Assembly; Choice: Option; WkshTempl: Code[10]; WkshName: Code[10])
    begin
        TrySourceType := "Planning Create Source Type".FromInteger(SourceType);
        TryChoice := Choice;
        TryWkshTempl := WkshTempl;
        TryWkshName := WkshName;
    end;
#endif

    procedure SetParameters(SourceType: Enum "Planning Create Source Type"; Choice: Integer; WkshTempl: Code[10]; WkshName: Code[10])
    begin
        TrySourceType := SourceType;
        TryChoice := Choice;
        TryWkshTempl := WkshTempl;
        TryWkshName := WkshName;
    end;

#if not CLEAN21
    [Obsolete('Replaced by procedure CarryOutFromProdOrder()', '21.0')]
    procedure CarryOutProdOrder(ReqLine: Record "Requisition Line"; ProdOrderChoice: Option " ",Planned,"Firm Planned","Firm Planned & Print","Copy to Req. Wksh"; ProdWkshTempl: Code[10]; ProdWkshName: Code[10]): Boolean
    begin
        exit(CarryOutActionsFromProdOrder(ReqLine, "Planning Create Prod. Order".FromInteger(ProdOrderChoice), ProdWkshTempl, ProdWkshName));
    end;
#endif

    procedure CarryOutActionsFromProdOrder(ReqLine: Record "Requisition Line"; ProdOrderChoice: Enum "Planning Create Prod. Order"; ProdWkshTempl: Code[10]; ProdWkshName: Code[10]): Boolean
    begin
        PrintOrder := ProdOrderChoice = ProdOrderChoice::"Firm Planned & Print";
        OnCarryOutActionsFromProdOrderOnAfterCalcPrintOrder(PrintOrder, ProdOrderChoice.AsInteger());

        case ReqLine."Action Message" of
            ReqLine."Action Message"::New:
                if ProdOrderChoice = ProdOrderChoice::"Copy to Req. Wksh" then
                    CarryOutToReqWksh(ReqLine, ProdWkshTempl, ProdWkshName)
                else
                    InsertProductionOrder(ReqLine, ProdOrderChoice);
            ReqLine."Action Message"::"Change Qty.",
          ReqLine."Action Message"::Reschedule,
          ReqLine."Action Message"::"Resched. & Chg. Qty.":
                exit(ProdOrderChgAndReshedule(ReqLine));
            ReqLine."Action Message"::Cancel:
                DeleteOrderLines(ReqLine);
        end;
        exit(true);
    end;

#if not CLEAN21
    [Obsolete('Replaced by procedure CarryOutActionsFromTransOrder()', '21.0')]
    procedure CarryOutTransOrder(ReqLine: Record "Requisition Line"; TransOrderChoice: Option " ","Make Trans. Orders","Make Trans. Orders & Print","Copy to Req. Wksh"; TransWkshTempName: Code[10]; TransJournalName: Code[10])
    begin
        CarryOutActionsFromTransOrder(ReqLine, "Planning Create Transfer Order".FromInteger(TransOrderChoice), TransWkshTempName, TransJournalName);
    end;
#endif

    procedure CarryOutActionsFromTransOrder(ReqLine: Record "Requisition Line"; TransOrderChoice: Enum "Planning Create Transfer Order"; TransWkshTempName: Code[10]; TransJournalName: Code[10])
    var
        IsHandled: Boolean;
    begin
        OnBeforeCarryOutTransOrder(SplitTransferOrders);

        PrintOrder := TransOrderChoice = TransOrderChoice::"Make Trans. Order & Print";

        if SplitTransferOrders then
            Clear(LastTransHeader);

        if TransOrderChoice = TransOrderChoice::"Copy to Req. Wksh" then
            CarryOutToReqWksh(ReqLine, TransWkshTempName, TransJournalName)
        else
            case ReqLine."Action Message" of
                ReqLine."Action Message"::New:
                    begin
                        IsHandled := false;
                        OnCarryOutActionsFromTransOrderOnBeforeInsertTransLine(ReqLine, PrintOrder, IsHandled);
                        if not IsHandled then
                            InsertTransLine(ReqLine, LastTransHeader);
                    end;
                ReqLine."Action Message"::"Change Qty.",
              ReqLine."Action Message"::Reschedule,
              ReqLine."Action Message"::"Resched. & Chg. Qty.":
                    begin
                        IsHandled := false;
                        OnCarryOutActionsFromTransOrderOnBeforeTransOrderChgAndReshedule(ReqLine, PrintOrder, IsHandled);
                        if not IsHandled then
                            TransOrderChgAndReshedule(ReqLine);
                    end;
                ReqLine."Action Message"::Cancel:
                    DeleteOrderLines(ReqLine);
            end;
    end;

#if not CLEAN21
    [Obsolete('Replaced by procedure CarryOutActionsFromAssemblyOrder()', '21.0')]
    procedure CarryOutAsmOrder(ReqLine: Record "Requisition Line"; AsmOrderChoice: Option " ","Make Assembly Orders","Make Assembly Orders & Print"): Boolean
    begin
        CarryOutActionsFromAssemblyOrder(ReqLine, "Planning Create Assembly Order".FromInteger(AsmOrderChoice));
    end;
#endif

    procedure CarryOutActionsFromAssemblyOrder(ReqLine: Record "Requisition Line"; AsmOrderChoice: Enum "Planning Create Assembly Order"): Boolean
    var
        AsmHeader: Record "Assembly Header";
    begin
        PrintOrder := AsmOrderChoice = AsmOrderChoice::"Make Assembly Orders & Print";
        case ReqLine."Action Message" of
            ReqLine."Action Message"::New:
                InsertAsmHeader(ReqLine, AsmHeader);
            ReqLine."Action Message"::"Change Qty.",
          ReqLine."Action Message"::Reschedule,
          ReqLine."Action Message"::"Resched. & Chg. Qty.":
                exit(AsmOrderChgAndReshedule(ReqLine));
            ReqLine."Action Message"::Cancel:
                DeleteOrderLines(ReqLine);
        end;
        exit(true);
    end;

    procedure CarryOutToReqWksh(ReqLine: Record "Requisition Line"; ReqWkshTempName: Code[10]; ReqJournalName: Code[10])
    var
        ReqLine2: Record "Requisition Line";
        PlanningComp: Record "Planning Component";
        PlanningRoutingLine: Record "Planning Routing Line";
        ProdOrderCapNeed: Record "Prod. Order Capacity Need";
        PlanningComp2: Record "Planning Component";
        PlanningRoutingLine2: Record "Planning Routing Line";
        ProdOrderCapNeed2: Record "Prod. Order Capacity Need";
        ReqLine3: Record "Requisition Line";
    begin
        ReqLine2 := ReqLine;
        ReqLine2."Worksheet Template Name" := ReqWkshTempName;
        ReqLine2."Journal Batch Name" := ReqJournalName;

        if LineNo = 0 then begin
            // we need to find the last line in worksheet
            ReqLine3.SetCurrentKey("Worksheet Template Name", "Journal Batch Name", "Line No.");
            ReqLine3.SetRange("Worksheet Template Name", ReqWkshTempName);
            ReqLine3.SetRange("Journal Batch Name", ReqJournalName);
            if ReqLine3.FindLast() then
                LineNo := ReqLine3."Line No.";
        end;
        LineNo += 10000;
        ReqLine2."Line No." := LineNo;

        if ReqLine2."Planning Line Origin" = ReqLine2."Planning Line Origin"::"Order Planning" then begin
            ReqLine2."Planning Line Origin" := ReqLine2."Planning Line Origin"::" ";
            ReqLine2.Level := 0;
            ReqLine2.Status := 0;
            ReqLine2.Reserve := false;
            ReqLine2."Demand Type" := 0;
            ReqLine2."Demand Subtype" := 0;
            ReqLine2."Demand Order No." := '';
            ReqLine2."Demand Line No." := 0;
            ReqLine2."Demand Ref. No." := 0;
            ReqLine2."Demand Date" := 0D;
            ReqLine2."Demand Quantity" := 0;
            ReqLine2."Demand Quantity (Base)" := 0;
            ReqLine2."Needed Quantity" := 0;
            ReqLine2."Needed Quantity (Base)" := 0;
            ReqLine2."Qty. per UOM (Demand)" := 0;
            ReqLine2."Unit Of Measure Code (Demand)" := '';
        end;
        OnCarryOutToReqWkshOnBeforeReqLineInsert(ReqLine2, ReqWkshTempName, ReqJournalName, LineNo);
        ReqLine2.Insert();

        ReqLineReserve.TransferReqLineToReqLine(ReqLine, ReqLine2, 0, true);
        if ReqLine.Reserve then
            ReserveBindingOrderToReqline(ReqLine2, ReqLine);

        PlanningComp.SetRange("Worksheet Template Name", ReqLine."Worksheet Template Name");
        PlanningComp.SetRange("Worksheet Batch Name", ReqLine."Journal Batch Name");
        PlanningComp.SetRange("Worksheet Line No.", ReqLine."Line No.");
        if PlanningComp.Find('-') then
            repeat
                PlanningComp2 := PlanningComp;
                PlanningComp2."Worksheet Template Name" := ReqWkshTempName;
                PlanningComp2."Worksheet Batch Name" := ReqJournalName;
                PlanningComp2."Worksheet Line No." := LineNo;
                if PlanningComp2."Planning Line Origin" = PlanningComp2."Planning Line Origin"::"Order Planning" then
                    PlanningComp2."Planning Line Origin" := PlanningComp2."Planning Line Origin"::" ";
                PlanningComp2."Dimension Set ID" := ReqLine2."Dimension Set ID";
                PlanningComp2.Insert();
                OnCarryOutToReqWkshOnAfterPlanningCompInsert(PlanningComp2, PlanningComp);
            until PlanningComp.Next() = 0;

        PlanningRoutingLine.SetRange("Worksheet Template Name", ReqLine."Worksheet Template Name");
        PlanningRoutingLine.SetRange("Worksheet Batch Name", ReqLine."Journal Batch Name");
        PlanningRoutingLine.SetRange("Worksheet Line No.", ReqLine."Line No.");
        if PlanningRoutingLine.Find('-') then
            repeat
                PlanningRoutingLine2 := PlanningRoutingLine;
                PlanningRoutingLine2."Worksheet Template Name" := ReqWkshTempName;
                PlanningRoutingLine2."Worksheet Batch Name" := ReqJournalName;
                PlanningRoutingLine2."Worksheet Line No." := LineNo;
                OnCarryOutToReqWkshOnAfterPlanningRoutingLineInsert(PlanningRoutingLine2, PlanningRoutingLine);
                PlanningRoutingLine2.Insert();
            until PlanningRoutingLine.Next() = 0;

        ProdOrderCapNeed.SetRange("Worksheet Template Name", ReqLine."Worksheet Template Name");
        ProdOrderCapNeed.SetRange("Worksheet Batch Name", ReqLine."Journal Batch Name");
        ProdOrderCapNeed.SetRange("Worksheet Line No.", ReqLine."Line No.");
        if ProdOrderCapNeed.Find('-') then
            repeat
                ProdOrderCapNeed2 := ProdOrderCapNeed;
                ProdOrderCapNeed2."Worksheet Template Name" := ReqWkshTempName;
                ProdOrderCapNeed2."Worksheet Batch Name" := ReqJournalName;
                ProdOrderCapNeed2."Worksheet Line No." := LineNo;
                ProdOrderCapNeed.Delete();
                ProdOrderCapNeed2.Insert();
            until ProdOrderCapNeed.Next() = 0;

        OnAfterCarryOutToReqWksh(ReqLine2, ReqLine);
    end;

    procedure GetTransferOrdersToPrint(var TransferHeader: Record "Transfer Header")
    begin
        if TempTransHeaderToPrint.FindSet() then
            repeat
                TransferHeader := TempTransHeaderToPrint;
                TransferHeader.Insert();
            until TempTransHeaderToPrint.Next() = 0;
    end;

    procedure ProdOrderChgAndReshedule(ReqLine: Record "Requisition Line"): Boolean
    var
        ProdOrderLine: Record "Prod. Order Line";
        PlanningComponent: Record "Planning Component";
        ProdOrderCapNeed: Record "Prod. Order Capacity Need";
        ProdOrderComp: Record "Prod. Order Component";
        ProdOrder: Record "Production Order";
    begin
        with ReqLine do begin
            TestField("Ref. Order Type", "Ref. Order Type"::"Prod. Order");
            ProdOrderLine.LockTable();
            if ProdOrderLine.Get("Ref. Order Status", "Ref. Order No.", "Ref. Line No.") then begin
                ProdOrderCapNeed.SetCurrentKey("Worksheet Template Name", "Worksheet Batch Name", "Worksheet Line No.");
                ProdOrderCapNeed.SetRange("Worksheet Template Name", "Worksheet Template Name");
                ProdOrderCapNeed.SetRange("Worksheet Batch Name", "Journal Batch Name");
                ProdOrderCapNeed.SetRange("Worksheet Line No.", "Line No.");
                ProdOrderCapNeed.DeleteAll();
                ProdOrderLine.BlockDynamicTracking(true);
                ProdOrderLine.Validate(Quantity, Quantity);
                OnProdOrderChgAndResheduleOnAfterValidateQuantity(ProdOrderLine, ReqLine);
                ProdOrderLine."Ending Time" := "Ending Time";
                ProdOrderLine.Validate("Planning Flexibility", "Planning Flexibility");
                ProdOrderLine.Validate("Ending Date", "Ending Date");
                ProdOrderLine."Due Date" := "Due Date";
                ProdOrderLine.Modify();
                ReqLineReserve.TransferPlanningLineToPOLine(ReqLine, ProdOrderLine, 0, true);
                ReqLineReserve.UpdateDerivedTracking(ReqLine);
                ReservMgt.SetReservSource(ProdOrderLine);
                ReservMgt.DeleteReservEntries(false, ProdOrderLine."Remaining Qty. (Base)");
                ReservMgt.ClearSurplus();
                ReservMgt.AutoTrack(ProdOrderLine."Remaining Qty. (Base)");
                PlanningComponent.SetRange("Worksheet Template Name", "Worksheet Template Name");
                PlanningComponent.SetRange("Worksheet Batch Name", "Journal Batch Name");
                PlanningComponent.SetRange("Worksheet Line No.", "Line No.");
                if PlanningComponent.Find('-') then
                    repeat
                        if ProdOrderComp.Get(
                             ProdOrderLine.Status, ProdOrderLine."Prod. Order No.", ProdOrderLine."Line No.", PlanningComponent."Line No.")
                        then begin
                            ReservePlanningComponent.TransferPlanningCompToPOComp(PlanningComponent, ProdOrderComp, 0, true);
                            ReservePlanningComponent.UpdateDerivedTracking(PlanningComponent);
                            ReservMgt.SetReservSource(ProdOrderComp);
                            ReservMgt.DeleteReservEntries(false, ProdOrderComp."Remaining Qty. (Base)");
                            ReservMgt.ClearSurplus();
                            ReservMgt.AutoTrack(ProdOrderComp."Remaining Qty. (Base)");
                            CheckDateConflict.ProdOrderComponentCheck(ProdOrderComp, false, false);
                        end else
                            PlanningComponent.Delete(true);
                    until PlanningComponent.Next() = 0;

                if "Planning Level" = 0 then
                    if ProdOrder.Get("Ref. Order Status", "Ref. Order No.") then begin
                        ProdOrder.Quantity := Quantity;
                        ProdOrder."Starting Time" := "Starting Time";
                        ProdOrder."Starting Date" := "Starting Date";
                        ProdOrder."Ending Time" := "Ending Time";
                        ProdOrder."Ending Date" := "Ending Date";
                        ProdOrder."Due Date" := "Due Date";
                        OnProdOrderChgAndResheduleOnBeforeProdOrderModify(ProdOrder, ProdOrderLine, ReqLine);
                        ProdOrder.Modify();
                        FinalizeOrderHeader(ProdOrder);
                    end;
                OnAfterProdOrderChgAndReshedule(ReqLine, ProdOrderLine);
            end else begin
                Message(StrSubstNo(CouldNotChangeSupplyTxt, "Ref. Order No.", "Ref. Line No."));
                exit(false);
            end;
        end;
        exit(true);
    end;

    procedure PurchOrderChgAndReshedule(ReqLine: Record "Requisition Line")
    var
        PurchLine: Record "Purchase Line";
        PurchHeader: Record "Purchase Header";
    begin
        ReqLine.TestField("Ref. Order Type", ReqLine."Ref. Order Type"::Purchase);
        if PurchLine.Get(PurchLine."Document Type"::Order, ReqLine."Ref. Order No.", ReqLine."Ref. Line No.") then begin
            OnPurchOrderChgAndResheduleOnAfterGetPurchLine(PurchLine);
            PurchLine.BlockDynamicTracking(true);
            PurchLine.Validate(Quantity, ReqLine.Quantity);
            OnPurchOrderChgAndResheduleOnBeforeValidateExpectedReceiptDate(ReqLine);
            PurchLine.Validate("Expected Receipt Date", ReqLine."Due Date");
            PurchLine.Validate("Planning Flexibility", ReqLine."Planning Flexibility");
            OnPurchOrderChgAndResheduleOnBeforePurchLineModify(ReqLine, PurchLine);
            PurchLine.Modify(true);
            ReqLineReserve.TransferReqLineToPurchLine(ReqLine, PurchLine, 0, true);
            ReqLineReserve.UpdateDerivedTracking(ReqLine);
            ReservMgt.SetReservSource(PurchLine);
            ReservMgt.DeleteReservEntries(false, PurchLine."Outstanding Qty. (Base)");
            ReservMgt.ClearSurplus();
            ReservMgt.AutoTrack(PurchLine."Outstanding Qty. (Base)");

            PurchHeader.Get(PurchLine."Document Type", PurchLine."Document No.");
            OnPurchOrderChgAndResheduleOnAfterGetPurchHeader(PurchHeader);
            PrintPurchaseOrder(PurchHeader);
        end else
            Error(CouldNotChangeSupplyTxt, ReqLine."Ref. Order No.", ReqLine."Ref. Line No.");
    end;

    procedure TransOrderChgAndReshedule(ReqLine: Record "Requisition Line")
    var
        TransLine: Record "Transfer Line";
        TransHeader: Record "Transfer Header";
    begin
        ReqLine.TestField("Ref. Order Type", ReqLine."Ref. Order Type"::Transfer);

        if TransLine.Get(ReqLine."Ref. Order No.", ReqLine."Ref. Line No.") then begin
            TransLine.BlockDynamicTracking(true);
            TransLine.Validate(Quantity, ReqLine.Quantity);
            TransLine.Validate("Receipt Date", ReqLine."Due Date");
            TransLine."Shipment Date" := ReqLine."Transfer Shipment Date";
            TransLine.Validate("Planning Flexibility", ReqLine."Planning Flexibility");
            OnTransOrderChgAndResheduleOnBeforeTransLineModify(ReqLine, TransLine);
            TransLine.Modify(true);
            ReqLineReserve.TransferReqLineToTransLine(ReqLine, TransLine, 0, true);
            ReqLineReserve.UpdateDerivedTracking(ReqLine);
            ReservMgt.SetReservSource(TransLine, "Transfer Direction"::Outbound);
            ReservMgt.DeleteReservEntries(false, TransLine."Outstanding Qty. (Base)");
            ReservMgt.ClearSurplus();
            ReservMgt.AutoTrack(TransLine."Outstanding Qty. (Base)");
            ReservMgt.SetReservSource(TransLine, "Transfer Direction"::Inbound);
            ReservMgt.DeleteReservEntries(false, TransLine."Outstanding Qty. (Base)");
            ReservMgt.ClearSurplus();
            ReservMgt.AutoTrack(TransLine."Outstanding Qty. (Base)");
            TransHeader.Get(TransLine."Document No.");
            PrintTransferOrder(TransHeader);
        end;
    end;

    procedure AsmOrderChgAndReshedule(ReqLine: Record "Requisition Line"): Boolean
    var
        AsmHeader: Record "Assembly Header";
        PlanningComponent: Record "Planning Component";
        AsmLine: Record "Assembly Line";
    begin
        with ReqLine do begin
            TestField("Ref. Order Type", "Ref. Order Type"::Assembly);
            AsmHeader.LockTable();
            if AsmHeader.Get(AsmHeader."Document Type"::Order, "Ref. Order No.") then begin
                AsmHeader.SetWarningsOff();
                AsmHeader.Validate(Quantity, Quantity);
                AsmHeader.Validate("Planning Flexibility", "Planning Flexibility");
                AsmHeader.Validate("Due Date", "Due Date");
                OnAsmOrderChgAndResheduleOnBeforeAsmHeaderModify(ReqLine, AsmHeader);
                AsmHeader.Modify(true);
                ReqLineReserve.TransferPlanningLineToAsmHdr(ReqLine, AsmHeader, 0, true);
                ReqLineReserve.UpdateDerivedTracking(ReqLine);
                ReservMgt.SetReservSource(AsmHeader);
                ReservMgt.DeleteReservEntries(false, AsmHeader."Remaining Quantity (Base)");
                ReservMgt.ClearSurplus();
                ReservMgt.AutoTrack(AsmHeader."Remaining Quantity (Base)");

                PlanningComponent.SetRange("Worksheet Template Name", "Worksheet Template Name");
                PlanningComponent.SetRange("Worksheet Batch Name", "Journal Batch Name");
                PlanningComponent.SetRange("Worksheet Line No.", "Line No.");
                if PlanningComponent.Find('-') then
                    repeat
                        if AsmLine.Get(AsmHeader."Document Type", AsmHeader."No.", PlanningComponent."Line No.") then begin
                            ReservePlanningComponent.TransferPlanningCompToAsmLine(PlanningComponent, AsmLine, 0, true);
                            ReservePlanningComponent.UpdateDerivedTracking(PlanningComponent);
                            ReservMgt.SetReservSource(AsmLine);
                            ReservMgt.DeleteReservEntries(false, AsmLine."Remaining Quantity (Base)");
                            ReservMgt.ClearSurplus();
                            ReservMgt.AutoTrack(AsmLine."Remaining Quantity (Base)");
                            CheckDateConflict.AssemblyLineCheck(AsmLine, false);
                        end else
                            PlanningComponent.Delete(true);
                    until PlanningComponent.Next() = 0;

                CollectAsmOrderForPrinting(AsmHeader);
            end else begin
                Message(StrSubstNo(CouldNotChangeSupplyTxt, "Ref. Order No.", "Ref. Line No."));
                exit(false);
            end;
        end;
        exit(true);
    end;

    procedure DeleteOrderLines(ReqLine: Record "Requisition Line")
    begin
        OnBeforeDeleteOrderLines(ReqLine);

        case ReqLine."Ref. Order Type" of
            ReqLine."Ref. Order Type"::"Prod. Order":
                DeleteProdOrderLines(ReqLine);
            ReqLine."Ref. Order Type"::Purchase:
                DeletePurchaseOrderLines(ReqLine);
            ReqLine."Ref. Order Type"::Transfer:
                DeleteTransferOrderLines(ReqLine);
            ReqLine."Ref. Order Type"::Assembly:
                DeleteAssemblyOrderLines(ReqLine);
        end;

        OnAfterDeleteOrderLines(ReqLine);
    end;

    local procedure DeleteProdOrderLines(ReqLine: Record "Requisition Line")
    var
        ProdOrder: Record "Production Order";
        ProdOrderLine: Record "Prod. Order Line";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeDeleteProdOrderLines(ReqLine, IsHandled);
        if IsHandled then
            exit;

        ProdOrderLine.SetCurrentKey(Status, "Prod. Order No.", "Line No.");
        ProdOrderLine.SetFilter("Item No.", '<>%1', '');
        ProdOrderLine.SetRange(Status, ReqLine."Ref. Order Status");
        ProdOrderLine.SetRange("Prod. Order No.", ReqLine."Ref. Order No.");
        if ProdOrderLine.Count in [0, 1] then begin
            if ProdOrder.Get(ReqLine."Ref. Order Status", ReqLine."Ref. Order No.") then
                ProdOrder.Delete(true);
        end else begin
            ProdOrderLine.SetRange("Line No.", ReqLine."Ref. Line No.");
            if ProdOrderLine.FindFirst() then
                ProdOrderLine.Delete(true);
        end;
    end;

    local procedure DeletePurchaseOrderLines(ReqLine: Record "Requisition Line")
    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeDeletePurchaseLines(ReqLine, IsHandled);
        if IsHandled then
            exit;

        PurchLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
        PurchLine.SetFilter(Type, '<>%1', PurchLine.Type::" ");
        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SetRange("Document No.", ReqLine."Ref. Order No.");
        if PurchLine.Count in [0, 1] then begin
            if PurchHeader.Get(PurchHeader."Document Type"::Order, ReqLine."Ref. Order No.") then
                PurchHeader.Delete(true);
        end else begin
            PurchLine.SetRange("Line No.", ReqLine."Ref. Line No.");
            if PurchLine.FindFirst() then
                PurchLine.Delete(true);
        end;
    end;

    local procedure DeleteTransferOrderLines(ReqLine: Record "Requisition Line")
    var
        TransHeader: Record "Transfer Header";
        TransLine: Record "Transfer Line";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeDeleteTransferLines(ReqLine, IsHandled);
        if IsHandled then
            exit;

        TransLine.SetCurrentKey("Document No.", "Line No.");
        TransLine.SetRange("Document No.", ReqLine."Ref. Order No.");
        if TransLine.Count in [0, 1] then begin
            if TransHeader.Get(ReqLine."Ref. Order No.") then
                TransHeader.Delete(true);
        end else begin
            TransLine.SetRange("Line No.", ReqLine."Ref. Line No.");
            if TransLine.FindFirst() then
                TransLine.Delete(true);
        end;
    end;

    local procedure DeleteAssemblyOrderLines(ReqLine: Record "Requisition Line")
    var
        AsmHeader: Record "Assembly Header";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeDeleteAssemblyLines(ReqLine, IsHandled);
        if IsHandled then
            exit;

        AsmHeader.Get(AsmHeader."Document Type"::Order, ReqLine."Ref. Order No.");
        AsmHeader.Delete(true);
    end;

    local procedure DeleteRequisitionLine(var RequisitionLine: Record "Requisition Line")
    begin
        OnBeforeDeleteRequisitionLine(RequisitionLine);
        RequisitionLine.Delete(true);
        OnAfterDeleteRequisitionLine(RequisitionLine);
    end;

#if not CLEAN21
    [Obsolete('Replaced by InsertProductionOrder', '21.0')]
    procedure InsertProdOrder(ReqLine: Record "Requisition Line"; ProdOrderChoice: Option " ",Planned,"Firm Planned","Firm Planned & Print")
    begin
        InsertProductionOrder(ReqLine, "Planning Create Prod. Order".FromInteger(ProdOrderChoice));
    end;
#endif

    procedure InsertProductionOrder(ReqLine: Record "Requisition Line"; ProdOrderChoice: Enum "Planning Create Prod. Order")
    var
        MfgSetup: Record "Manufacturing Setup";
        Item: Record Item;
        ProdOrder: Record "Production Order";
        HeaderExist: Boolean;
        IsHandled: Boolean;
    begin
        Item.Get(ReqLine."No.");
        MfgSetup.Get();
        if FindTempProdOrder(ReqLine) then
            HeaderExist := ProdOrder.Get(TempProductionOrder.Status, TempProductionOrder."No.");

        OnInsertProdOrderOnAfterFindTempProdOrder(ReqLine, ProdOrder, HeaderExist, Item);

        if not HeaderExist then begin
            case ProdOrderChoice of
                ProdOrderChoice::Planned:
                    MfgSetup.TestField("Planned Order Nos.");
                ProdOrderChoice::"Firm Planned",
                ProdOrderChoice::"Firm Planned & Print":
                    MfgSetup.TestField("Firm Planned Order Nos.");
                else
                    OnInsertProductionOrderOnProdOrderChoiceCaseElse(ProdOrderChoice);
            end;

            OnInsertProdOrderOnBeforeProdOrderInit(ReqLine);
            ProdOrder.Init();
            if ProdOrderChoice = ProdOrderChoice::"Firm Planned & Print" then
                ProdOrder.Status := ProdOrder.Status::"Firm Planned"
            else begin
                IsHandled := false;
                OnInsertProdOrderOnProdOrderChoiceNotFirmPlannedPrint(ProdOrder, ProdOrderChoice, IsHandled);
                if not IsHandled then
                    ProdOrder.Status := "Production Order Status".FromInteger(ProdOrderChoice.AsInteger());
            end;
            ProdOrder."No. Series" := ProdOrder.GetNoSeriesCode();
            if ProdOrder."No. Series" = ReqLine."No. Series" then
                ProdOrder."No." := ReqLine."Ref. Order No.";
            OnInsertProdOrderOnBeforeProdOrderInsert(ProdOrder, ReqLine);
            ProdOrder.Insert(true);
            OnInsertProdOrderOnAfterProdOrderInsert(ProdOrder, ReqLine);
            ProdOrder."Source Type" := ProdOrder."Source Type"::Item;
            ProdOrder."Source No." := ReqLine."No.";
            ProdOrder.Validate(Description, ReqLine.Description);
            ProdOrder."Description 2" := ReqLine."Description 2";
            ProdOrder."Variant Code" := ReqLine."Variant Code";
            ProdOrder."Creation Date" := Today;
            ProdOrder."Last Date Modified" := Today;
            ProdOrder."Inventory Posting Group" := Item."Inventory Posting Group";
            ProdOrder."Gen. Prod. Posting Group" := ReqLine."Gen. Prod. Posting Group";
            ProdOrder."Due Date" := ReqLine."Due Date";
            ProdOrder."Starting Time" := ReqLine."Starting Time";
            ProdOrder."Starting Date" := ReqLine."Starting Date";
            ProdOrder."Ending Time" := ReqLine."Ending Time";
            ProdOrder."Ending Date" := ReqLine."Ending Date";
            ProdOrder."Location Code" := ReqLine."Location Code";
            ProdOrder."Bin Code" := ReqLine."Bin Code";
            ProdOrder."Low-Level Code" := ReqLine."Low-Level Code";
            ProdOrder."Routing No." := ReqLine."Routing No.";
            ProdOrder.Quantity := ReqLine.Quantity;
            ProdOrder."Unit Cost" := ReqLine."Unit Cost";
            ProdOrder."Cost Amount" := ReqLine."Cost Amount";
            ProdOrder."Shortcut Dimension 1 Code" := ReqLine."Shortcut Dimension 1 Code";
            ProdOrder."Shortcut Dimension 2 Code" := ReqLine."Shortcut Dimension 2 Code";
            ProdOrder."Dimension Set ID" := ReqLine."Dimension Set ID";
            ProdOrder.UpdateDatetime();
            OnInsertProdOrderWithReqLine(ProdOrder, ReqLine);
            ProdOrder.Modify();
            InsertTempProdOrder(ReqLine, ProdOrder);
        end;
        InsertProdOrderLine(ReqLine, ProdOrder, Item);

        OnAfterInsertProdOrder(ProdOrder, ProdOrderChoice.AsInteger(), ReqLine);
    end;

    procedure InsertProdOrderLine(ReqLine: Record "Requisition Line"; ProdOrder: Record "Production Order"; Item: Record Item)
    var
        ProdOrderLine: Record "Prod. Order Line";
        CalculateProdOrder: Codeunit "Calculate Prod. Order";
        NextLineNo: Integer;
    begin
        ProdOrderLine.SetRange("Prod. Order No.", ProdOrder."No.");
        ProdOrderLine.SetRange(Status, ProdOrder.Status);
        ProdOrderLine.LockTable();
        if ProdOrderLine.FindLast() then
            NextLineNo := ProdOrderLine."Line No." + 10000
        else
            NextLineNo := 10000;

        OnInsertProdOrderLineOnBeforeProdOrderLineInit(ReqLine, Item);
        ProdOrderLine.Init();
        ProdOrderLine.BlockDynamicTracking(true);
        ProdOrderLine.Status := ProdOrder.Status;
        ProdOrderLine."Prod. Order No." := ProdOrder."No.";
        ProdOrderLine."Line No." := NextLineNo;
        ProdOrderLine."Item No." := ReqLine."No.";
        ProdOrderLine.Validate("Unit of Measure Code", ReqLine."Unit of Measure Code");
        ProdOrderLine."Production BOM Version Code" := ReqLine."Production BOM Version Code";
        ProdOrderLine."Routing Version Code" := ReqLine."Routing Version Code";
        ProdOrderLine."Routing Type" := ReqLine."Routing Type";
        ProdOrderLine."Routing Reference No." := ProdOrderLine."Line No.";
        ProdOrderLine.Description := ReqLine.Description;
        ProdOrderLine."Description 2" := ReqLine."Description 2";
        ProdOrderLine."Variant Code" := ReqLine."Variant Code";
        ProdOrderLine."Location Code" := ReqLine."Location Code";
        OnInsertProdOrderLineOnBeforeGetBinCode(ProdOrderLine, ReqLine);
        if ReqLine."Bin Code" <> '' then
            ProdOrderLine.Validate("Bin Code", ReqLine."Bin Code")
        else
            CalcProdOrder.SetProdOrderLineBinCodeFromRoute(ProdOrderLine, ProdOrder."Location Code", ProdOrder."Routing No.");
        ProdOrderLine."Scrap %" := ReqLine."Scrap %";
        ProdOrderLine."Production BOM No." := ReqLine."Production BOM No.";
        ProdOrderLine."Inventory Posting Group" := Item."Inventory Posting Group";
        ProdOrderLine.Validate("Unit Cost", ReqLine."Unit Cost");
        ProdOrderLine."Routing No." := ReqLine."Routing No.";
        ProdOrderLine."Starting Time" := ReqLine."Starting Time";
        ProdOrderLine."Starting Date" := ReqLine."Starting Date";
        ProdOrderLine."Ending Time" := ReqLine."Ending Time";
        ProdOrderLine."Ending Date" := ReqLine."Ending Date";
        ProdOrderLine."Due Date" := ReqLine."Due Date";
        ProdOrderLine.Status := ProdOrder.Status;
        ProdOrderLine."Planning Level Code" := ReqLine."Planning Level";
        ProdOrderLine."Indirect Cost %" := ReqLine."Indirect Cost %";
        ProdOrderLine."Overhead Rate" := ReqLine."Overhead Rate";
        UpdateProdOrderLineQuantity(ProdOrderLine, ReqLine, Item);
        if not (ProdOrder.Status = ProdOrder.Status::Planned) then
            ProdOrderLine."Planning Flexibility" := ReqLine."Planning Flexibility";
        ProdOrderLine.UpdateDatetime();
        ProdOrderLine."Shortcut Dimension 1 Code" := ReqLine."Shortcut Dimension 1 Code";
        ProdOrderLine."Shortcut Dimension 2 Code" := ReqLine."Shortcut Dimension 2 Code";
        ProdOrderLine."Dimension Set ID" := ReqLine."Dimension Set ID";
        OnInsertProdOrderLineWithReqLine(ProdOrderLine, ReqLine);
        ProdOrderLine.Insert();
        OnInsertProdOrderLineOnAfterProdOrderLineInsert(ProdOrderLine, ReqLine);
        CalculateProdOrder.CalculateProdOrderDates(ProdOrderLine, false);

        ReqLineReserve.TransferPlanningLineToPOLine(ReqLine, ProdOrderLine, ReqLine."Net Quantity (Base)", false);
        if ReqLine.Reserve and not (ProdOrderLine.Status = ProdOrderLine.Status::Planned) then
            ReserveBindingOrderToProd(ProdOrderLine, ReqLine);

        ProdOrderLine.Modify();
        SetProdOrderLineBinCodeFromPlanningRtngLines(ProdOrder, ProdOrderLine, ReqLine, Item);
        TransferBOM(ReqLine, ProdOrder, ProdOrderLine."Line No.");
        TransferCapNeed(ReqLine, ProdOrder, ProdOrderLine."Routing No.", ProdOrderLine."Routing Reference No.");

        if ProdOrderLine."Planning Level Code" > 0 then
            UpdateComponentLink(ProdOrderLine);

        OnAfterInsertProdOrderLine(ReqLine, ProdOrder, ProdOrderLine, Item);

        FinalizeOrderHeader(ProdOrder);
    end;

    local procedure SetProdOrderLineBinCodeFromPlanningRtngLines(ProdOrder: Record "Production Order"; var ProdOrderLine: Record "Prod. Order Line"; ReqLine: Record "Requisition Line"; Item: Record Item)
    var
        RefreshProdOrderLine: Boolean;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeSetProdOrderLineBinCodeFromPlanningRtngLines(ProdOrder, ProdOrderLine, ReqLine, Item, IsHandled);
        if IsHandled then
            exit;

        if TransferRouting(ReqLine, ProdOrder, ProdOrderLine."Routing No.", ProdOrderLine."Routing Reference No.") then begin
            RefreshProdOrderLine := false;
            OnInsertProdOrderLineOnAfterTransferRouting(ProdOrderLine, RefreshProdOrderLine);
            if RefreshProdOrderLine then
                ProdOrderLine.Get(ProdOrderLine.Status, ProdOrderLine."Prod. Order No.", ProdOrderLine."Line No.");
            CalcProdOrder.SetProdOrderLineBinCodeFromPlanningRtngLines(ProdOrderLine, ReqLine);
            ProdOrderLine.Modify();
        end;
    end;

    local procedure UpdateProdOrderLineQuantity(var ProdOrderLine: Record "Prod. Order Line"; ReqLine: Record "Requisition Line"; Item: Record Item)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeUpdateProdOrderLineQuantity(ProdOrderLine, ReqLine, Item, IsHandled);
        if IsHandled then
            exit;

        ProdOrderLine.Validate(Quantity, ReqLine.Quantity);
    end;

    [Scope('OnPrem')]
    procedure InsertAsmHeader(ReqLine: Record "Requisition Line"; var AsmHeader: Record "Assembly Header")
    var
        Item: Record Item;
    begin
        Item.Get(ReqLine."No.");
        AsmHeader.Init();
        AsmHeader."Document Type" := AsmHeader."Document Type"::Order;
        OnInsertAsmHeaderOnBeforeAsmHeaderInsert(AsmHeader, ReqLine);
        AsmHeader.Insert(true);
        OnInsertAsmHeaderOnAfterAsmHeaderInsert(AsmHeader, ReqLine);
        AsmHeader.SetWarningsOff();
        AsmHeader.Validate("Item No.", ReqLine."No.");
        AsmHeader.Validate("Unit of Measure Code", ReqLine."Unit of Measure Code");
        AsmHeader.Description := ReqLine.Description;
        AsmHeader."Description 2" := ReqLine."Description 2";
        AsmHeader."Variant Code" := ReqLine."Variant Code";
        AsmHeader."Location Code" := ReqLine."Location Code";
        AsmHeader."Inventory Posting Group" := Item."Inventory Posting Group";
        AsmHeader.Validate("Unit Cost", ReqLine."Unit Cost");
        AsmHeader."Due Date" := ReqLine."Due Date";
        AsmHeader."Starting Date" := ReqLine."Starting Date";
        AsmHeader."Ending Date" := ReqLine."Ending Date";

        AsmHeader.Quantity := ReqLine.Quantity;
        AsmHeader."Quantity (Base)" := ReqLine."Quantity (Base)";
        AsmHeader.InitRemainingQty();
        AsmHeader.InitQtyToAssemble();
        if ReqLine."Bin Code" <> '' then
            AsmHeader."Bin Code" := ReqLine."Bin Code"
        else
            AsmHeader.GetDefaultBin();

        AsmHeader."Planning Flexibility" := ReqLine."Planning Flexibility";
        AsmHeader."Shortcut Dimension 1 Code" := ReqLine."Shortcut Dimension 1 Code";
        AsmHeader."Shortcut Dimension 2 Code" := ReqLine."Shortcut Dimension 2 Code";
        AsmHeader."Dimension Set ID" := ReqLine."Dimension Set ID";
        ReqLineReserve.TransferPlanningLineToAsmHdr(ReqLine, AsmHeader, ReqLine."Net Quantity (Base)", false);
        if ReqLine.Reserve then
            ReserveBindingOrderToAsm(AsmHeader, ReqLine);
        AsmHeader.Modify();

        TransferAsmPlanningComp(ReqLine, AsmHeader);

        AddResourceComponents(ReqLine, AsmHeader);

        OnAfterInsertAsmHeader(ReqLine, AsmHeader);

        CollectAsmOrderForPrinting(AsmHeader);

        TempDocumentEntry.Init();
        TempDocumentEntry."Table ID" := DATABASE::"Assembly Header";
        TempDocumentEntry."Document Type" := AsmHeader."Document Type"::Order;
        TempDocumentEntry."Document No." := AsmHeader."No.";
        TempDocumentEntry."Entry No." := TempDocumentEntry.Count + 1;
        TempDocumentEntry.Insert();
    end;

    local procedure CollectAsmOrderForPrinting(var AsmHeader: Record "Assembly Header")
    begin
        if PrintOrder then begin
            TempAsmOrderToPrint.Init();
            TempAsmOrderToPrint."Document Type" := AsmHeader."Document Type";
            TempAsmOrderToPrint."No." := AsmHeader."No.";
            TempAsmOrderToPrint."Item No." := AsmHeader."Item No.";
            TempAsmOrderToPrint.Insert(false);
        end;
    end;

    local procedure AddResourceComponents(RequisitionLine: Record "Requisition Line"; var AssemblyHeader: Record "Assembly Header")
    var
        BOMComponent: Record "BOM Component";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeAddResourceComponents(RequisitionLine, AssemblyHeader, IsHandled);
        if IsHandled then
            exit;

        BOMComponent.SetRange("Parent Item No.", RequisitionLine."No.");
        BOMComponent.SetRange(Type, BOMComponent.Type::Resource);
        if BOMComponent.Find('-') then
            repeat
                AssemblyHeader.AddBOMLine(BOMComponent);
            until BOMComponent.Next() = 0;
    end;

    procedure TransferAsmPlanningComp(ReqLine: Record "Requisition Line"; AsmHeader: Record "Assembly Header")
    var
        AsmLine: Record "Assembly Line";
        PlanningComponent: Record "Planning Component";
    begin
        PlanningComponent.SetRange("Worksheet Template Name", ReqLine."Worksheet Template Name");
        PlanningComponent.SetRange("Worksheet Batch Name", ReqLine."Journal Batch Name");
        PlanningComponent.SetRange("Worksheet Line No.", ReqLine."Line No.");
        if PlanningComponent.Find('-') then
            repeat
                AsmLine.Init();
                AsmLine."Document Type" := AsmHeader."Document Type";
                AsmLine."Document No." := AsmHeader."No.";
                AsmLine."Line No." := PlanningComponent."Line No.";
                AsmLine.Type := AsmLine.Type::Item;
                AsmLine."Dimension Set ID" := PlanningComponent."Dimension Set ID";
                AsmLine.Validate("No.", PlanningComponent."Item No.");
                AsmLine.Description := PlanningComponent.Description;
                AsmLine."Unit of Measure Code" := PlanningComponent."Unit of Measure Code";
                AsmLine."Qty. Rounding Precision" := PlanningComponent."Qty. Rounding Precision";
                AsmLine."Qty. Rounding Precision (Base)" := PlanningComponent."Qty. Rounding Precision (Base)";
                AsmLine."Lead-Time Offset" := PlanningComponent."Lead-Time Offset";
                AsmLine.Position := PlanningComponent.Position;
                AsmLine."Position 2" := PlanningComponent."Position 2";
                AsmLine."Position 3" := PlanningComponent."Position 3";
                AsmLine."Variant Code" := PlanningComponent."Variant Code";
                AsmLine."Location Code" := PlanningComponent."Location Code";

                AsmLine."Quantity per" := PlanningComponent."Quantity per";
                AsmLine."Qty. per Unit of Measure" := PlanningComponent."Qty. per Unit of Measure";
                AsmLine.Quantity := PlanningComponent."Expected Quantity";
                AsmLine."Quantity (Base)" := PlanningComponent."Expected Quantity (Base)";
                AsmLine.InitRemainingQty();
                AsmLine.InitQtyToConsume();
                if PlanningComponent."Bin Code" <> '' then
                    AsmLine."Bin Code" := PlanningComponent."Bin Code"
                else
                    AsmLine.GetDefaultBin();

                AsmLine."Due Date" := PlanningComponent."Due Date";
                AsmLine."Unit Cost" := PlanningComponent."Unit Cost";
                AsmLine."Variant Code" := PlanningComponent."Variant Code";
                AsmLine."Cost Amount" := PlanningComponent."Cost Amount";

                AsmLine."Shortcut Dimension 1 Code" := PlanningComponent."Shortcut Dimension 1 Code";
                AsmLine."Shortcut Dimension 2 Code" := PlanningComponent."Shortcut Dimension 2 Code";

                OnAfterTransferAsmPlanningComp(PlanningComponent, AsmLine);

                AsmLine.Insert();

                ReservePlanningComponent.TransferPlanningCompToAsmLine(PlanningComponent, AsmLine, 0, true);
                AsmLine.AutoReserve();
                ReservMgt.SetReservSource(AsmLine);
                ReservMgt.AutoTrack(AsmLine."Remaining Quantity (Base)");
            until PlanningComponent.Next() = 0;
    end;

    procedure InsertTransHeader(ReqLine: Record "Requisition Line"; var TransHeader: Record "Transfer Header")
    var
        InvtSetup: Record "Inventory Setup";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeInsertTransHeader(ReqLine, TransHeader, IsHandled);
        if IsHandled then
            exit;

        InvtSetup.Get();
        InvtSetup.TestField("Transfer Order Nos.");

        with ReqLine do begin
            TransHeader.Init();
            TransHeader."No." := '';
            TransHeader."Posting Date" := WorkDate();
            OnInsertTransHeaderOnBeforeTransHeaderInsert(TransHeader, ReqLine);
            TransHeader.Insert(true);
            OnInsertTransHeaderOnAfterTransHeaderInsert(TransHeader, ReqLine);
            TransHeader.Validate("Transfer-from Code", "Transfer-from Code");
            TransHeader.Validate("Transfer-to Code", "Location Code");
            TransHeader."Receipt Date" := "Due Date";
            TransHeader."Shipment Date" := "Transfer Shipment Date";
            OnInsertTransHeaderOnBeforeTransHeaderModify(TransHeader, ReqLine);
            TransHeader.Modify();
            TempDocumentEntry.Init();
            TempDocumentEntry."Table ID" := DATABASE::"Transfer Header";
            TempDocumentEntry."Document No." := TransHeader."No.";
            TempDocumentEntry."Entry No." := TempDocumentEntry.Count + 1;
            TempDocumentEntry.Insert();
        end;

        if PrintOrder then begin
            TempTransHeaderToPrint."No." := TransHeader."No.";
            TempTransHeaderToPrint.Insert();
        end;
    end;

    procedure InsertTransLine(ReqLine: Record "Requisition Line"; var TransHeader: Record "Transfer Header")
    var
        TransLine: Record "Transfer Line";
        NextLineNo: Integer;
        ShouldInsertTransHeader: Boolean;
    begin
        ShouldInsertTransHeader := (ReqLine."Transfer-from Code" <> TransHeader."Transfer-from Code") or
           (ReqLine."Location Code" <> TransHeader."Transfer-to Code");
        OnInsertTransLineOnAfterCalcShouldInsertTransHeader(ReqLine, TransHeader, ShouldInsertTransHeader);
        if ShouldInsertTransHeader then
            InsertTransHeader(ReqLine, TransHeader);

        TransLine.SetRange("Document No.", TransHeader."No.");
        if TransLine.FindLast() then
            NextLineNo := TransLine."Line No." + 10000
        else
            NextLineNo := 10000;

        TransLine.Init();
        OnInsertTransLineOnAfterTransLineInit(TransLine, ReqLine);
        TransLine.BlockDynamicTracking(true);
        TransLine."Document No." := TransHeader."No.";
        TransLine."Line No." := NextLineNo;
        TransLine.Validate("Item No.", ReqLine."No.");
        TransLine.Description := ReqLine.Description;
        TransLine."Description 2" := ReqLine."Description 2";
        TransLine.Validate("Variant Code", ReqLine."Variant Code");
        TransLine.Validate("Transfer-from Code", ReqLine."Transfer-from Code");
        TransLine.Validate("Transfer-to Code", ReqLine."Location Code");
        TransLine.Validate(Quantity, ReqLine.Quantity);
        TransLine.Validate("Unit of Measure Code", ReqLine."Unit of Measure Code");
        CopyDimensionsFromReqToTransLine(TransLine, ReqLine);
        TransLine."Receipt Date" := ReqLine."Due Date";
        TransLine."Shipment Date" := ReqLine."Transfer Shipment Date";
        TransLine.Validate("Planning Flexibility", ReqLine."Planning Flexibility");
        OnInsertTransLineWithReqLine(TransLine, ReqLine, NextLineNo);
        TransLine.Insert();
        OnAfterTransLineInsert(TransLine, ReqLine);

        ReqLineReserve.TransferReqLineToTransLine(ReqLine, TransLine, ReqLine."Quantity (Base)", false);
        if ReqLine.Reserve then
            ReserveBindingOrderToTrans(TransLine, ReqLine);

        OnAfterInsertTransLine(TransHeader, ReqLine, TransLine, NextLineNo);
    end;

    local procedure CopyDimensionsFromReqToTransLine(var TransferLine: Record "Transfer Line"; RequisitionLine: Record "Requisition Line")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCopyDimensionsFromReqToTransLine(TransferLine, RequisitionLine, IsHandled);
        if IsHandled then
            exit;

        TransferLine."Shortcut Dimension 1 Code" := RequisitionLine."Shortcut Dimension 1 Code";
        TransferLine."Shortcut Dimension 2 Code" := RequisitionLine."Shortcut Dimension 2 Code";
        TransferLine."Dimension Set ID" := RequisitionLine."Dimension Set ID";
    end;

    procedure PrintTransferOrders()
    begin
        CarryOutAction.GetTransferOrdersToPrint(TempTransHeaderToPrint);
        if TempTransHeaderToPrint.FindSet() then begin
            PrintOrder := true;
            repeat
                PrintTransferOrder(TempTransHeaderToPrint);
            until TempTransHeaderToPrint.Next() = 0;

            TempTransHeaderToPrint.DeleteAll();
        end;
    end;

    procedure PrintTransferOrder(TransHeader: Record "Transfer Header")
    var
        ReportSelections: Record "Report Selections";
        TransHeader2: Record "Transfer Header";
    begin
        if PrintOrder then begin
            TransHeader2 := TransHeader;
            TransHeader2.SetRecFilter();
            OnPrintTransferOrderOnBeforePrintWithDialogWithCheckForCust(ReportSelections);
            ReportSelections.PrintWithDialogWithCheckForCust("Report Selection Usage"::Inv1, TransHeader2, false, 0);
        end;
    end;

    procedure PrintPurchaseOrder(PurchHeader: Record "Purchase Header")
    var
        ReportSelection: Record "Report Selections";
        PurchHeader2: Record "Purchase Header";
        PurchSetup: Record "Purchases & Payables Setup";
        PurchLine: Record "Purchase Line";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforePrintPurchaseOrder2(PurchHeader, PrintOrder, IsHandled);
        if IsHandled then
            exit;

        if PrintOrder and (PurchHeader."Buy-from Vendor No." <> '') then begin
            PurchHeader2 := PurchHeader;
            PurchSetup.Get();
            if PurchSetup."Calc. Inv. Discount" then begin
                PurchLine.Reset();
                PurchLine.SetRange("Document Type", PurchHeader."Document Type");
                PurchLine.SetRange("Document No.", PurchHeader."No.");
                PurchLine.FindFirst();
                CODEUNIT.Run(CODEUNIT::"Purch.-Calc.Discount", PurchLine);
            end;

            IsHandled := false;
            OnBeforePrintPurchaseOrder(PurchHeader2, IsHandled, PrintOrder);
            if IsHandled then
                exit;

            PurchHeader2.SetRecFilter();
            ReportSelection.PrintWithDialogWithCheckForVend(
              ReportSelection.Usage::"P.Order", PurchHeader2, false, PurchHeader2.FieldNo("Buy-from Vendor No."));
        end;
    end;

    procedure PrintMultiplePurchaseOrders(var TempPurchaseHeader: Record "Purchase Header" temporary)
    var
        PurchaseHeader: Record "Purchase Header";
        ReportSelections: Record "Report Selections";
        PurchCalcDiscByType: Codeunit "Purch - Calc Disc. By Type";
        SelectionFilterMgt: Codeunit SelectionFilterManagement;
        TempRecRef: RecordRef;
        RecRef: RecordRef;
        PurchaseOrderNoFilter: Text;
        IsHandled: Boolean;
    begin
        if not PrintOrder then
            exit;

        TempPurchaseHeader.Reset();
        if TempPurchaseHeader.IsEmpty() then
            exit;

        TempPurchaseHeader.FindSet();
        repeat
            PurchaseHeader.Get(TempPurchaseHeader."Document Type", TempPurchaseHeader."No.");
            PurchCalcDiscByType.ApplyDefaultInvoiceDiscount(0, PurchaseHeader);
        until TempPurchaseHeader.Next() = 0;

        IsHandled := false;
        OnBeforePrintMultiplePurchaseDocs(TempPurchaseHeader, IsHandled);
        if IsHandled then
            exit;

        TempRecRef.GetTable(TempPurchaseHeader);
        RecRef.GetTable(PurchaseHeader);
        PurchaseOrderNoFilter := SelectionFilterMgt.CreateFilterFromTempTable(TempRecRef, RecRef, PurchaseHeader.FieldNo("No."));

        PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
        PurchaseHeader.SetFilter("No.", PurchaseOrderNoFilter);
        PurchaseHeader.SetFilter("Buy-from Vendor No.", '<>%1', '');
        ReportSelections.PrintWithDialogWithCheckForVend(
            ReportSelections.Usage::"P.Order", PurchaseHeader, false, PurchaseHeader.FieldNo("Buy-from Vendor No."));
    end;

    procedure PrintAsmOrder(AsmHeader: Record "Assembly Header")
    var
        ReportSelections: Record "Report Selections";
        AsmHeader2: Record "Assembly Header";
    begin
        if PrintOrder and (AsmHeader."Item No." <> '') then begin
            AsmHeader2 := AsmHeader;
            AsmHeader2.SetRecFilter();
            ReportSelections.PrintWithDialogWithCheckForCust(ReportSelections.Usage::"Asm.Order", AsmHeader2, false, 0);
        end;
    end;

    internal procedure PrintAsmOrders()
    var
        AssemblyHeader: Record "Assembly Header";
        ReportSelections: Record "Report Selections";
        SelectionFilterMgt: Codeunit SelectionFilterManagement;
        TempRecRef: RecordRef;
        RecRef: RecordRef;
    begin
        CarryOutAction.GetAllAssemblyOrderForPrinting(TempAsmOrderToPrint);
        if not TempAsmOrderToPrint.IsEmpty() then begin
            TempRecRef.GetTable(TempAsmOrderToPrint);
            RecRef.GetTable(AssemblyHeader);
            AssemblyHeader.SetFilter("No.", SelectionFilterMgt.CreateFilterFromTempTable(TempRecRef, RecRef, AssemblyHeader.FieldNo("No.")));
            AssemblyHeader.SetFilter("Item No.", '<>%1', '');
            ReportSelections.PrintWithDialogWithCheckForCust(ReportSelections.Usage::"Asm.Order", AssemblyHeader, false, 0);
            TempAsmOrderToPrint.DeleteAll();
        end;
    end;

    internal procedure GetAllAssemblyOrderForPrinting(var AllAsmOrders: Record "Assembly Header" temporary)
    begin
        if PrintOrder then
            if TempAsmOrderToPrint.FindSet() then begin
                repeat
                    AllAsmOrders := TempAsmOrderToPrint;
                    if AllAsmOrders.Insert(false) then;
                until TempAsmOrderToPrint.Next() = 0;
                TempAsmOrderToPrint.DeleteAll();
            end;
    end;

    local procedure FinalizeOrderHeader(ProdOrder: Record "Production Order")
    var
        ReportSelection: Record "Report Selections";
        ProdOrder2: Record "Production Order";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeFinalizeOrderHeader(ProdOrder, PrintOrder, IsHandled);
        if IsHandled then
            exit;

        if PrintOrder and (ProdOrder."No." <> '') then begin
            ProdOrder2 := ProdOrder;
            ProdOrder2.SetRecFilter();
            ReportSelection.PrintWithDialogWithCheckForCust(ReportSelection.Usage::"Prod.Order", ProdOrder2, false, 0);
        end;
    end;

    procedure TransferRouting(ReqLine: Record "Requisition Line"; ProdOrder: Record "Production Order"; RoutingNo: Code[20]; RoutingRefNo: Integer): Boolean
    var
        WorkCenter: Record "Work Center";
        MachineCenter: Record "Machine Center";
        PlanningRtngLine: Record "Planning Routing Line";
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
        WMSManagement: Codeunit "WMS Management";
        FlushingMethod: Enum "Flushing Method Routing";
    begin
        PlanningRtngLine.SetRange("Worksheet Template Name", ReqLine."Worksheet Template Name");
        PlanningRtngLine.SetRange("Worksheet Batch Name", ReqLine."Journal Batch Name");
        PlanningRtngLine.SetRange("Worksheet Line No.", ReqLine."Line No.");
        if PlanningRtngLine.Find('-') then
            repeat
                ProdOrderRtngLine.Init();
                ProdOrderRtngLine.Status := ProdOrder.Status;
                ProdOrderRtngLine."Prod. Order No." := ProdOrder."No.";
                ProdOrderRtngLine."Routing No." := RoutingNo;
                ProdOrderRtngLine."Routing Reference No." := RoutingRefNo;
                ProdOrderRtngLine.CopyFromPlanningRoutingLine(PlanningRtngLine);
                case ProdOrderRtngLine.Type of
                    ProdOrderRtngLine.Type::"Work Center":
                        begin
                            WorkCenter.Get(PlanningRtngLine."No.");
                            ProdOrderRtngLine."Flushing Method" := WorkCenter."Flushing Method";
                        end;
                    ProdOrderRtngLine.Type::"Machine Center":
                        begin
                            MachineCenter.Get(ProdOrderRtngLine."No.");
                            ProdOrderRtngLine."Flushing Method" := MachineCenter."Flushing Method";
                        end;
                end;
                ProdOrderRtngLine."Location Code" := ReqLine."Location Code";
                ProdOrderRtngLine."From-Production Bin Code" :=
                  WMSManagement.GetProdCenterBinCode(PlanningRtngLine.Type, PlanningRtngLine."No.", ReqLine."Location Code", false, 0);

                FlushingMethod := ProdOrderRtngLine."Flushing Method";
                if ProdOrderRtngLine."Flushing Method" = ProdOrderRtngLine."Flushing Method"::Manual then
                    ProdOrderRtngLine."To-Production Bin Code" :=
                        WMSManagement.GetProdCenterBinCode(
                            PlanningRtngLine.Type, PlanningRtngLine."No.", ReqLine."Location Code", true,
                            FlushingMethod.AsInteger())
                else
                    ProdOrderRtngLine."Open Shop Floor Bin Code" :=
                        WMSManagement.GetProdCenterBinCode(
                            PlanningRtngLine.Type, PlanningRtngLine."No.", ReqLine."Location Code", true,
                            FlushingMethod.AsInteger());

                ProdOrderRtngLine.UpdateDatetime();
                OnAfterTransferPlanningRtngLine(PlanningRtngLine, ProdOrderRtngLine);
                ProdOrderRtngLine.Insert();
                OnAfterProdOrderRtngLineInsert(ProdOrderRtngLine, PlanningRtngLine, ProdOrder, ReqLine);
                CalcProdOrder.TransferTaskInfo(ProdOrderRtngLine, ReqLine."Routing Version Code");
            until PlanningRtngLine.Next() = 0;

        exit(not PlanningRtngLine.IsEmpty);
    end;

    procedure TransferBOM(ReqLine: Record "Requisition Line"; ProdOrder: Record "Production Order"; ProdOrderLineNo: Integer)
    var
        PlanningComponent: Record "Planning Component";
        ProdOrderComp2: Record "Prod. Order Component";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTransferBOM(ReqLine, ProdOrder, ProdOrderLineNo, IsHandled);
        if IsHandled then
            exit;

        PlanningComponent.SetRange("Worksheet Template Name", ReqLine."Worksheet Template Name");
        PlanningComponent.SetRange("Worksheet Batch Name", ReqLine."Journal Batch Name");
        PlanningComponent.SetRange("Worksheet Line No.", ReqLine."Line No.");
        if PlanningComponent.Find('-') then
            repeat
                OnTransferBOMOnBeforeProdOrderComp2Init(PlanningComponent);
                ProdOrderComp2.Init();
                ProdOrderComp2.Status := ProdOrder.Status;
                ProdOrderComp2."Prod. Order No." := ProdOrder."No.";
                ProdOrderComp2."Prod. Order Line No." := ProdOrderLineNo;
                ProdOrderComp2.CopyFromPlanningComp(PlanningComponent);
                ProdOrderComp2.UpdateDatetime();
                OnAfterTransferPlanningComp(PlanningComponent, ProdOrderComp2);
                ProdOrderComp2.Insert();
                CopyProdBOMComments(ProdOrderComp2);
                ReservePlanningComponent.TransferPlanningCompToPOComp(PlanningComponent, ProdOrderComp2, 0, true);
                if ProdOrderComp2.Status in [ProdOrderComp2.Status::"Firm Planned", ProdOrderComp2.Status::Released] then
                    ProdOrderComp2.AutoReserve();

                ReservMgt.SetReservSource(ProdOrderComp2);
                ReservMgt.AutoTrack(ProdOrderComp2."Remaining Qty. (Base)");
            until PlanningComponent.Next() = 0;
    end;

    procedure TransferCapNeed(ReqLine: Record "Requisition Line"; ProdOrder: Record "Production Order"; RoutingNo: Code[20]; RoutingRefNo: Integer)
    var
        ProdOrderCapNeed: Record "Prod. Order Capacity Need";
        NewProdOrderCapNeed: Record "Prod. Order Capacity Need";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTransferCapNeed(ReqLine, ProdOrder, RoutingNo, RoutingRefNo, IsHandled);
        if IsHandled then
            exit;

        ProdOrderCapNeed.SetCurrentKey("Worksheet Template Name", "Worksheet Batch Name", "Worksheet Line No.");
        ProdOrderCapNeed.SetRange("Worksheet Template Name", ReqLine."Worksheet Template Name");
        ProdOrderCapNeed.SetRange("Worksheet Batch Name", ReqLine."Journal Batch Name");
        ProdOrderCapNeed.SetRange("Worksheet Line No.", ReqLine."Line No.");
        if ProdOrderCapNeed.Find('-') then
            repeat
                NewProdOrderCapNeed.Init();
                NewProdOrderCapNeed := ProdOrderCapNeed;
                NewProdOrderCapNeed."Requested Only" := false;
                NewProdOrderCapNeed.Status := ProdOrder.Status;
                NewProdOrderCapNeed."Prod. Order No." := ProdOrder."No.";
                NewProdOrderCapNeed."Routing No." := RoutingNo;
                NewProdOrderCapNeed."Routing Reference No." := RoutingRefNo;
                NewProdOrderCapNeed."Worksheet Template Name" := '';
                NewProdOrderCapNeed."Worksheet Batch Name" := '';
                NewProdOrderCapNeed."Worksheet Line No." := 0;
                NewProdOrderCapNeed.UpdateDatetime();
                NewProdOrderCapNeed.Insert();
            until ProdOrderCapNeed.Next() = 0;
    end;

    procedure UpdateComponentLink(ProdOrderLine: Record "Prod. Order Line")
    var
        ProdOrderComp: Record "Prod. Order Component";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeUpdateComponentLink(ProdOrderLine, IsHandled);
        if IsHandled then
            exit;

        ProdOrderComp.SetCurrentKey(Status, "Prod. Order No.", "Prod. Order Line No.", "Item No.");
        ProdOrderComp.SetRange(Status, ProdOrderLine.Status);
        ProdOrderComp.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        ProdOrderComp.SetRange("Item No.", ProdOrderLine."Item No.");
        if ProdOrderComp.Find('-') then
            repeat
                ProdOrderComp."Supplied-by Line No." := ProdOrderLine."Line No.";
                ProdOrderComp.Modify();
            until ProdOrderComp.Next() = 0;
    end;

    procedure SetCreatedDocumentBuffer(var TempDocumentEntryNew: Record "Document Entry" temporary)
    begin
        TempDocumentEntry.Copy(TempDocumentEntryNew, true);
    end;

    local procedure InsertTempProdOrder(var RequisitionLine: Record "Requisition Line"; var NewProdOrder: Record "Production Order")
    begin
        if TempProductionOrder.Get(NewProdOrder.Status, NewProdOrder."No.") then
            exit;

        TempDocumentEntry.Init();
        TempDocumentEntry."Table ID" := DATABASE::"Production Order";
        TempDocumentEntry."Document Type" := NewProdOrder.Status;
        TempDocumentEntry."Document No." := NewProdOrder."No.";
        TempDocumentEntry."Entry No." := TempDocumentEntry.Count + 1;
        TempDocumentEntry.Insert();

        TempProductionOrder := NewProdOrder;
        if RequisitionLine."Ref. Order Status" = RequisitionLine."Ref. Order Status"::Planned then begin
            TempProductionOrder."Planned Order No." := RequisitionLine."Ref. Order No.";
            TempProductionOrder.Insert();
        end;
    end;

    local procedure FindTempProdOrder(var RequisitionLine: Record "Requisition Line"): Boolean
    begin
        if RequisitionLine."Ref. Order Status" = RequisitionLine."Ref. Order Status"::Planned then begin
            TempProductionOrder.SetRange("Planned Order No.", RequisitionLine."Ref. Order No.");
            exit(TempProductionOrder.FindFirst())
        end;
    end;

    procedure SetPrintOrder(OrderPrinting: Boolean)
    begin
        PrintOrder := OrderPrinting;
    end;

    procedure SetSplitTransferOrders(Split: Boolean)
    begin
        SplitTransferOrders := Split;
    end;

    procedure ReserveBindingOrderToProd(var ProdOrderLine: Record "Prod. Order Line"; var ReqLine: Record "Requisition Line")
    var
        SalesLine: Record "Sales Line";
        ProdOrderComp: Record "Prod. Order Component";
        AsmLine: Record "Assembly Line";
        JobPlanningLine: Record "Job Planning Line";
        ServiceLine: Record "Service Line";
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        ProdOrderCompReserve: Codeunit "Prod. Order Comp.-Reserve";
        AsmLineReserve: Codeunit "Assembly Line-Reserve";
        JobPlanningLineReserve: Codeunit "Job Planning Line-Reserve";
        ServiceLineReserve: Codeunit "Service Line-Reserve";
        ReservQty: Decimal;
        ReservQtyBase: Decimal;
    begin
        ProdOrderLine.CalcFields("Reserved Quantity", "Reserved Qty. (Base)");
        if ProdOrderLine."Remaining Qty. (Base)" - ProdOrderLine."Reserved Qty. (Base)" >
           ReqLine."Demand Quantity (Base)"
        then begin
            ReservQty := ReqLine."Demand Quantity";
            ReservQtyBase := ReqLine."Demand Quantity (Base)";
        end else begin
            ReservQty := ProdOrderLine."Remaining Quantity" - ProdOrderLine."Reserved Quantity";
            ReservQtyBase := ProdOrderLine."Remaining Qty. (Base)" - ProdOrderLine."Reserved Qty. (Base)";
        end;

        case ReqLine."Demand Type" of
            DATABASE::"Prod. Order Component":
                begin
                    ProdOrderComp.Get(
                      ReqLine."Demand Subtype", ReqLine."Demand Order No.", ReqLine."Demand Line No.", ReqLine."Demand Ref. No.");
                    ProdOrderCompReserve.BindToProdOrder(ProdOrderComp, ProdOrderLine, ReservQty, ReservQtyBase);
                end;
            DATABASE::"Sales Line":
                begin
                    SalesLine.Get(ReqLine."Demand Subtype", ReqLine."Demand Order No.", ReqLine."Demand Line No.");
                    SalesLineReserve.BindToProdOrder(SalesLine, ProdOrderLine, ReservQty, ReservQtyBase);
                    if SalesLine.Reserve = SalesLine.Reserve::Never then begin
                        SalesLine.Reserve := SalesLine.Reserve::Optional;
                        SalesLine.Modify();
                    end;
                end;
            DATABASE::"Assembly Line":
                begin
                    AsmLine.Get(ReqLine."Demand Subtype", ReqLine."Demand Order No.", ReqLine."Demand Line No.");
                    AsmLineReserve.BindToProdOrder(AsmLine, ProdOrderLine, ReservQty, ReservQtyBase);
                    if AsmLine.Reserve = AsmLine.Reserve::Never then begin
                        AsmLine.Reserve := AsmLine.Reserve::Optional;
                        AsmLine.Modify();
                    end;
                end;
            DATABASE::"Job Planning Line":
                begin
                    JobPlanningLine.SetRange("Job Contract Entry No.", ReqLine."Demand Line No.");
                    JobPlanningLine.FindFirst();
                    JobPlanningLineReserve.BindToProdOrder(JobPlanningLine, ProdOrderLine, ReservQty, ReservQtyBase);
                    if JobPlanningLine.Reserve = JobPlanningLine.Reserve::Never then begin
                        JobPlanningLine.Reserve := JobPlanningLine.Reserve::Optional;
                        JobPlanningLine.Modify();
                    end;
                end;
            DATABASE::"Service Line":
                begin
                    ServiceLine.Get(ReqLine."Demand Subtype", ReqLine."Demand Order No.", ReqLine."Demand Line No.");
                    ServiceLineReserve.BindToProdOrder(ServiceLine, ProdOrderLine, ReservQty, ReservQtyBase);
                    if ServiceLine.Reserve = ServiceLine.Reserve::Never then begin
                        ServiceLine.Reserve := ServiceLine.Reserve::Optional;
                        ServiceLine.Modify();
                    end;
                end;
        end;
        ProdOrderLine.Modify();
    end;

    procedure ReserveBindingOrderToTrans(var TransLine: Record "Transfer Line"; var ReqLine: Record "Requisition Line")
    var
        ProdOrderComp: Record "Prod. Order Component";
        SalesLine: Record "Sales Line";
        AsmLine: Record "Assembly Line";
        JobPlanningLine: Record "Job Planning Line";
        ServiceLine: Record "Service Line";
        ProdOrderCompReserve: Codeunit "Prod. Order Comp.-Reserve";
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        AsmLineReserve: Codeunit "Assembly Line-Reserve";
        JobPlanningLineReserve: Codeunit "Job Planning Line-Reserve";
        ServiceLineReserve: Codeunit "Service Line-Reserve";
        ReservQty: Decimal;
        ReservQtyBase: Decimal;
    begin
        TransLine.CalcFields("Reserved Quantity Inbnd.", "Reserved Qty. Inbnd. (Base)");
        if (TransLine."Outstanding Qty. (Base)" - TransLine."Reserved Qty. Inbnd. (Base)") > ReqLine."Demand Quantity (Base)" then begin
            ReservQty := ReqLine."Demand Quantity";
            ReservQtyBase := ReqLine."Demand Quantity (Base)";
        end else begin
            ReservQty := TransLine."Outstanding Quantity" - TransLine."Reserved Quantity Inbnd.";
            ReservQtyBase := TransLine."Outstanding Qty. (Base)" - TransLine."Reserved Qty. Inbnd. (Base)";
        end;

        case ReqLine."Demand Type" of
            DATABASE::"Prod. Order Component":
                begin
                    ProdOrderComp.Get(
                      ReqLine."Demand Subtype", ReqLine."Demand Order No.", ReqLine."Demand Line No.", ReqLine."Demand Ref. No.");
                    ProdOrderCompReserve.BindToTransfer(ProdOrderComp, TransLine, ReservQty, ReservQtyBase);
                end;
            DATABASE::"Sales Line":
                begin
                    SalesLine.Get(ReqLine."Demand Subtype", ReqLine."Demand Order No.", ReqLine."Demand Line No.");
                    SalesLineReserve.BindToTransfer(SalesLine, TransLine, ReservQty, ReservQtyBase);
                    if SalesLine.Reserve = SalesLine.Reserve::Never then begin
                        SalesLine.Reserve := SalesLine.Reserve::Optional;
                        SalesLine.Modify();
                    end;
                end;
            DATABASE::"Assembly Line":
                begin
                    AsmLine.Get(ReqLine."Demand Subtype", ReqLine."Demand Order No.", ReqLine."Demand Line No.");
                    AsmLineReserve.BindToTransfer(AsmLine, TransLine, ReservQty, ReservQtyBase);
                    if AsmLine.Reserve = AsmLine.Reserve::Never then begin
                        AsmLine.Reserve := AsmLine.Reserve::Optional;
                        AsmLine.Modify();
                    end;
                end;
            DATABASE::"Job Planning Line":
                begin
                    JobPlanningLine.SetRange("Job Contract Entry No.", ReqLine."Demand Line No.");
                    JobPlanningLine.FindFirst();
                    JobPlanningLineReserve.BindToTransfer(JobPlanningLine, TransLine, ReservQty, ReservQtyBase);
                    if JobPlanningLine.Reserve = JobPlanningLine.Reserve::Never then begin
                        JobPlanningLine.Reserve := JobPlanningLine.Reserve::Optional;
                        JobPlanningLine.Modify();
                    end;
                end;
            DATABASE::"Service Line":
                begin
                    ServiceLine.Get(ReqLine."Demand Subtype", ReqLine."Demand Order No.", ReqLine."Demand Line No.");
                    ServiceLineReserve.BindToTransfer(ServiceLine, TransLine, ReservQty, ReservQtyBase);
                    if ServiceLine.Reserve = ServiceLine.Reserve::Never then begin
                        ServiceLine.Reserve := ServiceLine.Reserve::Optional;
                        ServiceLine.Modify();
                    end;
                end;
        end;
        TransLine.Modify();
    end;

    procedure ReserveBindingOrderToAsm(var AsmHeader: Record "Assembly Header"; var ReqLine: Record "Requisition Line")
    var
        SalesLine: Record "Sales Line";
        ProdOrderComp: Record "Prod. Order Component";
        AsmLine: Record "Assembly Line";
        JobPlanningLine: Record "Job Planning Line";
        ServiceLine: Record "Service Line";
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        ProdOrderCompReserve: Codeunit "Prod. Order Comp.-Reserve";
        AsmLineReserve: Codeunit "Assembly Line-Reserve";
        JobPlanningLineReserve: Codeunit "Job Planning Line-Reserve";
        ServiceLineReserve: Codeunit "Service Line-Reserve";
        ReservQty: Decimal;
        ReservQtyBase: Decimal;
    begin
        AsmHeader.CalcFields("Reserved Quantity", "Reserved Qty. (Base)");
        if AsmHeader."Remaining Quantity (Base)" - AsmHeader."Reserved Qty. (Base)" >
           ReqLine."Demand Quantity (Base)"
        then begin
            ReservQty := ReqLine."Demand Quantity";
            ReservQtyBase := ReqLine."Demand Quantity (Base)";
        end else begin
            ReservQty := AsmHeader."Remaining Quantity" - AsmHeader."Reserved Quantity";
            ReservQtyBase := AsmHeader."Remaining Quantity (Base)" - AsmHeader."Reserved Qty. (Base)";
        end;

        case ReqLine."Demand Type" of
            DATABASE::"Prod. Order Component":
                begin
                    ProdOrderComp.Get(
                      ReqLine."Demand Subtype", ReqLine."Demand Order No.", ReqLine."Demand Line No.", ReqLine."Demand Ref. No.");
                    ProdOrderCompReserve.BindToAssembly(ProdOrderComp, AsmHeader, ReservQty, ReservQtyBase);
                end;
            DATABASE::"Sales Line":
                begin
                    SalesLine.Get(ReqLine."Demand Subtype", ReqLine."Demand Order No.", ReqLine."Demand Line No.");
                    SalesLineReserve.BindToAssembly(SalesLine, AsmHeader, ReservQty, ReservQtyBase);
                    if SalesLine.Reserve = SalesLine.Reserve::Never then begin
                        SalesLine.Reserve := SalesLine.Reserve::Optional;
                        SalesLine.Modify();
                    end;
                end;
            DATABASE::"Assembly Line":
                begin
                    AsmLine.Get(ReqLine."Demand Subtype", ReqLine."Demand Order No.", ReqLine."Demand Line No.");
                    AsmLineReserve.BindToAssembly(AsmLine, AsmHeader, ReservQty, ReservQtyBase);
                    if AsmLine.Reserve = AsmLine.Reserve::Never then begin
                        AsmLine.Reserve := AsmLine.Reserve::Optional;
                        AsmLine.Modify();
                    end;
                end;
            DATABASE::"Job Planning Line":
                begin
                    JobPlanningLine.SetRange("Job Contract Entry No.", ReqLine."Demand Line No.");
                    JobPlanningLine.FindFirst();
                    JobPlanningLineReserve.BindToAssembly(JobPlanningLine, AsmHeader, ReservQty, ReservQtyBase);
                    if JobPlanningLine.Reserve = JobPlanningLine.Reserve::Never then begin
                        JobPlanningLine.Reserve := JobPlanningLine.Reserve::Optional;
                        JobPlanningLine.Modify();
                    end;
                end;
            DATABASE::"Service Line":
                begin
                    ServiceLine.Get(ReqLine."Demand Subtype", ReqLine."Demand Order No.", ReqLine."Demand Line No.");
                    ServiceLineReserve.BindToAssembly(ServiceLine, AsmHeader, ReservQty, ReservQtyBase);
                    if ServiceLine.Reserve = ServiceLine.Reserve::Never then begin
                        ServiceLine.Reserve := ServiceLine.Reserve::Optional;
                        ServiceLine.Modify();
                    end;
                end;
        end;
        AsmHeader.Modify();
    end;

    procedure ReserveBindingOrderToReqline(var DemandReqLine: Record "Requisition Line"; var SupplyReqLine: Record "Requisition Line")
    var
        ProdOrderComp: Record "Prod. Order Component";
        SalesLine: Record "Sales Line";
        AsmLine: Record "Assembly Line";
        JobPlanningLine: Record "Job Planning Line";
        ServiceLine: Record "Service Line";
        ProdOrderCompReserve: Codeunit "Prod. Order Comp.-Reserve";
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        AssemblyLineReserve: Codeunit "Assembly Line-Reserve";
        JobPlanningLineReserve: Codeunit "Job Planning Line-Reserve";
        ServiceLineReserve: Codeunit "Service Line-Reserve";
    begin
        case SupplyReqLine."Demand Type" of
            DATABASE::"Prod. Order Component":
                begin
                    ProdOrderComp.Get(
                      SupplyReqLine."Demand Subtype", SupplyReqLine."Demand Order No.", SupplyReqLine."Demand Line No.",
                      SupplyReqLine."Demand Ref. No.");
                    ProdOrderCompReserve.BindToRequisition(
                      ProdOrderComp, DemandReqLine, SupplyReqLine."Needed Quantity", SupplyReqLine."Needed Quantity (Base)");
                end;
            DATABASE::"Sales Line":
                begin
                    SalesLine.Get(SupplyReqLine."Demand Subtype", SupplyReqLine."Demand Order No.", SupplyReqLine."Demand Line No.");
                    if (SalesLine.Reserve = SalesLine.Reserve::Never) and not SalesLine."Drop Shipment" then begin
                        SalesLine.Reserve := SalesLine.Reserve::Optional;
                        SalesLine.Modify();
                    end;
                    SalesLineReserve.BindToRequisition(
                      SalesLine, DemandReqLine, SupplyReqLine."Needed Quantity", SupplyReqLine."Needed Quantity (Base)");
                end;
            DATABASE::"Assembly Line":
                begin
                    AsmLine.Get(SupplyReqLine."Demand Subtype", SupplyReqLine."Demand Order No.", SupplyReqLine."Demand Line No.");
                    AssemblyLineReserve.BindToRequisition(
                      AsmLine, DemandReqLine, SupplyReqLine."Needed Quantity", SupplyReqLine."Needed Quantity (Base)");
                end;
            DATABASE::"Job Planning Line":
                begin
                    JobPlanningLine.SetRange("Job Contract Entry No.", SupplyReqLine."Demand Line No.");
                    JobPlanningLine.FindFirst();
                    JobPlanningLineReserve.BindToRequisition(
                      JobPlanningLine, DemandReqLine, SupplyReqLine."Needed Quantity", SupplyReqLine."Needed Quantity (Base)");
                end;
            DATABASE::"Service Line":
                begin
                    ServiceLine.Get(SupplyReqLine."Demand Subtype", SupplyReqLine."Demand Order No.", SupplyReqLine."Demand Line No.");
                    ServiceLineReserve.BindToRequisition(
                      ServiceLine, DemandReqLine, SupplyReqLine."Needed Quantity", SupplyReqLine."Needed Quantity (Base)");
                end;
        end;
    end;

    local procedure CopyProdBOMComments(ProdOrderComponent: Record "Prod. Order Component")
    var
        ProductionBOMCommentLine: Record "Production BOM Comment Line";
        ProductionBOMHeader: Record "Production BOM Header";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderCompCmtLine: Record "Prod. Order Comp. Cmt Line";
        VersionManagement: Codeunit VersionManagement;
        ActiveVersionCode: Code[20];
    begin
        ProdOrderLine.Get(ProdOrderComponent.Status, ProdOrderComponent."Prod. Order No.", ProdOrderComponent."Prod. Order Line No.");

        if not ProductionBOMHeader.Get(ProdOrderLine."Production BOM No.") then
            exit;

        ActiveVersionCode := VersionManagement.GetBOMVersion(ProductionBOMHeader."No.", WorkDate(), true);

        ProductionBOMCommentLine.SetRange("Production BOM No.", ProductionBOMHeader."No.");
        ProductionBOMCommentLine.SetRange("BOM Line No.", ProdOrderComponent."Line No.");
        ProductionBOMCommentLine.SetRange("Version Code", ActiveVersionCode);
        if ProductionBOMCommentLine.FindSet() then
            repeat
                ProdOrderCompCmtLine.CopyFromProdBOMComponent(ProductionBOMCommentLine, ProdOrderComponent);
                if not ProdOrderCompCmtLine.Insert() then
                    ProdOrderCompCmtLine.Modify();
            until ProductionBOMCommentLine.Next() = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCarryOutToReqWksh(var RequisitionLine: Record "Requisition Line"; RequisitionLine2: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterDeleteOrderLines(RequisitionLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterDeleteRequisitionLine(var RequisitionLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertProdOrder(var ProductionOrder: Record "Production Order"; ProdOrderChoice: Integer; var RequisitionLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertProdOrderLine(ReqLine: Record "Requisition Line"; ProdOrder: Record "Production Order"; var ProdOrderLine: Record "Prod. Order Line"; Item: Record Item)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertAsmHeader(var ReqLine: Record "Requisition Line"; var AsmHeader: Record "Assembly Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertTransLine(var TransHeader: Record "Transfer Header"; var ReqLine: Record "Requisition Line"; var TransLine: Record "Transfer Line"; var NextLineNo: Integer);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterTransferAsmPlanningComp(var PlanningComponent: Record "Planning Component"; var AssemblyLine: Record "Assembly Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterTransLineInsert(var TransferLine: Record "Transfer Line"; RequisitionLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterTransferPlanningRtngLine(var PlanningRtngLine: Record "Planning Routing Line"; var ProdOrderRtngLine: Record "Prod. Order Routing Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterTransferPlanningComp(var PlanningComponent: Record "Planning Component"; var ProdOrderComponent: Record "Prod. Order Component")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterProdOrderRtngLineInsert(var ProdOrderRoutingLine: Record "Prod. Order Routing Line"; PlanningRoutingLine: Record "Planning Routing Line"; ProdOrder: Record "Production Order"; RequisitionLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterProdOrderChgAndReshedule(var RequisitionLine: Record "Requisition Line"; var ProdOrderLine: Record "Prod. Order Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAddResourceComponents(RequisitionLine: Record "Requisition Line"; var AssemblyHeader: Record "Assembly Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCopyDimensionsFromReqToTransLine(var TransferLine: Record "Transfer Line"; RequisitionLine: Record "Requisition Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDeleteOrderLines(RequisitionLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDeleteAssemblyLines(RequisitionLine: Record "Requisition Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDeleteProdOrderLines(RequisitionLine: Record "Requisition Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDeletePurchaseLines(RequisitionLine: Record "Requisition Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDeleteRequisitionLine(var RequisitionLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDeleteTransferLines(RequisitionLine: Record "Requisition Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFinalizeOrderHeader(ProdOrder: Record "Production Order"; PrintOrder: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertTransHeader(ReqLine: Record "Requisition Line"; var TransHeader: Record "Transfer Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePrintPurchaseOrder(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean; PrintOrder: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTransferBOM(ReqLine: Record "Requisition Line"; ProdOrder: Record "Production Order"; ProdOrderLineNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTransferCapNeed(ReqLine: Record "Requisition Line"; ProdOrder: Record "Production Order"; RoutingNo: Code[20]; RoutingRefNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateProdOrderLineQuantity(var ProdOrderLine: Record "Prod. Order Line"; ReqLine: Record "Requisition Line"; Item: Record Item; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSetProdOrderLineBinCodeFromPlanningRtngLines(ProdOrder: Record "Production Order"; var ProdOrderLine: Record "Prod. Order Line"; ReqLine: Record "Requisition Line"; Item: Record Item; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateComponentLink(ProdOrderLine: Record "Prod. Order Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCarryOutToReqWkshOnAfterPlanningCompInsert(var PlanningComponent: Record "Planning Component"; PlanningComponent2: Record "Planning Component")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCarryOutToReqWkshOnAfterPlanningRoutingLineInsert(var PlanningRoutingLine: Record "Planning Routing Line"; PlanningRoutingLine2: Record "Planning Routing Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCarryOutToReqWkshOnBeforeReqLineInsert(var ReqLine: Record "Requisition Line"; var ReqWkshTempName: Code[10]; var ReqJournalName: Code[10]; var LineNo: Integer);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertProdOrderWithReqLine(var ProductionOrder: Record "Production Order"; var RequisitionLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertProdOrderLineWithReqLine(var ProdOrderLine: Record "Prod. Order Line"; var RequisitionLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertProdOrderLineOnBeforeProdOrderLineInit(var ReqLine: Record "Requisition Line"; var Item: Record Item)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertTransLineWithReqLine(var TransferLine: Record "Transfer Line"; var RequisitionLine: Record "Requisition Line"; var NextLineNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertProdOrderLineOnAfterTransferRouting(var ProdOrderLine: Record "Prod. Order Line"; var RefreshProdOrderLine: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertProdOrderLineOnAfterProdOrderLineInsert(var ProdOrderLine: Record "Prod. Order Line"; var RequisitionLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertProdOrderOnBeforeProdOrderInit(var ReqLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertProdOrderOnAfterFindTempProdOrder(var ReqLine: Record "Requisition Line"; var ProdOrder: Record "Production Order"; var HeaderExists: Boolean; var Item: Record Item)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertProdOrderOnAfterProdOrderInsert(var ProdOrder: Record "Production Order"; ReqLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertProdOrderOnBeforeProdOrderInsert(var ProdOrder: Record "Production Order"; ReqLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPurchOrderChgAndResheduleOnAfterGetPurchHeader(var PurchaseHeader: Record "Purchase Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPurchOrderChgAndResheduleOnAfterGetPurchLine(var PurchaseLine: Record "Purchase Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPurchOrderChgAndResheduleOnBeforePurchLineModify(var ReqLine: Record "Requisition Line"; var PurchLine: Record "Purchase Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnTransOrderChgAndResheduleOnBeforeTransLineModify(var ReqLine: Record "Requisition Line"; var TransLine: Record "Transfer Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnTransferBOMOnBeforeProdOrderComp2Init(var PlanningComponent: Record "Planning Component")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAsmOrderChgAndResheduleOnBeforeAsmHeaderModify(var ReqLine: Record "Requisition Line"; var AssemblyHeader: Record "Assembly Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnProdOrderChgAndResheduleOnAfterValidateQuantity(var ProdOrderLine: Record "Prod. Order Line"; var RequisitionLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnProdOrderChgAndResheduleOnBeforeProdOrderModify(var ProductionOrder: Record "Production Order"; ProdOrderLine: Record "Prod. Order Line"; RequisitionLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertTransHeaderOnBeforeTransHeaderInsert(var TransHeader: Record "Transfer Header"; ReqLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertTransHeaderOnAfterTransHeaderInsert(var TransHeader: Record "Transfer Header"; ReqLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertTransHeaderOnBeforeTransHeaderModify(var TransHeader: Record "Transfer Header"; ReqLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertTransLineOnAfterCalcShouldInsertTransHeader(RequisitionLine: Record "Requisition Line"; TransferHeader: Record "Transfer Header"; var Result: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertTransLineOnAfterTransLineInit(var TransLine: Record "Transfer Line"; ReqLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertAsmHeaderOnBeforeAsmHeaderInsert(var AsmHeader: Record "Assembly Header"; ReqLine: Record "Requisition Line");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertAsmHeaderOnAfterAsmHeaderInsert(var AsmHeader: Record "Assembly Header"; ReqLine: Record "Requisition Line");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPrintTransferOrderOnBeforePrintWithDialogWithCheckForCust(var ReportSelections: Record "Report Selections")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCarryOutActionsFromProdOrderOnAfterCalcPrintOrder(var PrintOrder: Boolean; ProdOrderChoice: Option)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertProductionOrderOnProdOrderChoiceCaseElse(ProdOrderChoice: Enum "Planning Create Prod. Order")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCarryOutActionsFromTransOrderOnBeforeTransOrderChgAndReshedule(ReqLine: Record "Requisition Line"; PrintOrder: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertProdOrderLineOnBeforeGetBinCode(var ProdOrderLine: Record "Prod. Order Line"; ReqLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertProdOrderOnProdOrderChoiceNotFirmPlannedPrint(var ProdOrder: Record "Production Order"; ProdOrderChoice: Enum "Planning Create Prod. Order"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCarryOutActionsFromTransOrderOnBeforeInsertTransLine(ReqLine: Record "Requisition Line"; PrintOrder: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePrintPurchaseOrder2(var PurchHeader: Record "Purchase Header"; PrintOrder: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPurchOrderChgAndResheduleOnBeforeValidateExpectedReceiptDate(var ReqLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnRunOnBeforeCalcProductionExist(RequisitionLine: Record "Requisition Line"; TryChoice: Option; TryWkshTempl: Code[10]; TryWkshName: Code[10]; var ProductionExist: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCarryOutTransOrder(SplitTransferOrders: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePrintMultiplePurchaseDocs(var TempPurchaseHeader: Record "Purchase Header" temporary; var IsHandled: Boolean)
    begin
    end;
}

