local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
local nebulaEmperorRead = include("nebulaEmperorRead")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local nebulaAllStarRead = include("nebulaAllStarRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_energy = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://NebulaEmperorWar/Com_energy", Com_energy)
fgui.register_extension("ui://NebulaAllStarWar/Com_energy", Com_energy)
function Com_energy:onInit()
	self.fields.title:setString(i18n("nebulaemperor_text_107"))
	self.barTitle = self.fields.bar:getChild("title")
	if not SoraDFIsRA() then
		self.fields.icon:fixPos()
	end
end
function Com_energy:onShow()
end
function Com_energy:updateEnergy(...)
	local ctrl, read
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		ctrl, read = nebulaAllStarCtrl, nebulaAllStarRead
	else
		ctrl, read = nebulaEmperorCtrl, nebulaEmperorRead
	end
	if not ctrl:getStartPalaceWar() then
		local energyMax = read.getPalaceEnergyMax()
		self.fields.bar:setMax(energyMax)
		local towerEnergy = ctrl:getTowerEnergyTotal()
		local remain = math.max(0, energyMax - towerEnergy)
		self.fields.bar:setValue(remain)
		if remain <= 0 then
			self:setStartPalaceWar()
		end
	else
		self:setStartPalaceWar()
	end
end
function Com_energy:setStartPalaceWar(...)
	self.fields.bar:setValue(0)
	self.barTitle:setString(i18n("nebulaemperor_text_108"))
end
function Com_energy:setActivityID(activityID)
	self.activityID = activityID
end
return Com_energy
