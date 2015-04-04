/*
    If you think this code looks like the Sierpinski Source Code,
    you're right. I borrowed the OpenGL Skeleton. It was too late
    in the evening or too soon in the morning for me to consider
    writing it from scratch.
    
    Nevertheless, there are some improvements. For instance there is a
    header file :-)
*/

#include "XGLeverywhere.h"

#include <math.h>
#include <stdlib.h>



#define EDGE_LENGTH	2.0

typedef struct Point3D
{
    GLfloat x;
    GLfloat y;
    GLfloat z;
} Point3D;

static int tick = 0;

void DrawFractal(Point3D inCenter,GLfloat inEdgeLength,unsigned short inLevel);
void draw(gasketstruct *gp);

void DrawFractal(Point3D inCenter,GLfloat inEdgeLength,unsigned short inLevel)
{
    if (inLevel==0)
    {
        register GLfloat cachevalue;
		
        inEdgeLength/=2;
		
        glBegin(GL_QUADS);
        
        cachevalue=inCenter.x-inEdgeLength;
        
        glNormal3f(-1.0,0.0,0.0);
        
        glVertex3f(cachevalue,inCenter.y-inEdgeLength,inCenter.z+inEdgeLength);
        glVertex3f(cachevalue,inCenter.y+inEdgeLength,inCenter.z+inEdgeLength);
        glVertex3f(cachevalue,inCenter.y+inEdgeLength,inCenter.z-inEdgeLength);
        glVertex3f(cachevalue,inCenter.y-inEdgeLength,inCenter.z-inEdgeLength);
                
        cachevalue=inCenter.x+inEdgeLength;
		
        glNormal3f(1.0,0.0,0.0);
		
        glVertex3f(cachevalue,inCenter.y-inEdgeLength,inCenter.z-inEdgeLength);
        glVertex3f(cachevalue,inCenter.y+inEdgeLength,inCenter.z-inEdgeLength);
        glVertex3f(cachevalue,inCenter.y+inEdgeLength,inCenter.z+inEdgeLength);
        glVertex3f(cachevalue,inCenter.y-inEdgeLength,inCenter.z+inEdgeLength);

        cachevalue=inCenter.y-inEdgeLength;
		
        glNormal3f(0.0,-1.0,0.0);
		
        glVertex3f(inCenter.x-inEdgeLength,cachevalue,inCenter.z-inEdgeLength);
        glVertex3f(inCenter.x+inEdgeLength,cachevalue,inCenter.z-inEdgeLength);
        glVertex3f(inCenter.x+inEdgeLength,cachevalue,inCenter.z+inEdgeLength);
        glVertex3f(inCenter.x-inEdgeLength,cachevalue,inCenter.z+inEdgeLength);
                
        cachevalue=inCenter.y+inEdgeLength;
		
        glNormal3f(0.0,1.0,0.0);
		
        glVertex3f(inCenter.x-inEdgeLength,cachevalue,inCenter.z+inEdgeLength);
        glVertex3f(inCenter.x+inEdgeLength,cachevalue,inCenter.z+inEdgeLength);
        glVertex3f(inCenter.x+inEdgeLength,cachevalue,inCenter.z-inEdgeLength);
        glVertex3f(inCenter.x-inEdgeLength,cachevalue,inCenter.z-inEdgeLength);
                
        cachevalue=inCenter.z-inEdgeLength;
		
        glNormal3f(0.0,0.0,-1.0);
		
        glVertex3f(inCenter.x-inEdgeLength,inCenter.y+inEdgeLength,cachevalue);
        glVertex3f(inCenter.x+inEdgeLength,inCenter.y+inEdgeLength,cachevalue);
        glVertex3f(inCenter.x+inEdgeLength,inCenter.y-inEdgeLength,cachevalue);
        glVertex3f(inCenter.x-inEdgeLength,inCenter.y-inEdgeLength,cachevalue);
		
        cachevalue=inCenter.z+inEdgeLength;
		
        glNormal3f(0.0,0.0,1.0);
		
        glVertex3f(inCenter.x-inEdgeLength,inCenter.y-inEdgeLength,cachevalue);
        glVertex3f(inCenter.x+inEdgeLength,inCenter.y-inEdgeLength,cachevalue);
        glVertex3f(inCenter.x+inEdgeLength,inCenter.y+inEdgeLength,cachevalue);
        glVertex3f(inCenter.x-inEdgeLength,inCenter.y+inEdgeLength,cachevalue);
		
        glEnd();
	}
	else
	{
        Point3D inNewCenter;
        
        inEdgeLength/=3;
        inLevel-=1;
        
        inNewCenter.x=inCenter.x-inEdgeLength;
        inNewCenter.y=inCenter.y-inEdgeLength;
        inNewCenter.z=inCenter.z-inEdgeLength;
        
        DrawFractal(inNewCenter,inEdgeLength,inLevel);
        
        inNewCenter.x=inCenter.x+inEdgeLength;
        inNewCenter.y=inCenter.y-inEdgeLength;
        inNewCenter.z=inCenter.z-inEdgeLength;
        
        DrawFractal(inNewCenter,inEdgeLength,inLevel);
        
        inNewCenter.x=inCenter.x-inEdgeLength;
        inNewCenter.y=inCenter.y+inEdgeLength;
        inNewCenter.z=inCenter.z-inEdgeLength;
        
        DrawFractal(inNewCenter,inEdgeLength,inLevel);
        
        inNewCenter.x=inCenter.x+inEdgeLength;
        inNewCenter.y=inCenter.y+inEdgeLength;
        inNewCenter.z=inCenter.z-inEdgeLength;
        
        DrawFractal(inNewCenter,inEdgeLength,inLevel);
        
        inNewCenter.x=inCenter.x-inEdgeLength;
        inNewCenter.y=inCenter.y-inEdgeLength;
        inNewCenter.z=inCenter.z+inEdgeLength;
        
        DrawFractal(inNewCenter,inEdgeLength,inLevel);
        
        inNewCenter.x=inCenter.x+inEdgeLength;
        inNewCenter.y=inCenter.y-inEdgeLength;
        inNewCenter.z=inCenter.z+inEdgeLength;
        
        DrawFractal(inNewCenter,inEdgeLength,inLevel);
        
        inNewCenter.x=inCenter.x-inEdgeLength;
        inNewCenter.y=inCenter.y+inEdgeLength;
        inNewCenter.z=inCenter.z+inEdgeLength;
        
        DrawFractal(inNewCenter,inEdgeLength,inLevel);
        
        inNewCenter.x=inCenter.x+inEdgeLength;
        inNewCenter.y=inCenter.y+inEdgeLength;
        inNewCenter.z=inCenter.z+inEdgeLength;
        
        DrawFractal(inNewCenter,inEdgeLength,inLevel);
                
        DrawFractal(inCenter,inEdgeLength,inLevel);
    }
}

