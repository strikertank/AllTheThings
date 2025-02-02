---------------------------------------------------
--          Z O N E S        M O D U L E         --
---------------------------------------------------

root(ROOTS.Zones, {
	m(BROKEN_ISLES, {
		m(HIGHMOUNTAIN, {
			n(ACHIEVEMENTS, {
				ach(11264, {	-- Adventurer of Highmountain
					crit(1),		-- Sekhan
					crit(2),		-- The Beastly Boxer
					crit(3),		-- Crab Rider Grmlrml
					crit(4),		-- Crawshuk the Hungry
					crit(5),		-- Gurbog da Basher
					crit(6),		-- Hartli the Snatcher
					crit(7),		-- Skywhisker Taskmaster
					crit(8),		-- Unethical Adventurers
					crit(9),		-- The Exiled Shaman
					crit(10),		-- Beastmaster Pao'lek
					crit(11),		-- Majestic Elderhorn
					crit(12),		-- Bristlemaul
					crit(13),		-- Scout Harefoot
					crit(14),		-- Bodash the Hoarder
					crit(15),		-- Totally Safe Treasure Chest
					crit(16),		-- Amateur Hunters
					crit(17),		-- Mellok, Son of Torok
					crit(18),		-- Devouring Darkness
					crit(19),		-- Luggut the Eggeater
					crit(20),		-- Shara Felbreath
					crit(21),		-- Captured Survivor
					crit(22),		-- Slumbering Bear
				}),
				ach(10059, {	-- Ain't No Mountain High Enough
					crit(28963, {	-- The Rivermane Tribe
						["sourceQuests"] = { 39487 },	-- Crystal Fury
					}),
					crit(28966, {	-- Riverbend
						["sourceQuests"] = { 38909 },	-- Get to High Ground
					}),
					crit(28405, {	-- The Skyhorn Tribe
						["sourceQuests"] = { 39387 },	-- The Skies of Highmountain
					}),
					crit(28964, {	-- The Bloodtotem Tribe
						["sourceQuests"] = { 39426 },	-- Blood Debt
					}),
					crit(29135, {	-- Huln's War
						["sourceQuests"] = { 39992 },	-- Huln's War - The Nathrezim
					}),
					crit(28965, {	-- Secrets of Highmountain
						["sourceQuests"] = { 39579 },	-- The Backdoor
					}),
					crit(28212, {	-- Battle of Snowblind Mesa
						["sourceQuests"] = { 39780 },	-- The Underking
					}),
				}),
				ach(10398, {	-- Drum Circle
					["description"] = "This achievement can be soloed since after 'Battle for Azeroth'. Repeatedly jump for 1-3 minutes in the middle ring on the lower floor of Thunder Totem. It CANNOT be completed while you are on 'Assault on Thunder Totem' and you must be able to hear the drum beats to know the achievement is working."
				}),
				explorationAch(10667),	-- Explore Highmountain
				ach(10626, {	-- Zoom!
					i(137298),	-- Zoom (PET!)
				}),
				ach(10774, {	-- Hatchling of the Talon
					["sourceQuests"] = { 41094 },	-- Hatchlings of the Talon
					["g"] = {
						i(139773),	-- Emerald Winds (TOY!)
					},
				}),
				ach(11257),	-- Treasures of Highmountain
			}),
		}),
	}),
});
