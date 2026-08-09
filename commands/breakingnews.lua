-- breakingnews.lua
-- Welcome back on pancakeJr's totaly legit news channel!

local headlines = {
    "Local man discovers `Ctrl+Z` exists. 2 years too late",
    "Scientists confirm: The group caht never actually sleeps",
    "The group chat got leaked. Authorities looking for members.",
    "New study shows that 90% of people are terrible at using the internet",
    "Area WiFi router is sentient. It has been demanding more bandwidth.",
    "Area WiFi router declared indepedence, demands recognition from the U.N",
    "Man convinced his code works, the code disagrees",
    "Breaking: Local microwave outlives 3 relationships",
    "Community shaken after a local actually reads Terms and Conditions",
    "Man opens 47 tabs 'Just to check 1 thing'",
    "Experts baffled as coffee fails to fix everything, again",
    "Local cat declares war on nothing in particular. The cat won",
    "Man says 'I'll sleep when i'm dead' regrets statement by 3 AM",
    "Breaking: Someone in this server still hasn't touched grass"
}

math.randomseed(os.time())

return {
    name = "breakingnews",
    description = "Delivers totally legit breaking news.",
    execute = function(message, args)
        message.channel:send("**Breaking News:** " .. headlines[math.random(#headlines)])
    end
}