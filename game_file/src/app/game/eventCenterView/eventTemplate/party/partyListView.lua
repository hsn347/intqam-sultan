local gametop = gModuleMgr.getObject("gametop")
local partyCtrl = SoraDGetCtrl("partyCtrl", gametop)
local partyltCtrl = include("partyltCtrl")
local timeCtrl = gametop.playertop_:getModule("timeCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local partyListView = class("partyListView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("partyListView")
	end
	return target
end)
local SCROLL_VIEW_WIDTH = 360
local SCROLL_VIEW_SPEED = 150
local PARTY_FEAST_REFRESH_TIME_CD = 5
_ENV, _ENV, _ENV = nil, nil, nil
_UPVALUE2_, (nil).plist = nil, "et_yanhuirukou_06.plist"
_ENV, (nil).blend, (nil)[1] = nil, nil, gl.ONE
_ENV, (nil).blend, (nil)[2] = nil, nil, gl.ONE
;(nil).x = 4.13
_ENV, (nil).p_down, (nil).scale, (nil).y = nil, nil, nil, 4.13
_UPVALUE2_, (nil).plist = nil, "et_yanhuirukou_15.plist"
_ENV, (nil).blend, (nil)[1] = nil, nil, gl.SRC_ALPHA
_ENV, (nil).blend, (nil)[2] = nil, nil, gl.ONE
;(nil).x = 6.5
_ENV, (nil).p1, (nil).scale, (nil).y = nil, nil, nil, 6.5
_UPVALUE2_, (nil).plist = nil, "et_yanhuirukou_16.plist"
_ENV, (nil).blend, (nil)[1] = nil, nil, gl.SRC_ALPHA
_ENV, (nil).blend, (nil)[2] = nil, nil, gl.ONE
;(nil).x = 7.0
_ENV, (nil).p2, (nil).scale, (nil).y = nil, nil, nil, 7.0
;(nil).tex = "#dh_ganenjie1_03.png"
;(nil).scale = 3.26
;(nil).from = 100
_ENV, _ENV, (nil)[1], (nil).image, (nil).to = nil, nil, nil, nil, 46
_UPVALUE2_, (nil).plist = nil, "et_yanhuirukou_04.plist"
_ENV, (nil).blend, (nil)[1] = nil, nil, gl.ONE
_ENV, (nil).blend, (nil)[2] = nil, nil, gl.ONE
;(nil).x = 4.56
_ENV, (nil).p_down, (nil).scale, (nil).y = nil, nil, nil, 4.56
_UPVALUE2_, (nil).plist = nil, "et_yanhuirukou_09.plist"
_ENV, (nil).blend, (nil)[1] = nil, nil, gl.SRC_ALPHA
_ENV, (nil).blend, (nil)[2] = nil, nil, gl.ONE
;(nil).x = 6.5
;(nil).scale, (nil).y = nil, 6.5
_ENV, (nil).p1, (nil).rotate = nil, nil, 42.61
_UPVALUE2_, (nil).plist = nil, "et_yanhuirukou_10.plist"
_ENV, (nil).blend, (nil)[1] = nil, nil, gl.SRC_ALPHA
_ENV, (nil).blend, (nil)[2] = nil, nil, gl.ONE
;(nil).x = 7.0
_ENV, (nil).p2, (nil).scale, (nil).y = nil, nil, nil, 7.0
;(nil).tex = "#dh_ganenjie1_02.png"
;(nil).scale = 3.26
;(nil).from = 58
_ENV, _ENV, (nil)[2], (nil).image, (nil).to = nil, nil, nil, nil, 100
_UPVALUE2_, (nil).plist = nil, "et_yanhuirukou_08.plist"
_ENV, (nil).blend, (nil)[1] = nil, nil, gl.ONE
_ENV, (nil).blend, (nil)[2] = nil, nil, gl.ONE
;(nil).x = 4.07
_ENV, (nil).p_down, (nil).scale, (nil).y = nil, nil, nil, 4.07
_UPVALUE2_, (nil).plist = nil, "et_yanhuirukou_13.plist"
_ENV, (nil).blend, (nil)[1] = nil, nil, gl.SRC_ALPHA
_ENV, (nil).blend, (nil)[2] = nil, nil, gl.ONE
;(nil).x = 6.5
;(nil).scale, (nil).y = nil, 6.5
_ENV, (nil).p1, (nil).rotate = nil, nil, 58.44
_UPVALUE2_, (nil).plist = nil, "et_yanhuirukou_14.plist"
_ENV, (nil).blend, (nil)[1] = nil, nil, gl.SRC_ALPHA
_ENV, (nil).blend, (nil)[2] = nil, nil, gl.ONE
;(nil).x = 7.0
_ENV, (nil).p2, (nil).scale, (nil).y = nil, nil, nil, 7.0
;(nil).tex = "#dh_ganenjie1_04.png"
;(nil).scale = 3.26
;(nil).from = 46
_ENV, _ENV, (nil)[3], (nil).image, (nil).to = nil, nil, nil, nil, 100
_UPVALUE2_, (nil).plist = nil, "et_yanhuirukou_01.plist"
_ENV, (nil).blend, (nil)[1] = nil, nil, gl.ONE
_ENV, (nil).blend, (nil)[2] = nil, nil, gl.ONE
;(nil).x = 4.09
_ENV, (nil).p_down, (nil).scale, (nil).y = nil, nil, nil, 4.4
_UPVALUE2_, (nil).plist = nil, "et_yanhuirukou_11.plist"
_ENV, (nil).blend, (nil)[1] = nil, nil, gl.SRC_ALPHA
_ENV, (nil).blend, (nil)[2] = nil, nil, gl.ONE
;(nil).x = 6.5
;(nil).scale, (nil).y = nil, 6.5
_ENV, (nil).p1, (nil).rotate = nil, nil, 70
_UPVALUE2_, (nil).plist = nil, "et_yanhuirukou_12.plist"
_ENV, (nil).blend, (nil)[1] = nil, nil, gl.SRC_ALPHA
_ENV, (nil).blend, (nil)[2] = nil, nil, gl.ONE
;(nil).x = 7.0
_ENV, (nil).p2, (nil).scale, (nil).y = nil, nil, nil, 7.0
;(nil).tex = "#dh_ganenjie1_01.png"
;(nil).scale = 3.26
;(nil).from = 100
;(nil)[4], (nil).image, (nil).to = nil, nil, 45
local FEAST_CELL_EFFECT_CFG
function partyListView:ctor()
	self.isAlreadyAttend = false
	self.singleIsMoved = false
	self:initView()
	self:initEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_PARTYCENTER_REFRESH", function(target, data)
		if data.isAlready then
			if not partyCtrl:getPartyUserData() then
				local partyCtrl, partyUserData = partyCtrl:getPartyUserData(), partyCtrl:getPartyUserData()
			end
			self:initNotJoinParty(partyUserData, self.isAlreadyAttend)
		else
			if not partyCtrl:getPartyCenterData() then
				local partyCtrl, partyCenterData = partyCtrl:getPartyCenterData(), partyCtrl:getPartyCenterData()
			end
			self:initNotJoinParty(partyCenterData, self.isAlreadyAttend)
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_PARTY_SHOWREWARD", function(target, data)
		local panel = SoraDCreatePanel("partyRewardView")
		panel:initData(data.reward, self.isAlreadyAttend)
		panel:show()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_PARTYDATA_REFRESH", function(target, data)
		if data.isAlready then
			if not partyCtrl:getPartyUserData() then
				local partyCtrl, partyUserData = partyCtrl:getPartyUserData(), partyCtrl:getPartyUserData()
			end
			self:initNotJoinParty(partyUserData, self.isAlreadyAttend)
		else
			if not partyCtrl:getPartyCenterData() then
				local partyCtrl, partyCenterData = partyCtrl:getPartyCenterData(), partyCtrl:getPartyCenterData()
			end
			self:initNotJoinParty(partyCenterData, self.isAlreadyAttend)
		end
	end)
