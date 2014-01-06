import processing.video.*;
Capture cam;

int brightnessThreshold = 105;

PFont f;
String message = "I've got ZAID in my hands";
// An array of Letter objects
Letter[] letters;
int prevNumFrames = 0;
int numFrames = 0;

void setup() {
  size(640, 480);
  // Load the font
  f = createFont("Arial",20,true);
  textFont(f);
  frameRate(80);
    
  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[0]);
    cam.start();     

  }

  // Create the array the same size as the String
  letters = new Letter[message.length()];
  // Initialize Letters at the correct x location
  int charSpacing = 640 / message.length();
  for (int i = 0; i < message.length(); i++) {
    letters[i] = new Letter(charSpacing * i, 10, message.charAt(i)); 
  }
  for (int i = 0; i < letters.length; i++) {
    // Display all letters
    letters[i].display();
  }  
}

void draw() {
    if (numFrames - prevNumFrames == 3200) {
    // Create the array the same size as the String
    message = "Afnan is so cool, it's not even funny.";
    letters = new Letter[message.length()];
    // Initialize Letters at the correct x location
    int charSpacing = 640 / message.length();
    for (int i = 0; i < message.length(); i++) {
      letters[i] = new Letter(charSpacing * i, 10, message.charAt(i)); 
    }
    for (int i = 0; i < letters.length; i++) {
      // Display all letters
      letters[i].display();
    } 
    numFrames++;
    prevNumFrames += 3200;
  }
  else {
    numFrames++; 
  }
  if (cam.available() == true) {
    cam.read();
  }
    
  cam.filter(GRAY);
  image(cam, 0, 0);
  
  cam.loadPixels(); 
    
  for (int i = 0; i < letters.length; i++) {
    float pixLoc = letters[i].x + 640 * letters[i].y;
    int intPixLoc = (int) pixLoc;
        
    if (intPixLoc < 307200 && cam.pixels.length > 0) {

      //Since all pixels are either black or white, we can assume a red
      //value of 0 means the pixel is black.  
      
      float r0 = red   (cam.pixels[intPixLoc]);
      float b0 = blue   (cam.pixels[intPixLoc]);
      float g0 = green   (cam.pixels[intPixLoc]);       

      float r1 = red   (cam.pixels[intPixLoc + 640]);
      float b1 = blue   (cam.pixels[intPixLoc + 640]);
      float g1 = green   (cam.pixels[intPixLoc + 640]);       

      float r2 = red   (cam.pixels[intPixLoc + 1280]);
      float b2 = blue   (cam.pixels[intPixLoc + 1280]);
      float g2 = green   (cam.pixels[intPixLoc + 1280]);       
  
      float luminescence0 = (0.2126*r0) + (0.7152*g0) + (0.0722*b0);
      float luminescence1 = (0.2126*r1) + (0.7152*g1) + (0.0722*b1);
      float luminescence2 = (0.2126*r2) + (0.7152*g2) + (0.0722*b2);
      
      if (luminescence0 < brightnessThreshold) {
        if (luminescence2 < brightnessThreshold) {
          letters[i].rise(1);
        }
        if (luminescence2 < brightnessThreshold) {
          letters[i].rise(2);
        }
        letters[i].rise(1);
        letters[i].display();                
      } else {
        letters[i].fall(1);
        letters[i].display();
      }  
    }    

  }
}

// A class to describe a single Letter
class Letter {
  char letter;
  // The object knows its original "home" location
  float homex,homey;
  // As well as its current location
  float x,y;

  Letter (float x_, float y_, char letter_) {
    x = x_;
    y = y_;
    letter = letter_; 
  }

  // Display the letter
  void display() {
    fill(0);
    text(letter,x,y);
  }

  // Move the letter down randomly
  void fall(float increment) {
    if (y < 475) {
      y += increment;    
    } else {
      y -= 3;
    }
  }

  // Move the letter down randomly
  void rise(float decrement) {
    if (y > 12) {
      y -= decrement;
    }
  }

}
