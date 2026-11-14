local alliancePetRead = include("alliancePetRead")
local gametop = gModuleMgr.getObject("gametop")
local petCtrl = gametop.playertop_:getModule("petCtrl")
local petltCtrl = include("petltCtrl")
local alliancePetCtrl = gametop.playertop_:getModule("alliancePetCtrl")
local alliancePetMainView = class("alliancePetMainView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("alliancePetMainView")
	end
	return target
end)
function alliancePetMainView:onEnterPanel(...)
	local director = cc.Director:getInstance()
	director:setProjection(cc.DIRECTOR_PROJECTION2_D)
end
function alliancePetMainView:onExitPanel(...)
	if SoraDCurrentSceneShowView("worldMapView") and gEnableWorldMap3D then
		local director = cc.Director:getInstance()
		director:setProjection(cc.DIRECTOR_PROJECTION3_D)
	end
end
function alliancePetMainView:ctor()
	self.isHideCurrentSceneView = true
	self.itemList, _ENV, self.donateData, _ENV, self.state = nil, nil, nil, nil, 1
	self:initWidget()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_PET_NORMAL_ERR", function(...)
		SoraDCloseLoading(self)
	end)
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_PET_DONATE_SUCCESS", handler(self, self.updateDonateData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_PET_DONATE_CD_CLEAN_SUCCESS", handler(self, self.updateDonateCD))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_PET_UPDATE_INFO", function(target, data)
		if data.statusChange then
			local state = alliancePetCtrl:getAlliancePetState()
			if gAlliancePetState.CALL == state then
				SoraDRemoveAllAfterPanelFromManager(self)
			else
				SoraDRemoveAllAfterPanelFromManager(self, true)
				self:initData()
			end
		elseif data.lvChange then
			self:updateDonateData()
		elseif data.pointChange then
			self:updateDonateData()
		elseif data.lifeChange then
			local leftLife = alliancePetCtrl:getAlliancePetLeftLife()
			alliancePetCtrl = true
			;(true).maxValue = 100
			;(true).curValue = leftLife
			self.loadingBarHp:setProgressDate(true)
			self.loadingBarHp:setProgressLabel(SoraDFValueSuit(leftLife, "%"))
		end
	end)
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_PET_REQ_INFO_BACK", function(target, data)
		SoraDCloseLoading(self)
		self:setPetInfo(alliancePetCtrl:getAlliancePetType())
	end)
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_BE_KICKED", function(target, data)
		SoraDRemoveAllAfterPanelFromManager(self)
	end)
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_BUILDING_CHANGE", function(target, data)
		if gAllianceBuilding.ALTAR ~= data.bid then
			return
		end
		SoraDRemoveAllAfterPanelFromManager(self)
	end)
	alliancePetCtrl:sendReqPetInfo()
	SoraDShowLoading(self, nil, nil, nil, 15)
