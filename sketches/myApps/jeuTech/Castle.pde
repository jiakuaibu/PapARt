
float MAX_HP = 5;

class Castle {

    float size = 55 /2f;
    float castleX = 120 + size;
    float castleY = 20 + size;

    PVector posPxGame;

    // We need to keep track of a Body and a radius
    Body body;
    color col;
    
    Player1 faction;

    Castle(Player1 faction){
	this.faction = faction;

	col = faction.playerColor;
	posPxGame = faction.gameCoord(new PVector(castleX, castleY));

	makeBody(posPxGame.x, posPxGame.y, size);

    }

    // This function removes the particle from the box2d world
    void killBody() {
	box2d.destroyBody(body);
    }

    public PVector getPosPxGame(){
	return posPxGame;
    }

    public void update(){

	if(hpChanged){
	    killBody();
	    float size2 = size * (hp /MAX_HP);
	    makeBody(posPxGame.x, posPxGame.y, size2);
	}

	// TODO: no more allocation here...
	posPxGame = faction.gameCoord(new PVector(castleX, castleY));
	Vec2 vPhys = box2d.coordPixelsToWorld(posPxGame.x, posPxGame.y);
	body.setTransform(vPhys, 0);
    }
    

    float hp = MAX_HP;
    boolean hpChanged  = true;
    public void isHit(){
	hp -= 1;
	hpChanged = true;
	println("hit");
    }

    // public float getCastleSize(){
    // 	float s = hp / MAX_HP * castleSize;
    // 	if(s < 10) 
    // 	    s = 10;
    // 	return s;
    // }

  void display(PGraphicsOpenGL g) {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);

    g.pushMatrix();
    g.translate(pos.x, pos.y);
    //    g.rotate(a);
    //    g.fill(col);
    g.fill(255);

    float size2 = size * 2 * (hp /MAX_HP);

    //    g.ellipse(0, 0, size*2, size*2);
    g.ellipse(0, 0, size2, size2);
    g.popMatrix();
  }


  // Here's our function that adds the particle to the Box2D world
  void makeBody(float x, float y, float r) {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.STATIC;
    body = box2d.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    body.createFixture(fd);
    body.setUserData(this);
  }

}
