report 317 "Vendor Pre-Payment Journal"
{
    DefaultLayout = RDLC;
    RDLCLayout = './PurchasesPayables/VendorPrePaymentJournal.rdlc';
    Caption = 'Vendor Pre-Payment Journal';

    dataset
    {
        dataitem("Gen. Journal Batch"; "Gen. Journal Batch")
        {
            DataItemTableView = SORTING("Journal Template Name", Name);
            column(Gen__Journal_Batch_Journal_Template_Name; "Journal Template Name")
            {
            }
            column(Gen__Journal_Batch_Name; Name)
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                PrintOnlyIfDetail = true;
                column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
                {
                }
                column(CompanyInformation_Name; CompanyInformation.Name)
                {
                }
                column(USERID; UserId)
                {
                }
                column(Gen__Journal_Batch___Journal_Template_Name_; "Gen. Journal Batch"."Journal Template Name")
                {
                }
                column(Gen__Journal_Batch__Name; "Gen. Journal Batch".Name)
                {
                }
                column(TIME; Time)
                {
                }
                column(Gen__Journal_Line__TABLECAPTION__________GenJnlLineFilter; "Gen. Journal Line".TableCaption + ': ' + GenJnlLineFilter)
                {
                }
                column(GenJnlLineFilter; GenJnlLineFilter)
                {
                }
                column(USE001Err; USE001Lbl)
                {
                }
                column(GenJnlTemplate__Force_Doc__Balance_; GenJnlTemplate."Force Doc. Balance")
                {
                }
                column(Integer_Number; Number)
                {
                }
                column(Payment_Journal___Pre_Check_TestCaption; Payment_Journal___Pre_Check_TestCaptionLbl)
                {
                }
                column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Gen__Journal_Batch___Journal_Template_Name_Caption; "Gen. Journal Batch".FieldCaption("Journal Template Name"))
                {
                }
                column(Gen__Journal_Batch__NameCaption; Gen__Journal_Batch__NameCaptionLbl)
                {
                }
                column(Gen__Journal_Line__Posting_Date_Caption; "Gen. Journal Line".FieldCaption("Posting Date"))
                {
                }
                column(Gen__Journal_Line__Document_Type_Caption; Gen__Journal_Line__Document_Type_CaptionLbl)
                {
                }
                column(Gen__Journal_Line__Document_No__Caption; Gen__Journal_Line__Document_No__CaptionLbl)
                {
                }
                column(Gen__Journal_Line__Account_Type_Caption; Gen__Journal_Line__Account_Type_CaptionLbl)
                {
                }
                column(Gen__Journal_Line__Account_No__Caption; Gen__Journal_Line__Account_No__CaptionLbl)
                {
                }
                column(Gen__Journal_Line_DescriptionCaption; "Gen. Journal Line".FieldCaption(Description))
                {
                }
                column(Gen__Journal_Line_AmountCaption; "Gen. Journal Line".FieldCaption(Amount))
                {
                }
                column(Gen__Journal_Line__Bal__Account_No__Caption; Gen__Journal_Line__Bal__Account_No__CaptionLbl)
                {
                }
                column(Gen__Journal_Line__Bal__Account_Type_Caption; Gen__Journal_Line__Bal__Account_Type_CaptionLbl)
                {
                }
                column(Gen__Journal_Line__Bank_Payment_Type_Caption; "Gen. Journal Line".FieldCaption("Bank Payment Type"))
                {
                }
                column(DocumentCaption; DocumentCaptionLbl)
                {
                }
                column(AccountCaption; AccountCaptionLbl)
                {
                }
                column(Bal__AccountCaption; Bal__AccountCaptionLbl)
                {
                }
                dataitem("Gen. Journal Line"; "Gen. Journal Line")
                {
                    DataItemLink = "Journal Template Name" = FIELD("Journal Template Name"), "Journal Batch Name" = FIELD(Name);
                    DataItemLinkReference = "Gen. Journal Batch";
                    DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.", "Account Type", "Account No.");
                    RequestFilterFields = "Posting Date";
                    column(Gen__Journal_Line__Posting_Date_; "Posting Date")
                    {
                    }
                    column(Gen__Journal_Line__Document_Type_; "Document Type")
                    {
                    }
                    column(Gen__Journal_Line__Document_No__; "Document No.")
                    {
                    }
                    column(Gen__Journal_Line__Bank_Payment_Type_; "Bank Payment Type")
                    {
                    }
                    column(Gen__Journal_Line__Account_Type_; "Account Type")
                    {
                    }
                    column(Gen__Journal_Line__Account_No__; "Account No.")
                    {
                    }
                    column(Gen__Journal_Line_Description; Description)
                    {
                    }
                    column(Gen__Journal_Line__Bal__Account_Type_; "Bal. Account Type")
                    {
                    }
                    column(Gen__Journal_Line__Bal__Account_No__; "Bal. Account No.")
                    {
                    }
                    column(Gen__Journal_Line__Applies_to_Doc__Type_; "Applies-to Doc. Type")
                    {
                    }
                    column(Gen__Journal_Line__Applies_to_Doc__No__; "Applies-to Doc. No.")
                    {
                    }
                    column(Gen__Journal_Line__Due_Date_; "Due Date")
                    {
                    }
                    column(Gen__Journal_Line_Description_Control3015; Description)
                    {
                    }
                    column(AmountDue; AmountDue)
                    {
                        AutoFormatExpression = "Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AmountDiscounted; AmountDiscounted)
                    {
                        AutoFormatExpression = "Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AmountPaid___AmountDiscounted___AmountPmtDiscTolerance___AmountPmtTolerance; AmountPaid - AmountDiscounted - AmountPmtDiscTolerance - AmountPmtTolerance)
                    {
                        AutoFormatExpression = "Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Gen__Journal_Line__Currency_Code_; "Currency Code")
                    {
                    }
                    column(AmountPmtDiscTolerance; AmountPmtDiscTolerance)
                    {
                        AutoFormatExpression = "Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AmountPmtTolerance; AmountPmtTolerance)
                    {
                        AutoFormatExpression = "Currency Code";
                        AutoFormatType = 1;
                    }
                    column(ShowApplyToOutput; ShowApplyToOutput)
                    {
                    }
                    column(TotalAmount; TotalAmount)
                    {
                    }
                    column(Amount___TotalAmountDiscounted___TotalAmountPmtDiscTolerance___TotalAmountPmtTolerance___AmountApplied; TotalAmount + TotalAmountDiscounted + TotalAmountPmtDiscTolerance + TotalAmountPmtTolerance + AmountApplied)
                    {
                        AutoFormatExpression = "Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AmountApplied; AmountApplied)
                    {
                    }
                    column(Gen__Journal_Line_Amount; Amount)
                    {
                        AutoFormatExpression = "Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Gen__Journal_Line__Currency_Code__Control35; "Currency Code")
                    {
                    }
                    column(STRSUBSTNO_USE003Err__Document_Type___Document_No___; StrSubstNo(USE003Lbl, "Document Type", "Document No."))
                    {
                    }
                    column(TotalAmountDiscounted; TotalAmountDiscounted)
                    {
                        AutoFormatExpression = "Currency Code";
                        AutoFormatType = 1;
                    }
                    column(TotalAmountPmtDiscTolerance; TotalAmountPmtDiscTolerance)
                    {
                        AutoFormatExpression = "Currency Code";
                        AutoFormatType = 1;
                    }
                    column(TotalAmountPmtTolerance; TotalAmountPmtTolerance)
                    {
                        AutoFormatExpression = "Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Gen__Journal_Line__Amount__LCY__; "Amount (LCY)")
                    {
                    }
                    column(Gen__Journal_Line__Balance__LCY__; "Balance (LCY)")
                    {
                    }
                    column(STRSUBSTNO_USE002Err__Journal_Template_Name___Journal_Batch_Name__; StrSubstNo(USE002Lbl, "Journal Template Name", "Journal Batch Name"))
                    {
                    }
                    column(AmountLcy; AmountLcy)
                    {
                    }
                    column(AmountBalLcy; AmountBalLcy)
                    {
                    }
                    column(Gen__Journal_Line_Journal_Template_Name; "Journal Template Name")
                    {
                    }
                    column(Gen__Journal_Line_Journal_Batch_Name; "Journal Batch Name")
                    {
                    }
                    column(Gen__Journal_Line_Line_No_; "Line No.")
                    {
                    }
                    column(Gen__Journal_Line_Applies_to_ID; "Applies-to ID")
                    {
                    }
                    column(Gen__Journal_Line__Applies_to_Doc__Type_Caption; FieldCaption("Applies-to Doc. Type"))
                    {
                    }
                    column(Gen__Journal_Line__Applies_to_Doc__No__Caption; FieldCaption("Applies-to Doc. No."))
                    {
                    }
                    column(Gen__Journal_Line__Due_Date_Caption; FieldCaption("Due Date"))
                    {
                    }
                    column(Description___Caption; Description___CaptionLbl)
                    {
                    }
                    column(AmountDueCaption; AmountDueCaptionLbl)
                    {
                    }
                    column(AmountDiscountedCaption; AmountDiscountedCaptionLbl)
                    {
                    }
                    column(AmountPmtDiscToleranceCaption; AmountPmtDiscToleranceCaptionLbl)
                    {
                    }
                    column(AmountPmtToleranceCaption; AmountPmtToleranceCaptionLbl)
                    {
                    }
                    column(Unapplied_AmountsCaption; Unapplied_AmountsCaptionLbl)
                    {
                    }
                    column(Gen__Journal_Line__Amount__LCY__Caption; CaptionClassTranslate('101,0,Total (%1)'))
                    {
                    }
                    column(Gen__Journal_Line__Balance__LCY__Caption; CaptionClassTranslate('101,0,Balance (%1)'))
                    {
                    }
                    column(Cust_Vend_Name; CustVendName)
                    {
                    }
                    dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
                    {
                        DataItemLink = "Customer No." = FIELD("Account No."), "Applies-to ID" = FIELD("Applies-to ID");
                        DataItemTableView = SORTING("Customer No.", Open, Positive, "Due Date", "Currency Code");
                        column(Cust__Ledger_Entry__Document_Type_; "Document Type")
                        {
                        }
                        column(Cust__Ledger_Entry__Document_No__; "Document No.")
                        {
                        }
                        column(Cust__Ledger_Entry_Description; Description)
                        {
                        }
                        column(Cust__Ledger_Entry__Due_Date_; "Due Date")
                        {
                        }
                        column(Remaining_Amount_; -"Remaining Amount")
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(AmountDiscounted_Control3033; AmountDiscounted)
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Amount_to_Apply____AmountDiscounted___AmountPmtDiscTolerance___AmountPmtTolerance_; -("Amount to Apply" + AmountDiscounted + AmountPmtDiscTolerance + AmountPmtTolerance))
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Cust__Ledger_Entry__Currency_Code_; "Currency Code")
                        {
                        }
                        column(AmountPmtTolerance_Control3049; AmountPmtTolerance)
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(AmountPmtDiscTolerance_Control3050; AmountPmtDiscTolerance)
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Cust__Ledger_Entry_Entry_No_; "Entry No.")
                        {
                        }
                        column(Cust__Ledger_Entry_Customer_No_; "Customer No.")
                        {
                        }
                        column(Cust__Ledger_Entry_Applies_to_ID; "Applies-to ID")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            CalcFields("Remaining Amount");

                            InitPmtDisc(-"Accepted Payment Tolerance", -"Remaining Amount");
                            CalcPmtDisc(
                              Positive, "Remaining Pmt. Disc. Possible",
                              "Pmt. Discount Date" >= "Gen. Journal Line"."Posting Date", "Accepted Pmt. Disc. Tolerance",
                              TotalCustAmount);

                            AmountPaid := AmountPaid + AmountPmtTolerance + AmountDiscounted + AmountPmtDiscTolerance;
                            if "Currency Code" = "Gen. Journal Line"."Currency Code" then begin
                                TotalAmountDiscounted := TotalAmountDiscounted + AmountDiscounted;
                                AmountApplied := AmountApplied + "Amount to Apply";
                                TotalAmountPmtTolerance := TotalAmountPmtTolerance + AmountPmtTolerance;
                                TotalAmountPmtDiscTolerance := TotalAmountPmtDiscTolerance + AmountPmtDiscTolerance;
                            end else begin
                                TotalAmountDiscounted :=
                                  TotalAmountDiscounted +
                                  CurrExchRate.ExchangeAmtFCYToFCY(
                                    "Gen. Journal Line"."Posting Date",
                                    "Currency Code",
                                    "Gen. Journal Line"."Currency Code",
                                    AmountDiscounted);
                                AmountApplied :=
                                  AmountApplied +
                                  CurrExchRate.ExchangeAmtFCYToFCY(
                                    "Gen. Journal Line"."Posting Date",
                                    "Currency Code",
                                    "Gen. Journal Line"."Currency Code",
                                    "Amount to Apply");
                                TotalAmountPmtTolerance :=
                                  TotalAmountPmtTolerance +
                                  CurrExchRate.ExchangeAmtFCYToFCY(
                                    "Gen. Journal Line"."Posting Date",
                                    "Currency Code",
                                    "Gen. Journal Line"."Currency Code",
                                    AmountPmtTolerance);
                                TotalAmountPmtDiscTolerance :=
                                  TotalAmountPmtDiscTolerance +
                                  CurrExchRate.ExchangeAmtFCYToFCY(
                                    "Gen. Journal Line"."Posting Date",
                                    "Currency Code",
                                    "Gen. Journal Line"."Currency Code",
                                    AmountPmtDiscTolerance);
                            end;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if ("Gen. Journal Line"."Account Type" <> "Gen. Journal Line"."Account Type"::Customer) or
                               ("Gen. Journal Line"."Applies-to ID" = '')
                            then
                                CurrReport.Break();

                            if CheckIfExistProcessedCustVendLedgerEntryApplicationGroup("Gen. Journal Line") then
                                CurrReport.Break()
                            else
                                AddProcessedCustVendLedgerEntryApplicationGroup("Gen. Journal Line");
                        end;
                    }
                    dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
                    {
                        DataItemLink = "Vendor No." = FIELD("Account No."), "Applies-to ID" = FIELD("Applies-to ID");
                        DataItemTableView = SORTING("Vendor No.", Open, Positive, "Due Date", "Currency Code");
                        column(Remaining_Amount__Control3035; -"Remaining Amount")
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Amount_to_Apply____AmountDiscounted___AmountPmtDiscTolerance___AmountPmtTolerance__Control3036; -("Amount to Apply" + AmountDiscounted + AmountPmtDiscTolerance + AmountPmtTolerance))
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(AmountDiscounted_Control3037; AmountDiscounted)
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Vendor_Ledger_Entry_Description; Description)
                        {
                        }
                        column(Vendor_Ledger_Entry__Due_Date_; "Due Date")
                        {
                        }
                        column(Vendor_Ledger_Entry__Document_No__; "Document No.")
                        {
                        }
                        column(Vendor_Ledger_Entry__Document_Type_; "Document Type")
                        {
                        }
                        column(Vendor_Ledger_Entry__Currency_Code_; "Currency Code")
                        {
                        }
                        column(AmountPmtTolerance_Control3051; AmountPmtTolerance)
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(AmountPmtDiscTolerance_Control3052; AmountPmtDiscTolerance)
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Vendor_Ledger_Entry_Entry_No_; "Entry No.")
                        {
                        }
                        column(Vendor_Ledger_Entry_Vendor_No_; "Vendor No.")
                        {
                        }
                        column(Vendor_Ledger_Entry_Applies_to_ID; "Applies-to ID")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            CalcFields("Remaining Amount");

                            InitPmtDisc(-"Accepted Payment Tolerance", -"Remaining Amount");
                            CalcPmtDisc(
                              Positive, "Remaining Pmt. Disc. Possible",
                              "Pmt. Discount Date" >= "Gen. Journal Line"."Posting Date", "Accepted Pmt. Disc. Tolerance",
                              TotalVendAmount);

                            AmountPaid := AmountPaid + AmountPmtTolerance + AmountDiscounted + AmountPmtDiscTolerance;
                            if "Currency Code" = "Gen. Journal Line"."Currency Code" then begin
                                TotalAmountDiscounted := TotalAmountDiscounted + AmountDiscounted;
                                AmountApplied := AmountApplied + "Amount to Apply";
                                TotalAmountPmtTolerance := TotalAmountPmtTolerance + AmountPmtTolerance;
                                TotalAmountPmtDiscTolerance := TotalAmountPmtDiscTolerance + AmountPmtDiscTolerance;
                            end else begin
                                TotalAmountDiscounted :=
                                  TotalAmountDiscounted +
                                  CurrExchRate.ExchangeAmtFCYToFCY(
                                    "Gen. Journal Line"."Posting Date",
                                    "Currency Code",
                                    "Gen. Journal Line"."Currency Code",
                                    AmountDiscounted);
                                AmountApplied :=
                                  AmountApplied +
                                  CurrExchRate.ExchangeAmtFCYToFCY(
                                    "Gen. Journal Line"."Posting Date",
                                    "Currency Code",
                                    "Gen. Journal Line"."Currency Code",
                                    "Amount to Apply");
                                TotalAmountPmtTolerance :=
                                  TotalAmountPmtTolerance +
                                  CurrExchRate.ExchangeAmtFCYToFCY(
                                    "Gen. Journal Line"."Posting Date",
                                    "Currency Code",
                                    "Gen. Journal Line"."Currency Code",
                                    AmountPmtTolerance);
                                TotalAmountPmtDiscTolerance :=
                                  TotalAmountPmtDiscTolerance +
                                  CurrExchRate.ExchangeAmtFCYToFCY(
                                    "Gen. Journal Line"."Posting Date",
                                    "Currency Code",
                                    "Gen. Journal Line"."Currency Code",
                                    AmountPmtDiscTolerance);
                            end;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if ("Gen. Journal Line"."Account Type" <> "Gen. Journal Line"."Account Type"::Vendor) or
                               ("Gen. Journal Line"."Applies-to ID" = '')
                            then
                                CurrReport.Break();

                            if CheckIfExistProcessedCustVendLedgerEntryApplicationGroup("Gen. Journal Line") then
                                CurrReport.Break()
                            else
                                AddProcessedCustVendLedgerEntryApplicationGroup("Gen. Journal Line");
                        end;
                    }
                    dataitem(ErrorLoop; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(ErrorText_Number_; ErrorText[Number])
                        {
                        }
                        column(ErrorLoop_Number; Number)
                        {
                        }
                        column(ErrorText_Number_Caption; ErrorText_Number_CaptionLbl)
                        {
                        }

                        trigger OnPostDataItem()
                        begin
                            ErrorCounter := 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if ErrorCounter <= 0 then
                                CurrReport.Break();

                            SetRange(Number, 1, ErrorCounter);
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if ("Document No." = LastDocumentNo) and ("Account Type" = LastAccountType) and ("Account No." = LastAccountNo) then
                            TotalAmount := TotalAmount + Amount
                        else begin
                            TotalAmount := Amount;
                            AmountApplied := 0;
                            TotalAmountDiscounted := 0;
                            TotalAmountPmtTolerance := 0;
                            TotalAmountPmtDiscTolerance := 0;
                        end;
                        AmountBalLcy := AmountBalLcy + "Balance (LCY)";
                        AmountLcy := AmountLcy + "Amount (LCY)";

                        if "Currency Code" = '' then
                            "Amount (LCY)" := Amount;

                        AccName := '';
                        BalAccName := '';

                        if not EmptyLine() then begin
                            MakeRecurringTexts("Gen. Journal Line");
                            AmountError := false;
                            CheckGenJnlLineErrors("Gen. Journal Line");
                        end;

                        CheckBalance();

                        AmountDiscounted := 0;
                        AmountPmtTolerance := 0;
                        AmountPmtDiscTolerance := 0;
                        for Sign := Sign::Negative to Sign::Positive do begin
                            TotalCustAmount[Sign] := 0;
                            TotalVendAmount[Sign] := 0;
                        end;
                        AmountPaid := Amount;
                        ShowApplyToOutput := false;
                        if "Applies-to Doc. No." <> '' then begin
                            ShowApplyToOutput := true;
                            case "Account Type" of
                                "Account Type"::Customer:
                                    CheckOldCustomer();
                                "Account Type"::Vendor:
                                    CheckOldVendor();
                                else
                                    ShowApplyToOutput := false;
                            end;
                        end else
                            CalcAppliesToIDTotals();
                        case "Account Type" of
                            "Account Type"::Customer:
                                if Cust.Get("Account No.") then
                                    CustVendName := Cust.Name;
                            "Account Type"::Vendor:
                                if Vend.Get("Account No.") then
                                    CustVendName := Vend.Name;
                            "Account Type"::"Bank Account":
                                if BankAcc.Get("Account No.") then
                                    CustVendName := BankAcc.Name;
                        end;

                        LastDocumentNo := "Document No.";
                        LastAccountNo := "Account No.";
                        LastAccountType := "Account Type";
                    end;

                    trigger OnPreDataItem()
                    begin
                        LastDocumentNo := '';
                        LastAccountNo := '';
                        LastAccountType := LastAccountType::"G/L Account";
                        AmountBalLcy := 0;
                        AmountLcy := 0;
                        TotalAmount := 0;

                        GenJnlTemplate.Get("Gen. Journal Batch"."Journal Template Name");
                        if GenJnlTemplate.Recurring then begin
                            if GetFilter("Posting Date") <> '' then
                                AddError(
                                  StrSubstNo(
                                    E000Err,
                                    FieldCaption("Posting Date")));
                            SetRange("Posting Date", 0D, WorkDate());
                            if GetFilter("Expiration Date") <> '' then
                                AddError(
                                  StrSubstNo(
                                    E000Err,
                                    FieldCaption("Expiration Date")));
                            SetFilter("Expiration Date", '%1 | %2..', 0D, WorkDate());
                        end;

                        if "Gen. Journal Batch"."No. Series" <> '' then begin
                            NoSeries.Get("Gen. Journal Batch"."No. Series");
                            LastEntrdDocNo := '';
                            LastEntrdDate := 0D;
                        end;

                        CurrentCustomerVendors := 0;
                        VATEntryCreated := false;

                        GenJnlLine2.Reset();
                        GenJnlLine2.CopyFilters("Gen. Journal Line");

                        TempGLAccNetChange.DeleteAll();
                        Clear(TotalAmountDiscounted);
                        Clear(TotalAmountPmtTolerance);
                        Clear(TotalAmountPmtDiscTolerance);
                        Clear(AmountApplied);
                    end;
                }
                dataitem(ReconcileLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    column(GLAccNetChange__No__; TempGLAccNetChange."No.")
                    {
                    }
                    column(GLAccNetChange_Name; TempGLAccNetChange.Name)
                    {
                    }
                    column(GLAccNetChange__Net_Change_in_Jnl__; TempGLAccNetChange."Net Change in Jnl.")
                    {
                    }
                    column(GLAccNetChange__Balance_after_Posting_; TempGLAccNetChange."Balance after Posting")
                    {
                    }
                    column(ReconcileLoop_Number; Number)
                    {
                    }
                    column(ReconciliationCaption; ReconciliationCaptionLbl)
                    {
                    }
                    column(GLAccNetChange__No__Caption; GLAccNetChange__No__CaptionLbl)
                    {
                    }
                    column(GLAccNetChange_NameCaption; GLAccNetChange_NameCaptionLbl)
                    {
                    }
                    column(GLAccNetChange__Net_Change_in_Jnl__Caption; GLAccNetChange__Net_Change_in_Jnl__CaptionLbl)
                    {
                    }
                    column(GLAccNetChange__Balance_after_Posting_Caption; GLAccNetChange__Balance_after_Posting_CaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if Number = 1 then
                            TempGLAccNetChange.Find('-')
                        else
                            TempGLAccNetChange.Next();
                    end;

                    trigger OnPostDataItem()
                    begin
                        TempGLAccNetChange.DeleteAll();
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange(Number, 1, TempGLAccNetChange.Count);
                    end;
                }

                trigger OnPreDataItem()
                begin
                    LastDocumentNo := '';
                end;
            }

            trigger OnAfterGetRecord()
            begin
                GenJnlTemplate.Get("Journal Template Name");

                ClearProcessedCustVendLedgerEntryApplicationGroups();
            end;

            trigger OnPreDataItem()
            begin
                GLSetup.Get();
                SalesSetup.Get();
                PurchSetup.Get();
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        GenJnlLineFilter := "Gen. Journal Line".GetFilters();
        CompanyInformation.Get();
    end;

    var
        GLSetup: Record "General Ledger Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        UserSetup: Record "User Setup";
        AccountingPeriod: Record "Accounting Period";
        GLAcc: Record "G/L Account";
        Currency: Record Currency;
        Cust: Record Customer;
        Vend: Record Vendor;
        BankAccPostingGr: Record "Bank Account Posting Group";
        BankAcc: Record "Bank Account";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlLine2: Record "Gen. Journal Line";
        TempGenJnlLine: Record "Gen. Journal Line" temporary;
        GenJnlAlloc: Record "Gen. Jnl. Allocation";
        OldCustLedgEntry: Record "Cust. Ledger Entry";
        OldVendLedgEntry: Record "Vendor Ledger Entry";
        VATPostingSetup: Record "VAT Posting Setup";
        NoSeries: Record "No. Series";
        FA: Record "Fixed Asset";
        ICPartner: Record "IC Partner";
        DeprBook: Record "Depreciation Book";
        FADeprBook: Record "FA Depreciation Book";
        FASetup: Record "FA Setup";
        TempGLAccNetChange: Record "G/L Account Net Change" temporary;
        CompanyInformation: Record "Company Information";
        CurrExchRate: Record "Currency Exchange Rate";
        TempGenJnlLineForProcessedCustVendLedgerEntryApplicationGroups: Record "Gen. Journal Line" temporary;
        GenJnlLineFilter: Text;
        AllowFAPostingFrom: Date;
        AllowFAPostingTo: Date;
        LastDate: Date;
        LastDocType: Enum "Gen. Journal Document Type";
        LastDocNo: Code[20];
        LastEntrdDocNo: Code[20];
        LastEntrdDate: Date;
        DocBalance: Decimal;
        DocBalanceReverse: Decimal;
        DateBalance: Decimal;
        DateBalanceReverse: Decimal;
        TotalBalance: Decimal;
        TotalBalanceReverse: Decimal;
        AccName: Text[100];
        LastLineNo: Integer;
        AmountError: Boolean;
        ErrorCounter: Integer;
        ErrorText: array[50] of Text[250];
        TempErrorText: Text[250];
        BalAccName: Text[100];
        CustVendName: Text[100];
        CurrentCustomerVendors: Integer;
        VATEntryCreated: Boolean;
        CustPosting: Boolean;
        VendPosting: Boolean;
        SalesPostingType: Boolean;
        PurchPostingType: Boolean;
        CurrentICPartner: Code[20];
        AmountDiscounted: Decimal;
        AmountPmtTolerance: Decimal;
        AmountPmtDiscTolerance: Decimal;
        AmountDue: Decimal;
        AmountPaid: Decimal;
        TotalAmountDiscounted: Decimal;
        TotalAmountPmtTolerance: Decimal;
        TotalAmountPmtDiscTolerance: Decimal;
        AmountApplied: Decimal;
        TotalAmount: Decimal;
        ShowApplyToOutput: Boolean;
        AmountLcy: Decimal;
        LastDocumentNo: Code[20];
        AmountBalLcy: Decimal;
        TotalCustAmount: array[2] of Decimal;
        TotalVendAmount: array[2] of Decimal;
        Sign: Option " ",Negative,Positive;
        LastAccountNo: Code[20];
        LastAccountType: Enum "Gen. Journal Account Type";

        E000Err: Label '%1 cannot be filtered when you post recurring journals.', Comment = '%1=Posting date field caption';
        E001Err: Label '%1 or %2 must be specified.', Comment = '%1=Account No. field caption; %2=Bal. Account No. field caption';
        E002Err: Label '%1 must be specified.', Comment = '%1=Gen. Posting Type field caption';
        E003Err: Label '%1 + %2 must be %3.', Comment = '%1=VAT Amount field caption;%2=VAT Base Amount field caption;%3=Amount field caption';
        E004Err: Label '%1 must be " " when %2 is %3.', Comment = '%1=Gen. Posting Type field caption;%2=Account Type field caption;%3=Account Type';
        E005Err: Label '%1, %2, %3 or %4 must not be completed when %5 is %6.', Comment = '%1=Gen. Bus. Posting Group field caption;%2=Gen. Prod. Posting Group field caption;%3=VAT Bus. Posting Group field caption;%4=VAT Prod. Posting Group field caption;%5=Account Type field caption;%6=Account Type';
        E006Err: Label '%1 must be negative.', Comment = '%1=Amount field caption';
        E007Err: Label '%1 must be positive.', Comment = '%1=Amount field caption';
        E008Err: Label '%1 must have the same sign as %2.', Comment = '%1=Sales/Purch. (LCY) field caption;%2=Amount field caption';
        E009Err: Label '%1 cannot be specified.', Comment = '%1=Job No. field caption';
        E011Err: Label '%1 + %2 must be -%3.', Comment = '%1=Bal. VAT Amount field caption;%2=Bal. VAT Base Amount field caption;%3=Amount field caption';
        E012Err: Label '%1 must have a different sign than %2.', Comment = '%1=Sales/Purch. (LCY) field caption;%2=Amount field caption';
        E013Err: Label '%1 must only be a closing date for G/L entries.', Comment = '%1=Posting Date field caption';
        E015Err: Label 'The lines are not listed according to Posting Date because they were not entered in that order.';
        E016Err: Label 'There is a gap in the number series.';
        E017Err: Label '%1 or %2 must be G/L Account or Bank Account.', Comment = '%1=Account Type field caption;%2=Bal. Account Type field caption';
        E018Err: Label '%1 must be 0.', Comment = '%1=Payment Discount % field caption';
        E019Err: Label '%1 cannot be specified when using recurring journals.', Comment = '%1=Bal. Account No. field caption';
        E020Err: Label '%1 must not be %2 when %3 = %4.', Comment = '%1=Recurring Method field caption;%2=Recurring Method;%3=Account Type field caption;%4=Account Type';
        E021Err: Label 'Allocations can only be used with recurring journals.';
        E022Err: Label 'Please specify %1 in the %2 allocation lines.', Comment = '%1=Account No. field caption;%2=GenJnlAlloc record count';
        E024Err: Label '%1 %2 posted on %3, must be separated by an empty line', Comment = '%1=Document Type;%2=Document No.;%3=Posting Date';
        E025Err: Label '%1 %2 is out of balance by %3.', Comment = '%1=LastDocType;%2=LastDocNo; %3=DocBalance';
        E026Err: Label 'The reversing entries for %1 %2 are out of balance by %3.', Comment = '%1=LastDocType;%2=LastDocNo;%3=DocBalanceReverse';
        E027Err: Label 'As of %1, the lines are out of balance by %2.', Comment = '%1=LastDate;%2=DateBalance';
        E028Err: Label 'As of %1, the reversing entries are out of balance by %2.', Comment = '%1=LastDate;%2=DateBalanceReverse';
        E029Err: Label 'The total of the lines is out of balance by %1.', Comment = '%1=Total balance';
        E030Err: Label 'The total of the reversing entries is out of balance by %1.', Comment = '%1=TotalBalanceReverse';
        E031Err: Label '%1 %2 does not exist.', Comment = '%1=G/L Account table caption;%2=Account No.';
        E032Err: Label '%1 must be %2 for %3 %4.', Comment = '%1=Blocked field caption;%2=FALSE;%3=G/L Account table caption;%4=Account No.';
        E036Err: Label '%1 %2 %3 does not exist.', Comment = '%1=VAT Posting Setup table caption;%2=VAT Bus. Posting Group;%3=VAT Prod. Posting Group';
        E037Err: Label '%1 must be %2.', Comment = '%1=VAT Calculation Type field caption;%2=VAT Calculation Type';
        E038Err: Label 'The currency %1 cannot be found. Please check the currency table.', Comment = '%1=Currency Code';
        E039Err: Label 'Sales %1 %2 already exists.', Comment = '%1=Document Type;%2=Document No.';
        E040Err: Label 'Purchase %1 %2 already exists.', Comment = '%1=Document Type;%2=Document No.';
        E041Err: Label '%1 must be entered.', Comment = '%1=External Document No. field caption';
        E042Err: Label '%1 must not be filled when %2 is different in %3 and %4.', Comment = '%1=Bank Payment Type field caption;%2=Currency Code field caption;%3=Table caption;%4=Bank Account table caption';
        E043Err: Label '%1 %2 must not have %3 = %4.', Comment = '%1=Fixed Asset table caption;%2=Account No.;%3=Budgeted Asset field caption;%4=TRUE';
        E044Err: Label '%1 must not be specified in fixed asset journal lines.', Comment = '%1=Job No.';
        E045Err: Label '%1 must be specified in fixed asset journal lines.', Comment = '%1=Depreciation Book Code field caption';
        E046Err: Label '%1 must be different than %2.', Comment = '%1=Depreciation Book Code field caption;%2=Duplicate in Depreciation Book field caption';
        E047Err: Label '%1 and %2 must not both be %3.', Comment = '%1=Account Type field caption;%2=Bal. Account Type field caption;%3=Account Type';
        E048Err: Label '%1  must not be specified when %2 = %3.', Comment = '%1=Gen. Posting Type field caption;%2=FA Posting Type field caption;%3=FA Posting Type';
        E049Err: Label '%1 must not be specified when %2 = %3.', Comment = '%1=Gen. Bus. Posting Group field caption;%2=FA Posting Type field caption;%3=FA Posting Type';
        E050Err: Label 'must not be specified together with %1 = %2.', Comment = '%1=FA Posting Type field caption;%2=FA Posting Type';
        E051Err: Label '%1 must be identical to %2.', Comment = '%1=Posting Date field caption;%2=FA Posting Date field caption';
        E052Err: Label '%1 cannot be a closing date.', Comment = '%1=FA Posting Date field caption';
        E053Err: Label '%1 is not within your range of allowed posting dates.', Comment = '%1=FA Posting Date field caption';
        E054Err: Label 'Insurance integration is not activated for %1 %2.', Comment = 'Depreciation Book Code field caption;%2=Depreciation Book Code';
        E055Err: Label 'must not be specified when %1 is specified.', Comment = 'FA Error Entry No. field caption';
        E056Err: Label 'When G/L integration is not activated, %1 must not be posted in the general journal.', Comment = '%1=FA Posting Type';
        E057Err: Label 'When G/L integration is not activated, %1 must not be specified in the general journal.', Comment = '%1=Some field caption';
        E058Err: Label '%1 must not be specified.', Comment = '%1=Some field caption';
        E059Err: Label 'The combination of Customer and Gen. Posting Type Purchase is not allowed.';
        E060Err: Label 'The combination of Vendor and Gen. Posting Type Sales is not allowed.';
        E061Err: Label 'The Balance and Reversing Balance recurring methods can be used only with Allocations.';
        E062Err: Label '%1 must not be 0.', Comment = '%1=Amount field caption';
        E064Err: Label '%1 %2 is already used in line %3 (%4 %5).', Comment = '%1=External Document No. field caption;%2=External Document No.;%3=Line No.;%4=Document No. field caption;%5=Document No.';
        E065Err: Label '%1 must not be blocked with type %2 when %3 is %4', Comment = '%1=Account Type;%2=Whether customer is blocked;%3=Document Type field caption;%4=Document Type';
        E066Err: Label 'You cannot enter G/L Account or Bank Account in both %1 and %2.', Comment = '%1=Account No. field caption;%2=Bal. Account No. field caption';
        E067Err: Label '%1 %2 is linked to %3 %4.', Comment = '%1=Customer table caption;%2=Account No.%3=IC Partner table caption;%4=IC Partner Code';
        E069Err: Label '%1 must not be specified when %2 is %3.', Comment = '%1=IC Partner G/L Acc. No. field caption;%2=IC Direction field caption;%3=IC Direction format';
        E070Err: Label '%1 must not be specified when the document is not an intercompany transaction.', Comment = '%1=IC Partner G/L Acc. No. field caption';
        USE001Lbl: Label 'Warning:  Checks cannot be financially voided when Force Doc. Balance is set to No in the Journal Template.';
        USE002Lbl: Label 'Totals for Journal %1, Batch %2', Comment = '%1=Journal Template Name;%2=Journal Batch Name';
        USE003Lbl: Label 'Total Amount, %1 %2', Comment = '%1=Document Type;%2=Document No.';
        Payment_Journal___Pre_Check_TestCaptionLbl: Label 'Payment Journal - Pre-Check Test';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Gen__Journal_Batch__NameCaptionLbl: Label 'Journal Batch';
        Gen__Journal_Line__Document_Type_CaptionLbl: Label 'Type';
        Gen__Journal_Line__Document_No__CaptionLbl: Label 'Number';
        Gen__Journal_Line__Account_Type_CaptionLbl: Label 'Type';
        Gen__Journal_Line__Account_No__CaptionLbl: Label 'Number';
        Gen__Journal_Line__Bal__Account_No__CaptionLbl: Label 'Number';
        Gen__Journal_Line__Bal__Account_Type_CaptionLbl: Label 'Type';
        DocumentCaptionLbl: Label 'Document';
        AccountCaptionLbl: Label 'Account';
        Bal__AccountCaptionLbl: Label 'Bal. Account';
        Description___CaptionLbl: Label 'Description';
        AmountDueCaptionLbl: Label 'AmountDue';
        AmountDiscountedCaptionLbl: Label 'Payment Discount';
        AmountPmtDiscToleranceCaptionLbl: Label 'Pmt. Discount Tolerance';
        AmountPmtToleranceCaptionLbl: Label 'Payment Tolerance';
        Unapplied_AmountsCaptionLbl: Label 'Unapplied Amounts';
        ErrorText_Number_CaptionLbl: Label 'Warning!';
        ReconciliationCaptionLbl: Label 'Reconciliation';
        GLAccNetChange__No__CaptionLbl: Label 'No.';
        GLAccNetChange_NameCaptionLbl: Label 'Name';
        GLAccNetChange__Net_Change_in_Jnl__CaptionLbl: Label 'Net Change in Jnl.';
        GLAccNetChange__Balance_after_Posting_CaptionLbl: Label 'Balance after Posting';

    local procedure CheckRecurringLine(GenJnlLine2: Record "Gen. Journal Line")
    begin
        with GenJnlLine2 do
            if GenJnlTemplate.Recurring then begin
                if "Recurring Method" = "Gen. Journal Recurring Method"::" " then
                    AddError(StrSubstNo(E002Err, FieldCaption("Recurring Method")));
                if Format("Recurring Frequency") = '' then
                    AddError(StrSubstNo(E002Err, FieldCaption("Recurring Frequency")));
                if "Bal. Account No." <> '' then
                    AddError(
                      StrSubstNo(
                        E019Err,
                        FieldCaption("Bal. Account No.")));
                case "Recurring Method" of
                    "Recurring Method"::"V  Variable", "Recurring Method"::"RV Reversing Variable",
                  "Recurring Method"::"F  Fixed", "Recurring Method"::"RF Reversing Fixed":
                        WarningIfZeroAmt("Gen. Journal Line");
                    "Recurring Method"::"B  Balance", "Recurring Method"::"RB Reversing Balance":
                        WarningIfNonZeroAmt("Gen. Journal Line");
                end;
                if "Recurring Method".AsInteger() > "Recurring Method"::"V  Variable".AsInteger() then begin
                    if "Account Type" = "Account Type"::"Fixed Asset" then
                        AddError(
                          StrSubstNo(
                            E020Err,
                            FieldCaption("Recurring Method"), "Recurring Method",
                            FieldCaption("Account Type"), "Account Type"));
                    if "Bal. Account Type" = "Bal. Account Type"::"Fixed Asset" then
                        AddError(
                          StrSubstNo(
                            E020Err,
                            FieldCaption("Recurring Method"), "Recurring Method",
                            FieldCaption("Bal. Account Type"), "Bal. Account Type"));
                end;
            end else begin
                if "Recurring Method" <> "Gen. Journal Recurring Method"::" " then
                    AddError(StrSubstNo(E009Err, FieldCaption("Recurring Method")));
                if Format("Recurring Frequency") <> '' then
                    AddError(StrSubstNo(E009Err, FieldCaption("Recurring Frequency")));
            end;
    end;

    local procedure CheckAllocations(GenJnlLine2: Record "Gen. Journal Line")
    begin
        with GenJnlLine2 do begin
            if "Recurring Method" in
               ["Recurring Method"::"B  Balance",
                "Recurring Method"::"RB Reversing Balance"]
            then begin
                GenJnlAlloc.Reset();
                GenJnlAlloc.SetRange("Journal Template Name", "Journal Template Name");
                GenJnlAlloc.SetRange("Journal Batch Name", "Journal Batch Name");
                GenJnlAlloc.SetRange("Journal Line No.", "Line No.");
                if not GenJnlAlloc.FindFirst() then
                    AddError(E061Err);
            end;

            GenJnlAlloc.Reset();
            GenJnlAlloc.SetRange("Journal Template Name", "Journal Template Name");
            GenJnlAlloc.SetRange("Journal Batch Name", "Journal Batch Name");
            GenJnlAlloc.SetRange("Journal Line No.", "Line No.");
            GenJnlAlloc.SetFilter(Amount, '<>0');
            if GenJnlAlloc.FindFirst() then
                if not GenJnlTemplate.Recurring then
                    AddError(E021Err)
                else begin
                    GenJnlAlloc.SetRange("Account No.", '');
                    if GenJnlAlloc.FindFirst() then
                        AddError(
                          StrSubstNo(
                            E022Err,
                            GenJnlAlloc.FieldCaption("Account No."), GenJnlAlloc.Count));
                end;
        end;
    end;

    local procedure MakeRecurringTexts(var GenJnlLine2: Record "Gen. Journal Line")
    begin
        with GenJnlLine2 do
            if ("Posting Date" <> 0D) and ("Account No." <> '') and ("Recurring Method" <> "Gen. Journal Recurring Method"::" ") then
                AccountingPeriod.MakeRecurringTexts("Posting Date", "Document No.", Description);
    end;

    local procedure CheckBalance()
    var
        GenJnlLine: Record "Gen. Journal Line";
        NextGenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine := "Gen. Journal Line";
        LastLineNo := "Gen. Journal Line"."Line No.";
        if "Gen. Journal Line".Next() = 0 then;
        NextGenJnlLine := "Gen. Journal Line";
        MakeRecurringTexts(NextGenJnlLine);
        "Gen. Journal Line" := GenJnlLine;
        with GenJnlLine do
            if not EmptyLine() then begin
                DocBalance := DocBalance + "Balance (LCY)";
                DateBalance := DateBalance + "Balance (LCY)";
                TotalBalance := TotalBalance + "Balance (LCY)";
                if "Recurring Method".AsInteger() >= "Recurring Method"::"RF Reversing Fixed".AsInteger() then begin
                    DocBalanceReverse := DocBalanceReverse + "Balance (LCY)";
                    DateBalanceReverse := DateBalanceReverse + "Balance (LCY)";
                    TotalBalanceReverse := TotalBalanceReverse + "Balance (LCY)";
                end;
                LastDocType := "Document Type";
                LastDocNo := "Document No.";
                LastDate := "Posting Date";
                if TotalBalance = 0 then begin
                    CurrentCustomerVendors := 0;
                    VATEntryCreated := false;
                end;
                if GenJnlTemplate."Force Doc. Balance" then begin
                    VATEntryCreated :=
                      VATEntryCreated or
                      (("Account Type" = "Account Type"::"G/L Account") and ("Account No." <> '') and
                       ("Gen. Posting Type" in ["Gen. Posting Type"::Purchase, "Gen. Posting Type"::Sale])) or
                      (("Bal. Account Type" = "Bal. Account Type"::"G/L Account") and ("Bal. Account No." <> '') and
                       ("Bal. Gen. Posting Type" in ["Bal. Gen. Posting Type"::Purchase, "Bal. Gen. Posting Type"::Sale]));
                    if (("Account Type" in ["Account Type"::Customer, "Account Type"::Vendor]) and
                        ("Account No." <> '')) or
                       (("Bal. Account Type" in ["Bal. Account Type"::Customer, "Bal. Account Type"::Vendor]) and
                        ("Bal. Account No." <> ''))
                    then
                        CurrentCustomerVendors := CurrentCustomerVendors + 1;
                    if (CurrentCustomerVendors > 1) and VATEntryCreated then
                        AddError(
                          StrSubstNo(
                            E024Err,
                            "Document Type", "Document No.", "Posting Date"));
                end;
            end;

        with NextGenJnlLine do begin
            if (LastDate <> 0D) and (LastDocNo <> '') and
               (("Posting Date" <> LastDate) or
                ("Document Type" <> LastDocType) or
                ("Document No." <> LastDocNo) or
                ("Line No." = LastLineNo))
            then begin
                if GenJnlTemplate."Force Doc. Balance" then begin
                    case true of
                        DocBalance <> 0:
                            AddError(StrSubstNo(E025Err, LastDocType, LastDocNo, DocBalance));
                        DocBalanceReverse <> 0:
                            AddError(StrSubstNo(E026Err, LastDocType, LastDocNo, DocBalanceReverse));
                    end;
                    DocBalance := 0;
                    DocBalanceReverse := 0;
                end;
                if ("Posting Date" <> LastDate) or
                   ("Document Type" <> LastDocType) or ("Document No." <> LastDocNo)
                then begin
                    CurrentCustomerVendors := 0;
                    VATEntryCreated := false;
                    CustPosting := false;
                    VendPosting := false;
                    SalesPostingType := false;
                    PurchPostingType := false;
                end;
            end;

            if (LastDate <> 0D) and (("Posting Date" <> LastDate) or ("Line No." = LastLineNo)) then begin
                case true of
                    DateBalance <> 0:
                        AddError(
                          StrSubstNo(
                            E027Err,
                            LastDate, DateBalance));
                    DateBalanceReverse <> 0:
                        AddError(
                          StrSubstNo(
                            E028Err,
                            LastDate, DateBalanceReverse));
                end;
                DocBalance := 0;
                DocBalanceReverse := 0;
                DateBalance := 0;
                DateBalanceReverse := 0;
            end;

            if "Line No." = LastLineNo then begin
                case true of
                    TotalBalance <> 0:
                        AddError(
                          StrSubstNo(
                            E029Err,
                            TotalBalance));
                    TotalBalanceReverse <> 0:
                        AddError(
                          StrSubstNo(
                            E030Err,
                            TotalBalanceReverse));
                end;
                DocBalance := 0;
                DocBalanceReverse := 0;
                DateBalance := 0;
                DateBalanceReverse := 0;
                TotalBalance := 0;
                TotalBalanceReverse := 0;
                LastDate := 0D;
                LastDocType := LastDocType::" ";
                LastDocNo := '';
            end;
        end;
    end;

    local procedure AddError(Text: Text[250])
    begin
        ErrorCounter := ErrorCounter + 1;
        ErrorText[ErrorCounter] := Text;
    end;

    local procedure AddConditionalError(Condition: Boolean; Text: Text[250])
    begin
        if Condition then
            AddError(Text);
    end;

    local procedure ReconcileGLAccNo(GLAccNo: Code[20]; ReconcileAmount: Decimal)
    begin
        if not TempGLAccNetChange.Get(GLAccNo) then begin
            GLAcc.Get(GLAccNo);
            GLAcc.CalcFields("Balance at Date");
            TempGLAccNetChange.Init();
            TempGLAccNetChange."No." := GLAcc."No.";
            TempGLAccNetChange.Name := GLAcc.Name;
            TempGLAccNetChange."Balance after Posting" := GLAcc."Balance at Date";
            TempGLAccNetChange.Insert();
        end;
        TempGLAccNetChange."Net Change in Jnl." := TempGLAccNetChange."Net Change in Jnl." + ReconcileAmount;
        TempGLAccNetChange."Balance after Posting" := TempGLAccNetChange."Balance after Posting" + ReconcileAmount;
        TempGLAccNetChange.Modify();
    end;

    local procedure CheckGLAcc(var GenJnlLine: Record "Gen. Journal Line"; var AccName: Text[100])
    begin
        with GenJnlLine do
            if not GLAcc.Get("Account No.") then
                AddError(
                  StrSubstNo(
                    E031Err,
                    GLAcc.TableCaption(), "Account No."))
            else begin
                AccName := GLAcc.Name;

                if GLAcc.Blocked then
                    AddError(
                      StrSubstNo(
                        E032Err,
                        GLAcc.FieldCaption(Blocked), false, GLAcc.TableCaption(), "Account No."));
                if GLAcc."Account Type" <> GLAcc."Account Type"::Posting then begin
                    GLAcc."Account Type" := GLAcc."Account Type"::Posting;
                    AddError(
                      StrSubstNo(
                        E032Err,
                        GLAcc.FieldCaption("Account Type"), GLAcc."Account Type", GLAcc.TableCaption(), "Account No."));
                end;
                if not "System-Created Entry" then
                    if "Posting Date" = NormalDate("Posting Date") then
                        if not GLAcc."Direct Posting" then
                            AddError(
                              StrSubstNo(
                                E032Err,
                                GLAcc.FieldCaption("Direct Posting"), true, GLAcc.TableCaption(), "Account No."));

                if "Gen. Posting Type" <> "Gen. Posting Type"::" " then begin
                    case "Gen. Posting Type" of
                        "Gen. Posting Type"::Sale:
                            SalesPostingType := true;
                        "Gen. Posting Type"::Purchase:
                            PurchPostingType := true;
                    end;
                    TestPostingType();

                    if not VATPostingSetup.Get("VAT Bus. Posting Group", "VAT Prod. Posting Group") then
                        AddError(
                          StrSubstNo(
                            E036Err,
                            VATPostingSetup.TableCaption(), "VAT Bus. Posting Group", "VAT Prod. Posting Group"))
                    else
                        if "VAT Calculation Type" <> VATPostingSetup."VAT Calculation Type" then
                            AddError(
                              StrSubstNo(
                                E037Err,
                                FieldCaption("VAT Calculation Type"), VATPostingSetup."VAT Calculation Type"))
                end;

                if GLAcc."Reconciliation Account" then
                    ReconcileGLAccNo("Account No.", Round("Amount (LCY)" / (1 + "VAT %" / 100)));
            end;
    end;

    local procedure CheckCust(var GenJnlLine: Record "Gen. Journal Line"; var AccName: Text[100])
    begin
        with GenJnlLine do
            if not Cust.Get("Account No.") then
                AddError(
                  StrSubstNo(
                    E031Err,
                    Cust.TableCaption(), "Account No."))
            else begin
                AccName := Cust.Name;
                if Cust."Privacy Blocked" then
                    AddError(Cust.GetPrivacyBlockedGenericErrorText(Cust));
                if ((Cust.Blocked = Cust.Blocked::All) or
                    ((Cust.Blocked in [Cust.Blocked::Invoice, Cust.Blocked::Ship]) and
                     ("Document Type" in ["Document Type"::Invoice, "Document Type"::" "]))
                    )
                then
                    AddError(
                      StrSubstNo(
                        E065Err,
                        "Account Type", Cust.Blocked, FieldCaption("Document Type"), "Document Type"));
                if "Currency Code" <> '' then
                    if not Currency.Get("Currency Code") then
                        AddError(
                          StrSubstNo(
                            E038Err,
                            "Currency Code"));
                if (Cust."IC Partner Code" <> '') and (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany) then
                    if ICPartner.Get(Cust."IC Partner Code") then begin
                        if ICPartner.Blocked then
                            AddError(
                              StrSubstNo(
                                '%1 %2',
                                StrSubstNo(
                                  E067Err,
                                  Cust.TableCaption(), "Account No.", ICPartner.TableCaption(), "IC Partner Code"),
                                StrSubstNo(
                                  E032Err,
                                  ICPartner.FieldCaption(Blocked), false, ICPartner.TableCaption(), Cust."IC Partner Code")));
                    end else
                        AddError(
                          StrSubstNo(
                            '%1 %2',
                            StrSubstNo(
                              E067Err,
                              Cust.TableCaption(), "Account No.", ICPartner.TableCaption(), Cust."IC Partner Code"),
                            StrSubstNo(
                              E031Err,
                              ICPartner.TableCaption(), Cust."IC Partner Code")));
                CustPosting := true;
                TestPostingType();

                if "Recurring Method" = "Gen. Journal Recurring Method"::" " then
                    if "Document Type" in
                       ["Document Type"::Invoice, "Document Type"::"Credit Memo",
                        "Document Type"::"Finance Charge Memo", "Document Type"::Reminder]
                    then begin
                        OldCustLedgEntry.Reset();
                        OldCustLedgEntry.SetCurrentKey("Document No.", "Document Type", "Customer No.");
                        OldCustLedgEntry.SetRange("Document Type", "Document Type");
                        OldCustLedgEntry.SetRange("Document No.", "Document No.");
                        if OldCustLedgEntry.FindFirst() then
                            AddError(
                              StrSubstNo(
                                E039Err, "Document Type", "Document No."));

                        if SalesSetup."Ext. Doc. No. Mandatory" or
                           ("External Document No." <> '')
                        then begin
                            if "External Document No." = '' then
                                AddError(
                                  StrSubstNo(
                                    E041Err, FieldCaption("External Document No.")));

                            OldCustLedgEntry.Reset();
                            OldCustLedgEntry.SetCurrentKey("Document Type", "External Document No.", "Customer No.");
                            OldCustLedgEntry.SetRange("Document Type", "Document Type");
                            OldCustLedgEntry.SetRange("Customer No.", "Account No.");
                            OldCustLedgEntry.SetRange("External Document No.", "External Document No.");
                            if OldCustLedgEntry.FindFirst() then
                                AddError(
                                  StrSubstNo(
                                    E039Err,
                                    "Document Type", "External Document No."));
                            CheckAgainstPrevLines("Gen. Journal Line");
                        end;
                    end;
            end;
    end;

    local procedure CheckVend(var GenJnlLine: Record "Gen. Journal Line"; var AccName: Text[100])
    var
        VendorMgt: Codeunit "Vendor Mgt.";
    begin
        with GenJnlLine do
            if not Vend.Get("Account No.") then
                AddError(
                  StrSubstNo(
                    E031Err,
                    Vend.TableCaption(), "Account No."))
            else begin
                AccName := Vend.Name;

                if Vend."Privacy Blocked" then
                    AddError(Vend.GetPrivacyBlockedGenericErrorText(Vend));

                if ((Vend.Blocked = Vend.Blocked::All) or
                    ((Vend.Blocked = Vend.Blocked::Payment) and ("Document Type" = "Document Type"::Payment))
                    )
                then
                    AddError(
                      StrSubstNo(
                        E065Err,
                        "Account Type", Vend.Blocked, FieldCaption("Document Type"), "Document Type"));

                if "Currency Code" <> '' then
                    if not Currency.Get("Currency Code") then
                        AddError(
                          StrSubstNo(
                            E038Err,
                            "Currency Code"));

                if (Vend."IC Partner Code" <> '') and (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany) then
                    if ICPartner.Get(Cust."IC Partner Code") then begin
                        if ICPartner.Blocked then
                            AddError(
                              StrSubstNo(
                                '%1 %2',
                                StrSubstNo(
                                  E067Err,
                                  Vend.TableCaption(), "Account No.", ICPartner.TableCaption(), Vend."IC Partner Code"),
                                StrSubstNo(
                                  E032Err,
                                  ICPartner.FieldCaption(Blocked), false, ICPartner.TableCaption(), Vend."IC Partner Code")));
                    end else
                        AddError(
                          StrSubstNo(
                            '%1 %2',
                            StrSubstNo(
                              E067Err,
                              Vend.TableCaption(), "Account No.", ICPartner.TableCaption(), "IC Partner Code"),
                            StrSubstNo(
                              E031Err,
                              ICPartner.TableCaption(), Vend."IC Partner Code")));
                VendPosting := true;
                TestPostingType();

                if "Recurring Method" = "Gen. Journal Recurring Method"::" " then
                    if "Document Type" in
                       ["Document Type"::Invoice, "Document Type"::"Credit Memo",
                        "Document Type"::"Finance Charge Memo", "Document Type"::Reminder]
                    then begin
                        OldVendLedgEntry.Reset();
                        OldVendLedgEntry.SetCurrentKey("Document No.", "Document Type", "Vendor No.");
                        OldVendLedgEntry.SetRange("Document Type", "Document Type");
                        OldVendLedgEntry.SetRange("Document No.", "Document No.");
                        if OldVendLedgEntry.FindFirst() then
                            AddError(
                              StrSubstNo(
                                E040Err,
                                "Document Type", "Document No."));

                        if PurchSetup."Ext. Doc. No. Mandatory" or
                           ("External Document No." <> '')
                        then begin
                            if "External Document No." = '' then
                                AddError(
                                  StrSubstNo(
                                    E041Err, FieldCaption("External Document No.")));

                            OldVendLedgEntry.Reset();
                            OldVendLedgEntry.SetCurrentKey("External Document No.", "Document Type", "Vendor No.");
                            VendorMgt.SetFilterForExternalDocNo(
                              OldVendLedgEntry, "Document Type", "External Document No.", "Account No.", "Document Date");
                            if OldVendLedgEntry.FindFirst() then
                                AddError(
                                  StrSubstNo(
                                    E040Err,
                                    "Document Type", "External Document No."));
                            CheckAgainstPrevLines("Gen. Journal Line");
                        end;
                    end;
            end;
    end;

    local procedure CheckBankAcc(var GenJnlLine: Record "Gen. Journal Line"; var AccName: Text[100])
    begin
        with GenJnlLine do
            if not BankAcc.Get("Account No.") then
                AddError(
                  StrSubstNo(
                    E031Err,
                    BankAcc.TableCaption(), "Account No."))
            else begin
                AccName := BankAcc.Name;

                if BankAcc.Blocked then
                    AddError(
                      StrSubstNo(
                        E032Err,
                        BankAcc.FieldCaption(Blocked), false, BankAcc.TableCaption(), "Account No."));
                if ("Currency Code" <> BankAcc."Currency Code") and (BankAcc."Currency Code" <> '') then
                    AddError(
                      StrSubstNo(
                        E037Err,
                        FieldCaption("Currency Code"), BankAcc."Currency Code"));

                if "Currency Code" <> '' then
                    if not Currency.Get("Currency Code") then
                        AddError(
                          StrSubstNo(
                            E038Err,
                            "Currency Code"));

                if "Bank Payment Type" <> "Bank Payment Type"::" " then
                    if ("Bank Payment Type" = "Bank Payment Type"::"Computer Check") and (Amount < 0) then
                        if BankAcc."Currency Code" <> "Currency Code" then
                            AddError(
                              StrSubstNo(
                                E042Err,
                                FieldCaption("Bank Payment Type"), FieldCaption("Currency Code"),
                                TableCaption, BankAcc.TableCaption()));

                if BankAccPostingGr.Get(BankAcc."Bank Acc. Posting Group") then
                    if BankAccPostingGr."G/L Account No." <> '' then
                        ReconcileGLAccNo(
                          BankAccPostingGr."G/L Account No.",
                          Round("Amount (LCY)" / (1 + "VAT %" / 100)));
            end;
    end;

    local procedure CheckFixedAsset(var GenJnlLine: Record "Gen. Journal Line"; var AccName: Text[100])
    begin
        with GenJnlLine do
            if not FA.Get("Account No.") then
                AddError(
                  StrSubstNo(
                    E031Err,
                    FA.TableCaption(), "Account No."))
            else begin
                AccName := FA.Description;
                if FA.Blocked then
                    AddError(
                      StrSubstNo(
                        E032Err,
                        FA.FieldCaption(Blocked), false, FA.TableCaption(), "Account No."));
                if FA.Inactive then
                    AddError(
                      StrSubstNo(
                        E032Err,
                        FA.FieldCaption(Inactive), false, FA.TableCaption(), "Account No."));
                if FA."Budgeted Asset" then
                    AddError(
                      StrSubstNo(
                        E043Err,
                        FA.TableCaption(), "Account No.", FA.FieldCaption("Budgeted Asset"), true));
                if DeprBook.Get("Depreciation Book Code") then
                    CheckFAIntegration(GenJnlLine)
                else
                    AddError(
                      StrSubstNo(
                        E031Err,
                        DeprBook.TableCaption(), "Depreciation Book Code"));
                if not FADeprBook.Get(FA."No.", "Depreciation Book Code") then
                    AddError(
                      StrSubstNo(
                        E036Err,
                        FADeprBook.TableCaption(), FA."No.", "Depreciation Book Code"));
            end;
    end;

    procedure CheckICPartner(var GenJnlLine: Record "Gen. Journal Line"; var AccName: Text[100])
    begin
        with GenJnlLine do
            if not ICPartner.Get("Account No.") then
                AddError(
                  StrSubstNo(
                    E031Err,
                    ICPartner.TableCaption(), "Account No."))
            else begin
                AccName := ICPartner.Name;
                if ICPartner.Blocked then
                    AddError(
                      StrSubstNo(
                        E032Err,
                        ICPartner.FieldCaption(Blocked), false, ICPartner.TableCaption(), "Account No."));
            end;
    end;

    local procedure TestFixedAsset(var GenJnlLine: Record "Gen. Journal Line")
    begin
        with GenJnlLine do begin
            case true of
                "Job No." <> '':
                    AddError(StrSubstNo(E044Err, FieldCaption("Job No.")));
                "FA Posting Type" = "FA Posting Type"::" ":
                    AddError(StrSubstNo(E045Err, FieldCaption("FA Posting Type")));
                "Depreciation Book Code" = '':
                    AddError(StrSubstNo(E045Err, FieldCaption("Depreciation Book Code")));
                "Depreciation Book Code" = "Duplicate in Depreciation Book":
                    AddError(
                      StrSubstNo(
                        E046Err, FieldCaption("Depreciation Book Code"), FieldCaption("Duplicate in Depreciation Book")));
                "Account Type" = "Bal. Account Type":
                    AddError(
                      StrSubstNo(E047Err, FieldCaption("Account Type"), FieldCaption("Bal. Account Type"), "Account Type"));
            end;
            if "Account Type" = "Account Type"::"Fixed Asset" then
                if "FA Posting Type" in
                   ["FA Posting Type"::"Acquisition Cost", "FA Posting Type"::Disposal, "FA Posting Type"::Maintenance]
                then begin
                    if (("Gen. Bus. Posting Group" <> '') or ("Gen. Prod. Posting Group" <> '')) and
                       ("Gen. Posting Type" = "Gen. Posting Type"::" ")
                    then
                        AddError(StrSubstNo(E002Err, FieldCaption("Gen. Posting Type")));
                end else begin
                    AddConditionalError(
                      "Gen. Posting Type" <> "Gen. Posting Type"::" ",
                      StrSubstNo(
                        E048Err,
                        FieldCaption("Gen. Posting Type"), FieldCaption("FA Posting Type"), "FA Posting Type"));
                    AddConditionalError(
                      "Gen. Bus. Posting Group" <> '',
                      StrSubstNo(
                        E049Err,
                        FieldCaption("Gen. Bus. Posting Group"), FieldCaption("FA Posting Type"), "FA Posting Type"));
                    AddConditionalError(
                      "Gen. Prod. Posting Group" <> '',
                      StrSubstNo(
                        E049Err,
                        FieldCaption("Gen. Prod. Posting Group"), FieldCaption("FA Posting Type"), "FA Posting Type"));
                end;
            if "Bal. Account Type" = "Bal. Account Type"::"Fixed Asset" then
                if "FA Posting Type" in
                   ["FA Posting Type"::"Acquisition Cost", "FA Posting Type"::Disposal, "FA Posting Type"::Maintenance]
                then begin
                    if ("Bal. Gen. Bus. Posting Group" <> '') or ("Bal. Gen. Prod. Posting Group" <> '') then
                        if "Bal. Gen. Posting Type" = "Bal. Gen. Posting Type"::" " then
                            AddError(StrSubstNo(E002Err, FieldCaption("Bal. Gen. Posting Type")));
                end else begin
                    AddConditionalError(
                      "Bal. Gen. Posting Type" <> "Bal. Gen. Posting Type"::" ",
                      StrSubstNo(
                        E049Err,
                        FieldCaption("Bal. Gen. Posting Type"), FieldCaption("FA Posting Type"), "FA Posting Type"));
                    AddConditionalError(
                      "Bal. Gen. Bus. Posting Group" <> '',
                      StrSubstNo(
                        E049Err,
                        FieldCaption("Bal. Gen. Bus. Posting Group"), FieldCaption("FA Posting Type"), "FA Posting Type"));
                    AddConditionalError(
                      "Bal. Gen. Prod. Posting Group" <> '',
                      StrSubstNo(
                        E049Err,
                        FieldCaption("Bal. Gen. Prod. Posting Group"), FieldCaption("FA Posting Type"), "FA Posting Type"));
                end;
            TempErrorText := '%1 ' + StrSubstNo(E050Err, FieldCaption("FA Posting Type"), "FA Posting Type");
            if "FA Posting Type" <> "FA Posting Type"::"Acquisition Cost" then begin
                AddConditionalError("Depr. Acquisition Cost", StrSubstNo(TempErrorText, FieldCaption("Depr. Acquisition Cost")));
                AddConditionalError("Salvage Value" <> 0, StrSubstNo(TempErrorText, FieldCaption("Salvage Value")));
                AddConditionalError(
                  ("FA Posting Type" <> "FA Posting Type"::Maintenance) and (Quantity <> 0),
                  StrSubstNo(TempErrorText, FieldCaption(Quantity)));
                AddConditionalError("Insurance No." <> '', StrSubstNo(TempErrorText, FieldCaption("Insurance No.")));
            end;
            if ("FA Posting Type" = "FA Posting Type"::Maintenance) and "Depr. until FA Posting Date" then
                AddError(StrSubstNo(TempErrorText, FieldCaption("Depr. until FA Posting Date")));
            if ("FA Posting Type" <> "FA Posting Type"::Maintenance) and ("Maintenance Code" <> '') then
                AddError(StrSubstNo(TempErrorText, FieldCaption("Maintenance Code")));

            if ("FA Posting Type" <> "FA Posting Type"::Depreciation) and
               ("FA Posting Type" <> "FA Posting Type"::"Custom 1") and
               ("No. of Depreciation Days" <> 0)
            then
                AddError(StrSubstNo(TempErrorText, FieldCaption("No. of Depreciation Days")));

            if "FA Posting Type" = "FA Posting Type"::Disposal then begin
                AddConditionalError("FA Reclassification Entry", StrSubstNo(TempErrorText, FieldCaption("FA Reclassification Entry")));
                AddConditionalError("Budgeted FA No." <> '', StrSubstNo(TempErrorText, FieldCaption("Budgeted FA No.")));
            end;

            if "FA Posting Date" = 0D then
                "FA Posting Date" := "Posting Date";
            if DeprBook.Get("Depreciation Book Code") and
               DeprBook."Use Same FA+G/L Posting Dates" and
               ("Posting Date" <> "FA Posting Date")
            then
                AddError(StrSubstNo(E051Err, FieldCaption("Posting Date"), FieldCaption("FA Posting Date")));
            if "FA Posting Date" <> 0D then begin
                AddConditionalError("FA Posting Date" <> NormalDate("FA Posting Date"), StrSubstNo(E052Err, FieldCaption("FA Posting Date")));
                AddConditionalError(
                  not ("FA Posting Date" in [DMY2Date(1, 1, 1) .. DMY2Date(31, 12, 9998)]), StrSubstNo(E053Err, FieldCaption("FA Posting Date")));
                if (AllowFAPostingFrom = 0D) and (AllowFAPostingTo = 0D) then begin
                    if UserId <> '' then
                        if UserSetup.Get(UserId) then begin
                            AllowFAPostingFrom := UserSetup."Allow FA Posting From";
                            AllowFAPostingTo := UserSetup."Allow FA Posting To";
                        end;
                    if (AllowFAPostingFrom = 0D) and (AllowFAPostingTo = 0D) then begin
                        FASetup.Get();
                        AllowFAPostingFrom := FASetup."Allow FA Posting From";
                        AllowFAPostingTo := FASetup."Allow FA Posting To";
                    end;
                    if AllowFAPostingTo = 0D then
                        AllowFAPostingTo := DMY2Date(31, 12, 9999);
                end;
                AddConditionalError(
                  ("FA Posting Date" < AllowFAPostingFrom) or
                  ("FA Posting Date" > AllowFAPostingTo),
                  StrSubstNo(E053Err, FieldCaption("FA Posting Date")));
            end;
            FASetup.Get();
            if ("FA Posting Type" = "FA Posting Type"::"Acquisition Cost") and
               ("Insurance No." <> '') and ("Depreciation Book Code" <> FASetup."Insurance Depr. Book")
            then
                AddError(StrSubstNo(E054Err, FieldCaption("Depreciation Book Code"), "Depreciation Book Code"));

            if "FA Error Entry No." > 0 then begin
                TempErrorText := '%1 ' + StrSubstNo(E055Err, FieldCaption("FA Error Entry No."));
                AddConditionalError("Depr. until FA Posting Date", StrSubstNo(TempErrorText, FieldCaption("Depr. until FA Posting Date")));
                AddConditionalError("Depr. Acquisition Cost", StrSubstNo(TempErrorText, FieldCaption("Depr. Acquisition Cost")));
                AddConditionalError(
                  "Duplicate in Depreciation Book" <> '',
                  StrSubstNo(TempErrorText, FieldCaption("Duplicate in Depreciation Book")));
                AddConditionalError("Use Duplication List", StrSubstNo(TempErrorText, FieldCaption("Use Duplication List")));
                AddConditionalError("Salvage Value" <> 0, StrSubstNo(TempErrorText, FieldCaption("Salvage Value")));
                AddConditionalError("Insurance No." <> '', StrSubstNo(TempErrorText, FieldCaption("Insurance No.")));
                AddConditionalError("Budgeted FA No." <> '', StrSubstNo(TempErrorText, FieldCaption("Budgeted FA No.")));
                AddConditionalError("Recurring Method".AsInteger() > 0, StrSubstNo(TempErrorText, FieldCaption("Recurring Method")));
                AddConditionalError("FA Posting Type" = "FA Posting Type"::Maintenance, StrSubstNo(TempErrorText, "FA Posting Type"));
            end;
        end;
    end;

    local procedure CheckFAIntegration(var GenJnlLine: Record "Gen. Journal Line")
    var
        GLIntegration: Boolean;
    begin
        with GenJnlLine do begin
            if "FA Posting Type" = "FA Posting Type"::" " then
                exit;
            case "FA Posting Type" of
                "FA Posting Type"::"Acquisition Cost":
                    GLIntegration := DeprBook."G/L Integration - Acq. Cost";
                "FA Posting Type"::Depreciation:
                    GLIntegration := DeprBook."G/L Integration - Depreciation";
                "FA Posting Type"::"Write-Down":
                    GLIntegration := DeprBook."G/L Integration - Write-Down";
                "FA Posting Type"::Appreciation:
                    GLIntegration := DeprBook."G/L Integration - Appreciation";
                "FA Posting Type"::"Custom 1":
                    GLIntegration := DeprBook."G/L Integration - Custom 1";
                "FA Posting Type"::"Custom 2":
                    GLIntegration := DeprBook."G/L Integration - Custom 2";
                "FA Posting Type"::Disposal:
                    GLIntegration := DeprBook."G/L Integration - Disposal";
                "FA Posting Type"::Maintenance:
                    GLIntegration := DeprBook."G/L Integration - Maintenance";
            end;
            if not GLIntegration then
                AddError(
                  StrSubstNo(
                    E056Err,
                    "FA Posting Type"));

            if not DeprBook."G/L Integration - Depreciation" then begin
                if "Depr. until FA Posting Date" then
                    AddError(
                      StrSubstNo(
                        E057Err,
                        FieldCaption("Depr. until FA Posting Date")));
                if "Depr. Acquisition Cost" then
                    AddError(
                      StrSubstNo(
                        E057Err,
                        FieldCaption("Depr. Acquisition Cost")));
            end;
        end;
    end;

    local procedure TestFixedAssetFields(var GenJnlLine: Record "Gen. Journal Line")
    begin
        with GenJnlLine do begin
            if "FA Posting Type" <> "FA Posting Type"::" " then
                AddError(StrSubstNo(E058Err, FieldCaption("FA Posting Type")));
            if "Depreciation Book Code" <> '' then
                AddError(StrSubstNo(E058Err, FieldCaption("Depreciation Book Code")));
        end;
    end;

    procedure TestPostingType()
    begin
        case true of
            CustPosting and PurchPostingType:
                AddError(E059Err);
            VendPosting and SalesPostingType:
                AddError(E060Err);
        end;
    end;

    local procedure WarningIfNegativeAmt(GenJnlLine: Record "Gen. Journal Line")
    begin
        if (GenJnlLine.Amount < 0) and not AmountError then begin
            AmountError := true;
            AddError(StrSubstNo(E007Err, GenJnlLine.FieldCaption(Amount)));
        end;
    end;

    local procedure WarningIfPositiveAmt(GenJnlLine: Record "Gen. Journal Line")
    begin
        if (GenJnlLine.Amount > 0) and not AmountError then begin
            AmountError := true;
            AddError(StrSubstNo(E006Err, GenJnlLine.FieldCaption(Amount)));
        end;
    end;

    local procedure WarningIfZeroAmt(GenJnlLine: Record "Gen. Journal Line")
    begin
        if (GenJnlLine.Amount = 0) and not AmountError then begin
            AmountError := true;
            AddError(StrSubstNo(E002Err, GenJnlLine.FieldCaption(Amount)));
        end;
    end;

    local procedure WarningIfNonZeroAmt(GenJnlLine: Record "Gen. Journal Line")
    begin
        if (GenJnlLine.Amount <> 0) and not AmountError then begin
            AmountError := true;
            AddError(StrSubstNo(E062Err, GenJnlLine.FieldCaption(Amount)));
        end;
    end;

    local procedure CheckAgainstPrevLines(GenJnlLine: Record "Gen. Journal Line")
    var
        i: Integer;
        AccType: Enum "Gen. Journal Account Type";
        AccNo: Code[20];
        ErrorFound: Boolean;
    begin
        if (GenJnlLine."External Document No." = '') or
           not (GenJnlLine."Account Type" in
                [GenJnlLine."Account Type"::Customer, GenJnlLine."Account Type"::Vendor]) and
           not (GenJnlLine."Bal. Account Type" in
                [GenJnlLine."Bal. Account Type"::Customer, GenJnlLine."Bal. Account Type"::Vendor])
        then
            exit;

        if GenJnlLine."Account Type" in [GenJnlLine."Account Type"::Customer, GenJnlLine."Account Type"::Vendor] then begin
            AccType := GenJnlLine."Account Type";
            AccNo := GenJnlLine."Account No.";
        end else begin
            AccType := GenJnlLine."Bal. Account Type";
            AccNo := GenJnlLine."Bal. Account No.";
        end;

        TempGenJnlLine.Reset();
        TempGenJnlLine.SetRange("External Document No.", GenJnlLine."External Document No.");

        i := 0;
        while (i < 2) and not ErrorFound do begin
            i := i + 1;
            if i = 1 then begin
                TempGenJnlLine.SetRange("Account Type", AccType);
                TempGenJnlLine.SetRange("Account No.", AccNo);
                TempGenJnlLine.SetRange("Bal. Account Type");
                TempGenJnlLine.SetRange("Bal. Account No.");
            end else begin
                TempGenJnlLine.SetRange("Account Type");
                TempGenJnlLine.SetRange("Account No.");
                TempGenJnlLine.SetRange("Bal. Account Type", AccType);
                TempGenJnlLine.SetRange("Bal. Account No.", AccNo);
            end;
            if TempGenJnlLine.FindFirst() then begin
                ErrorFound := true;
                AddError(
                  StrSubstNo(
                    E064Err, GenJnlLine.FieldCaption("External Document No."), GenJnlLine."External Document No.",
                    TempGenJnlLine."Line No.", GenJnlLine.FieldCaption("Document No."), TempGenJnlLine."Document No."));
            end;
        end;

        TempGenJnlLine.Reset();
        TempGenJnlLine := GenJnlLine;
        TempGenJnlLine.Insert();
    end;

    procedure CheckICDocument()
    var
        GenJnlLine4: Record "Gen. Journal Line";
    begin
        with "Gen. Journal Line" do
            if GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany then begin
                if ("Posting Date" <> LastDate) or ("Document Type" <> LastDocType) or ("Document No." <> LastDocNo) then begin
                    GenJnlLine4.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                    GenJnlLine4.SetRange("Journal Template Name", "Journal Template Name");
                    GenJnlLine4.SetRange("Journal Batch Name", "Journal Batch Name");
                    GenJnlLine4.SetRange("Posting Date", "Posting Date");
                    GenJnlLine4.SetRange("Document No.", "Document No.");
                    GenJnlLine4.SetFilter("IC Partner Code", '<>%1', '');
                    if GenJnlLine4.FindFirst() then
                        CurrentICPartner := GenJnlLine4."IC Partner Code"
                    else
                        CurrentICPartner := '';
                end;
                if (CurrentICPartner <> '') and ("IC Direction" = "IC Direction"::Outgoing) then
                    if ("Account Type" in ["Account Type"::"G/L Account", "Account Type"::"Bank Account"]) and
                       ("Bal. Account Type" in ["Bal. Account Type"::"G/L Account", "Account Type"::"Bank Account"]) and
                       ("Account No." <> '') and
                       ("Bal. Account No." <> '')
                    then
                        AddError(
                          StrSubstNo(
                            E066Err, FieldCaption("Account No."), FieldCaption("Bal. Account No.")))
                    else
                        if (("Account Type" in ["Account Type"::"G/L Account", "Account Type"::"Bank Account"]) and ("Account No." <> '')) xor
                           (("Bal. Account Type" in ["Bal. Account Type"::"G/L Account", "Account Type"::"Bank Account"]) and
                            ("Bal. Account No." <> ''))
                        then
                            CheckICAccountNo();
            end;
    end;

    local procedure CheckICAccountNo()
    var
        ICGLAccount: Record "IC G/L Account";
        ICBankAccount: Record "IC Bank Account";
    begin
#if not CLEAN22
        with "Gen. Journal Line" do
            if "IC Partner G/L Acc. No." = '' then
                AddError(StrSubstNo(E002Err, FieldCaption("IC Partner G/L Acc. No.")))
            else begin
                if ICGLAccount.Get("IC Partner G/L Acc. No.") then
                    if ICGLAccount.Blocked then
                        AddError(StrSubstNo(E032Err, ICGLAccount.FieldCaption(Blocked), false,
                            FieldCaption("IC Partner G/L Acc. No."), "IC Partner G/L Acc. No."))
                    else
                        if "IC Partner G/L Acc. No." <> '' then
                            AddError(StrSubstNo(E009Err, FieldCaption("IC Partner G/L Acc. No.")))
                        else
                            if "IC Partner G/L Acc. No." <> '' then begin
                                if "IC Direction" = "IC Direction"::Incoming then
                                    AddError(StrSubstNo(E069Err, FieldCaption("IC Partner G/L Acc. No."),
                                        FieldCaption("IC Direction"), Format("IC Direction")));
                                if CurrentICPartner = '' then
                                    AddError(StrSubstNo(E070Err, FieldCaption("IC Partner G/L Acc. No.")));
                            end;

                if "IC Account Type" = "IC Journal Account Type"::"Bank Account" then
                    if ICBankAccount.Get("IC Account No.") then
                        if ICBankAccount.Blocked then
                            AddError(StrSubstNo(E032Err, ICBankAccount.FieldCaption(Blocked), false,
                                FieldCaption("IC Account No."), "IC Account No."))
                        else begin
                            if "IC Direction" = "IC Direction"::Incoming then
                                AddError(StrSubstNo(E069Err, FieldCaption("IC Account No."),
                                    FieldCaption("IC Direction"), Format("IC Direction")));
                            if CurrentICPartner = '' then
                                AddError(StrSubstNo(E070Err, FieldCaption("IC Account No.")));
                        end;
            end;
#else
        with "Gen. Journal Line" do
            if "IC Account No." = '' then
                AddError(StrSubstNo(E002Err, FieldCaption("IC Account No.")))
            else begin
                if "IC Account Type" = "IC Journal Account Type"::"G/L Account" then
                    if ICGLAccount.Get("IC Account No.") then
                        if ICGLAccount.Blocked then
                            AddError(StrSubstNo(E032Err, ICGLAccount.FieldCaption(Blocked), false,
                                FieldCaption("IC Account No."), "IC Account No."))
                        else
                            if "IC Account No." <> '' then
                                AddError(StrSubstNo(E009Err, FieldCaption("IC Account No.")))
                            else begin
                                if "IC Direction" = "IC Direction"::Incoming then
                                    AddError(StrSubstNo(E069Err, FieldCaption("IC Account No."),
                                        FieldCaption("IC Direction"), Format("IC Direction")));
                                if CurrentICPartner = '' then
                                    AddError(StrSubstNo(E070Err, FieldCaption("IC Account No.")));
                            end;
                if "IC Account Type" = "IC Journal Account Type"::"Bank Account" then
                    if ICBankAccount.Get("IC Account No.") then
                        if ICBankAccount.Blocked then
                            AddError(StrSubstNo(E032Err, ICBankAccount.FieldCaption(Blocked), false,
                                FieldCaption("IC Account No."), "IC Account No."))
                        else
                            if "IC Account No." <> '' then
                                AddError(StrSubstNo(E009Err, FieldCaption("IC Account No.")))
                            else begin
                                if "IC Direction" = "IC Direction"::Incoming then
                                    AddError(StrSubstNo(E069Err, FieldCaption("IC Account No."),
                                        FieldCaption("IC Direction"), Format("IC Direction")));
                                if CurrentICPartner = '' then
                                    AddError(StrSubstNo(E070Err, FieldCaption("IC Account No.")));
                            end;
            end;
#endif
    end;

    local procedure CalcAppliesToIDTotals()
    begin
        if "Gen. Journal Line"."Applies-to ID" = '' then
            exit;

        case "Gen. Journal Line"."Account Type" of
            "Gen. Journal Line"."Account Type"::Customer:
                begin
                    TotalCustAmount[Sign::Negative] := CalcCustRemainingAmount(false);
                    TotalCustAmount[Sign::Positive] := CalcCustRemainingAmount(true);
                end;
            "Gen. Journal Line"."Account Type"::Vendor:
                begin
                    TotalVendAmount[Sign::Negative] := CalcVendRemainingAmount(false);
                    TotalVendAmount[Sign::Positive] := CalcVendRemainingAmount(true);
                end;
        end;
    end;

    local procedure CalcCustRemainingAmount(PositiveFilter: Boolean) TotalAmount: Decimal
    begin
        with OldCustLedgEntry do begin
            SetRange("Customer No.", "Gen. Journal Line"."Account No.");
            SetRange("Applies-to ID", "Gen. Journal Line"."Applies-to ID");
            SetRange(Positive, PositiveFilter);
            SetAutoCalcFields("Remaining Amount");
            if FindSet() then
                repeat
                    TotalAmount += "Remaining Amount";
                until Next() = 0;
        end;
    end;

    local procedure CalcVendRemainingAmount(PositiveFilter: Boolean) TotalAmount: Decimal
    begin
        with OldVendLedgEntry do begin
            SetRange("Vendor No.", "Gen. Journal Line"."Account No.");
            SetRange("Applies-to ID", "Gen. Journal Line"."Applies-to ID");
            SetRange(Positive, PositiveFilter);
            SetAutoCalcFields("Remaining Amount");
            if FindSet() then
                repeat
                    TotalAmount += "Remaining Amount";
                until Next() = 0;
        end;
    end;

    local procedure InitPmtDisc(NewAmtPmtTolerance: Decimal; NewAmtDue: Decimal)
    begin
        AmountDiscounted := 0;
        AmountPmtDiscTolerance := 0;
        AmountPmtTolerance := NewAmtPmtTolerance;
        AmountDue := NewAmtDue;
    end;

    local procedure CalcPmtDisc(Positive: Boolean; RemPmtDiscPossible: Decimal; IsPostingDateBeforePmtDate: Boolean; AcceptedPmtTolerance: Boolean; TotalAmount: array[2] of Decimal)
    var
        OppositeSignAmount: Decimal;
    begin
        if RemPmtDiscPossible = 0 then
            exit;

        if Positive then
            OppositeSignAmount := TotalAmount[Sign::Negative]
        else
            OppositeSignAmount := TotalAmount[Sign::Positive];
        if (IsPostingDateBeforePmtDate or AcceptedPmtTolerance) and
           (Abs(AmountPaid + AmountPmtTolerance - RemPmtDiscPossible) >= Abs(AmountDue - OppositeSignAmount))
        then
            if IsPostingDateBeforePmtDate then
                AmountDiscounted := -RemPmtDiscPossible
            else
                AmountPmtDiscTolerance := -RemPmtDiscPossible;
    end;

    local procedure CheckAccountType(var GenJournalLine: Record "Gen. Journal Line"; AccName1: Text[100]; AccName2: Text[100])
    begin
        with GenJournalLine do
            case "Account Type" of
                "Account Type"::"G/L Account":
                    CheckGLAcc("Gen. Journal Line", AccName1);
                "Account Type"::Customer:
                    CheckCust("Gen. Journal Line", AccName1);
                "Account Type"::Vendor:
                    CheckVend("Gen. Journal Line", AccName1);
                "Account Type"::"Bank Account":
                    CheckBankAcc("Gen. Journal Line", AccName1);
                "Account Type"::"Fixed Asset":
                    CheckFixedAsset("Gen. Journal Line", AccName1);
                "Account Type"::"IC Partner":
                    CheckICPartner("Gen. Journal Line", AccName2);
            end;
    end;

    local procedure CheckOldCustomer()
    begin
        with OldCustLedgEntry do begin
            Reset();
            SetCurrentKey("Document No.", "Document Type");
            SetRange("Document Type", "Gen. Journal Line"."Applies-to Doc. Type");
            SetRange("Document No.", "Gen. Journal Line"."Applies-to Doc. No.");
            SetRange("Customer No.", "Gen. Journal Line"."Account No.");
            if FindFirst() then begin
                CalcFields("Remaining Amount");
                "Gen. Journal Line"."Due Date" := "Due Date";
                "Gen. Journal Line".Description := Description;
                AmountDue := -"Remaining Amount";
                AmountPmtTolerance := -"Accepted Payment Tolerance";
                if ("Remaining Pmt. Disc. Possible" <> 0) and
                   (("Pmt. Discount Date" >= "Gen. Journal Line"."Posting Date") or "Accepted Pmt. Disc. Tolerance") and
                   (AmountPaid - AmountPmtTolerance - "Remaining Pmt. Disc. Possible" >= AmountDue)
                then
                    if "Pmt. Discount Date" >= "Gen. Journal Line"."Posting Date" then
                        AmountDiscounted := -"Remaining Pmt. Disc. Possible"
                    else
                        AmountPmtDiscTolerance := -"Remaining Pmt. Disc. Possible";
                AmountPaid := AmountPaid + AmountPmtTolerance + AmountDiscounted + AmountPmtDiscTolerance;
                TotalAmountDiscounted := TotalAmountDiscounted + AmountDiscounted;
                TotalAmountPmtTolerance := TotalAmountPmtTolerance + AmountPmtTolerance;
                TotalAmountPmtDiscTolerance := TotalAmountPmtDiscTolerance + AmountPmtDiscTolerance;
                AmountApplied := AmountApplied - AmountPaid;
            end else
                ShowApplyToOutput := false;
        end;
    end;

    local procedure CheckOldVendor()
    begin
        with OldVendLedgEntry do begin
            Reset();
            SetCurrentKey("Document No.", "Document Type");
            SetRange("Document Type", "Gen. Journal Line"."Applies-to Doc. Type");
            SetRange("Document No.", "Gen. Journal Line"."Applies-to Doc. No.");
            SetRange("Vendor No.", "Gen. Journal Line"."Account No.");
            if FindFirst() then begin
                CalcFields("Remaining Amount");
                "Gen. Journal Line"."Due Date" := "Due Date";
                "Gen. Journal Line".Description := Description;
                AmountDue := -"Remaining Amount";
                AmountPaid := "Gen. Journal Line".Amount;
                AmountPmtTolerance := -"Accepted Payment Tolerance";
                if ("Remaining Pmt. Disc. Possible" <> 0) and
                   (("Pmt. Discount Date" >= "Gen. Journal Line"."Posting Date") or "Accepted Pmt. Disc. Tolerance") and
                   (AmountPaid - AmountPmtTolerance - "Remaining Pmt. Disc. Possible" >= AmountDue)
                then
                    if "Pmt. Discount Date" >= "Gen. Journal Line"."Posting Date" then
                        AmountDiscounted := -"Remaining Pmt. Disc. Possible"
                    else
                        AmountPmtDiscTolerance := -"Remaining Pmt. Disc. Possible";
                AmountPaid := AmountPaid + AmountPmtTolerance + AmountDiscounted + AmountPmtDiscTolerance;
                TotalAmountDiscounted := TotalAmountDiscounted + AmountDiscounted;
                TotalAmountPmtTolerance := TotalAmountPmtTolerance + AmountPmtTolerance;
                TotalAmountPmtDiscTolerance := TotalAmountPmtDiscTolerance + AmountPmtDiscTolerance;
                AmountApplied := AmountApplied - AmountPaid;
            end else
                ShowApplyToOutput := false;
        end;
    end;

    local procedure CheckGenJnlLineErrors(var GenJournalLine: Record "Gen. Journal Line")
    var
        PaymentTerms: Record "Payment Terms";
        DimMgt: Codeunit DimensionManagement;
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        with GenJournalLine do begin
            if ("Account No." = '') and ("Bal. Account No." = '') then
                AddError(StrSubstNo(E001Err, FieldCaption("Account No."), FieldCaption("Bal. Account No.")))
            else
                if ("Account Type" <> "Account Type"::"Fixed Asset") and
                   ("Bal. Account Type" <> "Bal. Account Type"::"Fixed Asset")
                then
                    TestFixedAssetFields("Gen. Journal Line");
            CheckICDocument();
            if "Account No." <> '' then
                CheckAccount(GenJournalLine);

            if "Bal. Account No." <> '' then
                CheckBalAccount(GenJournalLine);

            if ("Account No." <> '') and
               not "System-Created Entry" and
               ("Gen. Posting Type" = "Gen. Posting Type"::" ") and
               (Amount = 0) and
               not GenJnlTemplate.Recurring and
               not "Allow Zero-Amount Posting" and
               ("Account Type" <> "Account Type"::"Fixed Asset")
            then
                WarningIfZeroAmt("Gen. Journal Line");

            CheckRecurringLine("Gen. Journal Line");
            CheckAllocations("Gen. Journal Line");

            if "Posting Date" = 0D then
                AddError(StrSubstNo(E002Err, FieldCaption("Posting Date")))
            else
                CheckNonZeroPostingDate(GenJournalLine);

            if "Document Date" <> 0D then
                if ("Document Date" <> NormalDate("Document Date")) and
                   (("Account Type" <> "Account Type"::"G/L Account") or
                    ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account"))
                then
                    AddError(
                      StrSubstNo(
                        E013Err, FieldCaption("Document Date")));

            if "Document No." = '' then begin
                AddError(StrSubstNo(E002Err, FieldCaption("Document No.")));
                Error(E002Err, FieldCaption("Document No."));
            end;
            if "Gen. Journal Batch"."No. Series" <> '' then begin
                if (LastEntrdDocNo <> '') and
                   ("Document No." <> LastEntrdDocNo) and
                   ("Document No." <> IncStr(LastEntrdDocNo))
                then
                    AddError(E016Err);
                LastEntrdDocNo := "Document No.";
            end;

            if ("Account Type" in ["Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"Fixed Asset"]) and
               ("Bal. Account Type" in ["Bal. Account Type"::Customer, "Bal. Account Type"::Vendor, "Bal. Account Type"::"Fixed Asset"])
            then
                AddError(
                  StrSubstNo(
                    E017Err,
                    FieldCaption("Account Type"), FieldCaption("Bal. Account Type")));

            if Amount * "Amount (LCY)" < 0 then
                AddError(
                  StrSubstNo(
                    E008Err, FieldCaption("Amount (LCY)"), FieldCaption(Amount)));

            if ("Account Type" = "Account Type"::"G/L Account") and
               ("Bal. Account Type" = "Bal. Account Type"::"G/L Account")
            then
                if "Applies-to Doc. No." <> '' then
                    AddError(StrSubstNo(E009Err, FieldCaption("Applies-to Doc. No.")));

            if (("Account Type" = "Account Type"::"G/L Account") and
                ("Bal. Account Type" = "Bal. Account Type"::"G/L Account")) or
               ("Document Type" <> "Document Type"::Invoice)
            then
                if PaymentTerms.Get("Payment Terms Code") then
                    if ("Document Type" = "Document Type"::"Credit Memo") and
                       (not PaymentTerms."Calc. Pmt. Disc. on Cr. Memos")
                    then begin
                        AddConditionalError("Pmt. Discount Date" <> 0D, StrSubstNo(E009Err, FieldCaption("Pmt. Discount Date")));
                        AddConditionalError("Payment Discount %" <> 0, StrSubstNo(E018Err, FieldCaption("Payment Discount %")));
                    end else begin
                        AddConditionalError("Pmt. Discount Date" <> 0D, StrSubstNo(E009Err, FieldCaption("Pmt. Discount Date")));
                        AddConditionalError("Payment Discount %" <> 0, StrSubstNo(E018Err, FieldCaption("Payment Discount %")));
                    end;

            if (("Account Type" = "Account Type"::"G/L Account") and
                ("Bal. Account Type" = "Bal. Account Type"::"G/L Account")) or
               ("Applies-to Doc. No." <> '')
            then
                AddConditionalError("Applies-to ID" <> '', StrSubstNo(E009Err, FieldCaption("Applies-to ID")));

            if ("Account Type" <> "Account Type"::"Bank Account") and
               ("Bal. Account Type" <> "Bal. Account Type"::"Bank Account")
            then
                AddConditionalError(
                    GenJnlLine2."Bank Payment Type" <> GenJnlLine2."Bank Payment Type"::" ", StrSubstNo(E009Err, FieldCaption("Bank Payment Type")));

            if ("Account No." <> '') and ("Bal. Account No." <> '') then begin
                PurchPostingType := false;
                SalesPostingType := false;
            end;
            if "Account No." <> '' then
                CheckAccountType("Gen. Journal Line", AccName, AccName);
            if "Bal. Account No." <> '' then begin
                CODEUNIT.Run(CODEUNIT::"Exchange Acc. G/L Journal Line", "Gen. Journal Line");
                CheckAccountType("Gen. Journal Line", BalAccName, AccName);
                CODEUNIT.Run(CODEUNIT::"Exchange Acc. G/L Journal Line", "Gen. Journal Line");
            end;

            AddConditionalError(not DimMgt.CheckDimIDComb("Dimension Set ID"), DimMgt.GetDimCombErr());

            TableID[1] := DimMgt.TypeToTableID1("Account Type".AsInteger());
            No[1] := "Account No.";
            TableID[2] := DimMgt.TypeToTableID1("Bal. Account Type".AsInteger());
            No[2] := "Bal. Account No.";
            TableID[3] := DATABASE::Job;
            No[3] := "Job No.";
            TableID[4] := DATABASE::"Salesperson/Purchaser";
            No[4] := "Salespers./Purch. Code";
            TableID[5] := DATABASE::Campaign;
            No[5] := "Campaign No.";
            AddConditionalError(not DimMgt.CheckDimValuePosting(TableID, No, "Dimension Set ID"), DimMgt.GetDimValuePostingErr());
        end;
    end;

    local procedure CheckBalAccount(var GenJournalLine: Record "Gen. Journal Line")
    begin
        with GenJournalLine do
            case "Bal. Account Type" of
                "Bal. Account Type"::"G/L Account":
                    begin
                        if ("Bal. Gen. Bus. Posting Group" <> '') or ("Bal. Gen. Prod. Posting Group" <> '') or
                           ("Bal. VAT Bus. Posting Group" <> '') or ("Bal. VAT Prod. Posting Group" <> '')
                        then
                            if "Bal. Gen. Posting Type" = "Bal. Gen. Posting Type"::" " then
                                AddError(StrSubstNo(E002Err, FieldCaption("Bal. Gen. Posting Type")));
                        if ("Bal. Gen. Posting Type" <> "Bal. Gen. Posting Type"::" ") and
                           ("VAT Posting" = "VAT Posting"::"Automatic VAT Entry")
                        then begin
                            if "Bal. VAT Amount" + "Bal. VAT Base Amount" <> -Amount then
                                AddError(
                                  StrSubstNo(
                                    E011Err, FieldCaption("Bal. VAT Amount"), FieldCaption("Bal. VAT Base Amount"),
                                    FieldCaption(Amount)));
                            if "Currency Code" <> '' then
                                if "Bal. VAT Amount (LCY)" + "Bal. VAT Base Amount (LCY)" <> -"Amount (LCY)" then
                                    AddError(
                                      StrSubstNo(
                                        E011Err, FieldCaption("Bal. VAT Amount (LCY)"),
                                        FieldCaption("Bal. VAT Base Amount (LCY)"), FieldCaption("Amount (LCY)")));
                        end;
                    end;
                "Bal. Account Type"::Customer, "Bal. Account Type"::Vendor:
                    begin
                        if "Bal. Gen. Posting Type" <> "Bal. Gen. Posting Type"::" " then
                            AddError(
                              StrSubstNo(
                                E004Err,
                                FieldCaption("Bal. Gen. Posting Type"), FieldCaption("Bal. Account Type"), "Bal. Account Type"));

                        if ("Bal. Gen. Bus. Posting Group" <> '') or ("Bal. Gen. Prod. Posting Group" <> '') or
                           ("Bal. VAT Bus. Posting Group" <> '') or ("Bal. VAT Prod. Posting Group" <> '')
                        then
                            AddError(
                              StrSubstNo(
                                E005Err,
                                FieldCaption("Bal. Gen. Bus. Posting Group"), FieldCaption("Bal. Gen. Prod. Posting Group"),
                                FieldCaption("Bal. VAT Bus. Posting Group"), FieldCaption("Bal. VAT Prod. Posting Group"),
                                FieldCaption("Bal. Account Type"), "Bal. Account Type"));

                        if "Document Type" <> "Document Type"::" " then
                            if ("Bal. Account Type" = "Bal. Account Type"::Customer) =
                               ("Document Type" in ["Document Type"::Payment, "Document Type"::"Credit Memo"])
                            then
                                WarningIfNegativeAmt("Gen. Journal Line")
                            else
                                WarningIfPositiveAmt("Gen. Journal Line");
                        if Amount * "Sales/Purch. (LCY)" > 0 then
                            AddError(
                              StrSubstNo(
                                E012Err,
                                FieldCaption("Sales/Purch. (LCY)"), FieldCaption(Amount)));
                        if "Job No." <> '' then
                            AddError(StrSubstNo(E009Err, FieldCaption("Job No.")));
                    end;
                "Bal. Account Type"::"Bank Account":
                    begin
                        if "Bal. Gen. Posting Type" <> "Bal. Gen. Posting Type"::" " then
                            AddError(
                              StrSubstNo(
                                E004Err,
                                FieldCaption("Bal. Gen. Posting Type"), FieldCaption("Bal. Account Type"), "Bal. Account Type"));

                        if ("Bal. Gen. Bus. Posting Group" <> '') or ("Bal. Gen. Prod. Posting Group" <> '') or
                           ("Bal. VAT Bus. Posting Group" <> '') or ("Bal. VAT Prod. Posting Group" <> '')
                        then
                            AddError(
                              StrSubstNo(
                                E005Err,
                                FieldCaption("Bal. Gen. Bus. Posting Group"), FieldCaption("Bal. Gen. Prod. Posting Group"),
                                FieldCaption("Bal. VAT Bus. Posting Group"), FieldCaption("Bal. VAT Prod. Posting Group"),
                                FieldCaption("Bal. Account Type"), "Bal. Account Type"));

                        AddConditionalError("Job No." <> '', StrSubstNo(E009Err, FieldCaption("Job No.")));
                    end;
                "Bal. Account Type"::"Fixed Asset":
                    TestFixedAsset("Gen. Journal Line");
            end;
    end;

    local procedure CheckAccount(var GenJournalLine: Record "Gen. Journal Line")
    begin
        with GenJournalLine do
            case "Account Type" of
                "Account Type"::"G/L Account":
                    begin
                        if ("Gen. Bus. Posting Group" <> '') or ("Gen. Prod. Posting Group" <> '') or
                           ("VAT Bus. Posting Group" <> '') or ("VAT Prod. Posting Group" <> '')
                        then
                            AddConditionalError(
                                "Gen. Posting Type" = "Gen. Posting Type"::" ", StrSubstNo(E002Err, FieldCaption("Gen. Posting Type")));

                        if ("Gen. Posting Type" <> "Gen. Posting Type"::" ") and
                           ("VAT Posting" = "VAT Posting"::"Automatic VAT Entry")
                        then begin
                            AddConditionalError(
                              "VAT Amount" + "VAT Base Amount" <> Amount,
                              StrSubstNo(
                                E003Err, FieldCaption("VAT Amount"), FieldCaption("VAT Base Amount"),
                                FieldCaption(Amount)));
                            AddConditionalError(("Currency Code" <> '') and
                              ("VAT Amount (LCY)" + "VAT Base Amount (LCY)" <> "Amount (LCY)"),
                              StrSubstNo(
                                E003Err, FieldCaption("VAT Amount (LCY)"),
                                FieldCaption("VAT Base Amount (LCY)"), FieldCaption("Amount (LCY)")));
                        end;
                    end;
                "Account Type"::Customer, "Account Type"::Vendor:
                    begin
                        AddConditionalError("Gen. Posting Type" <> "Gen. Posting Type"::" ",
                          StrSubstNo(
                            E004Err,
                            FieldCaption("Gen. Posting Type"), FieldCaption("Account Type"), "Account Type"));

                        if ("Gen. Bus. Posting Group" <> '') or ("Gen. Prod. Posting Group" <> '') or
                           ("VAT Bus. Posting Group" <> '') or ("VAT Prod. Posting Group" <> '')
                        then
                            AddError(
                              StrSubstNo(
                                E005Err,
                                FieldCaption("Gen. Bus. Posting Group"), FieldCaption("Gen. Prod. Posting Group"),
                                FieldCaption("VAT Bus. Posting Group"), FieldCaption("VAT Prod. Posting Group"),
                                FieldCaption("Account Type"), "Account Type"));

                        if "Document Type" <> "Document Type"::" " then
                            if "Account Type" = "Account Type"::Customer then
                                case "Document Type" of
                                    "Document Type"::"Credit Memo":
                                        WarningIfPositiveAmt("Gen. Journal Line");
                                    "Document Type"::Payment:
                                        if ("Applies-to Doc. Type" = "Applies-to Doc. Type"::"Credit Memo") and
                                           ("Applies-to Doc. No." <> '')
                                        then
                                            WarningIfNegativeAmt("Gen. Journal Line")
                                        else
                                            WarningIfPositiveAmt("Gen. Journal Line");
                                    "Document Type"::Refund:
                                        WarningIfNegativeAmt("Gen. Journal Line");
                                    else
                                        WarningIfNegativeAmt("Gen. Journal Line");
                                end
                            else
                                case "Document Type" of
                                    "Document Type"::"Credit Memo":
                                        WarningIfNegativeAmt("Gen. Journal Line");
                                    "Document Type"::Payment:
                                        if ("Applies-to Doc. Type" = "Applies-to Doc. Type"::"Credit Memo") and
                                           ("Applies-to Doc. No." <> '')
                                        then
                                            WarningIfPositiveAmt("Gen. Journal Line")
                                        else
                                            WarningIfNegativeAmt("Gen. Journal Line");
                                    "Document Type"::Refund:
                                        WarningIfPositiveAmt("Gen. Journal Line");
                                    else
                                        WarningIfPositiveAmt("Gen. Journal Line");
                                end;

                        if Amount * "Sales/Purch. (LCY)" < 0 then
                            AddError(
                              StrSubstNo(
                                E008Err,
                                FieldCaption("Sales/Purch. (LCY)"), FieldCaption(Amount)));
                        if "Job No." <> '' then
                            AddError(StrSubstNo(E009Err, FieldCaption("Job No.")));
                    end;
                "Account Type"::"Bank Account":
                    begin
                        if "Gen. Posting Type" <> "Gen. Posting Type"::" " then
                            AddError(
                              StrSubstNo(
                                E004Err,
                                FieldCaption("Gen. Posting Type"), FieldCaption("Account Type"), "Account Type"));

                        if ("Gen. Bus. Posting Group" <> '') or ("Gen. Prod. Posting Group" <> '') or
                           ("VAT Bus. Posting Group" <> '') or ("VAT Prod. Posting Group" <> '')
                        then
                            AddError(
                              StrSubstNo(
                                E005Err,
                                FieldCaption("Gen. Bus. Posting Group"), FieldCaption("Gen. Prod. Posting Group"),
                                FieldCaption("VAT Bus. Posting Group"), FieldCaption("VAT Prod. Posting Group"),
                                FieldCaption("Account Type"), "Account Type"));

                        if "Job No." <> '' then
                            AddError(StrSubstNo(E009Err, FieldCaption("Job No.")));
                    end;
                "Account Type"::"Fixed Asset":
                    TestFixedAsset("Gen. Journal Line");
            end;
    end;

    local procedure CheckNonZeroPostingDate(var GenJournalLine: Record "Gen. Journal Line")
    var
        UserSetupManagement: Codeunit "User Setup Management";
    begin
        with GenJournalLine do begin
            if "Posting Date" <> NormalDate("Posting Date") then
                if ("Account Type" <> "Account Type"::"G/L Account") or
                   ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account")
                then
                    AddError(
                      StrSubstNo(
                        E013Err, FieldCaption("Posting Date")));

            if not UserSetupManagement.TestAllowedPostingDate("Posting Date", TempErrorText) then
                AddError(TempErrorText);

            if "Gen. Journal Batch"."No. Series" <> '' then begin
                if NoSeries."Date Order" and ("Posting Date" < LastEntrdDate) then
                    AddError(E015Err);
                LastEntrdDate := "Posting Date";
            end;
        end;
    end;

    local procedure CheckIfExistProcessedCustVendLedgerEntryApplicationGroup(var GenJournalLine: Record "Gen. Journal Line"): Boolean
    begin
        if (GenJournalLine."Document No." = '') or (GenJournalLine."Account No." = '') or (GenJournalLine."Applies-to ID" = '') then
            exit(false);

        TempGenJnlLineForProcessedCustVendLedgerEntryApplicationGroups.Reset();
        TempGenJnlLineForProcessedCustVendLedgerEntryApplicationGroups.SetRange("Document No.", GenJournalLine."Document No.");
        TempGenJnlLineForProcessedCustVendLedgerEntryApplicationGroups.SetRange("Account Type", GenJournalLine."Account Type");
        TempGenJnlLineForProcessedCustVendLedgerEntryApplicationGroups.SetRange("Account No.", GenJournalLine."Account No.");
        TempGenJnlLineForProcessedCustVendLedgerEntryApplicationGroups.SetRange("Applies-to ID", GenJournalLine."Applies-to ID");
        exit(not TempGenJnlLineForProcessedCustVendLedgerEntryApplicationGroups.IsEmpty());
    end;

    local procedure AddProcessedCustVendLedgerEntryApplicationGroup(var GenJournalLine: Record "Gen. Journal Line")
    begin
        if (GenJournalLine."Document No." = '') or (GenJournalLine."Account No." = '') or (GenJournalLine."Applies-to ID" = '') then
            exit;

        Clear(TempGenJnlLineForProcessedCustVendLedgerEntryApplicationGroups);
        TempGenJnlLineForProcessedCustVendLedgerEntryApplicationGroups.Init();
        TempGenJnlLineForProcessedCustVendLedgerEntryApplicationGroups := GenJournalLine;
        if TempGenJnlLineForProcessedCustVendLedgerEntryApplicationGroups.Insert() then;
    end;

    local procedure ClearProcessedCustVendLedgerEntryApplicationGroups()
    begin
        TempGenJnlLineForProcessedCustVendLedgerEntryApplicationGroups.DeleteAll();
    end;
}

