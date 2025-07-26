% Part 1: Create a struct with 10 datasets

% Define the number of sites and their respective lengths
num_sites = 10;
site_lengths = [50, 70, 90, 110, 130, 150, 170, 190, 210, 230];

% Initialize the struct to store the datasets
data_struct = struct('distance', {}, 'chi', {}, 'z', {});

% Generate data for each site
for site_idx = 1:num_sites
    num_points = site_lengths(site_idx);
    
    % Generate sample data for distance, noisy Chi values, and Z values
    distance = linspace(0, num_points, num_points);
    chi = linspace(0, 2*pi, num_points) + randn(1, num_points) * 0.1;
    z = sin(chi) + randn(1, num_points) * 0.2;
    
    % Store the data in the struct
    data_struct(site_idx).distance = distance;
    data_struct(site_idx).chi = chi;
    data_struct(site_idx).z = z;
end

analyzeAndPlotData(data_struct);


% Part 2: Create a function to analyze and plot the data for each site

% Define a function to analyze and plot the data for each site
function analyzeAndPlotData(data_struct)
    num_sites = numel(data_struct);
    
    % Create a figure with subplots for each site
    figure;
    
    for site_idx = 1:num_sites
        subplot(num_sites, 1, site_idx);
        
        % Extract data for the current site
        distance = data_struct(site_idx).distance;
        chi = data_struct(site_idx).chi;
        z = data_struct(site_idx).z;
        
        % Perform the analysis (similar to the previous code)
        derivative = zeros(1, numel(distance));

        for i = 3:numel(distance)-2
            chi_5 = chi(i-2:i+2);
            z_5 = z(i-2:i+2);
            p = polyfit(chi_5, z_5, 2);
            derivative(i) = polyval(polyder(p), chi(i));
        end

        % Plot the derivative as a function of distance
        plot(distance(3:end-2), derivative(3:end-2));
%         xlabel('Distance from Origin');
        ylabel('Derivative of Z with respect to Chi');
%         title(['Site ' num2str(site_idx)]);
    end
    
    % Adjust subplot spacing
%     tight_layout();
    
    % Set a common x-axis label for the bottom subplot
    subplot(num_sites, 1, num_sites);
    xlabel('Distance from Origin');
end

% Call the function to analyze and plot the data for each site
