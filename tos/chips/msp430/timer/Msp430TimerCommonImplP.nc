
module Msp430TimerCommonImplP
{
  provides interface Msp430TimerEvent as VectorTimerA0;
  provides interface Msp430TimerEvent as VectorTimerA1;
  provides interface Msp430TimerEvent as VectorTimerB0;
  provides interface Msp430TimerEvent as VectorTimerB1;
  uses interface SingleActivityResource as CPUResource;
}
implementation
{
  TOSH_SIGNAL(TIMERA0_VECTOR) 
  { 
    act_t act = call CPUResource.enterInterrupt(QUANTO_ACTIVITY(PXY_TIMERA0)); 
    signal VectorTimerA0.fired(); 
    call CPUResource.exitInterrupt(act);
  }
  TOSH_SIGNAL(TIMERA1_VECTOR) 
  { 
#ifndef NO_TIMER_A1_ACT_CTX
    act_t act = call CPUResource.enterInterrupt(QUANTO_ACTIVITY(PXY_TIMERA1)); 
#endif
    signal VectorTimerA1.fired(); 
#ifndef NO_TIMER_A1_ACT_CTX
    call CPUResource.exitInterrupt(act);
#endif
  }
  TOSH_SIGNAL(TIMERB0_VECTOR)
  { 
    act_t act = call CPUResource.enterInterrupt(QUANTO_ACTIVITY(PXY_TIMERB0)); 
    signal VectorTimerB0.fired(); 
    call CPUResource.exitInterrupt(act);
  }
  TOSH_SIGNAL(TIMERB1_VECTOR)
  { 
    act_t act = call CPUResource.enterInterrupt(QUANTO_ACTIVITY(PXY_TIMERB1)); 
    signal VectorTimerB1.fired(); 
    call CPUResource.exitInterrupt(act);
  }
}

