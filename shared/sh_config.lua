Config = {}

Config.Locale = 'nl'

Config.BinSearch = {
    ["ReceiveBottle"] = math.random(1, 6),
    ["RewardBottle"] = math.random(1, 4),
    ["ItemNeeded"] = "bottle",
    ["SellLocations"] = vector3(29.33, -1770.33, 29.60),
    ["AvailableBins"] = {
        "prop_bin_01a",
        "prop_bin_03a",
        "prop_bin_05a"
    },
    ["SellWaitTime"] = 5000 -- Time in miliseconds
}