end
function partyListView:initView()
	self.table_JoinedParty, _ENV, self.table_NotJoinParty, _ENV = nil, nil, nil, nil
	local root = self._ccsView
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_banquet")
	self.title:setTitle(i18n("feast_title_01"))
	SoraDGetChildByName(self, "btn_FAQ"):addTouchEventListener(handler(self, partyListView.clickFAQBtn))
	self.btn_Node = SoraDGetChildByName(self, "btn_node")
	self.btn_NotJoin = SoraDGetChildByName(self.btn_Node, "btn_other_party")
	self.btn_NotJoin:setTitleText(i18n("feast_text_47"))
	self.btn_Joined = SoraDGetChildByName(self.btn_Node, "btn_join_party")
	self.btn_Joined:setTitleText(i18n("feast_text_48"))
	self.text_tip_1 = SoraDGetChildByName(self.btn_Node, "text_tips")
	SoraDSetTextWidthHeight(self.text_tip_1, cc.size(600, 60))
	self.text_tip_1:setFontSize(18)
	self.feastTipsIndex = 1
	self.text_tip_1:setString(i18n("feast_roll_tips_01"))
	self.text_tip_2 = self.text_tip_1:clone()
	self.text_tip_2:setName("text_tips_2")
	self.text_tip_2:addTo(self.text_tip_1:getParent())
	self.defaultTitlePos = cc.p(self.text_tip_1:getPosition())
	self.scroll = SoraDGetChildByName(self, "scroll")
	self.bg_feast = SoraDGetChildByName(self.scroll, "bg_feast")
	self.txtNobody = SoraDGetChildByName(self.scroll, "text_nobody")
	self.txtNobody:setString(i18n("feast_text_35"))
	self.bg_down = SoraDGetChildByName(self, "bg_down_part")
	self.btn_fresh = SoraDGetChildByName(self, "btn_fresh")
	self.btn_fresh:setTitleText(i18n("common_text_911"))
	self.special_icon = SoraDGetChildByName(self, "icon_feast")
	self.special_btn = self.special_icon:getChildByName("btn_up")
	SoradCreateTimer(self, handler(self, self.updateTime))
	if not partyCtrl:getPartyCenterData() then
		local _ENV, partyCenterData = partyCtrl:getPartyCenterData(), partyCtrl:getPartyCenterData()
	end
	self:initNotJoinParty(partyCenterData, false)