end
function alliancePetMainView:initWidget(...)
	local ccs_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_pet")
	ccs_title:setTitle(i18n("alliance_beast_text_31"))
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Text_time:setTimeEndListener(function(...)
	end)
	self.Panel_show_effect = SoraDGetChildByName(self, "Panel_show_effect")
	self.Panel_show = SoraDGetChildByName(self, "Panel_show")
	self.petSingle = SoraDGetExtendChildFromCCSByName(self, "CCS_petShowSingle_pet")
	self.petSingle:setScale(0.9)
	self.petSingle:setPositionY(self.petSingle:getPositionY() + 80)
	self.Text_pet_name = SoraDGetChildByName(self, "Text_pet_name")
	self.Text_title = SoraDGetChildByName(self, "Text_title")
	self.Image_bg_item = SoraDGetChildByName(self, "Image_bg_item")
	self.Image_bg_item:setTouchEnabled(true)
	self.Image_bg_item:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		local panel = SoraDCreatePanel("alliancePetRewardPopView")
		panel:setRewardInfo(self.petType)
		panel:show()
	end)
	local Text_name = SoraDGetChildByName(self.Image_bg_item, "Text_name")
	Text_name:setString(i18n("alliance_beast_btn_03"))
	self:setTrialBtnEffect()
	self:initRankButton()
	self.fireLeft = SoraDGetChildByName(self, "Sprite_fire_left")
	self.fireRight = SoraDGetChildByName(self, "Sprite_fire_right")
	local nodeFireL = SoraDGetCommonJetFireNode(true)
	nodeFireL:setPosition(20, 10)
	nodeFireL:addTo(self.fireLeft)
	local nodeFireR = SoraDGetCommonJetFireNode(true)
	nodeFireR:setPosition(20, 20)
	nodeFireR:addTo(self.fireRight)
	self.Node_state_1 = SoraDGetChildByName(self, "Top_Node_state_1")
	self.Text_state_1_1 = SoraDGetChildByName(self.Node_state_1, "Text_30")
	self.Text_state_1_1:setString(i18n("alliance_beast_text_18"))
	self.Text_state_1_2 = SoraDGetChildByName(self.Node_state_1, "Text_30_0")
	self:setBlessEffect()
	self.Node_state_2 = SoraDGetChildByName(self, "Top_Node_state_2")
	self.loadingBar = SoraDGetExtendChildFromCCSByName(self, "CCS_commonProgressBar_point")
	self.labelCurPoint = SoraDGetChildByName(self.Node_state_2, "Text_curPoint")
	self.Text_row_1 = SoraDGetChildByName(self.Node_state_2, "Text_row_1")
	self.Sprite_row_1 = SoraDGetChildByName(self.Node_state_2, "Sprite_row_1")
	self.Text_value_1 = SoraDGetChildByName(self.Node_state_2, "Text_value_1")
	self.Text_row_2 = SoraDGetChildByName(self.Node_state_2, "Text_row_2")
	self.Sprite_row_2 = SoraDGetChildByName(self.Node_state_2, "Sprite_row_2")
	self.Text_value_2 = SoraDGetChildByName(self.Node_state_2, "Text_value_2")
	self.timeBg1 = SoraDGetChildByName(self.Node_state_2, "Image_des1_bg")
	self.timeBg2 = SoraDGetChildByName(self.Node_state_2, "frame_maintenance_r")
	self.timeBg3 = SoraDGetChildByName(self.Node_state_2, "frame_maintenance_l")
	self.Text_donate_time = SoraDGetChildByName(self.Node_state_2, "Text_donate_time")
	self.Text_donate_time = SoraDCreateTimerLabel(self, self.Text_donate_time)
	self.Text_donate_time:setTimeEndListener(function(...)
		self.Text_donate_time:setVisible(false)
		self.timeBg1:setVisible(false)
		self.timeBg2:setVisible(false)
		self.timeBg3:setVisible(false)
	end)
	self.tableBtn = SoraDGetChildsArrayByName(self.Node_state_2, "CCS_alliancePetDonateBtn_", 3, 1, true, true)
	for i, v in ipairs(self.tableBtn) do
		v:setDonateType(i)
		v:setHandle(handler(self, self.donateBtnCallBack))
	end
	self.Node_state_3 = SoraDGetChildByName(self, "Top_Node_state_3")
	self.Text_lv = SoraDGetChildByName(self.Node_state_3, "Text_lv")
	self.Sprite_lv_l = SoraDGetChildByName(self.Node_state_3, "Sprite_lv_l")
	self.Sprite_lv_r = SoraDGetChildByName(self.Node_state_3, "Sprite_lv_r")
	self.Text_des_1 = SoraDGetChildByName(self.Node_state_3, "Text_des_1")
	self.Text_des_1:setString(i18n("alliance_beast_text_17"))
	self.Text_des_2 = SoraDGetChildByName(self.Node_state_3, "Text_des_2")
	self.Button_call = SoraDGetChildByName(self.Node_state_3, "Button_call")
	self.Button_call:setTitleText(i18n("arena_btn_04"))
	SoraDAutoSizeButtonText(self.Button_call, cc.size(192, 50))
	self.Button_call:addTouchEventListener(function(button, type)
		if type ~= ccui.TouchEventType.ended then
			return
		end
		local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
		if permissionCtrl:hasPlayerPermission(gAPermission.LAUNCH_WAR) then
			local allianceTerritoryAPI = include("allianceTerritoryAPI")
			local pos = allianceTerritoryAPI:getMainBuildingPos(gAllianceBuilding.ALTAR)
			local instanceID = alliancePetCtrl:getMapAltarId()
			worldMapFunction.GotoTrialMass(pos, instanceID)
		else
			_ENV = worldMapFunction.GotoTrialMass
			worldMapFunction.GotoTrialMass.des = i18n("common_text_2373")
			SoraDShowMsgBox(i18n("common_text_2371", worldMapFunction.GotoTrialMass), i18n("common_text_204"))
		end
	end)
	self.loadingBarHp = SoraDGetExtendChildFromCCSByName(self.Node_state_3, "CCS_commonProgressBar_hp")
	self.loadingBarHp:setProgressImg("progressbar_main_building02.png")
	self.loadingBarHp:setProgressContentSize(cc.size(422, 18.5))
	self.Text_cur_lv = SoraDGetChildByName(self.loadingBarHp, "Text_cur_lv")
	self.Text_time_state_3 = SoraDGetChildByName(self.Node_state_3, "Text_time_state_3")
	self.Text_time_state_3 = SoraDCreateTimerLabel(self, self.Text_time_state_3)
	self:setTrialEffect()
	self.petSingle:setVisible(false)
	self.Image_bg_item:setVisible(false)
	self.Node_state_1:setVisible(false)
	self.Node_state_2:setVisible(false)
	self.Node_state_3:setVisible(false)
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnHelp:addTouchEventListener(function(button, type)
		if type == ccui.TouchEventType.ended then
			SoraDPlaySound()
			userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.ALLIANCE_ALTAR_PET)
		end
	end)
	self.btnHelp:setVisible(IsArClient)
	if self:isIpad() then
		self.Text_title:setVisible(false)
		SoraDGetChildByName(self, "Image_line2"):setVisible(false)
		SoraDGetChildByName(self, "Image_lace_r"):setVisible(false)
		SoraDGetChildByName(self, "Image_lace_l"):setVisible(false)
		print("kshdkfjsd ")
		local Image_line1 = SoraDGetChildByName(self, "Image_line1")
		Image_line1:loadTexture("frame_cjxt_t.png", ccui.TextureResType.plistType)
		Image_line1:setPositionY(Image_line1:getPositionY() + 20)
		local Image_line1_1 = SoraDGetChildByName(self, "Image_line1_1")
		Image_line1_1:loadTexture("frame_cjxt_t.png", ccui.TextureResType.plistType)
		Image_line1_1:setPositionY(Image_line1_1:getPositionY() + 20)
		local Node_lvInfo = SoraDGetChildByName(self, "Node_lvInfo")
		Node_lvInfo:setPositionY(Node_lvInfo:getPositionY() - 10)
		local Node_bar = SoraDGetChildByName(self, "Node_bar")
		Node_bar:setPositionY(Node_bar:getPositionY() - 5)
		self.Node_state_1:setPositionY(self.Node_state_1:getPositionY() + 93)
		self.Node_state_2:setPositionY(self.Node_state_2:getPositionY() + 93)
		self.Node_state_3:setPositionY(self.Node_state_3:getPositionY() + 93)
		self.Image_time_bg = SoraDGetChildByName(self, "Image_time_bg")
		self.Text_time_state_3:setPositionY(self.Text_time_state_3:getPositionY() + 18)
		self.loadingBarHp:setPositionY(self.loadingBarHp:getPositionY() - 90)
		self.Image_time_bg:setPositionY(self.Image_time_bg:getPositionY() + 2)
		self.Image_bg_item:setPositionY(self.Image_bg_item:getPositionY() + 15)
	end
	if display.height > 960 then
		local offset = self:getOffset()
		self.Node_state_1:setPositionY(self.Node_state_1:getPositionY() - offset)
		self.Node_state_2:setPositionY(self.Node_state_2:getPositionY() - offset)
		self.Node_state_3:setPositionY(self.Node_state_3:getPositionY() - offset)
		self.loadingBarHp:setPositionY(self.loadingBarHp:getPositionY() + offset)
		self.Text_time_state_3:setPositionY(self.Text_time_state_3:getPositionY() + offset)
	end