void draw(gasketstruct *gp)
{
    static float position0[] = {-0.5,  1.2, 0.5, 0.0};
    static float ambient0[]  = {0.1, 0.1, 1.0, 0.8};
    static float spec[]      = {0.2, 0.2, 1.0, 1.0};

    glClearColor(0,0,0,0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glLightfv(GL_LIGHT0, GL_POSITION,  position0);
    glLightfv(GL_LIGHT0, GL_AMBIENT,   ambient0);
    glLightfv(GL_LIGHT0, GL_SPECULAR,  spec);
    glLightfv(GL_LIGHT0, GL_DIFFUSE,   gp->light_colour);

    glShadeModel(GL_FLAT);
    glPolygonMode(GL_FRONT,GL_FILL);
    glPolygonMode(GL_BACK, GL_LINE);

    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);

    glEnable(GL_CULL_FACE);

    glPushMatrix();
    glTranslatef( gp->pos[0], gp->pos[1], -15.0 );  

    glPushMatrix();
    glRotatef(2*gp->angle, 1.0, 0.0, 0.0);
    glRotatef(3*gp->angle, 0.0, 1.0, 0.0);
    glRotatef(  gp->angle, 0.0, 0.0, 1.0);
    glScalef( 4.0, 4.0, 4.0 );

    glCallList(gp->gasket1);

    glPopMatrix();

    glPopMatrix();


    if (tick++ >= gp->speed)
    {
        Point3D tPoint={0.0,0.0,0.0};

        tick = 0;
        if (gp->current_depth >= gp->max_depth)
            gp->current_depth = -gp->max_depth;
        gp->current_depth++;

        glDeleteLists (gp->gasket1, 1);
        glNewList (gp->gasket1, GL_COMPILE);
        DrawFractal(tPoint,EDGE_LENGTH,(gp->current_depth < 0? -gp->current_depth : gp->current_depth));
        glEndList();
    }
}


