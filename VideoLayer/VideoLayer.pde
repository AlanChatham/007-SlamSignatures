/**
 * Modified version of Frames 
 * by Andres Colubri. 
 * 
 * Moves through the video one frame at the time by using the
 * arrow keys. It estimates the frame counts using the framerate
 * of the movie file, so it might not be exact in some cases.
 */
 
import processing.video.*;

Movie mov;
int currentFrame = 0;
int movFrameRate = 30;
PImage[] frameBuffer;
int bufferSize = 10;
boolean isPlaying = true;

int movieWidth = 640;
int movieHeight = 480;

void setup() {
  // Set up a frame buffer and put some blank images in there.
  frameBuffer = new PImage[bufferSize];
  for (int i = 0; i < bufferSize; i++){
    frameBuffer[i] = createImage(movieHeight, movieWidth, RGB);
  }
  size(movieWidth, movieHeight);
  background(0);
  // Load and set the video to play. Setting the video 
  // in play mode is needed so at least one frame is read
  // and we can get duration, size and other information from
  // the video stream. 
  mov = new Movie(this, "Langston Hughes.avi");
  
  // Pausing the video at the first frame. 
  mov.play();
  mov.jump(0);
  if (!isPlaying){
    mov.pause();
  }
}

void movieEvent(Movie m) {
  m.read();
  if (isPlaying){
    currentFrame++;
  }
  // Load the movie image into the appropriate place
  frameBuffer[currentFrame % bufferSize].copy(mov, 0,0, mov.width, mov.height,
                                                    0,0, movieWidth, movieHeight);
}

void draw() {
  //background(0);
  //fill(255);
  
  // Clear the background
  background(0);
  // Draw and blend the entire frame buffer to the screen                                             
  int counter = 0;
  while((counter <= currentFrame) && (counter < bufferSize)){
    blend(frameBuffer[counter], 0, 0, movieWidth, movieHeight,
                                0, 0, movieWidth, movieHeight, LIGHTEST);
    counter++;
  }
  text(currentFrame + " / " + (getLength() - 1), 10, 30);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      if (0 < currentFrame){
        currentFrame--;
      } 
    }
    else if (keyCode == RIGHT) {
      if (currentFrame < getLength() - 1) currentFrame++;
    }
  } 
  setFrame(currentFrame);  
}
  
int getFrame() {    
  return ceil(mov.time() * movFrameRate) - 1;
}

void setFrame(int n) {
  mov.play();
    
  // The duration of a single frame:
  float frameDuration = 1.0 / movFrameRate;
    
  // We move to the middle of the frame by adding 0.5:
  float where = (n + 0.5) * frameDuration; 
    
  // Taking into account border effects:
  float diff = mov.duration() - where;
  if (diff < 0) {
    where += diff - 0.25 * frameDuration;
  }
   
  mov.jump(where);
  mov.pause();  
  isPlaying = false;
}  

int getLength() {
  return int(mov.duration() * movFrameRate);
}  

