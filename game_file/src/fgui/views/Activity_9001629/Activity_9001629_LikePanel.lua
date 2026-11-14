local chatFunctions = include("chatFunctions")
local activity_9001629_Ctrl = SoraDGetCtrl("activity_9001629_Ctrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local activity_9001629_Read = include("activity_9001629_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001629_LikePanel = class("Activity_9001629_LikePanel", baseFguiPanel)
function Activity_9001629_LikePanel:ctor(...)
	Activity_9001629_LikePanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001629_LikePanel:ctor", self.viewName)
end
function Activity_9001629_LikePanel:onInit()
	print("=======Activity_9001629_LikePanel:onInit")
	self.fields.btn_like:addClickEventListener(handler(self, self.onLikeClick))
	self.data = self.param.data
	self.wishIdx = self.param.wishIdx
end
function Activity_9001629_LikePanel:onShow()
	print("=======Activity_9001629_LikePanel:onShow")
	self:updateView()
	self.fields.Usm_2:setAlpha(0)
	self.fields.Usm_2:runAction(ffa.fadeIn(0.5))
end
function Activity_9001629_LikePanel:updateView()
	if chatFunctions.getIsPlayerSelf(self.data.uid) then
		self.fields.text_tip:setString(i18n("nebula_stars_wishing_text5"))
	else
		chatFunctions = i18n("nebula_stars_wishing_text5")
		i18n("nebula_stars_wishing_text5").nickName = self.data.name
		i18n("nebula_stars_wishing_text5").allianceAbb = self.data.abbr
		i18n("nebula_stars_wishing_text5").fromKid = self.data.kid
		local nameStr = lordInfoCtrl:getSplitName(i18n("nebula_stars_wishing_text5"))
		chatFunctions = i18n("nebula_stars_wishing_text5")
		i18n("nebula_stars_wishing_text5").name = nameStr
		self.fields.text_tip:setString(i18n("nebula_stars_wishing_text22", i18n("nebula_stars_wishing_text5")))
	end
	for i = 1, 3 do
		local textIdx = self.data.texts[i]
		self.fields["text_" .. i]:setVisible(textIdx ~= nil)
		self.fields["text_" .. i .. "_bg"]:setVisible(textIdx ~= nil)
		if textIdx then
			local textCfg = activity_9001629_Read.getWishingTextList(textIdx)
			self.fields["text_" .. i]:setString(i18n(textCfg.text))
		end
	end
	self.likeCount = self.data.hasLike and self.data.beLikedCount - 1 or self.data.beLikedCount
	self:updateLike(self.data.hasLike)
	self.view:fixChildrenPos()
end
function Activity_9001629_LikePanel:updateLike(isLike)
	dump(isLike, "MESSAGE_ACTIVITY_9001629_LIKE")
	self.isLike = isLike
	self.fields.text_num:setString(tostring(isLike and self.likeCount + 1 or self.likeCount))
	self.fields.icon_like:setURL(isLike and "frame_sdbns_dianzan.png" or "frame_sdbns_dianzan_dianji.png")
end
function Activity_9001629_LikePanel:onLikeClick()
	SoraDPlaySound()
	activity_9001629_Ctrl:reqLike(self.wishIdx, not self.isLike)
	_ENV = self.wishIdx
	self.wishIdx.nickName = self.data.name
	self.wishIdx.allianceAbb = self.data.abbr
	self.wishIdx.fromKid = self.data.kid
	local nameStr = lordInfoCtrl:getSplitName(self.wishIdx)
	if chatFunctions.getIsPlayerSelf(self.data.uid) then
		nameStr = i18n("common_text_142")
	end
	_ENV = nil
	;(nil).name = nameStr
	SoraDShowMsgTip(i18n(not self.isLike and "nebula_stars_wishing_text23" or "nebula_stars_wishing_text24", nil))
end
return Activity_9001629_LikePanel
