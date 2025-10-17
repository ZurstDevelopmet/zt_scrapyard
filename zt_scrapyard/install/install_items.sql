INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
    ('scrap_metal', 'Kovový šrot', 1, 0, 1),
    ('scrap_plastic', 'Plastový šrot', 1, 0, 1),
    ('scrap_rubber', 'Gumový šrot', 1, 0, 1),
    ('scrap_aluminum', 'Hliníkový šrot', 1, 0, 1),
    ('scrap_copper', 'Měděný šrot', 1, 0, 1),
    ('wrench', 'Klíč', 1, 0, 1),
    ('advanced_toolkit', 'Pokročilá sada nářadí', 2, 0, 1)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);