/* new window size or exposure */
void reshape(int width, int height)
{
    GLfloat h = (GLfloat) height / (GLfloat) width;

    glViewport(0, 0, (GLint) width, (GLint) height);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();

    gluPerspective( 30.0, 1/h, 1.0, 100.0 );
    gluLookAt(0.0, 0.0, 15.0,
              0.0, 0.0, 0.0,
              0.0, 1.0, 0.0);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glTranslatef(0.0, 0.0, -15.0);

    /* The depth buffer will be cleared, if needed, before the
    * next frame.  Right now we just want to black the screen.
    */
    glEnable(GL_DEPTH_TEST);
    glClear(GL_COLOR_BUFFER_BIT);

    glDepthFunc(GL_LESS);
}

void pinit(gasketstruct *gp,int speed,int max_depth)
{
    Point3D tPoint={0.0,0.0,0.0};
    
    gp->view_rotx = 0;
    gp->view_roty = 0;
    gp->view_rotz = 0;
    gp->angle = 0;
    
    tick=0;
    
    gp->speed=speed;
    gp->max_depth=max_depth;
    
    gp->xinc = 0.1*(1.0*random()/RAND_MAX);
    gp->yinc = 0.1*(1.0*random()/RAND_MAX);
    gp->zinc = 0.1*(1.0*random()/RAND_MAX);
    gp->light_colour[0] = 6.0;
    gp->light_colour[1] = 6.0;
    gp->light_colour[2] = 6.0;
    gp->light_colour[3] = 1.0;
    gp->pos[0] = 0.0;     
    gp->pos[1] = 0.0;
    gp->pos[2] = 0.0;    
    /* draw the gasket */
    gp->gasket1 = glGenLists(1);
    gp->current_depth = 0;       /* start out at level 0, not 1 */
    glNewList(gp->gasket1, GL_COMPILE);
    DrawFractal(tPoint,EDGE_LENGTH,gp->current_depth);
    glEndList();
}

void draw_gasket( gasketstruct *gp)
{
    int           angle_incr = 1;
    int           rot_incr = 1;/*MI_COUNT(mi) ? MI_COUNT(mi) : 1;*/

	glDrawBuffer(GL_BACK);

    if (gp->max_depth > 10)
        gp->max_depth = 10;
    
	draw(gp);

    /* rotate */
    gp->angle = (int) (gp->angle + angle_incr) % 360;
    if ( fabs( gp->pos[0] ) > 8.0 ) gp->xinc = -1.0 * gp->xinc;
    if ( fabs( gp->pos[1] ) > 6.0 ) gp->yinc = -1.0 * gp->yinc;
    if ( fabs( gp->pos[2] ) >15.0 ) gp->zinc = -1.0 * gp->zinc;
    gp->pos[0] += gp->xinc;
    gp->pos[1] += gp->yinc;
    gp->pos[2] += gp->zinc;    
    gp->view_rotx = (int) (gp->view_rotx + rot_incr) % 360;
    gp->view_roty = (int) (gp->view_roty +(rot_incr/2.0)) % 360;
    gp->view_rotz = (int) (gp->view_rotz +(rot_incr/3.0)) % 360;

    //glFinish();
}