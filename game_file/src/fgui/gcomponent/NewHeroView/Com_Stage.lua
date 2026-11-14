local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_Stage = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_Stage", Com_Stage)
function Com_Stage:onInit()
	self.isInit = true
	self.fields.Bar:setMax(100)
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.Bar:fixPos()
end
function Com_Stage:onItemRederer(index, obj)
	obj:initData(self.cfg[index + 1], self.heroID)
end
function Com_Stage:onShow()
end
function Com_Stage:initData(heroID)
	self.heroID = heroID
	self.cfg = heroltCtrl:getHeroAwakeStage(self.heroID)
	if self.isInit then
		local height = #self.cfg * 107 + (#self.cfg - 1) * 13
		self.fields.List:setHeight(height)
		self.barH = height - 63
		local bar_v = self.fields.Bar:getChild("bar_v")
		local bar_bg = self.fields.Bar:getChild("bg")
		self.fields.Bar:setHeight(self.barH)
		bar_bg:setHeight(self.barH)
		bar_v:setHeight(self.barH)
		bar_v:getChild("icon"):setWidth(self.barH + 19)
		self:getScrollPane():setPercY(self:getProgressValue() / 100, true)
		self.isInit = false
	end
	local val = self:getProgressValue()
	self.fields.List:setNumItems(#self.cfg)
	self.fields.Bar:setValue(val)
end
function Com_Stage:getProgressValue()
	local value = heroCtrl:getHeroPowerSkillPercent(self.heroID)
	local key = "awakeStage"
	local offsetY = 0
	for i, v in ipairs(self.cfg) do
		if value >= v[key] then
			if i == 1 then
				offsetY = offsetY + 44
			else
				offsetY = offsetY + 120
			end
		else
			local base = 120
			local lastNum = 0
			if i == 1 then
				base = 44
			else
				lastNum = self.cfg[i - 1][key]
			end
			offsetY = offsetY + base * (value - lastNum) / (v[key] - lastNum)
			break
		end
	end
	return offsetY * 100 / self.barH
end
return Com_Stage
