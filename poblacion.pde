
//Escala respecto al tamaño "original"
int escala=1;

//Radio del circulo para marcar (a escala)
float radio_base=1.15;

//Tamaño de la imagen
int imgSizeX=770;
int imgSizeY=540;
  
//Coordenadas de los límites del mapa - mex_equirec.png
/*
String mapname = "mex_equirec.png";
float lng_max=-86.54;
float lng_min=-117.271;
float lat_max=34.6586;
float lat_min=13.064;
*/


//Coordenadas de límites de mapa - mex-*.png
String mapname = "mex-gray.png";
float lng_max=-86.3;
float lng_min=-118.5;
float lat_max=33.3;
float lat_min=14.2;

PImage mx;

void setup(){
  mx = loadImage(mapname);
  colorMode(HSB,60,100,100,12);
  size(imgSizeX*escala,imgSizeY*escala);
  background(0);
  noStroke();
  smooth();
  image(mx,0,0,imgSizeX*escala,imgSizeY*escala);
  
  PFont f = loadFont("Calibri-48.vlw");
  textFont(f,9*escala);
   
  plotGeodots("localidades.csv");
  
  legendLine(20,60,2);
  
  save("densidad_"+nf(escala,1)+"x.png");
}

void legendLine(int mini, int maxi, int esc)
{
  int s = 10;
  
  for(int i=mini;i<=maxi;i++) //Hay problemas de precisión con float  http://forum.processing.org/topic/how-to-maintain-precision
  {
    strokeWeight(3*escala);
    stroke(maxi-i,100,100);
    //Horiz line((10+esc*i)*escala,500*escala,int(10+esc*(i+1))*escala,500*escala);
    line(s*escala,(350+esc*i)*escala,s*escala,(350+esc*(i+1))*escala);
    if( i%10 == 0 )
    {
      fill(maxi-i,100,100);
      
      strokeWeight(1*escala);
      line (s*escala,(350+esc*i)*escala,2*s*escala,(350+esc*i)*escala);
      
      text(nf(int(pow(10,i/10)),1),(2*s+5)*escala,(350+esc*i+3)*escala);
    }
  }
}

void plotGeodots(String dataset)
{
  String[] data = loadStrings(dataset);
  for(int i=0; i<data.length; i++)
  {
     String[] values = split(data[i],',');
     Point2D pos = pointAt(float(values[0]), float(values[1]));

      float col=10*(6-float(values[2])); //heatmap
      fill(col,100,100,float(values[2]));
     //RGB:fill(255,200,0,7*float(values[2]));

     float rad = radio_base*float(values[2])*escala;

     //ellipse(pos.x,pos.y,rad,rad); 
     degradedEllipse(pos.x,pos.y,rad,col,float(values[2]));
  }
}

void degradedEllipse(float x, float y, float rad, float hueVal, float maxTransp) 
{
  float transpStep = maxTransp/rad;
  for(float i=rad;i>0;i-=1)
  {
    fill(hueVal,100,100,maxTransp-i*transpStep);
    ellipse(x,y,i,i);
  }
}

Point2D pointAt(float lat, float lng)
{
  Point2D pos = new Point2D();
  if(lng>0) lng=-lng; //Si viene en long oeste
  
  pos.x = int( (lng_min-lng)*escala*imgSizeX/(lng_min-lng_max) );
  pos.y = int( (lat_max-lat)*escala*imgSizeY/(lat_max-lat_min) );
  
  return pos;
}

class Point2D {
  float x, y;
  
  Point2D(){}
  
  Point2D(float x, float y) {
    this.x = x; this.y = y;
  }
}


