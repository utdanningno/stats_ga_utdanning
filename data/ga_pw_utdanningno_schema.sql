-- mysql database schema for Google Analytics statistics four utdanning.no
-- ga_pw_utdanningno_data

CREATE TABLE `ga_pw_utdanningno_data` (
  `page_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_danish_ci DEFAULT NULL COMMENT 'url',
  `page_title` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_danish_ci DEFAULT NULL COMMENT 'Tittel',
  `page_type` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_danish_ci DEFAULT NULL COMMENT 'kategorisering (ikke i analytics)',
  `year` mediumint UNSIGNED DEFAULT NULL COMMENT 'årstall',
  `page_views` int NOT NULL COMMENT 'sidevisninger',
  `page_views_pst` float UNSIGNED DEFAULT NULL COMMENT 'prosent av årets sidevisninger',
  `unique_page_views` int NOT NULL COMMENT 'unike sidevisninger',
  `unique_page_views_pst` float UNSIGNED DEFAULT NULL COMMENT 'prosent av årets unike sidevisninger',
  `entrances` int NOT NULL COMMENT 'antall innganger',
  `entrances_pst` float UNSIGNED DEFAULT NULL COMMENT 'prosent av inngangssider til denne siden',
  `bounce_rate_pst` float NOT NULL COMMENT 'fluktfrekvens',
  `exit_pst` float DEFAULT NULL COMMENT 'prosent som forlater siden',
  `avg_time_on_page` time NOT NULL COMMENT 'gjsn. tid brukt på siden'
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_danish_ci COMMENT='pageviews 2013-2021 1.1.-9.3.';

ALTER TABLE `ga_pw_utdanningno_data`
  ADD KEY `page` (`page_url`),
  ADD KEY `aar` (`year`),
  ADD KEY `pageviews` (`page_views`),
  ADD KEY `page_title` (`page_title`)
;

