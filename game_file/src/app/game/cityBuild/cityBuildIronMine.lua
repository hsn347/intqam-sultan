local cityBuildIronMine = class("cityBuildIronMine", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildIronMine:ctor()
end
function cityBuildIronMine:loadView()
	self:loadBaseView()
end
return cityBuildIronMine
