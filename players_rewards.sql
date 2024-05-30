CREATE TABLE `players_rewards` (
  `citizenid` varchar(50) NOT NULL,
  `last_reward` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

ALTER TABLE `players_rewards`
  ADD PRIMARY KEY (`citizenid`);
COMMIT;

