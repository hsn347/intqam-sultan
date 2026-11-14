local gametop = gModuleMgr.getObject("gametop")
local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local rechargeltCtrl = include("rechargeltCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local presentGiftMainPopView = class("presentGiftMainPopView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("presentGiftMainPopView")
end)
function presentGiftMainPopView:ctor(properties)
	self.award, _ENV, self.activityID = gActivityTimeActivityID.PRESENT_GIFT_ACTIVITY, gActivityTimeActivityID.PRESENT_GIFT_ACTIVITY, gActivityTimeActivityID.PRESENT_GIFT_ACTIVITY
	self.nodeReward = SoraDGetChildByName(self, "Node_award")
	self.singleReward = SoraDGetChildByName(self.nodeReward, "CCS_commonItemAward_1")
	self.singleReward:setVisible(false)
	self.sprBg = SoraDGetChildByName(self, "Sprite_bg")
	self.btnGo = SoraDGetChildByName(self, "btnGo")
	self.txtGo = SoraDGetChildByName(self, "Text_go")
	self.txtPs = SoraDGetChildByName(self, "Text_ps")
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Image_title = SoraDGetChildByName(self, "Image_title")
	self.Image_title:ignoreContentAdaptWithSize(true)
	self.txtStartime = SoraDGetChildByName(self, "Text_startime")
	self.txtStartime:setVisible(false)
	self.txt_5 = SoraDGetChildByName(self, "Text_5_0")
	self.txt_5:setVisible(false)
	self.txtEndtime = SoraDGetChildByName(self, "Text_endtime")
	self.txtEndtime:setVisible(false)
	self.btnGo:addTouchEventListener(handler(self, self.btnGoClick))
	self:initAni()
	self:onSetBtn()
	self.txtPs:setString(i18n("daily_Recharege_02"))
	self:upDataReward()
	self:beginTime()
	self:initTitle()
	SoraDCreatAnimation(self.__cname, self, false)
end
function presentGiftMainPopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_CLIENT_RECHARGECENTER_DAYFIRST", handler(self, self.onSetBtn))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.newDay))
end
function presentGiftMainPopView:initAni()
	self.aniQiqiu = SoraDGetChildByName(self, "FileNode_qiqiu")
	self.aniCaidai = SoraDGetChildByName(self, "aniCaidai")
	self.aniBottom = SoraDGetChildByName(self, "FileNode_bottom")
	self.aniTop = SoraDGetChildByName(self, "FileNode_top")
	SoraDCreatAnimation("Node_Effect_qiqiu", self.aniQiqiu, true)
	SoraDCreatAnimation("Node_Effect_kzhl_bottom", self.aniBottom, true)
	SoraDCreatAnimation("Node_Effect_kzhl_top", self.aniTop, false)
	local spine_caidai = sp.SkeletonAnimation:create("spine/caidai.skel", "spine/caidai.atlas", 1)
	spine_caidai:setAnimation(0, "animation", true)
	spine_caidai:addTo(self.aniCaidai)
end
function presentGiftMainPopView:onSetBtn()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
	local flag = rechargeActivityCtrl:getIsPresentGift()
	self.btnGo:setEnabled(flag)
	if not flag then
		SoraDCreateGraySprite(self.sprBg)
	else
		SoraDNormalSprite(self.sprBg)
	end
	self.txtGo:setColor(flag and cc.c3b(255, 239, 167) or cc.c3b(255, 255, 255))
	if flag then
		self.txtGo:setString(i18n("common_text_477"))
		self.aniBottom:setVisible(true)
		self.aniTop:setVisible(true)
	else
		self.aniBottom:setVisible(false)
		self.aniTop:setVisible(false)
		local endTime = activityShowCtrl:getEndTimeSecond(self.activityID)
		print("presentGiftMainPopView:onSetBtn", self:isInWeehours(endTime))
		print(os.date("!%Y-%m-%d %H:%M:%S", endTime))
		print(os.date("!%Y-%m-%d %H:%M:%S", serviceFunctions.systemTime()))
		if serviceFunctions.isSameDay(endTime) then
			self.txtGo:setString(i18n("Anchor_text_21"))
		elseif self:isInWeehours(endTime) and endTime - serviceFunctions.systemTime() < 86400 then
			self.txtGo:setString(i18n("Anchor_text_21"))
		else
			self.txtGo:setString(i18n("daily_Recharege_03"))
		end
	end