end
function partyListView:initEvent()
	self.btn_NotJoin:addTouchEventListener(handler(self, partyListView.clickChangeTabBtn))
	self.btn_Joined:addTouchEventListener(handler(self, partyListView.clickChangeTabBtn))
	self.btn_fresh:addTouchEventListener(handler(self, partyListView.clickFreshBtn))
end
function partyListView:initNotJoinParty(partyCenterData, isAlready)
	if not partyCenterData then
		return
	end
	self.isAlreadyAttend = isAlready or false
	print("会计师的反馈就", self.isAlreadyAttend)
	self.partyCenterData = partyCenterData
	local num = table.nums(partyCenterData)
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollW = scrollInner:getContentSize().width
	local scrollMinH = self.scroll:getContentSize().height
	local scrollH = math.max(self.scroll:getContentSize().height, 350 * math.modf((num + 1) / 2))
	for i, v in ipairs(self.table_NotJoinParty) do
		v:setVisible(false)
	end
	self.table_NotJoinParty, _ENV = ipairs(self.table_NotJoinParty)
	self.txtNobody:setVisible(num <= 0 and isAlready == false)
	self.txtNobody:setPosition(cc.p(320, scrollMinH / 2))
	for i = 1, num do
		local v = partyCenterData[i]
		local single_item = self.table_NotJoinParty[i]
		if not single_item then
			single_item = self.bg_feast:clone()
			single_item:addTo(self.scroll)
			local btn = single_item:getChildByName("cell_btn")
			btn:setSwallowTouches(false)
			btn:addTouchEventListener(handlerEx(self, self.clickPartyCell, i))
			self.table_NotJoinParty[i] = single_item
		end
		single_item:setVisible(false)
		single_item:setPosition(cc.p(160 + (i + 1) % 2 * 320, scrollH - 180 - math.modf((i - 1) / 2) * 350))
		self:updatePartyCenterCell(single_item, v, isAlready)
	end
	offsetY = math.min(0, math.max(scrollMinH - scrollH, offsetY - (scrollH - scrollInner:getContentSize().height)))
	self.scroll:setInnerContainerSize(cc.size(scrollW, scrollH))
	scrollInner:setPositionY(offsetY)
