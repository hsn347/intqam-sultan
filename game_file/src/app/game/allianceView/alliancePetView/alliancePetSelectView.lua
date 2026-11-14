local gametop = gModuleMgr.getObject("gametop")
local alliancePetCtrl = gametop.playertop_:getModule("alliancePetCtrl")
local allianceScience = gametop.playertop_:getModule("allianceScience")
local petltCtrl = include("petltCtrl")
local alliancePetRead = include("alliancePetRead")
local alliancePetSelectView = class("alliancePetSelectView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("alliancePetSelectView")
	end
	return target
end)
function alliancePetSelectView:ctor()
	self.isHideCurrentSceneView = true
	self.tablePetList = alliancePetRead.getPetInfoList()
	alliancePetRead = nil
	;(nil).PetType = 9999
	table.insert(self.tablePetList, nil)
	self:initWidget()
	self:initScroll()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_PET_CALLBACK", function(target, data)
		SoraDCloseLoading(self)
		SoraDRemoveAllAfterPanelFromManager(self)
		SoraDCreatePanel("alliancePetMainView"):show()
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
end
function alliancePetSelectView:initWidget(...)
	local ccs_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_pet")
	ccs_title:setTitle(i18n("alliance_beast_text_31"))
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Text_time:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("alliance_beast_text_02", nil)
	end)
	local timeCD = alliancePetCtrl:getAlliancePetCallTimeCD()
	if 0 < timeCD then
		self.Text_time:beginTime(timeCD)
	else
		self.Text_time:setVisible(false)
	end
	self.Text_time:setTimeEndListener(function(...)
		self.Text_time:setVisible(false)
	end)
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_pet")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnHelp:addTouchEventListener(function(button, type)
		if type == ccui.TouchEventType.ended then
			SoraDPlaySound()
			userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.ALLIANCE_ALTAR_PET)
		end
	end)
	self.btnHelp:setVisible(IsArClient)
end
function alliancePetSelectView:initScroll(...)
	local sSize = self.scroll:getContentSize()
	local itemSize = cc.size(299, 275)
	self.itemSize = itemSize
	local scrollH = math.max(sSize.height, math.ceil(table.nums(self.tablePetList) / 2) * itemSize.height)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, scrollH))
	self.scrollH = scrollH
	if self.timerHandle then
		SoraDManagerRemoveTimer(self, self.timerHandle)
		self.timerHandle = nil
	end
	self.createIndex = 1
	self.timerHandle = SoradCreateTimer(self, handler(self, self.createPet), true)
end
function alliancePetSelectView:createPet(...)
	if self.createIndex > table.nums(self.tablePetList) then
		if self.timerHandle then
			SoraDManagerRemoveTimer(self, self.timerHandle)
			self.timerHandle = nil
		end
		return
	end
	local itemSize = self.itemSize
	local scrollH = self.scrollH
	local k = self.createIndex
	_ENV = nil
	local (nil).index, info = k, nil
	local item = self:createPetSelectSingleItem(info)
	local col = (k - 1) % 2 + 1
	local row = math.ceil(k / 2)
	item:setPosition(cc.p(170 + (col - 1) * itemSize.width, scrollH - 150 - (row - 1) * itemSize.height))
	item:addTo(self.scroll)
	self.createIndex = self.createIndex + 1