end
function alliancePetMainView:initRankButton(...)
	local button = self.Image_bg_item:clone()
	button:addTo(self.Image_bg_item:getParent())
	local x, y = self.Image_bg_item:getPosition()
	button:setPosition(x, y + 100)
	button:setVisible(true)
	SoraDGetChildByName(button, "Text_name"):setString(i18n("common_text_851"))
	local Sprite_icon = SoraDGetChildByName(button, "Sprite_icon")
	Sprite_icon:setSpriteFrame("icon_devilvalley_rank.png")
	Sprite_icon:setScale(0.82)
	button:addTouchEventListener(handler(self, self.onClickRank))
	self.btnRank = button
end
function alliancePetMainView:onClickRank(button, type)
	if type ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	alliancePetCtrl:sendReqWorshipRank()
	local panel = SoraDCreatePanel("collectSalaryAllianceRank")
	_ENV = nil
	;(nil).title = i18n("god_beast_text_45")
	;(nil).score = i18n("god_beast_text_46")
	panel:setNameData(nil)
	panel:show()
end
function alliancePetMainView:initData(...)
	self.state = alliancePetCtrl:getAlliancePetState()
	self.curShowLv = alliancePetCtrl:getAlliancePetLv()
	if self.state == gAlliancePetState.BLESS then
		self:refreshState1()
	elseif self.state == gAlliancePetState.DONATE then
		self:refreshState2()
	elseif self.state == gAlliancePetState.TRIAL then
		self:refreshState3()
	end
	self.Text_pet_name:setString(alliancePetRead.getName(self.petType))
	self.petSingle:setVisible(true)
	self:refreshPetModel()
