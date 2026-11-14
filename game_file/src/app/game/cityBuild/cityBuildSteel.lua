local cityBuildSteel = class("cityBuildSteel", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildSteel:ctor()
end
function cityBuildSteel:loadView()
	self:loadBaseView()
end
return cityBuildSteel
