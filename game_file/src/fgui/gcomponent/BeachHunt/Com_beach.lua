local treasureBeachRead = include("treasureBeachRead")
local beachTreasureCtrl = SoraDGetCtrl("beachTreasureCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_beach = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BeachHunt/Com_beach", Com_beach)
function Com_beach:onInit()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Usm_wj:setEffectPath("shatanxunbao_cz.usm", false)
	self.fields.Usm_wj:setBlendMode(fgui.BlendMode.Normal)
	self.fields.Usm_wj:play(false)
	self.fields.Usm_wj:setVisible(false)
	_ENV = false
	;(false).frame = 30
	self.fields.Usm_wj:getCriSprite():addFrameEventData(false)
	self.fields.Usm_wj:getCriSprite():setFrameEventCallback(handler(self, self.showNewBeach))
end
function Com_beach:onShow()
end
function Com_beach:onItemRenderer(index, obj)
	obj:setName("bake" .. index)
	obj:initData(self.bakeData[index + 1], index + 1, self.idx)
end
function Com_beach:initData(idx)
	self.idx = idx
	self.bakeData = treasureBeachRead.getBeachCfg()
	self.fields.list:setNumItems(#self.bakeData)
end
function Com_beach:doDigAct(idx, scale)
	self.idx = idx
	local bakeIdx = idx - 1
	local bakeItem = self.fields.list:getChild("bake" .. bakeIdx)
	local pos = self:getParent():convertToNodeSpace(cc.p(bakeItem:getPositionX(), bakeItem:getPositionY()))
	self.fields.Usm_wj:setPosition(pos.x * scale + 250, pos.y * scale + 330)
	self.fields.Usm_wj:setVisible(true)
	self.fields.Usm_wj:play()
end
function Com_beach:showNewBeach()
	SoraDPlaySound("normalcontrol", 6)
	beachTreasureCtrl:reqBeachTreasureLottery(self.idx)
end
return Com_beach
