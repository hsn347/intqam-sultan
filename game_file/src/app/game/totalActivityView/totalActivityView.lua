local gametop = gModuleMgr.getObject("gametop")
local cumuActiveCtrl = gametop.playertop_:getModule("cumuActiveCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
_ENV, _ENV = "activityShowCtrl", gametop.playertop_
;("activityShowCtrl").recharge = "bg_activity_show_cumu_recharge.png"
_ENV, gametop.playertop_[1], ("activityShowCtrl").comsum = "activityShowCtrl", "activityShowCtrl", "bg_activity_show_cumu_comsum.png"
_ENV, gametop.playertop_[2], ("activityShowCtrl").png = "activityShowCtrl", "activityShowCtrl", "bg_cumu_eagle.png"
_ENV, gametop.playertop_[3], ("activityShowCtrl").png = "activityShowCtrl", "activityShowCtrl", "bg_cumu_castle.png"
_ENV, gametop.playertop_[4], ("activityShowCtrl").png = "activityShowCtrl", "activityShowCtrl", "bg_cumu_leopard.png"
_ENV, gametop.playertop_[5], ("activityShowCtrl").png = "activityShowCtrl", "activityShowCtrl", "bg_cumu_leopard.png"
_ENV, gametop.playertop_[6], ("activityShowCtrl").png = "activityShowCtrl", "activityShowCtrl", "bg_cumu_eagle.png"
_ENV, gametop.playertop_[7], ("activityShowCtrl").png = "activityShowCtrl", "activityShowCtrl", "bg_cumu_leopard.png"
_ENV, gametop.playertop_[8], ("activityShowCtrl").png = "activityShowCtrl", "activityShowCtrl", "bg_cumu_eagle.png"
_ENV, gametop.playertop_[9], ("activityShowCtrl").png = "activityShowCtrl", "activityShowCtrl", "bg_cumu_leopard.png"
_ENV, gametop.playertop_[10], ("activityShowCtrl").png = "activityShowCtrl", "activityShowCtrl", "bg_activity_show_cumu_recharge.png"
_ENV, gametop.playertop_[11], ("activityShowCtrl").png = "activityShowCtrl", "activityShowCtrl", "bg_activity_show_cumu_recharge.png"
_ENV, gametop.playertop_[12], ("activityShowCtrl").png = "activityShowCtrl", "activityShowCtrl", "bg_activity_middle_recharge.png"
gametop.playertop_[13], ("activityShowCtrl").png = "activityShowCtrl", "bg_activity_show_cumu_recharge.png"
local scencepicDef = gametop.playertop_
local totalActivityView = class("totalActivityView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("totalActivityView")
	end
	return target
end)
function totalActivityView:ctor()
	self.title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_bag")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnHelp:addTouchEventListener(handler(self, self.getHelpInfo))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_items")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("totalSingle")
	self.Image_event = SoraDGetChildByName(self, "Image_event")
	self.Node_limit = SoraDGetChildByName(self, "Node_limit")
	self.Text_limit_tips = SoraDGetChildByName(self.Node_limit, "Text_limit_tips")
	self.Node_limit:setVisible(false)
	self.Text_tips = SoraDGetChildByName(self, "Text_tips")
	self.Node_time = SoraDGetChildByName(self, "Node_time")
	self.Text_labTime = SoraDGetChildByName(self.Node_time, "Text_labTime")
	self.Text_labTime = SoraDCreateTimerLabel(self, self.Text_labTime)
end
function totalActivityView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_CUMUACTIVITY_REFRESH", handler(self, self.refreshView))
end
function totalActivityView:refreshView(target, data)
	if activityShowCtrl:isActivityOpen(self.activityID) then
		self:initData()
	else
		self:removeFromParent()
	end
end
function totalActivityView:initData(activityID)
	if activityID then
		self.activityID = activityID
	end
	if gActivityTimeActivityID.CUMU_ACTIVITY_RECHARGE == self.activityID then
		self.cumuType = gCumuActivityType.CUMURECHARGE
	else
		self.cumuType = gCumuActivityType.CUMUCONSUM
	end
	local activityData = activityShowCtrl:getActivityData(self.activityID)
	self.scencepic = tonumber(activityData and activityData.param and activityData.param.scencepic) or 1
	if not (activityData and activityData.param) or not activityData.param.rewardconfig then
		_ENV = activityData.param.rewardconfig
	end
	self.awardList = activityData.param.rewardconfig
	self.totoalScale = #self.awardList
	self.cumuScale = cumuActiveCtrl:getCumuScale(self.activityID)
	dump(self.awardList, "totalActivityView:initData awardList")
	self:initView()
	self:initTime()
	self:initAward()
