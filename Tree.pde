import java.util.Random;



Random random =  new Random();
class Tree {
  PImage img=loadImage("coral1.jpg");
PImage img2=loadImage("coral2.jpg");
PImage img3=loadImage("coral3.jpg");
PImage img4=loadImage("coral4.jpg");
PImage img5=loadImage("coral5.jpg");
PImage  img6=loadImage("coral6.jpg");


PImage[] reef_textures= {img2, img3, img4, img5};  //img,  img6 
  ArrayList<Branch> branches = new ArrayList<Branch>();
  ArrayList<Leaf> leaves = new ArrayList<Leaf>();
  Boolean reached_attraction_points = false;
  int current_number_of_leaves; 
  PImage coral_texture;

  Tree(PVector pvector1, PVector pvector2) {
    for (int i = 0; i < 2000; i++) {
      leaves.add(new Leaf());
    }
    current_number_of_leaves = 0;
    Branch root = new Branch( pvector1, pvector2 );
    branches.add(root);
    Branch current = new Branch(root);
    int sel = random.nextInt(3);
    coral_texture = reef_textures[sel];

    while (!closeEnough(current)) {
      Branch trunk = new Branch(current);
      branches.add(trunk);
      current = trunk;
    }
         // reached_attraction_points = true;
  }

  boolean closeEnough(Branch b) {

    for (Leaf l : leaves) {
      float d = PVector.dist(b.pos, l.pos);
      if (d < max_dist) {
        return true;
      }
    }
    return false;
  }

  void grow() {
    for (Leaf l : leaves) {
      Branch closest = null;
      PVector closestDir = null;
      float record = -1;

      for (Branch b : branches) {
        PVector dir = PVector.sub(l.pos, b.pos);
        float d = dir.mag();
        if (d < min_dist) {
          l.reached();
          reached_attraction_points = true;
          closest = null;
          break;
        } else if (d > max_dist) {
        } else if (closest == null || d < record) {
          closest = b;
          closestDir = dir;
          record = d;
        }
      }
      if (closest != null) {
       // closestDir.normalize();
        closest.dir.add(closestDir);
        closest.count++;
      }
    }

    for (int i = leaves.size()-1; i >= 0; i--) {
      if (leaves.get(i).reached) {
       leaves.remove(i);
      }
    }

    for (int i = branches.size()-1; i >= 0; i--) {
      Branch b = branches.get(i);
      if (b.count > 0) {
        b.dir.div(b.count);
        PVector rand = PVector.random2D();
        rand.setMag(0.3);
        b.dir.add(rand);
        b.dir.normalize();
        Branch newB = new Branch(b);
        branches.add(newB);
        b.reset();
      }
    }
  }

  void show() {
    
    /*
    for (Leaf l : leaves) {
      l.show();
    }
    */
    stroke(0);
    PShape globe = createShape(SPHERE, 30);
    globe.setTexture(coral_texture);
    //for (Branch b : branches) {
    for (int i = 0; i < branches.size()/2; i++) {
      Branch b = branches.get(i);
      if (b.parent != null) {
        float sw = map(i, 0, branches.size()/2, 5, 0);
        strokeWeight(sw);
        //stroke(0,255,0);
        //line(b.pos.x, b.pos.y, b.pos.z, b.parent.pos.x, b.parent.pos.y, b.parent.pos.z);
        
        //beginShape();
        pushMatrix();
        translate(b.pos.x, b.pos.y, b.pos.z);
        shape(globe);
        popMatrix();
        
        
       
      }
    }
    current_number_of_leaves++;
  }
  
  void show2() {
    //float xoff = 0.0;

    for (Leaf l : leaves) {
      l.show();
    }    
    
    for (int i = 0; i < branches.size(); i++) {
      Branch b = branches.get(i);
      if (b.parent != null) {
        float sw = map(i, 0, branches.size(), 3, 0);
        strokeWeight(sw);
        
        //xoff = xoff + .0001;
       // float n = noise(xoff);
        
        float n =1;
        //stroke(139,69,19);
        line(b.pos.x+300, b.pos.y+100, b.pos.z, b.parent.pos.x, b.parent.pos.y+100, b.parent.pos.z);
      }
    }
  }
  
}