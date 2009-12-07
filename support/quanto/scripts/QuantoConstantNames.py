from QuantoLogConstants import QuantoLogConstants
from QuantoCoreConstants import QuantoCoreConstants
from QuantoCC2420Constants import QuantoCC2420Constants
from QuantoAppConstants import QuantoAppConstants

class QuantoLogConstantsNamed:
  typeName = {
    QuantoLogConstants.MSG_TYPE_SINGLE_CHG  : 'single_chg',
    QuantoLogConstants.MSG_TYPE_MULTI_CHG  : 'multi_chg',
    QuantoLogConstants.MSG_TYPE_COUNT_EV  : 'count_ev',
    QuantoLogConstants.MSG_TYPE_POWER_CHG  : 'power_chg',
    QuantoLogConstants.MSG_TYPE_FLUSH_REPORT : 'flush_report'
  }
  subtypeName = {
    QuantoLogConstants.MSG_TYPE_SINGLE_CHG  : {
      QuantoLogConstants.SINGLE_CHG_NORMAL  : 'normal',
      QuantoLogConstants.SINGLE_CHG_ENTER_INT  : 'enter_int',
      QuantoLogConstants.SINGLE_CHG_EXIT_INT  : 'exit_int',
      QuantoLogConstants.SINGLE_CHG_BIND  : 'bind',
    } ,
    QuantoLogConstants.MSG_TYPE_MULTI_CHG  : {
      QuantoLogConstants.MULTI_CHG_ADD  : 'add',
      QuantoLogConstants.MULTI_CHG_REM  : 'remove',
      QuantoLogConstants.MULTI_CHG_IDL  : 'idle',
    } ,
    QuantoLogConstants.MSG_TYPE_COUNT_EV  : {
      0 : '-',
    } ,
    QuantoLogConstants.MSG_TYPE_POWER_CHG  : {
      0 : '-',
    } ,
    QuantoLogConstants.MSG_TYPE_FLUSH_REPORT  : {
      0 : '-',
    } ,
  }


