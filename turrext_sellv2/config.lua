Config                            = {}
Config.NotifyPlayerOnPoliceDispatch = true
-- Either integrated or qs-dispatch
Config.Dispatch = "integrated"
-- Either ESX or OX
Config.Inventory = "OX"
Config.DispatchBlipTimer = 30000 -- (MS)
Config.InstantRespawnAfterPedDeath = false -- If true, ped will respawn as soon as he is dead, if false, he will respawn after ExpireTimer is over.
Config.Zones = {

	[1] = {
		Id = 1,
		Pos   = {x = -886.8, y = -820.84, z = 18.48},
		Size  = {x = 1.0, y = 1.0, z = 1.0},
		Color = 39,
        Radius = 60.0,
		Type  = 51,
		Blipname = "Blip 1",
        Rotate = false,
        Showblip = true,
        Drawradius = true,
		Peds = {
			Enabled = true,
			MaxPedAmount = 3,
			SpawnCoords = {
				[1] = {
					Pos = {x = -886.8, y = -821.48, z = 17.96},
					Heading = 0,
					Model = "mp_m_freemode_01",
					Actions = {
						ApproachPlayer = true,
						FreezePed = false,
						Wandering = true,
						Invincible = false,
						IgnoreEvents = true,
						ExpireTimer = 300, -- When will the ped be removed after it's task has completed or its been alive too long.
						PoliceNotifyChance = 10, -- % Chance Ped will Notify Police / 100
						RequestSpecificItem = true, -- If True, it will only request 1 Item from the ItemGroup, Else it will have a preset to buy x amount of items our of player hands but it will buy any item out of its shop
						ItemGroup = 2
					}
				},
				[2] = {
					Pos = {x = -840.88, y = -806.4, z = 18.64},
					Heading = 0,
					Model = "mp_m_freemode_01",
					Actions = {
						ApproachPlayer = true,
						FreezePed = false,
						Wandering = false,
						Invincible = false,
						IgnoreEvents = false,
						ExpireTimer = 300, -- When will the ped be removed after it's task has completed or its been alive too long.
						PoliceNotifyChance = 10, -- % Chance Ped will Notify Police / 100
						RequestSpecificItem = true,
						ItemGroup = 2
					}
				},
				[3] = {
					Pos = {x = -892.96, y = -839.48, z = 17.44},
					Heading = 0,
					Model = "mp_m_freemode_01",
					Actions = {
						ApproachPlayer = false,
						FreezePed = true,
						Wandering = false,
						Invincible = true,
						IgnoreEvents = true,
						ExpireTimer = 300, -- When will the ped be removed after it's task has completed or its been alive too long.
						PoliceNotifyChance = 10, -- % Chance Ped will Notify Police / 100
						RequestSpecificItem = false,
						ItemGroup = 2
					}
				},

			} 
		}
	},

    [2] = {
		Id = 2,
		Pos   = {x = 223.72, y = -830.88, z = 30.4},

		Size  = {x = 1.0, y = 1.0, z = 1.0},
		Color = 66,
        Radius = 45.0,
		Type  = 51,
		Blipname = "Blip 2",
        Rotate = false,
        Showblip = true,
        Drawradius = true,
		Peds = {
			Enabled = true,
			MaxPedAmount = 2,
			SpawnCoords = {
				[1] = {
					Pos = {x = 221.32, y = -862.8, z = 30.28},
					Heading = 0,
					Model = "a_f_m_tramp_01",
					Actions = {
						ApproachPlayer = false,
						FreezePed = true,
						Wandering = false,
						Invincible = true,
						IgnoreEvents = true,
						ExpireTimer = 300, -- When will the ped be removed after it's task has completed or its been alive too long.
						PoliceNotifyChance = 75, -- % Chance Ped will Notify Police / 100
						RequestSpecificItem = false,
						ItemGroup = 4
					}
				},
				[2] = {
					Pos = {x = 213.72, y = -814.08, z = 30.72},
					Heading = 0,
					Model = "cs_russiandrunk",
					Actions = {
						ApproachPlayer = true,
						FreezePed = false,
						Wandering = true,
						Invincible = false,
						IgnoreEvents = true,
						ExpireTimer = 300, -- When will the ped be removed after it's task has completed or its been alive too long.
						PoliceNotifyChance = 70, -- % Chance Ped will Notify Police / 100
						RequestSpecificItem = false,
						ItemGroup = 1
					}
				}

			} 
		}
	},

	[3] = {
		Id = 3,
		Pos   = {x = 1961.48, y = 5177.48, z = 47.92},
		Size  = {x = 1.0, y = 1.0, z = 1.0},
		Color = 66,
        Radius = 10.0,
		Type  = 51,
		Blipname = "Drug Dealer1",
        Rotate = false,
        Showblip = false,
        Drawradius = false,
		Peds = {
			Enabled = true,
			MaxPedAmount = 1,
			SpawnCoords = {
				[1] = {
					Pos = {x = 1961.48, y = 5177.48, z = 47.92},
					Heading = 271.04,
					Model = "s_m_y_dealer_01",
					Actions = {
						ApproachPlayer = false,
						FreezePed = true,
						Wandering = false,
						Invincible = true,
						IgnoreEvents = true,
						ExpireTimer = 300, -- When will the ped be removed after it's task has completed or its been alive too long.
						PoliceNotifyChance = 10, -- % Chance Ped will Notify Police / 100
						RequestSpecificItem = false,
						ItemGroup = 3
					}
				},

			} 
		}
	},
	[4] = {
		Id = 4,
		Pos   = {x = 2560.4, y = 4669.36, z = 34.08},
		Size  = {x = 1.0, y = 1.0, z = 1.0},
		Color = 1,
        Radius = 10.0,
		Type  = 310,
		Blipname = "Drug Dealer",
        Rotate = false,
        Showblip = true,
        Drawradius = false,
		Peds = {
			Enabled = true,
			MaxPedAmount = 1,
			SpawnCoords = {
				[1] = {
					Pos = {x = 2560.4, y = 4669.36, z = 34.08},
					Heading = 33.44,
					Model = "s_m_y_dealer_01",
					Actions = {
						ApproachPlayer = false,
						FreezePed = true,
						Wandering = false,
						Invincible = true,
						IgnoreEvents = true,
						ExpireTimer = 300, -- When will the ped be removed after it's task has completed or its been alive too long. ( IN SECONDS )
						PoliceNotifyChance = 10, -- % Chance Ped will Notify Police / 100
						RequestSpecificItem = false,
						ItemGroup = 3
					}
				},

			} 
		}
	},
	[5] = {
		Id = 5,
		Pos   = {x = 1697.4, y = 4923.32, z = 42.08},
		Size  = {x = 1.0, y = 1.0, z = 1.0},
		Color = 2,
        Radius = 10.0,
		Type  = 541,
		Blipname = "Shop Sell Ped",
        Rotate = false,
        Showblip = true,
        Drawradius = false,
		Peds = {
			Enabled = true,
			MaxPedAmount = 1,
			SpawnCoords = {
				[1] = {
					Pos = {x = 1697.4, y = 4923.32, z = 42.08},
					Heading = 313.84,
					Model = "mp_m_shopkeep_01",
					Actions = {
						ApproachPlayer = false,
						FreezePed = true,
						Wandering = false,
						Invincible = true,
						IgnoreEvents = true,
						ExpireTimer = 300, -- When will the ped be removed after it's task has completed or its been alive too long.
						PoliceNotifyChance = 10, -- % Chance Ped will Notify Police / 100
						RequestSpecificItem = false,
						ItemGroup = 3
					}
				},

			} 
		}
	},
}

