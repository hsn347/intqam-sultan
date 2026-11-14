local baseComponent = require("fgui.base.baseComponent")
local Com_MC_Suit = fgui.extension_class(fgui.GComponent, baseComponent)
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
local divineBeastMarkRead = include("divineBeastMarkRead")
fgui.register_extension("ui://MythicalCreatures/Com_MC_Suit", Com_MC_Suit)
_ENV = fgui.register_extension
fgui.register_extension[3] = "divine_beast_mark_suit_04"
local fgui.register_extension[4], qualityMap = "divine_beast_mark_suit_03", fgui.register_extension
function Com_MC_Suit:onInit()
	self:fixChildrenPos()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_MC_Suit:onShow()
end
function Com_MC_Suit:initData(beastId, quality)
	self.beastId = beastId
	self.quality = quality
	self.suitBuffCfgLsit = divineBeastMarkRead.getSuitBuffCfgs(quality, self.beastId)
	self.controllers.c1:setSelectedIndex(quality == 3 and 1 or 0)
	self.stageList, divineBeastMarkRead = self.controllers.c1.setSelectedIndex, self.controllers.c1.setSelectedIndex
	for k, v in ipairs(self.suitBuffCfgLsit) do
		table.insert(self.stageList, v.need_lv)
	end
	self:updateView()
end
function Com_MC_Suit:updateView()
	self.lvCount = divineBeastMarkCtrl:getQualityLvsCount(self.beastId, self.quality)
	divineBeastMarkCtrl = nil
	;(nil).num = self.lvCount
	self.fields.title:setString(i18n(qualityMap[self.quality], nil))
	self.fields.list:setNumItems(#self.suitBuffCfgLsit)
	self.fields.list:setHeight(105 * #self.suitBuffCfgLsit)
	dump(self.stageList, "self.stageList")
	local percent = SoraDGetStageValue(self.lvCount, self.stageList)
	print(percent, "percent")
	if percent < 9.5 and self.lvCount ~= 0 then
		percent = 9.5
	end
	self.fields.progress:setValue(percent)
end
function Com_MC_Suit:onItemRenderer(index, item)
	local cfg = self.suitBuffCfgLsit[index + 1]
	item:initData(cfg, self.beastId, self.lvCount)
end
return Com_MC_Suit
