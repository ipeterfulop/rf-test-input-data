CREATE OR REPLACE FUNCTION getNormalizaltOrszagNev(
	orszagnev VARCHAR2
) RETURN VARCHAR2 as 
	normalizaltNev VARCHAR2;
BEGIN
	
	normalizaltNev := LOWER (
		REPLACE(
		REPLACE(
					REPLACE(
						orszagnev, ' ', ''
						), 
					'á', 'a'),
		'Á', 'A')
		);

	return normalizaltNev;
END
 