from visual import *

# a program to illustrate a ball bouncing in a right triangle

# March 10, 2005 updated October 17, 2007

#Amy Kolan



#good starting conditions to show the hanging out effect

#ball.pos=(trix,9.5,0), ball.velocity=vector(-1,0.001,0)

clear="on"

trix=14.2

triy=10.

scene.center=(trix/2.,triy/2.,0)

vec1=vector(trix,0,0)

vec2=vector(0,triy,0)

ball=sphere(pos=(trix,6,0), radius=0.2, color=color.red)

ball.trail=curve(color=color.green)

# start ball on side

ball_side="side"

tribot=box(pos=(trix/2.,0,0),axis=(1,0,0), size=(trix,.2,0), color=color.white)

triside=box(pos=(trix,triy/2.,0), axis=(1,0,0), size=(.2,triy,0), color=color.white)

trihyp=box(pos=(trix/2., triy/2., 0), axis=(trix,triy,0), size=(mag(vec1+vec2),.2,0))



ball.velocity=vector(-1,-1,0)

# first entry must be negative

dt=.01





vertex1=vector(0,0,0)

vertex2=vector(trix,0,0)

vertex3=vector(trix,triy,0)

triangle_bot=vector(1,0,0)

triangle_side=vector(0,1,0)

triangle_hyp=norm(vector(-trix,-triy,0))



triangle_bot_norm=-1*cross(triangle_bot,(0,0,1))

triangle_side_norm=-1*cross(triangle_side,(0,0,1))

triangle_hyp_norm=-1*cross(triangle_hyp,(0,0,1))

#print triangle_hyp.x, triangle_hyp.y, triangle_hyp_norm.x, triangle_hyp_norm.y



triangle_hyp_slope=triangle_hyp.y/triangle_hyp.x





# print triangle_hyp_slope





if (ball.velocity.x!=0): # ball is not going straight up or down

    ball_slope=ball.velocity.y/ball.velocity.x

    ball_intercept=ball.pos.y-ball_slope*ball.pos.x

inter_hyp=vector(0,0,0)

inter_side=vector(0,0,0)

inter_bottom=vector(0,0,0)



newvel=vector(0,0,0)

lineto_vertex=vector(1,0,0)

scene.autoscale=0

i=0





# print ball.pos

while i>-1:

    if ((i%200==0) and clear=="on"):

        p1=ball.pos

        v1=ball.velocity

        ball.visible=0

        ball.trail.visible=0

        ball=sphere(pos=p1, radius=0.2, color=color.red)

        ball.velocity=v1

        ball.trail=curve(color=color.green)

        ball.trail.append(pos=ball.pos)

        ball.trail.visible=1

        ball.visible=1

    rate(300)

    i=i+1

    if (ball_side=="hyp"): # ball is at hypoteneuse

        lineto_vertex=vertex2-ball.pos

        if cross(ball.velocity,lineto_vertex).z>0: # ball hits bottom

            inter_bottom.x=-1*ball_intercept/ball_slope

            ball.velocity.y=-ball.velocity.y

            ball.pos=inter_bottom

            ball_slope=ball.velocity.y/ball.velocity.x

            ball_intercept=ball.pos.y-ball_slope*ball.pos.x

            ball.trail.append(pos=ball.pos)

            ball_side="bottom"

            # print "A", ball.velocity.x, ball.velocity.y

        else: # ball hits side

            inter_side.x=trix

            inter_side.y=ball_slope*trix+ball_intercept

            dist=mag(inter_side-ball.pos)

            ball.velocity.x=-ball.velocity.x

            ball.pos=inter_side

            ball_slope=ball.velocity.y/ball.velocity.x

            ball_intercept=ball.pos.y-ball_slope*ball.pos.x

            ball.trail.append(pos=ball.pos)

            ball_side="side"

            # print "B", ball.velocity.x, ball.velocity.y

    elif (ball_side=="side"): # ball is at side

        lineto_vertex=vertex1-ball.pos

        if cross(ball.velocity,lineto_vertex).z>0: # ball hits hypotenuse

            inter_hyp.x=ball_intercept/(triangle_hyp_slope-ball_slope)

            inter_hyp.y=triangle_hyp_slope*inter_hyp.x

            dist=mag(inter_hyp-ball.pos)

            # print "interC", ball.velocity.x,ball.velocity.y

            newvel=dot(ball.velocity,triangle_hyp)*triangle_hyp

            # print "interC", newvel.x, newvel.y

            newvel=newvel-dot(ball.velocity,triangle_hyp_norm)*triangle_hyp_norm

            ball.pos=inter_hyp

            ball.velocity=newvel

            ball_slope=ball.velocity.y/ball.velocity.x

            ball_intercept=ball.pos.y-ball_slope*ball.pos.x

            ball.trail.append(pos=ball.pos)

            ball_side="hyp"

            # print "C", ball.velocity.x, ball.velocity.y

        else: # ball hits bottom

            inter_bottom.x=-1*ball_intercept/ball_slope

            dist=mag(inter_bottom-ball.pos)

            ball.velocity.y=-ball.velocity.y

            ball.pos=inter_bottom

            ball_slope=ball.velocity.y/ball.velocity.x

            ball_intercept=ball.pos.y-ball_slope*ball.pos.x

            ball.trail.append(pos=ball.pos)

            ball_side="bottom"

            # print "D", ball.velocity.x, ball.velocity.y

    elif (ball_side=="bottom"): # ball is at bottom

        lineto_vertex=vertex3-ball.pos

        if cross(ball.velocity,lineto_vertex).z>0: # ball hits side

            inter_side.x=trix

            inter_side.y=ball_slope*trix+ball_intercept

            dist=mag(inter_side-ball.pos)

            ball.velocity.x=-ball.velocity.x

            ball.pos=inter_side

            ball_slope=ball.velocity.y/ball.velocity.x

            ball_intercept=ball.pos.y-ball_slope*ball.pos.x

            ball.trail.append(pos=ball.pos)

            ball_side="side"

            # print "E", ball.velocity.x, ball.velocity.y

        else: # ball hits hypoteneuse

            inter_hyp.x=ball_intercept/(triangle_hyp_slope-ball_slope)

            inter_hyp.y=triangle_hyp_slope*inter_hyp.x

            dist=mag(inter_hyp-ball.pos)

            # print inter_hyp.x, inter_hyp.y, ball.velocity.x,ball.velocity.y

            newvel=dot(ball.velocity,triangle_hyp)*triangle_hyp

            newvel=newvel-dot(ball.velocity,triangle_hyp_norm)*triangle_hyp_norm

            # print newvel.x, newvel.y

            ball.pos=inter_hyp

            ball.velocity=newvel

            ball_slope=ball.velocity.y/ball.velocity.x

            ball_intercept=ball.pos.y-ball_slope*ball.pos.x

            ball.trail.append(pos=ball.pos)

            ball_side="hyp"

            # print "F", ball.velocity.x, ball.velocity.y

        

  

  

        

    

        

        

        