end
function partyListView:updatePartyCenterCell(cell, info, isAlready)
	local cellName = cell:getChildByName("text_name")
	local cellNum = cell:getChildByName("text_number")
	local cellIcon = cell:getChildByName("icon_feast")
	local cellBtn = cell:getChildByName("cell_btn")
	if info then
		cell:setVisible(true)
		cellIcon:setVisible(false)
		cellIcon:setSpriteFrame("icon_Daily_reward_treasure_S_close.png")
		local ownUUID = lordInfoCtrl:getLordInfo().base.uid
		local leftTime = math.max(info.endTime - timeCtrl:getServerTime(), 0)
		if info.isEnd and info.isReward then
			cell:setSpriteFrame("bg_feast_07.png")
		else
			cell:setSpriteFrame("bg_feast_06.png")
		end
		if isAlready then
			cellBtn:setTag(1)
		else
			cellBtn:setTag(0)
		end
		if info.uidListInfo[tostring(ownUUID)] and isAlready then
			cellIcon:setVisible(true)
			if info.uidListInfo[tostring(ownUUID)].sEvent == gSpecialEventType.EVENT_MATERIAL or info.uidListInfo[tostring(ownUUID)].sEvent == gSpecialEventType.EVENT_BANDIT then
				cellIcon:setSpriteFrame("icon_feast_05.png")
			end
			if (info.uidListInfo[tostring(ownUUID)].sEvent > 3 or info.uidListInfo[tostring(ownUUID)].sEvent == gSpecialEventType.NO_EVENT or info.uidListInfo[tostring(ownUUID)].sEvent == gSpecialEventType.EVENT_TIRED) and info.isReward then
				cellIcon:setSpriteFrame("icon_Daily_reward_treasure_S_open.png")
			end
		end
		if info.isReward and leftTime <= 0 then
			cellIcon:setVisible(true)
			cellIcon:setSpriteFrame("icon_Daily_reward_treasure_S_open.png")
			cell:setSpriteFrame("bg_feast_07.png")
		end
		lordInfoCtrl = nil
		;(nil).name = info.nickName
		cellName:setString(i18n("feast_text_04", nil))
		cellNum:setString(string.format("%s %d/%d", i18n("feast_btn_02"), table.nums(info.uidListInfo), info.maxCount))
		self:updatePartyCenterCellTime(cell, info)
		self:updatePartyCellEffect(cell, info)
	end