end
function alliancePetMainView:refreshPetModel(...)
	local pid, rank = alliancePetRead.getPetSinglePidAndRank(self.petType, self.curShowLv)
	if not (self.curPid and self.curRank) or self.curPid ~= pid or self.curRank ~= rank then
		self.curPid = pid
		self.curRank = rank
		alliancePetRead = nil
		;(nil).pid = pid
		;(nil).rank = rank
		self.petSingle:initData(nil)
	end
end
function alliancePetMainView:refreshState1(...)
	self.Node_state_1:setVisible(true)
	self.effectNode_1:setVisible(true)
	self.Node_state_2:setVisible(false)
	self.Node_state_3:setVisible(false)
	self.effectNode_3:setVisible(false)
	self.Text_title:setString(i18n("alliance_beast_text_20"))
	self.Text_title:setVisible(true)
	self.Image_bg_item:setVisible(false)
	self.Text_time:setVisible(true)
	self.Text_time:setTimeLast(function(ticket)
		return i18n("alliance_beast_text_19") .. ticket
	end)
	self.Text_time:beginTime(alliancePetCtrl:getAlliancePetBlessingTimeCD())
	local curLv = alliancePetCtrl:getAlliancePetLv()
	self.Text_state_1_2:setString(alliancePetRead.getWishDesByType(self.petType, curLv))
	if self:isIpad() then
		self.Text_title:setVisible(false)
		self.Image_time_bg:setContentSize(cc.size(640, 50))
	end
