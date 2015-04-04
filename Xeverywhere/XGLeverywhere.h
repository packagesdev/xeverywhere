#ifndef __XGLEVERYWHERE__
#define __XGLEVERYWHERE__

#include <OpenGL/gl.h>
#include <OpenGL/glu.h>

typedef struct
{
    GLfloat     view_rotx, view_roty, view_rotz;
    GLfloat     light_colour[4];/* = {6.0, 6.0, 6.0, 1.0}; */
    GLfloat     pos[3];/* = {0.0, 0.0, 0.0}; */
    GLfloat     xinc,yinc,zinc;
    GLfloat     angle;
    GLuint      gasket1;

    int current_depth;
    int max_depth;
    
    int speed;
} gasketstruct;


void pinit(gasketstruct *gp,int speed,int max_depth);
void draw_gasket( gasketstruct *gp);
void reshape(int width, int height);

#endif