end
function alliancePetSelectView:createPetSelectSingleItem(info)
	local item = SoraDCreateBasePanel("alliancePetSelectSingle")
	function item.initWidget(_info)
		item.Button_call = SoraDGetChildByName(item, "Button_1")
		item.Button_call:addTouchEventListener(function(button, type)
			if type ~= ccui.TouchEventType.ended then
				return
			end
			item.clickCallback(_info)
		end)
		item.Text_wait = SoraDGetChildByName(item, "Text_wait")
		item.Text_wait:setString(i18n("common_text_1036"))
		item.frame_lmss1_left = SoraDGetChildByName(item, "frame_lmss1_left")
		item.frame_lmss1_right = SoraDGetChildByName(item, "frame_lmss1_right")
		item.frame_lmss2_left = SoraDGetChildByName(item, "frame_lmss2_left")
		item.frame_lmss2_right = SoraDGetChildByName(item, "frame_lmss2_right")
		local nodeFireL = SoraDGetCommonJetFireNode(true)
		nodeFireL:setPosition(30, 180)
		nodeFireL:addTo(item.frame_lmss1_left)
		local nodeFireR = SoraDGetCommonJetFireNode(true)
		nodeFireR:setPosition(55, 180)
		nodeFireR:addTo(item.frame_lmss1_right)
		item.petSingle = SoraDGetChildByName(item, "Sprite_petShowSingle")
		item.Panel_click = SoraDGetChildByName(item, "Panel_click")
		item.Panel_click:setSwallowTouches(false)
		item.Panel_click:addTouchEventListener(function(panel, eventType)
			if eventType == ccui.TouchEventType.ended then
				local touchBeganPoint = panel:getTouchBeganPosition()
				local touchmovePoint = panel:getTouchEndPosition()
				if math.abs(touchBeganPoint.x - touchmovePoint.x) < 10 and 10 > math.abs(touchBeganPoint.y - touchmovePoint.y) then
					if gAlliancePetCallState.UNKNOW == _info.state then
						return
					else
						item.clickCallback(_info)
					end
				end
			end
		end)
	end
	function item.initData(_info)
		local petType = self.tablePetList[_info.index].PetType
		if petType == 9999 then
			_info.state = gAlliancePetCallState.UNKNOW
		else
			local freeLv = alliancePetRead.getCallFreeCond(petType)
			if alliancePetRead.checkScienceTotalLv(freeLv) then
				_info.state = gAlliancePetCallState.UNLOCKED
			else
				_info.state = gAlliancePetCallState.LOCKED
			end
		end
		if gAlliancePetCallState.UNLOCKED == _info.state then
			item.Text_wait:setVisible(false)
			item.Button_call:setTitleText(i18n("alliance_beast_btn_01"))
			SoraDAutoSizeButtonText(item.Button_call, cc.size(90, 30))
		elseif gAlliancePetCallState.LOCKED == _info.state then
			item.Text_wait:setVisible(false)
			item.Button_call:setTitleText(i18n("alliance_beast_btn_02"))
			SoraDAutoSizeButtonText(item.Button_call, cc.size(90, 30))
			item.frame_lmss1_left:setVisible(false)
			item.frame_lmss1_right:setVisible(false)
			item.petSingle:setColor(cc.c3b(105, 105, 105))
			SoraDSetNodeGray(item.frame_lmss2_left, true)
			SoraDSetNodeGray(item.frame_lmss2_right, true)
		elseif gAlliancePetCallState.UNKNOW == _info.state then
			item.Text_wait:setVisible(true)
			item.Button_call:setVisible(false)
			item.frame_lmss1_left:setVisible(false)
			item.frame_lmss1_right:setVisible(false)
			SoraDSetNodeGray(item.frame_lmss2_left, true)
			SoraDSetNodeGray(item.frame_lmss2_right, true)
			item.petSingle:setVisible(false)
		end
		if _info.index then
			local pet = self.tablePetList[_info.index]
			item.petSingle:setSpriteFrame(alliancePetRead.getPicture(pet.PetType))
		end
	end
	function item.clickCallback(_info)
		local pet = self.tablePetList[_info.index]
		local petType = pet.PetType
		local freeLv = alliancePetRead.getCallFreeCond(petType)
		if alliancePetRead.checkScienceTotalLv(freeLv) then
			_info.state = gAlliancePetCallState.UNLOCKED
		else
			_info.state = gAlliancePetCallState.LOCKED
		end
		self = gAlliancePetCallState.LOCKED
		gAlliancePetCallState.LOCKED.state = _info.state
		local gAlliancePetCallState.LOCKED.petType, petInfo = petType, gAlliancePetCallState.LOCKED
		if GLOBAL_GAME_ALLIANCE_MODE then
			self = nil
			;(nil).petInfo = petInfo
			uiManager:show("AlliancePetSelectPop", nil)
		else
			local panel = SoraDCreatePanel("alliancePetSelectPopView")
			panel:setPetInfo(petInfo)
			panel:show()
		end
	end
	item.initWidget(info)
	item.initData(info)
	return item
end
function alliancePetSelectView:onExitPanel(...)
	if self.timerHandle then
		SoraDManagerRemoveTimer(self, self.timerHandle)
		self.timerHandle = nil
	end
end
return alliancePetSelectView
