%setup
solvers = {@ExplicitEuler, @heunmethod, @RungeKutta};
time_steps = [1./8, 0.25, 0.5, 1];
time_steps = sort(time_steps);
fp = @(p) (1.-p/10.)*p;
tend = 5;
p0 = 1;

%for each solver implemented
for sol=1:length(solvers)
    % setup table
    tab = table('Size',[4,4],...
                'VariableTypes',["double" "double" "double" "double"],...
                'VariableNames',["dt" "error" "error red." "error app."]);
    %plot the analytical solution 
    figure; 
    plot(0:0.01:tend, pexact(0.01, tend),'k');
    hold on;
   
    i = 1; %count timesteps
    
    % calculate solution for dt=1/16 (needed for error reduction)
    yhat = solvers{sol}(fp,p0,min(time_steps)/2.,tend);
    e = approximationError(yhat, pexact(min(time_steps)/2,tend), min(time_steps)/2, tend);
    
    for dt=time_steps
        yhat = solvers{sol}(fp,p0,dt,tend); %solve ODE
        if dt==min(time_steps) %to calculate the approximate error
            pkbest = yhat;
        end
        plot(0:dt:tend,yhat,'--'); %plot for this timestep
        
        %fill table for this timestep
        eold = e;
        e = approximationError(yhat, pexact(dt,tend), dt, tend);
        ehat = approximationError(yhat, pkbest(1:2^(i-1):end), dt, tend);
        tab(i,1) = {dt};
        tab(i,2) = {e};
        tab(i,3) = {eold/e};
        tab(i,4) = {ehat};
        
        i = i+1; %increment time step
    end
    
    %make the plot pretty
    legend(['analytical', string(time_steps)],'location','southeast');
    hold off;
    
    %print the table
    tab
end