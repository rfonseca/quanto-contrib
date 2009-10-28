configuration TestIntegerSetAppC {
}
implementation {
	components MainC, TestIntegerSetC;
	TestIntegerSetC -> MainC.Boot;

   components LedsC;
   TestIntegerSetC.Leds -> LedsC;

}



