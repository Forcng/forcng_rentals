Config = {}

Config.Rent = "ox_target"
Config.PedModel = "a_m_m_business_01"

Config.Prices = {
  bumpercar = 150,
}

Config.Keys = "mk_vehiclekeys"

Config.Rents = {
    test = {
        title = "Test Rental",
        coords = vector3(-300.8170, -921.7972, 30.0806),
        heading = 270.4101,
        vehicles = {
            {
                title = 'Car Rentals',
                icon = 'fas fa-car',
                description = 'Price: ' .. Config.Prices.bumpercar .. '$',
                event = 'forcng:client:spawnVehicle',
                image = 'https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1046243/f2b501553666039b8f397817cb58b9a2028223cd.png',
                args = {
                  vehicle = 'veto2',
                  spawn = vector3(-306.0261, -926.0320, 30.080),
                  heading = 88.9133,
                  price = Config.Prices.bumpercar 
                }
            },
        }
    }
}

Config.Blips = {
    colour = 15,
    id = 225
}
