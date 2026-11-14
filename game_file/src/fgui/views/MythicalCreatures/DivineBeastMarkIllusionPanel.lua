local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DivineBeastMarkIllusionPanel = class("DivineBeastMarkIllusionPanel", baseFguiPanel)
local divineBeastMarkRead = include("divineBeastMarkRead")
function DivineBeastMarkIllusionPanel:ctor(...)
	DivineBeastMarkIllusionPanel.super.ctor(self, ...)
	print("DivineBeastMarkIllusionPanel:ctor", self.viewName)
	self.debug = true
end
function DivineBeastMarkIllusionPanel:onInit()
	print("=======DivineBeastMarkIllusionPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_2935"), handler(self, self.onClickClose))
	self.curSelectedType = 0
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.list:setItemProvider(handler(self, self.onItemProvider))
end
function DivineBeastMarkIllusionPanel:onShow()
	print("=======DivineBeastMarkIllusionPanel:onShow")
	self.fields.list:setHeight((self.view:getHeight() - 1136) / 2 + self.fields.list:getHeight())
	self:initData()
end
function DivineBeastMarkIllusionPanel:initData()
	local markCfgs = divineBeastMarkRead.getDbMarkCfgs()
	local divineBeastMarkRead, rareMarkCfgs
	local divineBeastMarkRead, normalMarkCfgs
	local divineBeastMarkRead, mapCache
	for _, markCfg in pairs(markCfgs) do
		if not mapCache[markCfg.type] then
			if markCfg.if_rare == 1 then
				table.insert(rareMarkCfgs, markCfg)
				divineBeastMarkRead = rareMarkCfgs
				rareMarkCfgs.quality = markCfg.quality
				mapCache[markCfg.type], rareMarkCfgs.index = rareMarkCfgs, #rareMarkCfgs
			elseif self.curSelectedType == 0 or markCfg.army_id == self.curSelectedType then
				table.insert(normalMarkCfgs, markCfg)
				divineBeastMarkRead = normalMarkCfgs
				normalMarkCfgs.quality = markCfg.quality
				mapCache[markCfg.type], normalMarkCfgs.index = normalMarkCfgs, #normalMarkCfgs
			end
		elseif mapCache[markCfg.type].quality < markCfg.quality then
			if markCfg.if_rare == 1 then
				rareMarkCfgs[mapCache[markCfg.type].index] = markCfg
			else
				normalMarkCfgs[mapCache[markCfg.type].index] = markCfg
			end
			mapCache[markCfg.type].quality = markCfg.quality
		end
	end
	self.rareMarkCfgs = rareMarkCfgs
	self.normalMarkCfgs = normalMarkCfgs
	table.sort(normalMarkCfgs, function(a, b)
		return a.ID > b.ID
	end)
	local count = 1 + math.ceil(#normalMarkCfgs / 4)
	self.fields.list:setNumItems(count)
end
function DivineBeastMarkIllusionPanel:onItemProvider(index)
	if index == 0 then
		return "ui://MythicalCreatures/Com_MC_illusionSingle1"
	else
		return "ui://MythicalCreatures/Com_MC_illusionSingle2"
	end
end
function DivineBeastMarkIllusionPanel:onItemRenderer(index, obj)
	if index == 0 then
		obj:initData(self.rareMarkCfgs, self.curSelectedType)
		obj:setTypeSelectedCallback(handler(self, self.onSelectedCallback))
	else
		obj:initData(self.normalMarkCfgs, index - 1)
	end
end
function DivineBeastMarkIllusionPanel:onSelectedCallback(tag)
	self.curSelectedType = tag
	self:initData()
end
return DivineBeastMarkIllusionPanel
