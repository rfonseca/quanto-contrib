#include <Timer.h>
#include <UserButton.h>

/* Test App 1 for Resource across task invocations
 * Tests the Resource module and the CtxBasicSchedulerP module
 * Two tasks are attributed different contexts A and B, and 
 * alternate rescheduling themselves.
 * The context of a task is preserved and propagated to any task that
 * it posts. 
 */

module TestQuantoTimerC
{
  uses interface Leds;
  uses interface Boot;
  uses interface Random;
  uses interface QuantoLog;
  uses interface Notify<button_state_t> as UserButtonNotify;
  uses interface Timer<TMilli> as TimerA;   
  uses interface Timer<TMilli> as TimerB;   

  uses interface SingleActivityResource as CPUResource;
  uses interface MultiActivityResource as LED0Resource;
  uses interface MultiActivityResource as LED2Resource;
}
implementation
{
  enum {
    QUANTO_ACTIVITY(MAIN) = NEW_QUANTO_ACTIVITY_ID,
    QUANTO_ACTIVITY(A) = NEW_QUANTO_ACTIVITY_ID,
    QUANTO_ACTIVITY(B) = NEW_QUANTO_ACTIVITY_ID,
  };

  enum {
    N = 20,
  };


  uint8_t remaining = N;
  uint8_t outstanding = 0;

  void initState() {
    remaining = N;
    outstanding = 0;
  }

  inline void scheduleA() {
      call TimerA.startOneShot( call Random.rand16() % 512 );
      outstanding++;
      remaining--;
  }

  inline void scheduleB() {
      call TimerB.startOneShot( call Random.rand16() % 512 );
      outstanding++;
      remaining--;
  }


  void start() {
    act_t old_act = call CPUResource.get();
    call QuantoLog.record();
    call CPUResource.set(mk_act_local(QUANTO_ACTIVITY(A)));
    if (remaining) 
        scheduleA();
    call CPUResource.set(mk_act_local(QUANTO_ACTIVITY(B)));
    if (remaining)
        scheduleB();
    call CPUResource.set(old_act);
  }

  event void Boot.booted()
  {
    call UserButtonNotify.enable();
  }

  event void UserButtonNotify.notify(button_state_t buttonState) {
    if (buttonState == BUTTON_PRESSED) {
        initState();
        call CPUResource.set(mk_act_local(QUANTO_ACTIVITY(MAIN)));
        start();
    }
  }
  
  void done() {
     call CPUResource.set(mk_act_local(QUANTO_ACTIVITY(MAIN)));
     call QuantoLog.flush();
  }

  //play with LED0
  event void TimerA.fired() {
    bool ledOn = (call Leds.get() & LEDS_LED0);     
    outstanding--;
    if (!ledOn) {
        call Leds.led0On();
        call LED0Resource.add(call CPUResource.get());
    } else {
        call Leds.led0Off();
        call LED0Resource.remove(call CPUResource.get());
    }
    if (remaining)
        scheduleA();
    else if (!outstanding) 
        done();
  }

  //play with Led2
  event void TimerB.fired() {
    bool ledOn = (call Leds.get() & LEDS_LED2);     
    outstanding--;
    if (!ledOn) {
        call Leds.led2On();
        call LED2Resource.add(call CPUResource.get());
    } else {
        call Leds.led2Off();
        call LED2Resource.remove(call CPUResource.get());
    }
    if (remaining)
        scheduleB();
    else if (!outstanding) 
        done();
  }
}

