local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local redPackageActivityCtrl = gametop.playertop_:getModule("redPackageActivityCtrl")
local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
local redPackageRead = include("redPackageRead")
local rechargeRead = include("rechargeRead")
local eventRedPackage = class("eventRedPackage", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventRedPackage")
	end
	return target
end)
function eventRedPackage:ctor()
	self:bindBtnClose()
	_ENV = self.bindBtnClose
	self.bindBtnClose.claim = 1
	self.bindBtnClose.go = 2
	self.taskArray, _ENV, self.btnStatusDef, self.bindBtnClose.received = self.bindBtnClose, self.bindBtnClose, self.bindBtnClose, 3
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_eventRedPackage")
	self.ccs_title:setTitle(i18n("common_text_4097"))
	self.ccs_title:setTitleWidthHeight(cc.size(450, 100))
	self.panel_cut = SoraDGetChildByName(self, "Panel_cut")
	self.Image_eventBg = SoraDGetChildByName(self, "Image_event")
	self.Image_eventBg:loadTexture(SoraDCheckPNG("bg_activity_show_9001069.png", gDefaultPNG.ACTIVITY_BG), ccui.TextureResType.plistType)
	self.node_line = SoraDGetChildByName(self, "Node_line")
	self.bottom_frm = SoraDGetChildByName(self, "Bottom_frm")
	self.node_task = SoraDGetChildByName(self, "Node_task")
	self.img_timeBg = SoraDGetChildByName(self, "Image_timeBg")
	self.node_time = SoraDGetChildByName(self, "Node_time")
	self.node_time:setVisible(false)
	self.text_leftTime = SoraDGetChildByName(self.node_time, "Text_timeLeft")
	self.text_leftTime:setString(i18n("common_text_2669"))
	self.text_time = SoraDGetChildByName(self.node_time, "Text_time")
	self.text_time = SoraDCreateTimerLabel(self, self.text_time)
	self.panel_content = SoraDGetChildByName(self, "Panel_content")
	self.text_title = SoraDGetChildByName(self.panel_content, "Text_title")
	self.text_title:setString(i18n("common_text_4098"))
	self.node_cer = SoraDGetChildByName(self.panel_content, "Node_cer")
	self.text_cerPackage = SoraDGetChildByName(self.node_cer, "Text_cerPackage")
	self.text_cerPackage:setString(i18n("common_text_4100"))
	self.text_packageName = SoraDGetChildByName(self.node_cer, "Text_packageName")
	self.text_info = SoraDGetChildByName(self.panel_content, "Text_info")
	self.text_info:setString(i18n("common_text_4099"))
	self.text_task = SoraDGetChildByName(self, "Text_task")
	self.text_task:setString(i18n("common_text_4101"))
	self.text_reset = SoraDGetChildByName(self, "Text_reset")
	self.text_reset:setString(i18n("common_text_4102"))
	self.single = SoraDGetChildByName(self, "Panel_single")
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView_award")
	self:initData()
	self:setAutoSize()
	self:initView()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_REDPACKAGE_REFRESH", handler(self, self.refreshView))
end
function eventRedPackage:setAutoSize()
	local offsetY = math.min(display.height - 960, 176)
	self.panel_cut:setContentSize(cc.size(display.width, 150 + offsetY))
	self.Image_eventBg:setPositionY(self.panel_cut:getContentSize().height + math.max(0, 176 - offsetY) * 0.5)
	self.img_timeBg:setPositionY(0)
	self.node_time:setPositionY(15)
	self.node_line:setPositionY(display.height - self.panel_cut:getContentSize().height - 83)
	self.panel_content:setPositionY(self.node_line:getPositionY() - self.panel_content:getContentSize().height - 25)
	self.node_task:setPositionY(self.panel_content:getPositionY() - 27)
	self.scroll:setContentSize(cc.size(self.scroll:getContentSize().width, self.node_task:getPositionY() - 65))
	self.bottom_frm:setContentSize(cc.size(self.bottom_frm:getContentSize().width, self.node_line:getPositionY()))
	if display.height < 960 then
		self.panel_cut:setContentSize(cc.size(display.width, 150))
		self.Image_eventBg:setPositionY(240)
		self.node_line:setPositionY(display.height + self.panel_cut:getPositionY() - 150)
		self.panel_content:setPositionY(self.node_line:getPositionY() - 200)
		self.bottom_frm:setContentSize(cc.size(self.bottom_frm:getContentSize().width, self.node_line:getPositionY()))
		self.node_task:setPositionY(self.panel_content:getPositionY() - 30)
		self.scroll:setContentSize(cc.size(self.scroll:getContentSize().width, display.height - 525))
	end
	SoraDGetChildByName(self, "Size_Image_frm_left"):setContentSize(cc.size(290, self.scroll:getContentSize().height))
	SoraDGetChildByName(self, "Size_Image_frm_right"):setContentSize(cc.size(290, self.scroll:getContentSize().height))