end
function partyListView:updatePartyCellEffect(cell, info)
	if not info then
		cell:getChildByName("effect_down_node"):removeAllChildren()
		cell:getChildByName("effect_up_node"):removeAllChildren()
		return
	end
	local partyLv = info.partyLv
	local effectName = "paritcle_" .. partyLv
	local downNode = cell:getChildByName("effect_down_node")
	local upNode = cell:getChildByName("effect_up_node")
	local particleUp = upNode:getChildByName(effectName)
	local particleDown = downNode:getChildByName(effectName)
	if particleDown and particleUp then
		return
	end
	downNode:removeAllChildren()
	upNode:removeAllChildren()
	local effectCfg = FEAST_CELL_EFFECT_CFG[info.partyLv]
	_ENV = nil
	;(nil)[1] = effectCfg.p_down
	particleDown = SoraDCreateEffectNode(nil)
	particleDown:setName(effectName)
	particleDown:addTo(downNode)
	upImage = display.newSprite(effectCfg.image.tex)
	upImage:setScale(effectCfg.image.scale)
	upImage:addTo(upNode)
	upImage:setOpacity(effectCfg.image.from)
	SoraDMixtureGLONE(upImage)
	_ENV = nil
	;(nil)[1] = cca.fadeTo(0.5833333333333334, effectCfg.image.to)
	;(nil)[2] = cca.fadeTo(0.5, effectCfg.image.from)
	;(nil)[3] = cca.fadeTo(0.5, effectCfg.image.from)
	;(nil)[4] = cca.fadeTo(0.5, effectCfg.image.from)
	upImage:runAction(cc.RepeatForever:create(cca.seq(nil)))
	_UPVALUE2_ = upImage
	upImage[1] = effectCfg.p1
	upImage[2] = effectCfg.p2
	particleUp = SoraDCreateEffectNode(upImage)
	particleUp:setName(effectName)
	particleUp:addTo(upNode)
end
function partyListView:updatePartyCenterCellTime(cell, info, leftTime, isAlready)
	local cellTime = cell:getChildByName("text_lefttime")
	leftTime = info.endTime - timeCtrl:getServerTime()
	if leftTime <= 0 then
		if not self.isAlreadyAttend then
			partyCtrl:sendCheckPartyCenter()
		end
		cellTime:setString(i18n("common_text_1402"))
		cellTime:setColor(cc.c3b(255, 0, 0))
		return
	end
	cellTime:setColor(cc.c3b(255, 255, 255))
	cellTime:setString(string.format("%s%s", i18n("common_text_2809"), SoraDConvertSecondToString(leftTime)))
end
function partyListView:updateTime()
	local timeList, isClear = partyltCtrl.clearFinishParty(self.partyCenterData)
	for i, v in ipairs(self.partyCenterData) do
		if self.table_NotJoinParty[i] then
			self:updatePartyCenterCellTime(self.table_NotJoinParty[i], v, timeList[i])
		end
	end
	if self.btn_fresh and self.checkRefreshCD then
		local timeEnd = self.checkRefreshCD - timeCtrl:getServerTime()
		if 0 < timeEnd then
			self.btn_fresh:setTitleText(SoraDConvertSecondToString(timeEnd))
		else
			self.checkRefreshCD = nil
			self.btn_fresh:setTitleText(i18n("common_text_911"))
		end
	end
