PImage map;
String [] mapData, hold;
StringList chains;
float [][] points;
boolean [] checks;
color [] colors;

float phi0 = 0;
float lambda0 = radians(-69);
float phi1 = radians(47.5f);
float phi2 = radians(43f);
float minX, maxX, minY, maxY, position;

void setup(){
  size(375,600);
  map = loadImage("maine.png");
  phi0 = 0;
  lambda0 = radians(-69);
  phi1 = radians(43f);
  phi2 = radians(47.5f);
  
  minX = calcX(47.467424, -71.25);
  minY = calcY(47.467424, -71.25);
  maxX = calcX(43.066681, -66.963355);
  maxY = calcY(43.066681, -66.963355);
  
  setupArrays();
  checks = new boolean[chains.size()];
  for (int i = 0; i < checks.length; i++)
    checks[i] = false;
  setupColors();
}

void setupArrays(){
  int count = -1;
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
  position = width/chains.size();
}

void setupColors(){
  int r, g, b;
  colors = new color[chains.size()];
  for (int i = 0; i < colors.length; i++){
    r = int(random(255));
    g = int(random(255));
    b = int(random(255));
    colors[i] = color(r,g,b);
  }
}

void draw(){
  background(175);
  fill(0);
  noStroke();
  textAlign(CENTER, CENTER);
  
  drawNames();
  image(map,0,0);
  allPoints();
}

void drawNames(){
  for (int i = 0; i < chains.size(); i++){
    if (checks[i] == true){
      fill(colors[i]);
      rect(i*position, height-40, position, 40);
      fill(0);
    }
    text(chains.get(i), i*position, height-30, position, 20);
  }
}

void allPoints(){
  for (int i = 0; i < points.length; i++){
    if(checks[int(points[i][2])] == true){
      fill(colors[int(points[i][2])]);
      drawPoint(points[i][0], points[i][1]);
    }
  }
}

void drawPoint(float x, float y){
  float lat, lon;
  lat = map(x, minX, maxX, 0, width);
  lon = map(y, minY, maxY, 0, height-50);
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

void mousePressed(){
  for (int i = 0; i < chains.size(); i++){
    if (mouseX > i*position && mouseX < (i+.9)*position &&  mouseY > height-50)
      checks[i] = !checks[i];
  }
}


// Source: https://www.google.com/fusiontables/DataSource?docid=1HDRk5AjNoPCShwERz_bjyKVGDapFmQil4hl9eMM
// Source: https://www.google.com/fusiontables/DataSource?docid=1mJ7YnPH8QkRb0u8cTV0eMjnLjFdUQMNm50F-nYB9#rows:id=1
// Other Ideas: Subway, Wendy's, KFC, Arby's, Taco Bell
