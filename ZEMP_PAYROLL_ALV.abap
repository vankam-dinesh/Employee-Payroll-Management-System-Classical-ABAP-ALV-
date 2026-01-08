
REPORT zemp_payroll_alv.

TYPE-POOLS: slis.

TYPES: BEGIN OF ty_payroll,
         empid   TYPE i,
         ename   TYPE string,
         dept    TYPE string,
         basic   TYPE p DECIMALS 2,
         hra     TYPE p DECIMALS 2,
         da      TYPE p DECIMALS 2,
         tax     TYPE p DECIMALS 2,
         netpay  TYPE p DECIMALS 2,
       END OF ty_payroll.

DATA: it_payroll TYPE STANDARD TABLE OF ty_payroll,
      wa_payroll TYPE ty_payroll,
      it_fieldcat TYPE slis_t_fieldcat_alv,
      wa_fieldcat TYPE slis_fieldcat_alv.

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM calculate_salary.
  PERFORM display_alv.

FORM get_data.
  wa_payroll-empid = 1001.
  wa_payroll-ename = 'RAVI'.
  wa_payroll-dept  = 'IT'.
  wa_payroll-basic = 30000.
  APPEND wa_payroll TO it_payroll.

  wa_payroll-empid = 1002.
  wa_payroll-ename = 'SITA'.
  wa_payroll-dept  = 'HR'.
  wa_payroll-basic = 28000.
  APPEND wa_payroll TO it_payroll.
ENDFORM.

FORM calculate_salary.
  LOOP AT it_payroll INTO wa_payroll.
    wa_payroll-hra = wa_payroll-basic * 0.20.
    wa_payroll-da  = wa_payroll-basic * 0.10.
    wa_payroll-tax = wa_payroll-basic * 0.05.
    wa_payroll-netpay = wa_payroll-basic + wa_payroll-hra + wa_payroll-da - wa_payroll-tax.
    MODIFY it_payroll FROM wa_payroll.
  ENDLOOP.
ENDFORM.

FORM display_alv.
  PERFORM fieldcat USING 'EMPID' 'Employee ID'.
  PERFORM fieldcat USING 'ENAME' 'Employee Name'.
  PERFORM fieldcat USING 'DEPT' 'Department'.
  PERFORM fieldcat USING 'BASIC' 'Basic Salary'.
  PERFORM fieldcat USING 'HRA' 'HRA'.
  PERFORM fieldcat USING 'DA' 'DA'.
  PERFORM fieldcat USING 'TAX' 'Tax'.
  PERFORM fieldcat USING 'NETPAY' 'Net Pay'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      it_fieldcat = it_fieldcat
    TABLES
      t_outtab = it_payroll.
ENDFORM.

FORM fieldcat USING p_field p_text.
  CLEAR wa_fieldcat.
  wa_fieldcat-fieldname = p_field.
  wa_fieldcat-seltext_m = p_text.
  APPEND wa_fieldcat TO it_fieldcat.
ENDFORM.
