function y =heun(fP,yo,dt,tend)

y=zeros(tend/dt,1);%Initialize output vector
n=tend/dt;
y1=yo;
for t=1: n
    fP1=feval(fP,y1);%calculate f'(y1)
    y2euler=y1+dt*fP1;%Use Euler method to calculate Y2
    fP2=feval(fP,y2euler);%calculate f'(y2) 
    y2heun=y1+(dt*1/2*(fP1+fP2));%clculate Y2 Using Heun method
    y1=y2heun;%set y1=y2
    y(t,1)=y1;%add y1 to vector
    
 end
end
