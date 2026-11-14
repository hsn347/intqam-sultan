local cityBuildMilitaryTent = class("cityBuildMilitaryTent", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildMilitaryTent:ctor()
end
function cityBuildMilitaryTent:loadView()
	self:loadBaseView()
end
return cityBuildMilitaryTent
