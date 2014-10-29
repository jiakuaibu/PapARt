/* 
 * Copyright (C) 2014 Jeremy Laviole <jeremy.laviole@inria.fr>.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301  USA
 */
package fr.inria.papart.multitouch;

import fr.inria.papart.depthcam.DepthPoint;
import processing.core.PVector;
import toxi.geom.Vec3D;

// TODO: TrackedTouchPoint ...
// TODO: Filtered TouchPoint ...
/**
 * TouchPoint class for multi-touch tracking.
 *
 * @author jeremy
 */
public class TouchPoint extends DepthPoint {

    // protected PVector position... in DepthPoint
    private PVector previousPosition = new PVector();
    private PVector speed = new PVector();

    private Vec3D positionKinect;
    private Vec3D previousPositionKinect;
//    private PVector speedKinect = new PVector();

    private float confidence;
//    public float size;
    private boolean is3D;
    private boolean isCloseToPlane;

    // Tracking related variables
    private static final int NO_ID = 0;
    private static int globalID = 1;
    protected int id = NO_ID;
    private int updateTime;
    private int createTime = -1;

    private boolean toDelete = false;
    public boolean isUpdated = false;

// filtering 
    private OneEuroFilter[] filters;
    public static float filterFreq = 30f;
    public static float filterCut = 0.2f;
    public static float filterBeta = 8.000f;
    public static final int NO_TIME = -1;

    public TouchPoint() {
        try {
            filters = new OneEuroFilter[3];
            for (int i = 0; i < 3; i++) {
                filters[i] = new OneEuroFilter(filterFreq, filterCut, filterBeta);
            }
        } catch (Exception e) {
            System.out.println("OneEuro Exception. Pay now." + e);
        }
    }

    @Override
    public void setPosition(Vec3D pos) {
        super.setPosition(pos);
        setPreviousPosition();
    }

    @Override
    public void setPosition(PVector pos) {
        super.setPosition(pos);
        setPreviousPosition();
    }

    public float distanceTo(TouchPoint tp) {
        return this.positionKinect.distanceTo(tp.positionKinect);
    }

    public void setPositionKinect(Vec3D pos) {
        this.positionKinect = new Vec3D(pos);
        this.previousPositionKinect = new Vec3D(pos);
    }

    public Vec3D getPositionKinect() {
        return this.positionKinect;
    }

    public Vec3D getPreviousPositionKinect() {
        return this.previousPositionKinect;
    }

    private void setPreviousPosition() {
        previousPosition.set(this.position);
    }

    public PVector getPreviousPosition() {
        return this.previousPosition;
    }

    public void filter() {
        try {
            position.x = (float) filters[0].filter(position.x);
            position.y = (float) filters[1].filter(position.y);
            position.z = (float) filters[2].filter(position.z);
        } catch (Exception e) {
            System.out.println("OneEuro init Exception. Pay now." + e);
        }
    }

    public boolean updateWith(TouchPoint tp) {
        if (isUpdated || tp.isUpdated) {
            return false;
        }

        assert(this.createTime < tp.createTime);
        
        // these points are used for update. They will not be used again.
        this.setUpdated(true);
        tp.setUpdated(true);

        // mark the last update as the creation of the other point. 
        this.updateTime = tp.createTime;

        // delete the updating point (keep the existing one)
        // TODO: check this as it is obvious ?
        tp.toDelete = true;

        updatePosition(tp);

        // The touchPoint gets an ID, it is a grown up now. 
        if (this.id == NO_ID) {
            this.id = globalID++;
        }

        filter();
        return true;
    }

    private void updatePosition(TouchPoint tp) {
        // Error checking: never update 3D with non 3D !
        assert (tp.is3D == this.is3D);

        // save the previous position
        previousPosition = position.get();
        previousPositionKinect = positionKinect.copy();

        this.position.set(tp.position);
        this.positionKinect.set(tp.positionKinect);
        this.confidence = tp.confidence;
        this.isCloseToPlane = tp.isCloseToPlane;

        speed.set(this.position);
        speed.sub(this.previousPosition);
    }

    public boolean isObselete(int currentTime, int duration) {
        return (currentTime - updateTime) > duration;
    }

    public int getID() {
        return this.id;
    }

    static final int SHORT_TIME_PERIOD = 200;  // in ms

    public boolean isYoung(int currentTime) {
        int age = getAge(currentTime);
        return age == NO_TIME || age < SHORT_TIME_PERIOD;
    }

    public int getAge(int currentTime) {
        if (this.createTime == NO_TIME) {
            return NO_TIME;
        } else {
            return currentTime - this.createTime;
        }
    }

    public void setCreationTime(int timeStamp) {
        this.createTime = timeStamp;
        this.updateTime = timeStamp;
    }
    
    public PVector getSpeed() {
        return this.speed;
    }

    protected void setUpdated(boolean updated) {
        this.isUpdated = updated;
    }

    public boolean isUpdated() {
        return isUpdated;
    }

    public float getConfidence() {
        return confidence;
    }

    public void setConfidence(float confidence) {
        this.confidence = confidence;
    }

    public boolean is3D() {
        return is3D;
    }

    public void set3D(boolean is3D) {
        this.is3D = is3D;
    }

    public boolean isCloseToPlane() {
        return isCloseToPlane;
    }

    public void setCloseToPlane(boolean isCloseToPlane) {
        this.isCloseToPlane = isCloseToPlane;
    }

    public void setToDelete() {
        this.toDelete = true;
    }

    public boolean isToDelete() {
        return this.toDelete;
    }

    @Override
    public String toString() {
        return "Touch Point, kinect: " + positionKinect + " , proj: " + position + "confidence " + confidence + " ,close to Plane : " + isCloseToPlane;
    }


}
