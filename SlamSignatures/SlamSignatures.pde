/**
 * Modified version of Frames 
 * by Andres Colubri. 
 * 
 * Moves through the video one frame at the time by using the
 * arrow keys. It estimates the frame counts using the framerate
 * of the movie file, so it might not be exact in some cases.
 */
 
import processing.video.*;

int outputWidth = 1280 * 3;
int outputHeight = 720;
int videoFrameWidth = 160;//320;
int videoFrameHeight = 120;//240;

int videoInputWidth = 320;//960;
int videoInputHeight = 240;//720;

// We're doing a digital zoom from the camera,
//  so these offsets move around the area 
//  we're sampling from
int frameOffsetX = 0;//130;
int frameOffsetY = 0;//210;
int frameUnit = 50; // How much we move each time

int threshold = 20;

int imageColumns = 75;
int topOffset = videoFrameHeight / 4;
int bottomOffset = videoFrameHeight / 4;
int imageRows = 8;
int numberOfImages = imageColumns * imageRows;
int columnOffset = (outputWidth - videoFrameWidth) / (imageColumns - 1);
int rowOffset = ((outputHeight + topOffset + bottomOffset) - videoFrameHeight) / (imageRows - 1);

int circleX = 2234;
int circleY = 376;
int circleRadius = 500;

Capture video;
PGraphics videoMask;
PImage videoFrame;
PImage outputImage;

void setup() {
  size(outputWidth, outputHeight);
  frameRate(30);
  videoFrame = createImage(videoFrameWidth, videoFrameHeight, ARGB);
  outputImage = createImage(outputWidth, outputHeight, ARGB);
  videoMask = createGraphics(videoFrameWidth, videoFrameHeight);
  videoMask.beginDraw();
  videoMask.background(0);
  videoMask.noStroke();
  videoMask.fill(255);
  videoMask.ellipse(videoFrameWidth/2, videoFrameHeight/2, videoFrameWidth, videoFrameHeight);
  videoMask.endDraw();
  
  // Set up the camera or exit the program
  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } 
  else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    // The camera can be initialized directly using an element
    // from the array returned by list():
    //video = new Capture(this, videoFrameWidth, videoFrameHeight);
    // Or, the settings can be defined based on the text in the list
    //cam = new Capture(this, 640, 480, "Built-in iSight", 30);
    video = new Capture(this, videoInputWidth, videoInputHeight);
    // Start capturing the images from the camera
    video.start();
  }
}

int frameCounter = 0;
int previousMillis = 0;

void draw() {
  // Only update on new camera data
  if (video.available() == true) {
    // If we've filled up our image, reset things
    if (frameCounter % numberOfImages == 0){
      frameCounter = 0;
      //background(0);
      outputImage = createImage(outputWidth,outputHeight, ARGB);
    }
    
    video.read();
    videoFrame.copy(video, frameOffsetX, frameOffsetY, 
                    frameOffsetX +  videoInputWidth, frameOffsetY +  videoInputHeight,
                    0,0, videoFrameWidth, videoFrameHeight);
    //videoFrame.loadPixels();
   // videoFrame.copy(video, 0, 0, 360, 240, 0, 0, 360, 240);
    videoFrame.loadPixels();
    int numPixels = videoFrame.width * videoFrame.height;
    color black = color(0);
    int pixelRedBrightness = 0;
    /*for (int i = 0; i < numPixels; i++) {
      pixelRedBrightness = videoFrame.pixels[i] >> 16 & 0xFF;
      if (pixelRedBrightness < threshold) { // If the pixel is brighter than the
        videoFrame.pixels[i] = black; // threshold value, make it white
      } 
    }*/
    videoFrame.updatePixels();
    videoFrame.mask(videoMask);
    
    int column = frameCounter % imageColumns;
    int row = frameCounter / imageColumns;
    int frameX = column * columnOffset;
    int frameY = row * rowOffset - topOffset;
    
    outputImage.blend(videoFrame, 0, 0, videoFrameWidth, videoFrameHeight,
                 frameX, frameY, videoFrameWidth, videoFrameHeight, LIGHTEST);
  
    frameCounter++;  
    
    background(0);
    image(outputImage, 0, 0);
    noStroke();
    fill(0);
    //smooth(8);
    //if (frameX)
    ellipse(circleX, circleY, circleRadius, circleRadius);
    println(millis() - previousMillis);
    previousMillis = millis();
  }
}

void mousePressed() {
  
  circleX = mouseX; 
  circleY = mouseY;
  print("circleX: ");
  println(circleX);
  print("circleY :");
  println(circleY); 
}

void keyPressed() {
  if (key == CODED){
    if (keyCode == LEFT)
      frameOffsetX -= frameUnit;
    if (keyCode == RIGHT)
      frameOffsetX += frameUnit;
    if (keyCode == UP)
      frameOffsetY -= frameUnit;
    if (keyCode == DOWN)
      frameOffsetY += frameUnit;
  }
  print("X: ");
  println(frameOffsetX);
  print("Y: ");
  println(frameOffsetY);
}