end
function totalActivityView:initTime()
	local _eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.Text_labTime:beginTime(_eventTime.timerNode.timer:getRemainTime())
	SoraDToCenter(self.Node_time)
end
function totalActivityView:initAward()
	_ENV = nil
	;(nil).view = self
	;(nil).scroll = self.scroll
	;(nil).cumuType = self.cumuType
	;(nil).activityID = self.activityID
	self.scroll:updateScrollView(cc.size(640, 250), self.awardList, 1, nil)
	self.scroll:jumpIndexToBottom(math.min(self.totoalScale, self.cumuScale + 1))
end
function totalActivityView:initView()
	local loadCommon = function()
		if self.cumuType % 2 == 1 then
			self.Image_event:loadTexture(scencepicDef[1].recharge, ccui.TextureResType.plistType)
		else
			self.Image_event:loadTexture(scencepicDef[1].comsum, ccui.TextureResType.plistType)
		end
	end
	if self.scencepic == 1 then
		loadCommon()
	elseif not scencepicDef[self.scencepic] then
		self.scencepic = 1
		loadCommon()
	else
		self.Image_event:loadTexture(scencepicDef[self.scencepic].png, ccui.TextureResType.plistType)
	end
	if self.cumuType == gCumuActivityType.CUMURECHARGE then
		self.title:setTitle(i18n("mail_text_87"))
		self.Text_tips:setString(i18n("common_text_1176"))
	end
	if self.cumuType == gCumuActivityType.CUMUCONSUM then
		self.title:setTitle(i18n("mail_text_88"))
		self.Text_tips:setString(i18n("common_text_1172"))
	end
	if self.cumuType == gCumuActivityType.IOS_CUMURECHARGE then
		self.title:setTitle(i18n("common_text_1756"))
		self.Text_tips:setString(i18n("common_text_1176"))
		self.Node_limit:setVisible(true)
		self.Text_limit_tips:setString(i18n("common_text_1757"))
	end
	if self.cumuType == gCumuActivityType.IOS_CUMUCONSUM then
		self.title:setTitle(i18n("common_text_1758"))
		self.Text_tips:setString(i18n("common_text_1172"))
		self.Node_limit:setVisible(true)
		self.Text_limit_tips:setString(i18n("common_text_1759"))
	end
	if self.cumuType == gCumuActivityType.ANDROID_CUMURECHARGE then
		self.title:setTitle(i18n("common_text_1866"))
		self.Text_tips:setString(i18n("common_text_1176"))
		self.Node_limit:setVisible(true)
		self.Text_limit_tips:setString(i18n("common_text_1867"))
	end
	if self.cumuType == gCumuActivityType.ANDROID_CUMUCONSUM then
		self.title:setTitle(i18n("common_text_1869"))
		self.Text_tips:setString(i18n("common_text_1172"))
		self.Node_limit:setVisible(true)
		self.Text_limit_tips:setString(i18n("common_text_1870"))
	end
end
function totalActivityView:getHelpInfo(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local msg
		_ENV = nil
		;(nil)[gCumuActivityType.CUMURECHARGE] = i18n("common_text_1177")
		;(nil)[gCumuActivityType.CUMUCONSUM] = i18n("common_text_1172")
		;(nil)[gCumuActivityType.IOS_CUMURECHARGE] = i18n("common_text_1797")
		;(nil)[gCumuActivityType.IOS_CUMUCONSUM] = i18n("common_text_1796")
		;(nil)[gCumuActivityType.ANDROID_CUMURECHARGE] = i18n("common_text_1868")
		local (nil)[gCumuActivityType.ANDROID_CUMUCONSUM], msgDef = i18n("common_text_1871"), nil
		msg = self.cumuType and msgDef[self.cumuType]
		if msg then
			_ENV = "common_text_1871"
			;("common_text_1871").align = SoraDFLabelR()
			SoraDShowHelpMsgTip(msg, "common_text_1871")
		end
	end
end
return totalActivityView