end
function eventRedPackage:initData()
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.RED_PACKAGE_ACTIVITY)
	if eventTime then
		self.node_time:setVisible(true)
		self.text_time:beginTime(eventTime.timerNode.timer:getRemainTime())
		SoraDToCenter(self.node_time, 10, SoraDFIsRA())
	end
	self.rid = activityShowCtrl:getRedPackageRid()
	local giftName = ""
	local offsetY = 0
	for k, v in ipairs(self.rid) do
		local giftStyle = rechargeRead.getPageViewData(v)
		if k == 3 then
			local str = ""
			str = giftName .. "   " .. i18n(giftStyle.activeName)
			self.text_packageName:setString(str)
			if self.text_packageName:getVirtualRendererSize().width > 430 then
				str = giftName .. "\n" .. i18n(giftStyle.activeName)
				offsetY = 16
			end
			giftName = str
		elseif k == 1 then
			giftName = i18n(giftStyle.activeName)
		else
			giftName = giftName .. "   " .. i18n(giftStyle.activeName)
		end
	end
	self.text_packageName:setString(giftName)
	if #self.rid == 3 then
		self.node_cer:setPositionY(100 + offsetY)
		self.text_packageName:setTextAreaSize(cc.size(430, 50))
	else
		self.node_cer:setPositionY(100)
		self.text_packageName:setTextAreaSize(cc.size(430, 25))
	end
end
function eventRedPackage:refreshView(target, data)
	SoraDCloseLoading(self)
	for k, v in ipairs(self.taskArray) do
		if v then
			local taskInfo = redPackageActivityCtrl:getInfoByTaskID(v.taskID)
			local status = self.btnStatusDef.go
			if taskInfo.taskFinish >= taskInfo.taskMax then
				if taskInfo.received then
					status = self.btnStatusDef.received
				else
					status = self.btnStatusDef.claim
				end
			end
			v.setBtnStatus(status)
			v.setPercent(taskInfo.taskFinish, taskInfo.taskMax)
		end
	end
	if data and data.reward then
		SoraDMailGainItems(data.reward, true)
	end
end
function eventRedPackage:initView()
	self.taskID = redPackageActivityCtrl:getAllTaskID()
	local singleHeight = 145
	local scrollH = math.max(self.scroll:getContentSize().height, #self.taskID * singleHeight)
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollH))
	for k, v in ipairs(self.taskID) do
		local single = self:getSingle(k == #self.taskID)
		local taskInfo = redPackageActivityCtrl:getInfoByTaskID(v)
		single:setPosition(cc.p(0, scrollH - k * singleHeight + 5))
		single.taskID = v
		single.setDes(redPackageRead.getTaskDesByID(v))
		single.setAwards(taskInfo.reward)
		single:addTo(self.scroll)
		self.taskArray[k] = single
	end
	self:refreshView()
end
function eventRedPackage:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.RED_PACKAGE_ACTIVITY) then
		self:removeFromParent()
	end
