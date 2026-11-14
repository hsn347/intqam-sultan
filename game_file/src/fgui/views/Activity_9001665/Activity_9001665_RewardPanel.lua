local activity_9001665_Read = include("activity_9001665_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001665_RewardPanel = class("Activity_9001665_RewardPanel", baseFguiPanel)
local activity_9001665_Ctrl = SoraDGetCtrl("activity_9001665_Ctrl")
function Activity_9001665_RewardPanel:ctor(...)
	Activity_9001665_RewardPanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001665_RewardPanel:ctor", self.viewName)
end
function Activity_9001665_RewardPanel:onInit()
	print("=======Activity_9001665_RewardPanel:onInit")
	self.fields.n17:setAllFrameNameOnce("Activity_9001665_glow_%02d.png", 0, true)
	self.fields.listStar:setItemRenderer(handler(self, self.itemRenderer_listStar))
end
function Activity_9001665_RewardPanel:onShow()
	print("=======Activity_9001665_RewardPanel:onShow")
	self:updateView()
	self.fields.bg:runAction(ffa.seq(ffa.delay(1), ffa.callFunc(function()
		self.fields.bg:setVisible(false)
	end)))
end
function Activity_9001665_RewardPanel:itemRenderer_listStar(index, obj)
end
function Activity_9001665_RewardPanel:updateView()
	local isWin = self.param.extraData.isWin
	self.controllers.c2:setSelectedIndex(isWin and 0 or 1)
	if not isWin then
		self.fields.text_losetips:setString(i18n("fishingmaster_text_13"))
		return
	end
	self.controllers.c1:setSelectedIndex(self.param.extraData.hard - 1)
	local curUseTime = math.floor(self.param.extraData.passTime * 100)
	local finalScore = self.param.extraData.difficultPoint + self.param.extraData.operatePoint
	local maxScore = activity_9001665_Ctrl:getMaxScore()
	if self.param.newRecord then
		self.fields.text_tips:setVisible(true)
		self.fields.text_tips:setString(i18n("fishingmaster_text_11"))
	else
		self.fields.text_tips:setVisible(false)
	end
	local showTime = string.format("%d:%d:%.02f", math.floor(curUseTime / 100 / 3600), math.floor(curUseTime / 100 / 60 % 60), curUseTime / 100 % 60)
	_ENV = i18n("fishingmaster_text_11")
	_ENV, _ENV, i18n("fishingmaster_text_11").time = i18n("fishingmaster_text_11")
	i18n("fishingmaster_text_11").num, i18n("fishingmaster_text_11").color = i18n("fishingmaster_text_11")
	self.fields.text_time:setString(i18n_html("fishingmaster_text_15", i18n("fishingmaster_text_11")))
	_ENV = i18n_html("fishingmaster_text_15", i18n("fishingmaster_text_11"))
	_ENV, _ENV, i18n_html("fishingmaster_text_15", i18n("fishingmaster_text_11")).point = self.param.extraData.difficultPoint, string.formatnumberthousands(self.param.extraData.difficultPoint), string.formatnumberthousands(self.param.extraData.difficultPoint)
	string.formatnumberthousands(self.param.extraData.difficultPoint).point, self.param.extraData.difficultPoint.color = self.param.extraData.difficultPoint, "#70C723"
	self.fields.text_hard:setString(i18n_html("fishingmaster_text_09", i18n_html("fishingmaster_text_15", i18n("fishingmaster_text_11"))))
	_ENV = i18n_html("fishingmaster_text_09", i18n_html("fishingmaster_text_15", i18n("fishingmaster_text_11")))
	_ENV, _ENV, i18n_html("fishingmaster_text_09", i18n_html("fishingmaster_text_15", i18n("fishingmaster_text_11"))).point = self.param.extraData.operatePoint, string.formatnumberthousands(self.param.extraData.operatePoint), string.formatnumberthousands(self.param.extraData.operatePoint)
	string.formatnumberthousands(self.param.extraData.operatePoint).point, self.param.extraData.operatePoint.color = self.param.extraData.operatePoint, "#70C723"
	self.fields.text_oprate:setString(i18n_html("fishingmaster_text_10", i18n_html("fishingmaster_text_09", i18n_html("fishingmaster_text_15", i18n("fishingmaster_text_11")))))
	local fishId = self.param.fishId
	local cfg = activity_9001665_Read.getFishCfg(fishId)
	if cfg then
		self.controllers.c1:setSelectedIndex(3)
		self.fields.icon:setURL(cfg.fishPic)
		self.fields.text_name:setString(i18n(cfg.fishName))
		self.fields.listStar:setNumItems(cfg.star)
		self.controllers.ctrlNew:setSelectedIndex(self.param.isNew and 1 or 0)
	else
		self.controllers.ctrlNew:setSelectedIndex(0)
	end
end
return Activity_9001665_RewardPanel
