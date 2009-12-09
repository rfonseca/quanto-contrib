ifeq ($(findstring Darwin, $(shell uname)), Darwin)
  export GCC=gcc-4.0
  CFLAGS += -D_FORTIFY_SOURCE=0
  MIGFLAGS += -D_FORTIFY_SOURCE=0
endif

FILES=QuantoLogEntry.py QuantoLogConstants.py QuantoCoreConstants.py \
      QuantoCC2420Constants.py QuantoLogMsgV.py \
      QuantoCTimeConstants.py QuantoCTimeMsg.py
all: $(FILES)
clean:
	rm $(FILES) *.pyc
QuantoLogEntry.py: $(QUANTO_ROOT)/tos/lib/quanto/QuantoLog/RawUartMsg.h 
	which $(GCC)
	mig $(MIGFLAGS) -o $@ -python-classname=QuantoLogEntry python \
              $(QUANTO_ROOT)/tos/lib/quanto/QuantoLog/RawUartMsg.h \
              nx_entry_t

QuantoLogMsgV.py: $(QUANTO_ROOT)/tos/lib/quanto/QuantoLog/QuantoLogStagedMyUART.h \
                  $(QUANTO_ROOT)/tos/lib/quanto/QuantoLog/RawUartMsg.h 
	mig $(MIGFLAGS) -o $@ -python-classname=QuantoLogMsgV python \
              $(QUANTO_ROOT)/tos/lib/quanto/QuantoLog/QuantoLogStagedMyUART.h \
              quanto_vlog_msg_t


QuantoLogConstants.py: $(QUANTO_ROOT)/tos/lib/quanto/QuantoLog/RawUartMsg.h 
	nescc-ncg $(CFLAGS) -o $@ -python-classname=QuantoLogConstants python \
              $(QUANTO_ROOT)/tos/lib/quanto/QuantoLog/RawUartMsg.h \
                MSG_TYPE_OFFSET \
                MSG_TYPE_SINGLE_CHG \
                MSG_TYPE_MULTI_CHG \
                MSG_TYPE_COUNT_EV \
                MSG_TYPE_POWER_CHG \
                MSG_TYPE_FLUSH_REPORT \
                SINGLE_CHG_NORMAL \
                SINGLE_CHG_ENTER_INT \
                SINGLE_CHG_EXIT_INT \
                SINGLE_CHG_BIND \
                MULTI_CHG_ADD \
                MULTI_CHG_REM \
                MULTI_CHG_IDL \
                TYPE_SINGLE_CHG_NORMAL \
                TYPE_SINGLE_CHG_ENTER_INT \
                TYPE_SINGLE_CHG_EXIT_INT \
                TYPE_SINGLE_CHG_BIND \
                TYPE_MULTI_CHG_ADD \
                TYPE_MULTI_CHG_REM \
                TYPE_MULTI_CHG_IDL \
                TYPE_POWER_CHG \
                TYPE_COUNT_EV \
                TYPE_FLUSH_REPORT

QuantoCTimeConstants.py: $(QUANTO_ROOT)/tos/lib/quanto/QuantoLog/QuantoLogCumulative.h
	nescc-ncg $(CFLAGS) -o $@ -python-classname=QuantoCTimeConstants python \
             $(QUANTO_ROOT)/tos/lib/quanto/QuantoLog/QuantoLogCumulative.h \
                MSG_TYPE_CTIME \
                CTIME_HEADER \
                CTIME_BODY \
                TYPE_CTIME_HEADER \
                TYPE_CTIME_BODY

QuantoCTimeMsg.py: $(QUANTO_ROOT)/tos/lib/quanto/QuantoLog/QuantoLogCumulative.h
	mig $(MIGFLAGS) -I$(QUANTO_ROOT)/tos/lib/quanto -DMIG -o $@ -python-classname=QuantoCTimeMsg python \
             $(QUANTO_ROOT)/tos/lib/quanto/QuantoLog/QuantoLogCumulative.h \
             ctime_msg_t

QuantoCoreConstants.py: $(QUANTO_ROOT)/tos/lib/quanto/activity.h
	nescc-ncg $(CFLAGS) -DMIG -o $@ -python-classname=QuantoCoreConstants \
              python $(QUANTO_ROOT)/tos/lib/quanto/activity.h \
                ACT_INVALID \
                ACT_NODE_MASK \
                ACT_NODE_OFF \
                ACT_NODE_INVALID \
                ACT_TYPE_MASK \
                ACT_TYPE_OFF 

QuantoCC2420Constants.py: $(QUANTO_ROOT)/tos/chips/cc2420/CC2420Quanto.h
	nescc-ncg $(CFLAGS) -DMIG -I%T -I$(QUANTO_ROOT)/tos/lib/quanto -o $@ -python-classname=QuantoCC2420Constants \
              python $(QUANTO_ROOT)/tos/chips/cc2420/CC2420Quanto.h \
                CC2420_PW_STOPPED \
                CC2420_PW_STARTING \
                CC2420_PW_LISTEN \
                CC2420_PW_RX \
                CC2420_PW_TX \
                CC2420_PW_STOPPING \
                CC2420_PW_RXFIFO \
                CC2420_PW_TXFIFO \
                CC2420_POWERSTATE_MASK \
                CC2420_POWERSTATE_OFF \
                CC2420_POWERLEVEL_MASK \
                CC2420_POWERLEVEL_OFF

