#include <Timer.h>
#include <UserButton.h>

/* Test App 1 for carrying activity labels across task invocations
 * Tests the SingleActivityResource module and the scheduler module.
 * Two tasks are attributed different contexts A and B, and 
 * alternate rescheduling themselves.
 * The context of a task is preserved and propagated to any task that
 * it posts. 
 */

module TestSingleActivityResourceC
{
  uses interface Leds;
  uses interface Boot;
  uses interface Random;
  uses interface SingleActivityResource as CPUResource;
  uses interface QuantoLog;
  uses interface Notify<button_state_t> as UserButtonNotify;
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

  void initState() {
    remaining = N;
  }

  task void taskA(); 
  task void taskB();

  void start() {
    act_t old_ctx = call CPUResource.get();
    call QuantoLog.record();
    call CPUResource.set(mk_act_local(QUANTO_ACTIVITY(A)));
    if (remaining--)
        post taskA();
    call CPUResource.set(mk_act_local(QUANTO_ACTIVITY(B)));
    if (remaining--)
        post taskB();
    call CPUResource.set(old_ctx);
  }

  event void Boot.booted()
  {
    call UserButtonNotify.enable();
  }

  event void UserButtonNotify.notify(button_state_t buttonState) {
    if (buttonState == BUTTON_PRESSED) {
        call Leds.led1Toggle();
        initState();
        call CPUResource.set(mk_act_local(QUANTO_ACTIVITY(MAIN)));
        start();
    }
  }

  //do some variable amount of blocking work
  void doWork() {
    uint32_t i;
    uint32_t lim;
    int a = 0;
    act_t c = call CPUResource.get();
    if (c == mk_act_local(QUANTO_ACTIVITY(A))) 
        call Leds.led0Toggle();
    else if (c == mk_act_local(QUANTO_ACTIVITY(B)))
        call Leds.led2Toggle();
    //lim = 50000;
    lim = call Random.rand32() % 100000u;
    for (i = 0; i < lim; i++) 
        a++;
  }

  void done() {
     call CPUResource.set(mk_act_local(QUANTO_ACTIVITY(MAIN)));
     call QuantoLog.flush();
  }

  event void QuantoLog.full() {
  }

  task void taskA() {
    doWork();
    if (remaining) {
        post taskA();
        if (! (--remaining))
            done();
    }
  }

  task void taskB() {
    doWork();
    if (remaining) {
        post taskB();
        if (! (--remaining))
            done();
    }
  }
}

