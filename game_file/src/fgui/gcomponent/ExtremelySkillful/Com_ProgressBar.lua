local extremelySkillfulRead = include("extremelySkillfulRead")
local ExtremelySkillfulCtrl = SoraDGetCtrl("ExtremelySkillfulCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_ProgressBar = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ExtremelySkillful/Com_ProgressBar", Com_ProgressBar)
function Com_ProgressBar:onInit()
	self:fixChildrenPos()
	self.fields.ProgressBar:getChild("bar"):fixPos()
	self.fields.Button_add:addClickListener(handler(self, self.onClickAdd))
end
function Com_ProgressBar:onShow()
end
function Com_ProgressBar:updateData()
	local maxValue = extremelySkillfulRead.getNextExp(ExtremelySkillfulCtrl:getLevel(), ExtremelySkillfulCtrl:getGroupIndex())
	self.fields.ProgressBar:setMax(maxValue)
	self.fields.ProgressBar:setValue(ExtremelySkillfulCtrl:getExp())
	self.fields.title:setString(ExtremelySkillfulCtrl:getLevel())
end
function Com_ProgressBar:onClickAdd()
	SoraDPlaySound()
	self:jumpToGift()
end
function Com_ProgressBar:getGiftInfo()
	local giftInfo = SoraDGetCtrl("rechargeActivityCtrl"):getHotActivityList()
	_UPVALUE3_ = nil
	;(nil)[1] = 19187
	;(nil)[2] = 19186
	;(nil)[3] = 19185
	for _, v in ipairs(nil) do
		local item = giftInfo[tostring(v)]
		if item and tonumber(item.extraData) >= 1 then
			return item
		end
	end
end
function Com_ProgressBar:jumpToGift()
	local giftData = self:getGiftInfo()
	if giftData then
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = nil
			;(nil).rechargeID = tonumber(giftData.ID)
			uiManager:show("rechargeView", nil)
		else
			local panel = SoraDCreatePanel("rechargeView")
			panel:jumpToLimitNode(giftData.category, tonumber(giftData.ID))
			panel:show()
		end
	else
		SoraDShowMsgTip(i18n("HeroVault_text_03"))
	end
end
return Com_ProgressBar
