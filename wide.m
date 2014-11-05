files = '1.png	2.png	3.png	4.png	5.png	6.png	7.png	8.png	9.png	10.png	11.png	12.png	13.png	14.png	15.png	16.png	17.png';
list_files = strsplit( files, '	');

path = '/Users/catarina/Desktop/Faces/Wide_Faces_Resized_lots_of_features/';

images_wide = zeros(length( list_files ), 160000 );

for i = 1 : 1 : length( list_files )
    
    % create the path of the images_wide by combining
    % the file path to the narrow faces folder 
    % with the name of the file image
    image_path = char(strcat( path, list_files(i)) );
    
    image = imread( image_path );
    
    % put the image in an n-dimensional vector
    image_pixels = reshape( image, 1, prod( size( image ) ) ); 

    % store the n-dimensional vector
    images_wide(i, :) = image_pixels;
    
end

mapping_wide = zeros( length(list_files), 3 );

% the wide faces have a 40 % chance of being Lork and
% 60 % chance of being Adok 
indx = 1 : length( list_files );
random_faces_wide = indx( randperm( length( indx )));

% select 60% of the images_wide
total_adok_faces_wide = round( 0.6 * length( random_faces_wide ) );

% store the adok faces
adok_faces_wide = images_wide( random_faces_wide( 1 : total_adok_faces_wide ), : );

% store the lork faces
lork_faces_wide = images_wide( random_faces_wide( total_adok_faces_wide+1 : end ), : );

% make the mapping_wide between the filename and the adoks
mapping_wide( random_faces_wide( 1 : total_adok_faces_wide ), 2 ) = 'A';
mapping_wide( random_faces_wide( 1 : total_adok_faces_wide ), 1 ) = random_faces_wide( 1 : total_adok_faces_wide );

% make the mapping_wide between the filename and the lorks
mapping_wide( random_faces_wide( total_adok_faces_wide+1 : end ), 2 ) = 'L';
mapping_wide( random_faces_wide( total_adok_faces_wide+1 : end ), 1 ) = random_faces_wide( total_adok_faces_wide + 1 : end );

adoks_wide = random_faces_wide( 1 : total_adok_faces_wide );
lorks_wide = random_faces_wide( total_adok_faces_wide + 1 : end );

% The adoks have a 70% chance of being frinedly and
% 30 % chance of being hostile
[total_adoks, c] = size( adok_faces_wide );
indx_2 = 1 : total_adoks;
random_friendly_wide = indx_2(randperm(length( indx_2 )));

% select 70% of the lork faces randomly
total_adok_friendly = round( 0.7 * length( random_friendly_wide ) );

% store the friendly adok faces
adok_friendly_wide = adok_faces_wide( random_friendly_wide( 1 : total_adok_friendly ), : );

% store the hostile adok faces
adok_hostile_wide = adok_faces_wide( random_friendly_wide( total_adok_friendly+1 : end ), : );

for i = 1 : length(random_friendly_wide)
    
    if( i <=  total_lork_hostile )
        mapping_wide( adoks_wide( random_friendly_wide(i)), 3 ) = 'F'; 
    else
        mapping_wide( adoks_wide( random_friendly_wide(i)), 3 ) = 'H'; 
    end
end

% The lorks have a 70% chance of being hostile and
% 30 % chance of being friendly
[total_lorks, c] = size( lork_faces_wide );
indx_3 = 1 : total_lorks;
random_hostile_wide = indx_3(randperm( total_lorks ));

% select 70% of the lork faces randomly
total_lorks_friendly = round( 0.7 * length( random_hostile_wide ) );

% store the hostile lork faces
lork_hostile_wide = lork_faces_wide( random_hostile_wide( 1 : total_lork_hostile ), : );

% store the friendly lork faces
lork_friendly_wide = lork_faces_wide( random_hostile_wide( total_lork_hostile+1 : end ), : );

for i = 1 : length(random_hostile_wide)
    
    if( i <=  total_lork_hostile )
        mapping_wide( lorks_wide( random_hostile_wide(i)) , 3 ) = 'H'; 
    else
        mapping_wide( lorks_wide( random_hostile_wide(i)), 3 ) = 'F'; 
    end
    
end

mapping_wide = sortrows( mapping_wide );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x = lork_hostile_wide( 1, :);
y = adok_hostile_wide( 1, :);

% cosine similarity
theta = acos( dot(x,y) / (norm(x,2)*norm(y,2)));


