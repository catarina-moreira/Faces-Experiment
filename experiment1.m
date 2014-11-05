path = '/Users/catarina/Desktop/Faces/Faces_Resized_lots_of_features/';

% read image in a 400 x 400 pixels
main_image_good = imread( strcat(path, 'base_good.png') );

% transform the image into a 1-dimensional vector
main_image_good = reshape( main_image_good, 1, prod(size(main_image_good)));

% read image in a 400 x 400 pixels
main_image_bad = imread( strcat(path, 'base_bad.png') );

% transform the image into a 1-dimensional vector
main_image_bad = reshape( main_image_bad, 1, prod(size(main_image_bad)));

% ---------------------------------------------------------------

files = '2.png	3.png	4.png	5.png	6.png	7.png	8.png	9.png	10.png	11.png	12.png	13.png	14.png	15.png	16.png	17.png	19.png	20.png	21.png	22.png	23.png	24.png	25.png	26.png	27.png	28.png	29.png	30.png	31.png	32.png	33.png	34.png';
list_files = strsplit( files, '	');

images = zeros(length( list_files ), 160000 );

thetas_bad = zeros( 1, length( list_files ) );
thetas_good = zeros( 1, length( list_files ) );

quantum_probabilities_attack = zeros( 1, length( list_files ) );
quantum_probabilities_withdraw = zeros( 1, length( list_files ) );

for i = 1 : 1 : length( list_files )
    
    % create the path of the images_narrow by combining
    % the file path to the narrow faces folder 
    % with the name of the file image
    image_path = char(strcat( path, list_files{i}) );
    
    image = imread( image_path );
    
    % put the image in an n-dimensional vector
    image_pixels = reshape( image, 1, prod( size( image ) ) ); 

    % store the n-dimensional vector
    images(i, :) = image_pixels;
    
    % measure the cosine similarity between the image read and the bad 
    % face
    
    theta_bad = dot_product(main_image_bad, image_pixels) /(dot_product(main_image_bad, main_image_bad)*dot_product(image_pixels, image_pixels));
    thetas_bad(i) = theta_bad;
    
    % measure the cosine similarity between the image read and the good
    % face
    
    theta_good = dot_product(main_image_good, image_pixels) /(dot_product(main_image_good, main_image_good)*dot_product(image_pixels, image_pixels));
    thetas_good(i) = theta_good;
    
end

max_bad = max( thetas_bad );
min_bad = min( thetas_bad );

max_good = max( thetas_good );
min_good = min( thetas_good );

% renormalize the angle of the vectors
for i = 1 : length( thetas_bad )
    thetas_bad( i ) = ( thetas_bad( i ) - min_bad ) / ( max_bad - min_bad );
    thetas_bad( i ) = acos( thetas_bad(i) );
    
    thetas_good( i ) = ( thetas_good( i ) - min_good ) / ( max_good - min_good );
    thetas_good( i ) = acos( thetas_good(i) );
end

% compute quantum probabilities

for i = 1 : length( thetas_bad )
   
    probability_attack = 0.19*0.43 + 0.81*0.63 + 2*sqrt(0.19*0.43)*sqrt(0.81*0.63)*cos( thetas_bad(i) - thetas_good(i)  );
    probability_withdraw = 0.19*0.57 + 0.81*0.37 + 2*sqrt(0.19*0.57)*sqrt(0.81*0.37)*cos( thetas_bad(i) - thetas_good(i) );
    
    norm_prob = probability_attack + probability_withdraw;
    
    probability_attack = probability_attack / norm_prob;
    probability_withdraw = probability_withdraw / norm_prob;
    
    quantum_probabilities_attack(i) = probability_attack;
    quantum_probabilities_withdraw(i) = probability_withdraw;
    
    display([ thetas_bad(i), thetas_good(i), thetas_bad(i) - thetas_good(i),  quantum_probabilities_attack(i) ]);
end

display( mean( quantum_probabilities_attack ));













