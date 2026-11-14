local cityBuilding = class("cityBuilding", function(imgName)
	return display.newSprite(imgName)
end)
function cityBuilding:ctor()
	print("buildImg")
end
return cityBuilding
