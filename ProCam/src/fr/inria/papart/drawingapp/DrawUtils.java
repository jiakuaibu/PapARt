/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package fr.inria.papart.drawingapp;

import processing.core.PApplet;
import processing.core.PFont;
import processing.opengl.PGraphics3D;
import processing.core.PImage;

import processing.opengl.*;
import javax.media.opengl.*;
import static processing.core.PConstants.QUADS;

/**
 *
 * @author jeremylaviole
 */
public class DrawUtils {

    public static PApplet applet;

    static public void drawImage(PGraphics3D pg3d, PImage img, int x, int y, int w, int h) {
        pg3d.pushMatrix();
        pg3d.translate(x, y);
        pg3d.scale(-1, 1, 1);
        pg3d.rotate(PApplet.PI);
        pg3d.image(img, 0, 0, w, h);
        pg3d.popMatrix();
    }

    static public void drawImage(PGraphicsOpenGL g, PImage img, int x, int y, int w, int h) {
//        g.pushMatrix();
//        g.translate(x, y);
//        g.scale(-1, 1, 1);
//        g.rotate(PApplet.PI);
//        g.image(img, 0, 0, w, h);
//        g.popMatrix();
        
        g.beginShape(QUADS);
        g.texture(img);
        g.vertex(x, y, 0, h);
        g.vertex(x, y + h, 0, 0);
        g.vertex(x + w, y + h, w, 0);
        g.vertex(x + w, y, w, h);
        g.endShape();
        
    }

    static public void drawImage(PGraphicsOpenGL g, Texture tex, int x, int y, int w, int h) {

//         vertex(-100, -100, 0, 0, 0);
//  vertex(100, -100, 0, img.width, 0);
//  vertex(100, 100, 0, img.width, img.height);
//  vertex(-100, 100, 0, 0, img.height);
        
        tex.bind();
        g.beginShape(QUADS);
        g.vertex(x, y, 0, 0);
        g.vertex(x, y + h, 0, h);
        g.vertex(x + w, y + h, w, h);
        g.vertex(x + w, y, w, 0);
        g.endShape();
        tex.unbind();
    }

//    static public void drawImage(GLGraphicsOffScreen pg3d, PImage img, int x, int y, int w, int h) {
//        pg3d.pushMatrix();
//        pg3d.translate(x, y);
//        pg3d.scale(-1, 1, 1);
//        pg3d.rotate(PApplet.PI);
//        pg3d.image(img, 0, 0, w, h);
//        pg3d.popMatrix();
//    }
    static public void drawText(PGraphics3D pg3d, String text, PFont font, int x, int y) {
        pg3d.pushMatrix();
        pg3d.translate(x, y);
        pg3d.scale(-1, 1, 1);
        pg3d.rotate(PApplet.PI);
        pg3d.textMode(PApplet.MODEL);
        pg3d.textFont(font);
        pg3d.text(text, 0, 0);
        pg3d.popMatrix();
    }

    static public void drawText(PGraphics3D pg3d, String text, PFont font, int fontSize, int x, int y) {
        pg3d.pushMatrix();
        pg3d.translate(x, y);
        pg3d.scale(-1, 1, 1);
        pg3d.rotate(PApplet.PI);
        pg3d.textMode(PApplet.MODEL);
        pg3d.textFont(font, fontSize);
        pg3d.text(text, 0, 0);
        pg3d.popMatrix();
    }

    static public void drawText(PGraphics3D pg3d, String text, PFont font, int fontSize, int x, int y, int w, int h) {
        pg3d.pushMatrix();
        pg3d.translate(x, y);
        pg3d.scale(-1, 1, 1);
        pg3d.rotate(PApplet.PI);
//        pg3d.textMode(PApplet.MODEL);
        pg3d.rectMode(PApplet.CENTER);

        pg3d.textFont(font, fontSize);
        pg3d.text(text, 0, 0, w, h);

        pg3d.noFill();
        pg3d.stroke(100);
        pg3d.rect(0, 0, w, h);

        pg3d.popMatrix();
    }
}
