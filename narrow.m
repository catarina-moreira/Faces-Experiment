files = '18.png	19.png	20.png	21.png	22.png	23.png	24.png	25.png	26.png	27.png	28.png	29.png	30.png	31.png	32.png	33.png	34.png';
list_files = strsplit( files, '	');

path = '/Users/catarina/Desktop/Faces/Narrow_Faces_Resized_lots_of_features/';

images_narrow = zeros(length( list_files ), 160000 );

for i = 1 : 1 : length( list_files )
    
    % create the path of the images_narrow by combining
    % the file path to the narrow faces folder 
    % with the name of the file image
    image_path = char(strcat( path, list_files(i)) );
    
    image = imread( image_path );
    
    % put the image in an n-dimensional vector
    image_pixels = reshape( image, 1, prod( size( image ) ) ); 

    % store the n-dimensional vector
    images_narrow(i, :) = image_pixels;
    
end

mapping_narrow = zeros( length(list_files), 3 );

% the narrow faces have a 40 % chance of being Adok and
% 60 % chance of being Lork 
indx = 1 : length( list_files );
random_faces_narrow = indx( randperm( length( indx )));

% select 60% of the images_narrow
total_lork_faces_narrow = round( 0.6 * length( random_faces_narrow ) );

% store the lork faces
lork_faces_narrow = images_narrow( random_faces_narrow( 1 : total_lork_faces_narrow ), : );

% store the adok faces
adok_faces_narrow = images_narrow( random_faces_narrow( total_lork_faces_narrow+1 : end ), : );

% make the mapping_narrow between the filename and the lorks
mapping_narrow( random_faces_narrow( 1 : total_lork_faces_narrow ), 2 ) = 'L';
mapping_narrow( random_faces_narrow( 1 : total_lork_faces_narrow ), 1 ) = random_faces_narrow( 1 : total_lork_faces_narrow ) + 17;

% make the mapping_narrow between the filename and the adoks
mapping_narrow( random_faces_narrow( total_lork_faces_narrow+1 : end ), 2 ) = 'A';
mapping_narrow( random_faces_narrow( total_lork_faces_narrow+1 : end ), 1 ) = random_faces_narrow( total_lork_faces_narrow+1 : end ) + 17;

lorks_narrow = random_faces_narrow( 1 : total_lork_faces_narrow );
adoks_narrow = random_faces_narrow( total_lork_faces_narrow + 1 : end );

% The lorks_narrow have a 70% chance of being hostile and
% 30 % chance of being friendly
[total_lorks, c] = size( lork_faces_narrow );
indx_2 = 1 : total_lorks;
random_hostile_narrow = indx_2(randperm(length( indx_2 )));

% select 70% of the lork faces randomly
total_lork_hostile = round( 0.7 * length( random_hostile_narrow ) );

% store the hostile lork faces
lork_hostile_narrow = lork_faces_narrow( random_hostile_narrow( 1 : total_lork_hostile ), : );

% store the friendly lork faces
lork_friendly_narrow = lork_faces_narrow( random_hostile_narrow( total_lork_hostile+1 : end ), : );

for i = 1 : length(random_hostile_narrow)
    
    if( i <=  total_lork_hostile )
        mapping_narrow( lorks_narrow( random_hostile_narrow(i)), 3 ) = 'H'; 
    else
        mapping_narrow( lorks_narrow( random_hostile_narrow(i)), 3 ) = 'F'; 
    end
end

% The adoks_narrow have a 70% chance of being friendly and
% 30 % chance of being hostile
[total_adoks, c] = size( adok_faces_narrow );
indx_3 = 1 : total_adoks;
random_friendly_narrow = indx_3(randperm( total_adoks ));

% select 70% of the adok faces randomly
total_adok_friendly = round( 0.7 * length( random_friendly_narrow ) );

% store the friendly adok faces
adok_friendly_narrow = adok_faces_narrow( random_friendly_narrow( 1 : total_adok_friendly ), : );

% store the hostile adok faces
adok_hostile_narrow = adok_faces_narrow( random_friendly_narrow( total_adok_friendly+1 : end ), : );

for i = 1 : length(random_friendly_narrow)
    
    if( i <=  total_adok_friendly )
        mapping_narrow( adoks_narrow( random_friendly_narrow(i)) , 3 ) = 'F'; 
    else
        mapping_narrow( adoks_narrow( random_friendly_narrow(i)), 3 ) = 'H'; 
    end
    
end

mapping_narrow = sortrows( mapping_narrow );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x = lork_hostile_narrow( 1, :);
y = adok_hostile_narrow( 1, :);


% cosine similarity
theta = acos( dot(x,y) / (norm(x,2)*norm(y,2)));