Config.Selling = {
	[1] = {
		NPCPermenentShop = false,
		Jobonly = false,
		JobLabel = "Benny's Mechanic",
		Job = "none",
		Items = { -- Name, -- Label, -- Price, -- Account, -- Min Amount sold per Ped, -- Max Amount sold per Ped
			[1] = {
				Name = "water",
				Label = "Bottle of Water",
				Price = 10,
				Account = "money",
				MinItem = 3,
				MaxItem = 6,

			}
		}
	},
	[2] = {
		NPCPermenentShop = false,
		JobOnly = false,
		JobLabel = "Benny's Mechanic",
		Job = "mechanic",
		Items = { -- Name, -- Label, -- Price, -- Account, -- Min Amount sold per Ped, -- Max Amount sold per Ped
			[1] = {
				Name = "fixkit",
				Label = "Repair Kit",
				Price = 10,
				Account = "money",
				MinItem = 2,
				MaxItem = 4,

			},
			[2] = {
				Name = "bread",
				Label = "Loaf of Bread",
				Price = 10,
				Account = "bank",
				MinItem = 1,
				MaxItem = 4,
			}
		}
	},
	[3] = {
		-- These are NPC Shops, Recommened to disable approach, wandering, and enable freeze, invincible and ignore events.
		-- Also disable Specific Item for ped
		NPCPermenentShop = true, -- Makes it a permenent shop so that the NPC will buy unlimited material and will open a shop with ox_target
		JobOnly = false,
		JobLabel = "Benny's Mechanic",
		Job = "mechanic",
		Items = { -- Name, -- Label, -- Price, -- Account, -- Min Amount sold per Ped, -- Max Amount sold per Ped
		[1] = {
			Name = "smokes",
			Label = "Cigarettes",
			Price = 10,
			Account = "black",
		},
		[2] = {
			Name = "weed",
			Label = "Weed Rolls",
			Price = 10,
			Account = "black",
		},
		}
	},
	[4] = {
		-- These are NPC Shops, Recommened to disable approach, wandering, and enable freeze, invincible and ignore events.
		-- Also disable Specific Item for ped
		NPCPermenentShop = true, -- Makes it a permenent shop so that the NPC will buy unlimited material and will open a shop with ox_target
		JobOnly = false,
		JobLabel = "Benny's Mechanic",
		Job = "mechanic",
		Items = { -- Name, -- Label, -- Price, -- Account, -- Min Amount sold per Ped, -- Max Amount sold per Ped
		[1] = {
			Name = "fixkit",
			Label = "Repair Kit",
			Price = 10,
			Account = "money",
		},
		[2] = {
			Name = "water",
			Label = "water",
			Price = 10,
			Account = "bank",
		},
		}
	}
}
Config.RenderDistance = 120
Config.GlobalWanderDist = 10 -- Do not Change unless you know what youare doing