end
function presentGiftMainPopView:newDay()
	print("presentGiftMainPopView新的一天")
	if clientEventMgr.judgeIsOpen(self.activityID) then
		self.btnGo:setEnabled(true)
		SoraDNormalSprite(self.sprBg)
		self.txtGo:setColor(cc.c3b(255, 239, 167))
		self.txtGo:setString(i18n("common_text_477"))
		self.aniBottom:setVisible(true)
		self.aniTop:setVisible(true)
	end
end
function presentGiftMainPopView:isInWeehours(time)
	if time == 0 then
		return false
	end
	local ret = false
	local hour = os.date("!%H", time)
	local minute = os.date("!%M", time)
	local second = os.date("!%S", time)
	if hour == "00" and minute == "00" and second == "00" then
		ret = true
	end
	return ret
end
function presentGiftMainPopView:upDataReward()
	local data = rechargeltCtrl.getRechargeFirstDailyConfig()
	_UPVALUE2_ = nil
	;(nil)[1] = "itemid"
	;(nil)[2] = "count"
	local rewardData = serviceFunctions.tableFormat(data[1].result, nil)
	function checkIsShowLight(itemId)
		if data[1].show then
			for i, v in ipairs(data[1].show) do
				if v == itemId then
					return true
				end
			end
		else
			return false
		end
	end
	for index = 1, table.nums(rewardData) do
		local itemAward = self.award[index]
		if itemAward then
			itemAward:initData(rewardData[index].itemid, rewardData[index].count)
		else
			itemAward = include("commonItemAward").new()
			itemAward:setRealScale(0.8)
			itemAward:setPresentgiftModel()
			itemAward:setOwnView(self)
			itemAward:setPosition(0, 0)
			itemAward:addTo(self.nodeReward)
			itemAward:initData(rewardData[index].itemid, rewardData[index].count)
			if checkIsShowLight(rewardData[index].itemid) then
				itemAward:showNewCoolSquare()
				itemAward:setCoolSquareScale(0.98)
			else
				itemAward:hideCoolSquare()
			end
			self.award[index] = itemAward
		end
	end
	SoraDToCenter(self.nodeReward, 100, SoraDFIsRA())
end
function presentGiftMainPopView:initTitle()
	self.Image_title:loadTexture(SoraDFIsRA() and "frame_9001293_font_ar.png" or "frame_9001293_font_en.png", ccui.TextureResType.plistType)
end
function presentGiftMainPopView:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function presentGiftMainPopView:updateTime()
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	local str
	if not eventTime then
		self:endTime()
		if self.Text_time then
			self.Text_time:setString("00:00:00")
		end
		return
	end
	local remainTime = eventTime.timerNode.timer:getRemainTime()
	if remainTime then
		str = SoraDConvertSecondToString(remainTime)
	end
	if self.Text_time then
		self.Text_time:setString(str)
	end
end
function presentGiftMainPopView:endTime()
	SoraDManagerRemoveTimer(self, self.timeHandler)
end
function presentGiftMainPopView:btnGoClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		local flag = rechargeActivityCtrl:getIsPresentGift()
		if flag then
			SoraDPlaySound()
			if GLOBAL_GAME_RECHARGE_MODE then
				uiManager:show("rechargeView")
			else
				SoraDCreatePanel("rechargeView"):show()
			end
		end
	end
end
function presentGiftMainPopView:msgCallBack(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return presentGiftMainPopView