end
function partyListView:clickPartyCell(index, target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		local partyData = partyCtrl:getPartyData()
		if not partyCtrl:getPartyCenterData() then
			local _ENV, partyCenterData = partyCtrl:getPartyCenterData(), partyCtrl:getPartyCenterData()
		end
		if not partyCtrl:getPartyUserData() then
			local _ENV, partyUserData = partyCtrl:getPartyUserData(), partyCtrl:getPartyUserData()
		end
		local feastID
		if target:getTag() == 0 then
			if partyData.isTired and timeCtrl:getServerTime() < partyData.tiredEndtime then
				_ENV = partyData.tiredEndtime
				_ENV = "feast_text_40"
				;("feast_text_40").timeHandler = partyltCtrl.getLeftTiredTime
				;("feast_text_40").goldHandler = partyltCtrl.getLeftTiredGold
				;("feast_text_40").isBySelf = false
				SoraDShowSpeedUpBox(partyData.tiredEndtime, function(exitType)
					if exitType == MSGBOX_CALLBACK_SPEEDUP then
						partyCtrl:sendRemoveTired()
					end
				end, i18n("feast_text_40"), "feast_text_40")
				return
			end
			feastID = partyCenterData[index].partyID
			local leftTime = math.max(partyCenterData[index].endTime - timeCtrl:getServerTime(), 0)
			if partyCenterData[index].isReward and leftTime <= 0 then
				return
			end
		else
			feastID = partyUserData[index].partyID
			local ownUUID = lordInfoCtrl:getLordInfo().base.uid
			local userInfo = partyUserData[index].uidListInfo[tostring(ownUUID)]
			local leftTime = math.max(partyUserData[index].endTime - timeCtrl:getServerTime(), 0)
			_ENV = partyUserData[index].endTime - timeCtrl:getServerTime()
			;(partyUserData[index].endTime - timeCtrl:getServerTime()).commonReward = userInfo.commonReward
			;(partyUserData[index].endTime - timeCtrl:getServerTime()).eventReward = userInfo.eventReward
			;(partyUserData[index].endTime - timeCtrl:getServerTime()).feastInfo = partyUserData[index]
			local (partyUserData[index].endTime - timeCtrl:getServerTime()).attackBanditResult, totalInfo = userInfo.attackBanditResult, partyUserData[index].endTime - timeCtrl:getServerTime()
			if partyUserData[index].isReward and leftTime <= 0 then
				return
			end
			if not partyUserData[index].isEnd and userInfo and (userInfo.sEvent == gSpecialEventType.EVENT_MATERIAL or userInfo.sEvent == gSpecialEventType.EVENT_BANDIT) and userInfo.sEvent ~= gSpecialEventType.EVENT_TIRED then
				local panel = SoraDCreatePanel("partyEventView")
				panel:initData(userInfo, feastID, true)
				panel:show()
				return
			end
			if not partyUserData[index].isReward and (userInfo.sEvent > 3 or userInfo.sEvent == gSpecialEventType.EVENT_TIRED or userInfo.sEvent == gSpecialEventType.NO_EVENT) then
				local panel = SoraDCreatePanel("partyRewardView")
				if userInfo.commonReward and userInfo.eventReward then
					panel:initData(totalInfo, true)
				else
					local FARD = require_data("feast_attend_reward", true).data
					timeCtrl = true
					;(true)[1] = "id"
					;(true)[2] = "num"
					local rewardData = serviceFunctions.tableFormat(FARD[partyUserData[index].partyLv].Reward, true)
					timeCtrl = "id"
					;("id")[1] = "id"
					;("id")[2] = "num"
					local extraRewardData = serviceFunctions.tableFormat(FARD[partyUserData[index].partyLv].ExtraReward, "id")
					totalInfo.commonReward = rewardData
					if userInfo.sEvent ~= gSpecialEventType.NO_EVENT and userInfo.sEvent ~= gSpecialEventType.REJECT_MATERIAL and userInfo.sEvent ~= gSpecialEventType.REJECT_BANDIT then
						totalInfo.eventReward = extraRewardData
					end
					panel:initData(totalInfo, true)
				end
				panel:show()
				return
			end
		end
		local feastPanel = SoraDCreatePanel("partyFeastListView")
		feastPanel:initData(feastID)
		feastPanel:show()
	elseif eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif eventType == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function partyListView:clickFreshBtn(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not self.checkRefreshCD then
			local curTime = timeCtrl:getServerTime()
			self.checkRefreshCD = curTime + PARTY_FEAST_REFRESH_TIME_CD
			partyCtrl:sendCheckPartyCenter()
		else
			SoraDShowMsgTip(i18n("feast_tips_11"))
		end
	end
end
function partyListView:clickChangeTabBtn(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local index = target == self.btn_NotJoin
		self.btn_NotJoin:setTouchEnabled(not index)
		self.btn_NotJoin:setBright(not index)
		self.btn_Joined:setTouchEnabled(index)
		self.btn_Joined:setBright(index)
		self:showOrHideDown(index)
	end
end
function partyListView:showOrHideDown(index)
	if index then
		self.btn_NotJoin:loadTextureNormal("btn_alliance_choose.png", ccui.TextureResType.plistType)
		self.btn_Joined:loadTextureNormal("btn_alliance_unchoose.png", ccui.TextureResType.plistType)
		self.bg_down:setVisible(index)
		self.scroll:setContentSize(cc.size(self.scroll:getContentSize().width, 650))
		self.scroll:setPositionY(-650)
		if display.height > 960 then
			self.scroll:setContentSize(cc.size(self.scroll:getContentSize().width, 825))
			self.scroll:setPositionY(-825)
		end
		if device.isIphoneXMode() then
			self.scroll:setContentSize(cc.size(self.scroll:getContentSize().width, 975))
			self.scroll:setPositionY(-975)
		end
		if math.floor(display.height) == 853 then
			self.scroll:setContentSize(cc.size(self.scroll:getContentSize().width, 540))
			self.scroll:setPositionY(-540)
		end
		partyCtrl:sendCheckPartyCenter()
		if not partyCtrl:getPartyCenterData() then
			local _ENV, partyCenterData = partyCtrl:getPartyCenterData(), partyCtrl:getPartyCenterData()
		end
		self:initNotJoinParty(partyCenterData, false)
	else
		self.btn_NotJoin:loadTextureNormal("btn_alliance_unchoose.png", ccui.TextureResType.plistType)
		self.btn_Joined:loadTextureNormal("btn_alliance_choose.png", ccui.TextureResType.plistType)
		self.bg_down:setVisible(index)
		self.scroll:setContentSize(cc.size(self.scroll:getContentSize().width, 760))
		self.scroll:setPositionY(-760)
		if display.height > 960 then
			self.scroll:setContentSize(cc.size(self.scroll:getContentSize().width, 935))
			self.scroll:setPositionY(-935)
		end
		if device.isIphoneXMode() then
			self.scroll:setContentSize(cc.size(self.scroll:getContentSize().width, 1085))
			self.scroll:setPositionY(-1085)
		end
		partyCtrl:sendPartyUserList()
		if not partyCtrl:getPartyUserData() then
			local _ENV, partyUserData = partyCtrl:getPartyUserData(), partyCtrl:getPartyUserData()
		end
		self:initNotJoinParty(partyUserData, true)
	end
end
function partyListView:clickFAQBtn(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.PARTY_ACTIVITY)
	end
end
function partyListView:getTitleTips()
	local FTD = require_data("feast_tips")
	self.maxFeastTipsNum = #FTD.data
	if self.feastTipsIndex > self.maxFeastTipsNum then
		self.feastTipsIndex = 1
	end
	local msg = i18n(string.format("feast_roll_tips_%02d", self.feastTipsIndex))
	self.feastTipsIndex = self.feastTipsIndex + 1
	return msg
end
function partyListView:startMsgScrollHorizontal()
	self.text_tip_1:stopAllActions()
	self.text_tip_2:stopAllActions()
	local topSize = self.text_tip_1:getContentSize()
	local offset = topSize.width / 2 + SCROLL_VIEW_WIDTH
	self.text_tip_2:setPosition(self.defaultTitlePos.x + offset, self.defaultTitlePos.y)
	local SCROLL_VIEW_WIDTH, arrDownAni = self.text_tip_2.setPosition, self.text_tip_2.setPosition
	local time = offset / SCROLL_VIEW_SPEED
	table.insert(arrDownAni, cc.MoveBy:create(time, cc.p(-offset, 0)))
	table.insert(arrDownAni, cc.CallFunc:create(handler(self, self.showMsgAni)))
	self.text_tip_2:runAction(cc.Sequence:create(arrDownAni))
	self.text_tip_1:runAction(cc.MoveBy:create(time, cc.p(-offset, 0)))
	local tmp = self.text_tip_2
	self.text_tip_2 = self.text_tip_1
	self.text_tip_1 = tmp
end
function partyListView:showMsgAni()
	local msg = self:getTitleTips()
	if msg then
		self.curMsg = msg
		self.text_tip_2:setString(msg)
		self:startMsgScrollHorizontal()
	else
		self.curMsg = nil
		self.text_tip_2:setString("")
		self.text_tip_1:setString("")
	end
end
return partyListView
