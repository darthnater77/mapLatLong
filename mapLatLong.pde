Converter data;
String [] mapData, hold;
StringList chains;
float [][] points;

float phi0 = 0;
float lambda0 = radians(-96);
float phi1 = radians(29.5f);
float phi2 = radians(45.5f);
int current;
float minX, maxX, minY, maxY;

void setup(){
  size(450,600);
  current = 0;
  phi0 = 0;
  lambda0 = radians(-69);
  phi1 = radians(43f);
  phi2 = radians(47.5f);
  
  minX = calcX(48, -72);
  minY = calcY(48, -72);
  maxX = calcX(43.5, -66);
  maxY = calcY(43.5, -66);
  
  setupArrays();
}

void setupArrays(){
  int count = 0;
  chains =  new StringList();
  mapData = loadStrings("LatLong.tsv");
  points = new float[mapData.length][3];
  for (int i = 0; i < mapData.length; i++){
    hold = split(mapData[i], "\t");
    if (!chains.hasValue(trim(hold[2]))){
      chains.append(trim(hold[2]));
      count++;
    }
    points[i][0] = calcX(float(hold[0]), float(hold[1]));
    points[i][1] = calcY(float(hold[0]), float(hold[1]));
    points[i][2] = count;
  }
}

void draw(){
  background(175);
  fill(0);
  stroke(0);
  textAlign(CENTER, CENTER);
  
  drawNames();
  allPoints();
}

void drawNames(){
  float position = width/chains.size();
  for (int i = 0; i < chains.size(); i++){
    if (mouseX > i*position && mouseX < (i+.9)*position &&  mouseY > height-50)
      current = i+1;
    if (current == i+1)
      fill(0,0,255);
    else
      fill(0);
    text(chains.get(i), i*position, height-30, position, 20);
  }
  if (mouseY< height-50)
    current = 0;
}

void allPoints(){
  boolean check = false;
  if (current == 0){
    check = true;
    stroke(255,0,0);
  }
  for (int i = 0; i < points.length; i++){
    if(check == false){
      if (points[i][2] == current)
        stroke(0,0,255);
      else
        stroke(0,255,0);
    }
    drawPoint(points[i][0], points[i][1]);
  }
}

void drawPoint(float x, float y){
  float lat, lon;
  lat = map(x, minX, maxX, 0, width);
  lon = map(y, minY, maxY, 0, height);
  ellipse(lat, lon, 5, 5);
}

float calcX(float lat, float lon){
  float phi = radians(lat);
  float lambda = radians(lon);
    
  float n = 0.5f * (sin(phi1) + sin(phi2));
  float theta = n * (lambda - lambda0);
  float c = sq(cos(phi1)) + 2*n*sin(phi1);
  float rho = sqrt(c - 2*n*sin(phi))/n;
  float rho0 = sqrt(c - 2*n*sin(phi0))/n;
    
  float x = rho * sin(theta);
  return x;
}

float calcY(float lat, float lon){
  float phi = radians(lat);
  float lambda = radians(lon);
  
  float n = 0.5f * (sin(phi1) + sin(phi2));
  float theta = n * (lambda - lambda0);
  float c = sq(cos(phi1)) + 2*n*sin(phi1);
  float rho = sqrt(c - 2*n*sin(phi))/n;
  float rho0 = sqrt(c - 2*n*sin(phi0))/n;

  float y = rho0 - rho*cos(theta);  
  return y;
}


// Source; https://www.google.com/fusiontables/DataSource?docid=1HDRk5AjNoPCShwERz_bjyKVGDapFmQil4hl9eMM
// Source: https://www.google.com/fusiontables/DataSource?docid=1mJ7YnPH8QkRb0u8cTV0eMjnLjFdUQMNm50F-nYB9#rows:id=1
