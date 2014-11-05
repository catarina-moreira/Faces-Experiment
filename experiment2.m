path = '/Users/catarina/Desktop/Faces/Faces_Resized_lots_of_features/';

% read image in a 400 x 400 pixels
main_image_good = imread( strcat(path, 'base_good.png') );

% transform the image into a 1-dimensional vector
main_image_good = reshape( main_image_good, 1, prod(size(main_image_good)));

% convert types
main_image_good = cast( main_image_good, 'double' ); 

% noise
% main_image_good = reshape( main_image_good, 400, 400 );
% main_image_good = imnoise( main_image_good, 'salt & pepper');
% main_image_good = reshape( main_image_good, 1, prod(size(main_image_good)));
    
% read image in a 400 x 400 pixels
main_image_bad = imread( strcat(path, 'base_bad.png') );

% transform the image into a 1-dimensional vector
main_image_bad = reshape( main_image_bad, 1, prod(size(main_image_bad)));

% convert types
main_image_bad = cast( main_image_bad, 'double' );

% noise
main_image_bad = reshape( main_image_bad, 400, 400 );
main_image_bad = imnoise( main_image_bad, 'salt & pepper' );
main_image_bad = reshape( main_image_bad, 1, prod(size(main_image_bad)));

% ---------------------------------------------------------------

files_bad = '19.png	20.png	21.png	22.png	23.png	24.png	25.png	26.png	27.png	28.png	29.png	30.png	31.png	32.png	33.png	34.png';
files_good = '2.png	3.png	4.png	5.png	6.png	7.png	8.png	9.png	10.png	11.png	12.png	13.png	14.png	15.png	16.png	17.png';

list_files_good = strsplit( files_bad, '	');
list_files_bad = strsplit( files_good, '	');

images_bad = zeros(length( list_files_bad ), 160000 );
images_good = zeros(length( list_files_good ), 160000 );

thetas_bad = zeros( 1, length( list_files_bad ) );
thetas_good = zeros( 1, length( list_files_bad ) );

quantum_probabilities_attack = zeros( 1, length( list_files_bad ) );
quantum_probabilities_withdraw = zeros( 1, length( list_files_bad ) );

for i = 1 : 1 : length( list_files_bad )
    
    % create the path of the images_narrow by combining
    % the file path to the narrow faces folder 
    % with the name of the file image
    image_path_bad = char(strcat( path, list_files_bad{i}) );
    image_path_good = char(strcat( path, list_files_good{i}) );
    
    image_bad = imread( image_path_bad );
    image_good = imread( image_path_good );
    
    % put the image in an n-dimensional vector
    image_pixels_bad = reshape( image_bad, 1, prod( size( image_bad ) ) ); 
    image_pixels_good = reshape( image_good, 1, prod( size( image_good ) ) ); 

    % convert types
    image_pixels_bad = cast( image_pixels_bad, 'double' );
    image_pixels_good = cast( image_pixels_good, 'double' );
    
    % apply gaussian noise of 30%
    %image_pixels = reshape( image_pixels, 400, 400 );
    %image_pixels = imnoise( image_pixels, 'gaussian', 0.3 );
    %image_pixels = reshape( image_pixels, 1, prod(size(image_pixels)));

    % store the n-dimensional vector
    images_bad(i, :) = image_pixels_bad;
    images_good(i, :) = image_pixels_good;
    
    % measure the cosine similarity between the image read and the bad 
    % face
    
    theta_bad = dot_product(main_image_bad, image_pixels_bad) /(dot_product(main_image_bad, main_image_bad)*dot_product(image_pixels_bad, image_pixels_bad));
    thetas_bad(i) = acos(theta_bad);
    
    % measure the cosine similarity between the image read and the good
    % face
    
    theta_good = dot_product(main_image_good, image_pixels_good) /(dot_product(main_image_good, main_image_good)*dot_product(image_pixels_good, image_pixels_good));
    thetas_good(i) = acos(theta_good);
    
end

max_bad = max( thetas_bad );
min_bad = min( thetas_bad );

max_good = max( thetas_good );
min_good = min( thetas_good );

% renormalize the angle of the vectors
for i = 1 : length( thetas_bad )
    thetas_bad( i ) =( ( thetas_bad( i ) - min_bad ) / ( max_bad - min_bad ))*( 2*pi - 0 ) - 0 ;
    
    thetas_good( i ) = (( thetas_good( i ) - min_good ) / ( max_good - min_good ))*( 2*pi - 0 ) - 0;
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