end
function alliancePetMainView:refreshState2(...)
	self.Node_state_1:setVisible(false)
	self.effectNode_1:setVisible(false)
	self.Node_state_2:setVisible(true)
	self.Node_state_3:setVisible(false)
	self.effectNode_3:setVisible(false)
	self.Text_title:setString(i18n("alliance_beast_text_11"))
	self.Text_title:setVisible(true)
	self.Image_bg_item:setVisible(true)
	self.Text_time:setVisible(true)
	self.Text_time:setTimeLast(function(ticket)
		return i18n("alliance_beast_text_10") .. ticket
	end)
	self.Text_time:beginTime(alliancePetCtrl:getAlliancePetReturnTimeCD())
	self.donateData = alliancePetCtrl:getAlliancePetData()
	for i, v in ipairs(self.tableBtn) do
		v:initData(self.petType)
	end
	local donateTimeCD = alliancePetCtrl:getDonateTimeCD()
	if donateTimeCD <= 0 then
		self.Text_donate_time:setVisible(false)
		self.timeBg1:setVisible(false)
		self.timeBg2:setVisible(false)
		self.timeBg3:setVisible(false)
	else
		self.Text_donate_time:setVisible(true)
		self.timeBg1:setVisible(true)
		self.timeBg2:setVisible(true)
		self.timeBg3:setVisible(true)
		self.Text_donate_time:beginTime(donateTimeCD)
		if alliancePetCtrl:checkDonateLock() then
			self.Text_donate_time:setColor(display.COLOR_RED)
		else
			self.Text_donate_time:setColor(cc.c3b(255, 200, 100))
		end
	end
	if self.curShowLv >= alliancePetRead.getMinTrailLevel(self.petType) then
		self.effectNode_trial:setVisible(true)
	else
		self.effectNode_trial:setVisible(false)
	end
	self:refreshNodeLvInfo()
	if self:isIpad() then
		self.Text_title:setVisible(false)
		self.Image_time_bg:setContentSize(cc.size(640, 50))
	end
end
function alliancePetMainView:refreshNodeLvInfo(...)
	local curLv = self.curShowLv
	local curSword = alliancePetRead.getSword(self.petType, curLv)
	self.maxLv = alliancePetRead.getMaxLevel(self.petType)
	if self.maxLv == curLv then
		alliancePetRead = nil
		;(nil).lv = curLv
		self.Text_row_1:setString(string.format("%s%s(MAX)", i18n("common_text_279"), i18n("common_text_100", nil)))
		self.Text_row_2:setString(string.format("%s%d(MAX)", i18n("alliance_beast_text_13"), curSword))
		self.Sprite_row_1:setVisible(false)
		self.Sprite_row_2:setVisible(false)
		self.Text_value_1:setVisible(false)
		self.Text_value_2:setVisible(false)
		self.labelCurPoint:setString(i18n("common_text_283"))
		alliancePetRead = i18n("common_text_283")
		i18n("common_text_283").maxValue = 1
		i18n("common_text_283").curValue = 1
		self.loadingBar:setProgressDate(i18n("common_text_283"))
		return
	else
		alliancePetRead = i18n("common_text_283")
		i18n("common_text_283").lv = curLv
		self.Text_row_1:setString(string.format("%s%s", i18n("common_text_279"), i18n("common_text_100", i18n("common_text_283"))))
		self.Text_row_2:setString(string.format("%s%d", i18n("alliance_beast_text_13"), curSword))
	end
	local nextLv = self.curShowLv + 1
	local nextSword = alliancePetRead.getSword(self.petType, nextLv)
	if self.maxLv == nextLv then
		alliancePetRead = string.format("%s%d", i18n("alliance_beast_text_13"), curSword)
		string.format("%s%d", i18n("alliance_beast_text_13"), curSword).lv = nextLv
		self.Text_value_1:setString(string.format("%s(MAX)", i18n("common_text_100", string.format("%s%d", i18n("alliance_beast_text_13"), curSword))))
		self.Text_value_2:setString(string.format("%d(MAX)", nextSword))
	else
		alliancePetRead = string.format("%d(MAX)", nextSword)
		string.format("%d(MAX)", nextSword).lv = nextLv
		self.Text_value_1:setString(i18n("common_text_100", string.format("%d(MAX)", nextSword)))
		self.Text_value_2:setString(tostring(nextSword))
	end
	if SoraDFIsRA() then
		self.Sprite_row_1:setPositionX(self.Text_row_1:getPositionX() - self.Text_row_1:getContentSize().width - 33)
		self.Text_value_1:setPositionX(self.Text_row_1:getPositionX() - self.Text_row_1:getContentSize().width - 65)
		self.Sprite_row_2:setPositionX(self.Text_row_2:getPositionX() - self.Text_row_2:getContentSize().width - 33)
		self.Text_value_2:setPositionX(self.Text_row_2:getPositionX() - self.Text_row_2:getContentSize().width - 65)
	else
		self.Sprite_row_1:setPositionX(self.Text_row_1:getPositionX() + self.Text_row_1:getContentSize().width + 33)
		self.Text_value_1:setPositionX(self.Text_row_1:getPositionX() + self.Text_row_1:getContentSize().width + 65)
		self.Sprite_row_2:setPositionX(self.Text_row_2:getPositionX() + self.Text_row_2:getContentSize().width + 33)
		self.Text_value_2:setPositionX(self.Text_row_2:getPositionX() + self.Text_row_2:getContentSize().width + 65)
	end
	local needPoint = alliancePetRead.getNeedPoint(self.petType, self.curShowLv)
	if needPoint then
		self.labelCurPoint:setString(string.formatnumberthousands(self.donateData.point) .. "/" .. string.formatnumberthousands(needPoint))
		alliancePetRead = string.formatnumberthousands(self.donateData.point) .. "/" .. string.formatnumberthousands(needPoint)
		;(string.formatnumberthousands(self.donateData.point) .. "/" .. string.formatnumberthousands(needPoint)).maxValue = needPoint
		;(string.formatnumberthousands(self.donateData.point) .. "/" .. string.formatnumberthousands(needPoint)).curValue = self.donateData.point
		self.loadingBar:setProgressDate(string.formatnumberthousands(self.donateData.point) .. "/" .. string.formatnumberthousands(needPoint))
	end
