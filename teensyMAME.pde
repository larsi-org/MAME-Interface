#define REPEATRATE 100 // milliseconds

const byte pin_P1_UP     =  0;
const byte pin_P1_DOWN   =  1;
const byte pin_P1_LEFT   =  2;
const byte pin_P1_RIGHT  =  3;

const byte pin_P1_B1     =  4;
const byte pin_P1_B2     =  5;
const byte pin_P1_B3     =  6;
const byte pin_P1_B4     =  7;
const byte pin_P1_B5     = 12;
const byte pin_P1_B6     = 13;

const byte pin_P1_START  = 14;
const byte pin_P1_COIN   = 15;
const byte pin_PAUSE     = 16;
const byte pin_SELECT    = 17;
const byte pin_CANCEL    = 18;
const byte pin_CONFIG    = 19;

const byte pin_LEDOutput = 11;

//Variables for the states of the MAME buttons
byte buttons[] = {
  pin_P1_UP, pin_P1_DOWN, pin_P1_LEFT, pin_P1_RIGHT,
  pin_P1_B1, pin_P1_B2, pin_P1_B3, pin_P1_B4, pin_P1_B5, pin_P1_B6,
  pin_P1_START, pin_P1_COIN, pin_PAUSE, pin_SELECT, pin_CANCEL, pin_CONFIG
};

byte keys[] = {
  KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT,
  KEY_A, KEY_S, KEY_D, KEY_Z, KEY_X, KEY_C,
  KEY_1, KEY_5, KEY_P, KEY_ENTER, KEY_ESC, KEY_TAB
};

#define NUMBUTTONS sizeof(buttons)

void setup()
{
  //Setup the pin modes.
  pinMode( pin_LEDOutput, OUTPUT );

  //Special for the Teensy is the INPUT_PULLUP
  //It enables a pullup resitor on the pin.
  for (byte i = 0; i < NUMBUTTONS; i++) {
    pinMode(buttons[i], INPUT_PULLUP);
  }
}

void loop()
{
  // //debugging the start button...
  digitalWrite ( pin_LEDOutput, digitalRead(pin_P1_START));

  //Progess the MAME controller buttons to send keystrokes.
  fcnProcessButtons();
}

//Function to process the buttons from the SNES controller
void fcnProcessButtons()
{
  static long currentkey = 0;
  byte nothingpressed = 1;

  // run through all the buttons
  for (byte i = 0; i < NUMBUTTONS; i++) {

    // are any of them pressed?
    if (! digitalRead(buttons[i])) {
      nothingpressed = 0; // at least one button is pressed!

      // if its a new button, release the old one, and press the new one
      if (currentkey != keys[i]) {
        Keyboard.set_key1(0);
        Keyboard.send_now();
        Keyboard.set_key1(keys[i]);
        currentkey = keys[i];
        Keyboard.send_now();
      } 
      else {
        // the same button is pressed, so repeat!
        Keyboard.set_key1(keys[i]);
        Keyboard.send_now();
        delay(REPEATRATE);
      }
    }
  }

  if (nothingpressed) {
    // release all keys
    Keyboard.set_key1(0);
    Keyboard.send_now();
  }
}

