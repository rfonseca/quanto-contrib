COMPONENT=BlinkAppC

#CFLAGS += -DNO_TIMER_A1_ACT_CTX
CFLAGS += -DCOUNT_LOG

XML        = app.xml
DUMPTYPES = '-fnesc-dump=constants(name(QUANTO_.*_ACTIVITY_ID) | name(QUANTO_.*_RESOURCE_ID))'

CFLAGS += $(DUMPTYPES) -fnesc-dumpfile=$(XML)

include $(MAKERULES)