end
function alliancePetMainView:refreshState3(...)
	self.Node_state_1:setVisible(false)
	self.effectNode_1:setVisible(false)
	self.Node_state_2:setVisible(false)
	self.Node_state_3:setVisible(true)
	self.effectNode_3:setVisible(true)
	self.Text_title:setString(i18n("alliance_beast_btn_04"))
	self.Text_title:setVisible(false)
	self.Image_bg_item:setVisible(false)
	self.Text_time:setVisible(false)
	self.Text_time_state_3:setTimeLast(function(ticket)
		return i18n("alliance_beast_text_10") .. ticket
	end)
	self.Text_time_state_3:beginTime(alliancePetCtrl:getAlliancePetReturnTimeCD())
	if not alliancePetRead.getRewards(self.petType, self.curShowLv) then
		local _ENV, rewards = alliancePetRead.getRewards(self.petType, self.curShowLv), alliancePetRead.getRewards(self.petType, self.curShowLv)
	end
	local MAX_REWARD = 8
	local dataCount = IsArClient and #rewards / 2 or #rewards / 3
	dataCount = math.min(MAX_REWARD, math.floor(dataCount / 2) * 2)
	for k, v in pairs(self.itemList) do
		v:setVisible(false)
	end
	local getItemPosition = function(i)
		_ENV = nil
		;(nil).x = 105 + 110 * ((i - 1) % 4)
		local (nil).y, position = 295 - (math.ceil(i / 4) - 1) * 100, nil
		return position
	end
	local _ENV, positions = pairs(self.itemList)
	for i = 1, MAX_REWARD do
		local position = getItemPosition(i)
		positions[#positions + 1] = position
	end
	if dataCount == 6 then
		for i = 1, dataCount do
			if i <= 2 then
				positions[i] = clone(positions[i + 1])
			else
				positions[i] = clone(positions[i + 2])
			end
		end
	end
	for i = 1, dataCount do
		local singleItem
		if not self.itemList[i] then
			singleItem = include("itemSingleView").new()
			singleItem:addTo(self.Node_state_3)
			singleItem:setScale(0.65)
			singleItem:setItemClickCallback(handler(self, self.showDetail))
			self.itemList[i] = singleItem
		else
			self.itemList[i]:setVisible(true)
			singleItem = self.itemList[i]
		end
		if positions[i] then
			singleItem:setPosition(positions[i])
		else
			singleItem:setPosition(getItemPosition(i))
		end
		if IsArClient then
			_ENV, _ENV = getItemPosition(i)
			getItemPosition(i).id = rewards[i * 2 - 1]
			getItemPosition(i).itemData, getItemPosition(i).count = getItemPosition(i)
			singleItem:initData(getItemPosition(i))
			singleItem:setButtonTag(rewards[i * 2 - 1])
		else
			_ENV, _ENV = getItemPosition(i)
			getItemPosition(i).id = rewards[i * 3 - 2]
			rewards[i * 2 - 1].itemData, getItemPosition(i).count = getItemPosition(i)
			singleItem:initData(rewards[i * 2 - 1])
			singleItem:setButtonTag(rewards[i * 3 - 2])
		end
	end
	_ENV = rewards[i * 3 - 2]
	rewards[i * 3 - 2].lv = self.curShowLv
	self.Text_lv:setString(string.format("%s%s", i18n("alliance_beast_text_16"), i18n("common_text_100", rewards[i * 3 - 2])))
	self.Sprite_lv_l:setPositionX(display.cx - self.Text_lv:getContentSize().width / 2 - 20)
	self.Sprite_lv_r:setPositionX(display.cx + self.Text_lv:getContentSize().width / 2 + 20)
	self.Text_des_2:setString(alliancePetRead.getWishDesByType(self.petType, self.curShowLv))
	_ENV = alliancePetRead.getWishDesByType(self.petType, self.curShowLv)
	alliancePetRead.getWishDesByType(self.petType, self.curShowLv).lv = self.curShowLv
	self.Text_cur_lv:setString(i18n("common_text_100", alliancePetRead.getWishDesByType(self.petType, self.curShowLv)))
	local leftLife = alliancePetCtrl:getAlliancePetLeftLife()
	_ENV = i18n("common_text_100", alliancePetRead.getWishDesByType(self.petType, self.curShowLv))
	i18n("common_text_100", alliancePetRead.getWishDesByType(self.petType, self.curShowLv)).maxValue = 100
	i18n("common_text_100", alliancePetRead.getWishDesByType(self.petType, self.curShowLv)).curValue = leftLife
	self.loadingBarHp:setProgressDate(i18n("common_text_100", alliancePetRead.getWishDesByType(self.petType, self.curShowLv)))
	self.loadingBarHp:setProgressLabel(SoraDFValueSuit(leftLife, "%"))
	if self:isIpad() then
		self.Text_title:setVisible(false)
		self.Image_time_bg:setContentSize(cc.size(640, 65))
	end
	if display.height > 960 then
		local offset = self:getOffset()
	end
end
function alliancePetMainView:showDetail(button, type)
	if type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		SoraDPlaySound()
		button:stopAllActions()
		if self.tips then
			self.tips:removeFromParent()
			self.tips = nil
		end
	elseif type == ccui.TouchEventType.began then
		_UPVALUE1_ = nil
		;(nil)[1] = cca.delay(0.2)
		;(nil)[2] = cca.callFunc(function()
			self.tips = SoraDCreatePanel("commonItemTips")
			self.tips:initData(button:getTag())
			local dt = 140
			if not SoraDFIsRA() then
				dt = -140
			end
			self.tips:setPosition(cc.p(320 + dt, display.cy))
			self.tips:addTo(self, 99)
		end)
		;(nil)[3] = cca.callFunc(function()
			self.tips = SoraDCreatePanel("commonItemTips")
			self.tips:initData(button:getTag())
			local dt = 140
			if not SoraDFIsRA() then
				dt = -140
			end
			self.tips:setPosition(cc.p(320 + dt, display.cy))
			self.tips:addTo(self, 99)
		end)
		button:runAction(cca.seq(nil))
	end
end
function alliancePetMainView:donateBtnCallBack(type)
	local gametop = gModuleMgr.getObject("gametop")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local jointime = memberMgr:getOwnMember():getProperty("joinTime")
	local curtime = serviceFunctions.systemTime()
	local needtime = gConstValue.ALLIANCE_DONATE_NEE_JOIN_ALLIANCE_TIME
	if needtime > curtime - jointime then
		SoraDShowMsgTip(i18n("alliance_beast_notice_07"), nil, nil)
		return
	end
	if self.maxLv == self.curShowLv then
		SoraDShowMsgTip(i18n("common_text_283"))
		return
	end
	if alliancePetCtrl:checkDonateLock() then
		local panel = SoraDCreatePanel("alliancePetSpeedUpBox")
		i18n("common_text_283").data, _ENV, _ENV = i18n("common_text_283")
		_ENV, i18n("common_text_283").msg = i18n("common_text_656"), i18n("common_text_656")
		i18n("common_text_283").tableArgv, i18n("common_text_656").speedUpName = i18n("common_text_656"), i18n("common_text_655")
		panel:initData(i18n("common_text_283"))
		panel:show()
	else
		alliancePetCtrl:reqDonatePet(type)
		SoraDShowLoading(self, nil, nil, nil, 15)
	end
end
function alliancePetMainView:updateDonateData()
	SoraDCloseLoading(self)
	self.curShowLv = alliancePetCtrl:getAlliancePetLv()
	self:refreshState2()
	self:refreshPetModel()
end
function alliancePetMainView:updateDonateCD()
	SoraDCloseLoading(self)
	self.Text_donate_time:setVisible(false)
	self.timeBg1:setVisible(false)
	self.timeBg2:setVisible(false)
	self.timeBg3:setVisible(false)
end
function alliancePetMainView:setPetInfo(petType)
	self.petType = petType
	self:initData()
end
function alliancePetMainView:isIpad(...)
	if display.height < 960 then
		return true
	else
		return false
	end
end
function alliancePetMainView:getOffset(...)
	if display.height > 960 then
		local offset = math.min(display.height - 960, 75)
		return offset
	end
	return 0
end
function alliancePetMainView:setBlessEffect(...)
	local effectNode_1 = SoraDCreatAnimation("shenshouzhufu", nil, true)
	self.effectNode_1 = effectNode_1
	effectNode_1:setPosition(cc.p(320, -80))
	self.Panel_show:addChild(effectNode_1)
	effectNode_1:setVisible(false)
	local sp = SoraDGetChildByName(effectNode_1, "Sprite_8")
	if sp:isOpacityModifyRGB() then
		sp:setBlendFunc(gl.ONE, gl.ONE)
	else
		sp:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
end
function alliancePetMainView:setTrialEffect(...)
	local effectNode_3 = SoraDCreatAnimation("shenshou")
	self.effectNode_3 = effectNode_3
	effectNode_3:setPosition(cc.p(320, -80))
	self.Panel_show_effect:addChild(effectNode_3)
	effectNode_3:setVisible(false)
	_ENV, _ENV = effectNode_3, effectNode_3.setVisible
	_ENV, effectNode_3.plist = false, "et_shenshouxiulian_04.plist"
	;(false).x = 0
	_ENV, effectNode_3.pos, (false).y = false, false, 0
	;(false).x = 6.9053
	effectNode_3.setVisible[1], effectNode_3.scale, (false).y = effectNode_3, false, 2.0733
	local param = effectNode_3.setVisible
	local et_node = SoraDCreateEffectNode(param)
	et_node:setPosition(cc.p(320, 50))
	et_node:addTo(self.Panel_show, 2)
end
function alliancePetMainView:setTrialBtnEffect(...)
	local effectNode = SoraDCreatAnimation("touzhi")
	self.effectNode_trial = effectNode
	effectNode:setPosition(cc.p(35, 37))
	effectNode:setScale(0.75)
	self.Image_bg_item:addChild(effectNode)
	effectNode:setVisible(false)
	local sp = SoraDGetChildByName(effectNode, "gddaf_1")
	if sp:isOpacityModifyRGB() then
		sp:setBlendFunc(gl.ONE, gl.ONE)
	else
		sp:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	end
end
return alliancePetMainView
