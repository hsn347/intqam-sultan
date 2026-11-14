local baseComponent = require("fgui.base.baseComponent")
local Com_MC_SuitCell = fgui.extension_class(fgui.GComponent, baseComponent)
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
local buffDesRead = include("buffDesRead")
fgui.register_extension("ui://MythicalCreatures/Com_MC_SuitCell", Com_MC_SuitCell)
function Com_MC_SuitCell:onInit()
	self:fixChildrenPos()
	self.fields.bg:fix()
	self.fields.icon:fix()
	self.fields.clickMask:addEventListener(fgui.UIEventType.Click, handler(self, self.onClickMask))
end
function Com_MC_SuitCell:onShow()
	self.fields.box_ani:setAllFrameNameOnce("dh_zhaiyueqd7_0%02d.png", 0, true)
end
function Com_MC_SuitCell:initData(cfg, beastId, level)
	self.fields.Text_score:setString(cfg.need_lv)
	self.beastId = beastId
	self.cfg = cfg
	self.controllers.c2:setSelectedIndex(cfg.quality == 3 and 1 or 0)
	local isGotReward = divineBeastMarkCtrl:getIsGotSuitReward(beastId, cfg.quality, cfg.need_lv)
	local c1Index = level < cfg.need_lv and 0 or isGotReward and 2 or 1
	self.controllers.c1:setSelectedIndex(c1Index)
	local str = i18n(cfg.introduce)
	self.fields.text_des:setString(str)
end
function Com_MC_SuitCell:onClickMask()
	SoraDPlaySound()
	_ENV = nil
	;(nil).data = self.cfg.reward
	;(nil).btnTitle = i18n("common_text_1146")
	;(nil).callback = function()
		dump(self.cfg, "self.cfg")
		divineBeastMarkCtrl:sendSuitReward(self.beastId, self.cfg.quality, self.cfg.need_lv)
	end
	uiManager:show("CommonPopBox2", nil)
end
return Com_MC_SuitCell
