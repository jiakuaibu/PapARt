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

import fr.inria.papart.procam.display.ARDisplay;
import fr.inria.papart.procam.Screen;
import fr.inria.papart.procam.display.BaseDisplay;
import fr.inria.papart.procam.display.ProjectorDisplay;
import java.util.ArrayList;
import processing.core.PVector;

/**
 *
 * @author jiii
 */
public abstract class TouchInput {

    abstract public void update();

    abstract public TouchList projectTouchToScreen(Screen screen, BaseDisplay display);

    public PVector project(Screen screen, BaseDisplay display, float x, float y) throws Exception {
        boolean isProjector = display instanceof ProjectorDisplay;
        boolean isARDisplay = display instanceof ARDisplay;

        // check that the correct method is called !
        PVector paperScreenCoord;
        if (isProjector) {
             paperScreenCoord = ((ProjectorDisplay) display).projectPointer(screen, x, y);
        } else {
            if (isARDisplay) {
                paperScreenCoord = ((ARDisplay) display).projectPointer(screen, x, y);
            } else {
                paperScreenCoord = display.projectPointer(screen, x, y);
            }
        }
        return paperScreenCoord;
    }
}