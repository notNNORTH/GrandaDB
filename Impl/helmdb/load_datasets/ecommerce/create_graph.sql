\c ecommerce;

create graph social_network(follows ELABEL,person VLABEL);
create graph tag_network(interested_in ELABEL,person VLABEL,tag VLABEL);