end
function eventRedPackage:getSingle(isLast)
	local single = self.single:clone()
	single.award, _ENV = self.single, self.single
	local text_plan = SoraDGetChildByName(single, "Text_plan")
	text_plan:setString(i18n("common_text_3780"))
	local text_cur = SoraDGetChildByName(single, "Text_cur")
	local text_total = SoraDGetChildByName(single, "Text_total")
	local text_des = SoraDGetChildByName(single, "Text_des")
	local node_bottom_line = SoraDGetChildByName(single, "Node_bottom_line")
	node_bottom_line:setVisible(isLast)
	local btn_go = SoraDGetChildByName(single, "Button_go")
	SoraDAutoSizeButtonText(btn_go, cc.size(120, 50))
	function single.setPercent(cur, total)
		if cur == 0 then
			text_cur:setColor(cc.c3b(246, 6, 6))
		else
			text_cur:setColor(cc.c3b(255, 190, 0))
		end
		if total < cur then
			cur = total
		end
		text_cur:setString(cur)
		text_total:setString("/" .. total)
		text_cur:setPositionX(20)
		text_total:setPositionX(text_cur:getPositionX() + text_cur:getContentSize().width)
		text_plan:setPositionX(text_total:getPositionX() + text_total:getContentSize().width)
		if not SoraDFIsRA() then
			text_total:setPositionX(620)
			text_cur:setPositionX(text_total:getPositionX() - text_total:getContentSize().width)
			text_plan:setPositionX(text_cur:getPositionX() - text_cur:getContentSize().width - 10)
		end
	end
	function single.setDes(des)
		single.des = des
		text_des:setString(des)
	end
	function single.setAwards(awards)
		local index = 1
		for i = 1, #awards - 1, 2 do
			local award = include("rewardItem").new()
			award:hideLabName()
			award:setItemStyle(3)
			award:setScale(0.8)
			_ENV = 0.8
			;(0.8).itemID = awards[i]
			;(0.8).num = awards[i + 1]
			award:initData(0.8)
			award:setPosition(cc.p(120 + index * 90, 40))
			if not SoraDFIsRA() then
				award:setPosition(cc.p(-10 + index * 90, 40))
			end
			award:setTag(awards[i])
			award:setItemCallBack(function()
				if single.tips then
					single.tips:removeFromParent()
					single.tips = nil
				end
			end)
			award:setItemTouchBeginHandle(function(target)
				if single.tips then
					single.tips:removeFromParent()
					single.tips = nil
				end
				single.tips = SoraDCreatePanel("commonItemTips")
				single.tips:initData(target:getTag())
				local posX = target:getPositionX() - 50
				if posX < 300 then
					posX = posX + 380
				end
				if not SoraDFIsRA() then
					posX = target:getPositionX() + 50
					if 310 < posX then
						posX = posX - 380
					end
				end
				single.tips:setPosition(cc.p(posX, 140))
				single.tips:addTo(single, 99)
			end)
			award:addTo(single)
			single.award[index] = award
			index = index + 1
		end
	end
	function single.setBtnStatus(status)
		single.status = status
		if status == self.btnStatusDef.received then
			btn_go:setTitleText(i18n("common_text_1892"))
			btn_go:setTitleColor(cc.c3b(110, 110, 110))
			btn_go:loadTextures("", "", "", ccui.TextureResType.plistType)
			btn_go:setTouchEnabled(false)
		elseif status == self.btnStatusDef.claim then
			btn_go:setTitleText(i18n("common_text_1146"))
			btn_go:setTitleColor(cc.c3b(255, 255, 255))
			btn_go:loadTextures("btn_green_small_01.png", "", "", ccui.TextureResType.plistType)
			btn_go:setTouchEnabled(true)
			btn_go:addTouchEventListener(function(target, event)
				if event == ccui.TouchEventType.ended then
					SoraDPlaySound()
					SoraDShowLoading(self)
					redPackageActivityCtrl:sendReceiveMsg(single.taskID)
				end
			end)
		elseif status == self.btnStatusDef.go then
			btn_go:setTitleText(i18n("common_text_477"))
			btn_go:setTitleColor(cc.c3b(255, 255, 255))
			btn_go:loadTextures("btn_red_small_01.png", "", "", ccui.TextureResType.plistType)
			btn_go:setTouchEnabled(true)
			btn_go:addTouchEventListener(function(target, event)
				if event == ccui.TouchEventType.ended then
					SoraDPlaySound()
					if single.taskID == RED_PACKAGE_TASK_TYPE.RECHARGE_RED_PACKAGE then
						if not rechargeActivityCtrl:getNormalAndAllianceRechargeActivityList() then
							local _ENV, copyActivityList = rechargeActivityCtrl:getNormalAndAllianceRechargeActivityList(), rechargeActivityCtrl:getNormalAndAllianceRechargeActivityList()
						end
						if self.rid and next(self.rid) and next(copyActivityList) then
							local reID = 0
							for k, v in pairs(copyActivityList) do
								reID = v.ID
								break
							end
							math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
							local index = math.random(#self.rid)
							if copyActivityList[tostring(self.rid[index])] then
								reID = self.rid[index]
							end
							if GLOBAL_GAME_RECHARGE_MODE then
								_ENV = 6
								;(6).id = reID
								;(6).fromCenter = gRechargeActiveFromEnum.ROAD17
								uiManager:show("rechargePopFrame", 6)
							else
								local panel = SoraDCreatePanel("rechargePopFrame")
								panel:initData(reID, gRechargeActiveFromEnum.ROAD17)
								panel:show()
							end
						end
					else
						SoraDRemoveAllPrePanelFromManager(self)
						local panel = SoraDCreatePanel("chatView")
						panel:show()
						panel:init()
					end
				end
			end)
		end
	end
	function single.setSkipHandler(handler)
		single.skipHandler = handler
	end
	return single
end
return eventRedPackage
