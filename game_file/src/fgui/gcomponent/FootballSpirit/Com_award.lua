local footballElfCtrl = SoraDGetCtrl("footballElfCtrl")
local footballElfRead = include("footballElfRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_award = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://FootballSpirit/Com_award", Com_award)
function Com_award:onInit()
end
function Com_award:onShow()
end
function Com_award:initData(data, level, isSenior, onlyShow)
	local curLv = footballElfCtrl:getCurLv()
	local recordLv = footballElfCtrl:getReceiveRecord(isSenior)
	local isUnlock = footballElfCtrl:getIsUnlock()
	self.fields.item:initData(data.id, data.count)
	self.fields.icon_lock:setVisible(isSenior and not isUnlock)
	if onlyShow then
		self.fields.done:setVisible(false)
		self.fields.n4:setVisible(false)
		self.fields.item:setEffectShow(false)
		local ret = footballElfCtrl:getReceiveStatusAndNum()
		local maxCfgLv = footballElfRead.getMaxExpCfgLv(footballElfCtrl:getClassType())
		if isSenior then
			self.fields.item:setEffectShow(ret and curLv > maxCfgLv and footballElfCtrl:getIsUnlock())
		else
			self.fields.item:setEffectShow(ret and curLv > maxCfgLv)
		end
	else
		self.fields.done:setVisible(level <= recordLv)
		self.fields.n4:setVisible(level <= recordLv)
		if isSenior then
			if level <= curLv and level > recordLv and isUnlock then
				self.fields.item:setEffectShow(true)
			else
				self.fields.item:setEffectShow(false)
			end
		elseif level <= curLv and level > recordLv then
			self.fields.item:setEffectShow(true)
		else
			self.fields.item:setEffectShow(false)
		end
	end
end
return Com_award
