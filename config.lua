Config                      	= {}
Config.DrawDistance         	= 50.0
Config.Locale               	= 'en'
Config.CompanyPlate				= "Pharmacy-"
Config.RiskedRates				= {"1.1", "1.2", "0.9", "0.8", "1.3"}


Config.Zones = {
	pharmacistActions = {
		Coords = vector3(260.1, 204.3, 109.2),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 102, g = 102, b = 204},
		Type = 1
	},
	pharmacistStocks = {
		Coords = vector3(244.50, 232.18, 105.28),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 102, g = 102, b = 204},
		Type = 1
	},
	VehicleSpawner = {
		Coords = vector3(249.7, 196.7, 105),
		Size  = {x = 1.0, y = 1.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 36, Rotate = true
	},
	VehicleSpawnPoint = {
		Coords  = vector3(249.5, 192.5, 105),
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Type    = -1, Rotate = false,
		Heading = 70.81
	},
	VehicleDeleter = {
		Coords   = vector3(254.9374, 190.0125, 103.9),
		Size  = {x = 3.0, y = 3.0, z = 0.25},
		Color = {r = 255, g = 0, b = 0},
		Type  = 1, Rotate = false
	}
}
Config.AuthorizedVehicles = {
	{
		model = 'nspeedo',
		label = 'Standard bus',
		auth  = 'recruit'
	},
	{
		model = 'rmodgtr50',
		label = 'GTR-50 ',
		auth  = 'boss'
	}
}

