local backToTopCtrl = SoraDGetCtrl("backToTopCtrl")
local backToTopRead = include("backToTopRead")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local backToTopView = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewServerReturn/backToTopView", backToTopView)
function backToTopView:onInit()
	self.expRechargeID = 19079
	self.activityID = gActivityTimeActivityID.BACK_TO_TOP_ACTIVITY
	self.fields.Button_info:addClickListener(handler(self, self.onClickInfo))
	self.fields.Button_unlock:setString(i18n("return_peak_05"))
	self.fields.Button_unlock:addClickListener(handler(self, self.onClickUnlock))
	self.fields.Button_add:addClickListener(handler(self, self.onClickAdd))
	self.fields.text_level:setString(i18n("common_text_748"))
	self.fields.text_normal:setString(i18n("return_peak_04"))
	self.fields.text_top:setString(i18n("return_peak_03"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
	self.fields.Button_task:setString(i18n("return_peak_02"))
	self.fields.Button_task:addClickListener(handler(self, self.onClickTask))
	self.fields.Button_claim:setString(i18n("summoned_btn_01"))
	self.fields.Button_claim:addClickListener(handler(self, self.onClickClaim))
	self.fields.icon_lv:setSpriteFrame(SoraDFIsRA() and "framer_xnbxsd_lv_02.png" or "framer_xnbxsd_lv_01.png")
	self.fields.Button_info:fixPos()
	self.fields.Button_add:fixPos()
	self.fields.Text_lv:fixPos()
	self.fields.icon_lv:fixPos()
	self.fields.Label_banner:fix()
	self.fields.Bar_exp:fix()
	self.fields.Button_task:fixPos()
	self.fields.Button_claim:fixPos()
	self.fields.text_level:fixPos()
	self.fields.text_normal:fixPos()
	self.fields.text_top:fixPos()
	self.fields.n51:fixPos()
	self.fields.n52:fixPos()
	self.peakLv = backToTopRead.getPeakLvCfgNum()
end
function backToTopView:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_BACK_TO_TOP_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_BACK_TO_TOP_EXP_GIFT", handler(self, self.initData))
end
function backToTopView:onItemRender(index, obj)
	obj:initData(self.listData[index + 1], self.curLv)
end
function backToTopView:onShow()
	self.fields.Text_time:initActivityTime(self.activityID)
	self:initData()
end
function backToTopView:initData()
	self.exp = backToTopCtrl:getCurExp()
	local lv, curExp, nextExp = backToTopRead.getExpCfg(self.exp)
	self.curLv = lv
	if nextExp then
		backToTopCtrl = nil
		;(nil).lv = lv
		self.fields.Text_lv:setString(i18n("common_text_101", nil))
		self.fields.Bar_exp:setPercent(curExp, nextExp)
	else
		local _lv, _curExp, _nextExp = backToTopRead.getMaxLvAndExp(self.exp)
		self.curLv = _lv
		backToTopCtrl = i18n("common_text_101", nil)
		i18n("common_text_101", nil).lv = _lv
		self.fields.Text_lv:setString(i18n("common_text_101", i18n("common_text_101", nil)))
		self.fields.Bar_exp:setPercent(_curExp, _nextExp)
	end
	self.listData = backToTopRead.getPeakLvCfg()
	self.fields.List:setNumItems(#self.listData)
	if self.curLv > 0 and self.curLv > backToTopCtrl:getRewardLv() and backToTopCtrl:getRewardLv() < self.peakLv or backToTopCtrl:isUnLockTop() and self.curLv > backToTopCtrl:getFurtherRewardLv() then
		self.fields.Button_claim:setEnabled(true)
		backToTopCtrl = true
		;(true).visible = true
		;(true).num = 0
		self.fields.Button_claim:setRedDot(true)
	else
		self.fields.Button_claim:setEnabled(false)
		backToTopCtrl = false
		;(false).visible = false
		;(false).num = 0
		self.fields.Button_claim:setRedDot(false)
	end
	self.fields.Com_extra:initExtra()
	self.fields.lock:setVisible(not backToTopCtrl:isUnLockTop())
	backToTopCtrl = not backToTopCtrl:isUnLockTop()
	;(not backToTopCtrl:isUnLockTop()).visible = 0 < backToTopCtrl:getTaskRewardNum()
	;(not backToTopCtrl:isUnLockTop()).num = 0
	self.fields.Button_task:setRedDot(not backToTopCtrl:isUnLockTop())
	self.fields.Button_unlock:setVisible(not backToTopCtrl:isUnLockTop())
	if not rechargeActivityCtrl:getLogByID(self.expRechargeID) then
		local backToTopCtrl, expGiftInfo = rechargeActivityCtrl:getLogByID(self.expRechargeID), rechargeActivityCtrl:getLogByID(self.expRechargeID)
	end
	local expCount = expGiftInfo.count or 0
	local _, _, _, limited = backToTopRead.getGiftInfo(self.expRechargeID)
	self.fields.Button_add:setVisible(expCount < limited)
end
function backToTopView:onClickInfo()
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("return_peak_01"))
end
function backToTopView:onClickUnlock()
	SoraDPlaySound()
	print("礼包购买弹窗")
	uiManager:show("backToTopPop")
end
function backToTopView:onClickAdd()
	SoraDPlaySound()
	print("跳转到对应的经验礼包")
	uiManager:show("backToTopExp")
end
function backToTopView:onClickTask()
	SoraDPlaySound()
	print("打开任务")
	uiManager:show("backToTopTaskView")
end
function backToTopView:onClickClaim()
	SoraDPlaySound()
	print("领奖")
	backToTopCtrl:sendClaimReward()
end
return backToTopView
