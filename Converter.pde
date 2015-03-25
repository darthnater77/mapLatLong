  
class Converter{  
  PrintWriter output;
  String[] lines, split;
  float x, y;

  float phi0 = 0;
  float lambda0 = radians(-96);
  float phi1 = radians(29.5f);
  float phi2 = radians(45.5f);

  Converter(String infile, String outfile){
    lines = loadStrings(infile);
    output = createWriter(outfile);
  }

  void run(){
    for(int i = 0; i < lines.length; i++){
      split = split(lines[i], "\t");
      x = float(split[0]);
      y = float(split[1]);
      output.println(split[2]+"  "+calcX(x, y)+"  "+calcY(x, y)+"  ");
    }
    output.close();
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
}
