local expostulationLogic = include("expostulationLogic")
local baseComponent = require("fgui.base.baseComponent")
local Com_bless = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Activity_9001128/Com_bless", Com_bless)
function Com_bless:onInit()
	self.fields.mv_sx:setAllFrameName("zhufujmsx%.2d.png", 0)
	self.fields.mv_sx:setVisible(false)
	self:addClickListener(handler(self, self.btnClick))
end
function Com_bless:onShow()
end
function Com_bless:setType(index)
	self.controllers.c1:setSelectedIndex(index)
end
function Com_bless:setStatus(status, discountStr)
	self.controllers.c2:setSelectedIndex(status)
	if discountStr then
		self.fields.Text_reduce:setString(discountStr)
	end
end
function Com_bless:setEffect(effectType)
	self.effectType = effectType
end
function Com_bless:playFlash(handle)
	self.fields.Text_reduce:setAlpha(0)
	self.fields.title:setAlpha(0)
	self.fields.wh:setVisible(false)
	self.fields.mv_sx:setVisible(true)
	self.fields.mv_sx:setPlaySettings(0, -1, 1, -1, function()
		if handle then
			handle()
		end
		self.fields.mv_sx:setVisible(false)
		self.fields.Text_reduce:runAction(ffa.fadeIn(0.2))
		self.fields.title:runAction(ffa.fadeIn(0.2))
	end)
end
function Com_bless:btnClick()
	if self.controllers.c1:getSelectedIndex() == 0 and self.controllers.c2:getSelectedIndex() == 2 then
		SoraDPlaySound()
		if self.effectType == gLuckyBlessActivityEffectType.BUILD_UPGRADE then
			expostulationLogic.jumpToBuild()
			SoraDRemoveAllPanelFromManager()
		elseif self.effectType == gLuckyBlessActivityEffectType.TECHNOLOGY_RESEARCH then
			expostulationLogic.jumpToCollege()
			SoraDRemoveAllPanelFromManager()
		elseif self.effectType == gLuckyBlessActivityEffectType.TRAIN_SOLDIERS then
			expostulationLogic.jumpToCamp(true)
			SoraDRemoveAllPanelFromManager()
		elseif self.effectType == gLuckyBlessActivityEffectType.BUILD_STRENGTH then
			gModuleMgr.sharedMgr("mildGuideManager"):starToCanUpgradeStar()
			SoraDRemoveAllPanelFromManager()
		elseif self.effectType == gLuckyBlessActivityEffectType.MAKE_A_WISH then
			if not SoraDGetCtrl("cityCtrl"):getBuildCell(BUILDID.WISHING_WELL, 0) then
				SoraDShowMsgTip(i18n("common_text_4846"))
				return
			end
			_ENV = i18n("common_text_4846")
			gModuleMgr.sharedMgr("mildGuideManager"):starMildByNewPlayerQuestID(gNewPLayerTaskType.MAKE_A_WISH, i18n("common_text_4846"))
			SoraDRemoveAllPanelFromManager()
		end
	end
end
return Com_bless
