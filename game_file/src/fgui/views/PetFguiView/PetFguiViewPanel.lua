local baseFguiPanel = require("fgui.base.baseFguiPanel")
local PetFguiViewPanel = class("PetFguiViewPanel", baseFguiPanel)
local gametop = gModuleMgr.getObject("gametop")
local petCtrl = gametop.playertop_:getModule("petCtrl")
local petltCtrl = include("petltCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local shopCtrl = gametop.playertop_:getModule("shopCtrl")
local petDesRead = include("petDesRead")
local itemDesRead = include("itemDesRead")
local guideCtrl = gametop.playertop_:getModule("guideCtrl")
function PetFguiViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	self.debug = true
	print("PetFguiViewPanel:ctor", self.viewName)
end
function PetFguiViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE5_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "PetFguiView"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[5] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function PetFguiViewPanel:onInit()
	self.fields.Com_Title:initData(i18n("Dear_pet_main_01"), handler(self, self.onClickClose))
	self.fields.btn_unlock:setTitle(i18n("common_text_740"))
	self.fields.btn_unlock:addClickEventListener(handler(self, self.onUnlockClick))
	self.fields.scroll_pets:setItemRenderer(handler(self, self.onPetHeadRenderer))
	self.fields.scroll_attributes:setItemRenderer(handler(self, self.onAttributeRenderer))
	self.fields.scroll_attributes:setItemProvider(handler(self, self.onAttributeProvider))
	self.fields.btn_show:addClickEventListener(handler(self, self.onClick_btn_show))
	self.fields.btn_share:addClickEventListener(handler(self, self.onClick_btn_share))
	include("commonShareButton").createSnapshootWithButton(self.fields.btn_snapshot, 4, nil, function()
		if not tolua.isnull(self) then
			self.fields.pet_model.petNode:hidePUEffect()
		end
	end, function()
	end, function()
		print("关闭分享界面------")
		if not tolua.isnull(self) then
			self.fields.pet_model.petNode:showPUEffect()
		end
	end)
	self.fields.btn_strongest:addClickEventListener(handler(self, self.onClick_btn_strongest))
	self.fields.btn_max:addClickEventListener(handler(self, self.showPetPreview))
	self.fields.text_max_tip:setString(i18n("Dear_pet_main_03"))
	self.fields.btn_max:setTitle(i18n("Dear_pet_main_07"))
	self.fields.Button_left:addClickEventListener(handler(self, self.onPageBtnClick), SoraDFIsRA() and 1 or -1)
	self.fields.Button_right:addClickEventListener(handler(self, self.onPageBtnClick), SoraDFIsRA() and -1 or 1)
	if not SoraDFIsRA() then
		self.fields.n405:fixPos()
		self.fields.btn_max:fixPos()
	end
end
function PetFguiViewPanel:setSelectPetId(petId, isNeedScroll)
	local isNeedScrollToTop = isNeedScroll
	local isNeedScrollToCurPet = false
	if petId == nil then
		self.tablePetMap, petId = petCtrl:getSortPetMapInfoList()
		isNeedScrollToCurPet = true
	end
	if self.selectPetId ~= petId then
		self.fields.scroll_attributes:removeChildrenToPool()
	end
	self.selectPetId = petId
	self:updateView()
	if isNeedScrollToTop then
		self.fields.scroll_pets:scrollToView(0, false, false)
	end
	if isNeedScrollToCurPet and self.curIndex then
		self.fields.scroll_pets:scrollToView(self.curIndex, false, true)
	end
	self:setCurPet(petId)
end
function PetFguiViewPanel:updateView()
	self.tablePetMap = petCtrl:getSortPetMapInfoList()
	self.fields.scroll_pets:setNumItems(#self.tablePetMap)
end
function PetFguiViewPanel:updateCurPet()
	self:setSelectPetId(self.selectPetId)
end
function PetFguiViewPanel:getCurPet(petId)
	for key, value in pairs(self.tablePetMap) do
		if value.pid == petId then
			return value, key
		end
	end
end
function PetFguiViewPanel:setCurPet(petId)
	self.selectPetId = petId
	self.curPet, self.selectIndex = self:getCurPet(petId)
	local isUnlock = petCtrl:isPetUnlock(petId)
	self.isUnlock = isUnlock
	local isCanUnlock, isCanUnlockRet = petCtrl:petIsCanUnlock(petId)
	self.isCanUnlock = isCanUnlock
	self.isCanUnlockRet = isCanUnlockRet
	petCtrl = nil
	;(nil).byUID = true
	local showPid = SoraDConfigGet("Game:petView:cityPetShow~integer", nil)
	self.fields.btn_show:setGrayed(showPid ~= petId)
	self.fields.btn_show:setVisible(petDesRead.getIsNeedShowBtnShow(self.curPet.pid))
	self.fields.btn_max:setVisible(isUnlock)
	local petData = petCtrl:getPet(petId)
	self.curRank = petData and petData.rank or nil
	self.fields.pet_step_icons:setPetData(self.curPet, self.curRank)
	if self.curRank == nil then
		self.curRank = #self.curPet.rankInfo
	end
	petCtrl = self.curPet
	self.curPet.pid = self.curPet.pid
	self.curPet.rank = self.curRank
	self.fields.pet_model:initData(self.curPet)
	self.fields.pet_name:setString(petDesRead.getName(petId))
	self.fields.txt_unlock_lv:setVisible(not isUnlock)
	self.petData = petData
	self:updateTrainDetail()
end
function PetFguiViewPanel:updateAttr(petId, lv, rank, isFull)
	local tableAttr = petltCtrl.getPetTelentAndSecialSkill(petId, rank, lv)
	local nextRankMaxLvTableAttr
	if isFull then
		local petMaxLev = petltCtrl.getPetMaxLevInRank(petId, rank + 1)
		nextRankMaxLvTableAttr = petltCtrl.getPetTelentAndSecialSkill(petId, rank + 1, petMaxLev)
	end
	local tableAttr1 = tableAttr.special_send
	self.atts, petltCtrl = petltCtrl.getPetTelentAndSecialSkill(petId, rank + 1, petMaxLev), petltCtrl.getPetTelentAndSecialSkill(petId, rank + 1, petMaxLev)
	if tableAttr1 and next(tableAttr1) then
		petltCtrl = rank + 1
		;(rank + 1).type = 1
		;(rank + 1).value = tableAttr1
		table.insert(self.atts, rank + 1)
	end
	for i, v in ipairs(tableAttr.special_add) do
		local nextValue = nextRankMaxLvTableAttr and nextRankMaxLvTableAttr.special_add and nextRankMaxLvTableAttr.special_add[i] or nil
		petltCtrl = nil
		;(nil).type = 2
		;(nil).value = v
		;(nil).nextValue = nextValue
		table.insert(self.atts, nil)
	end
	for i, v in ipairs(tableAttr.telent) do
		local nextValue = nextRankMaxLvTableAttr and nextRankMaxLvTableAttr.telent and nextRankMaxLvTableAttr.telent[i] or nil
		petltCtrl = nil
		;(nil).type = 3
		;(nil).value = v
		;(nil).nextValue = nextValue
		table.insert(self.atts, nil)
	end
	self.fields.scroll_attributes:setNumItems(#self.atts)
end
function PetFguiViewPanel:updateTrainDetail()
	local petId = self.curPet.pid
	self.fields.LoadingBar_progress:setVisible(self.isUnlock)
	self.fields.node_finger:setVisible(not self.isUnlock and self.isCanUnlock and SoraDIsGameGuide() == nil)
	self.fields.btn_unlock:setVisible(not self.isUnlock and self.isCanUnlock)
	self.fields.PetUnLock:setVisible(not self.isUnlock and not self.isCanUnlock)
	local maxLv = petltCtrl.getPetMaxLev(petId)
	if self.isUnlock then
		local isMaxLv = maxLv <= self.petData.level
		local isFull = self.petData:getPetIsReachMaxLvInCurRank() and not self.petData:getPetIsReachMaxRank()
		self.isFull = isFull
		self.fields.com_rankup:setVisible(isFull)
		self.fields.LoadingBar_progress_rank:setVisible(isFull)
		self.fields.com_levelup:setVisible(not isFull and not isMaxLv)
		self.fields.LoadingBar_progress:setVisible(not isFull)
		if isFull then
			self.fields.com_levelup:isFeedItemClick(false)
			self.fields.com_rankup:initData(self.petData, self.isShowPetAdvancePoint and self.pointHides[petId] == nil)
			self.fields.LoadingBar_progress_rank:initDataUpStage(self.petData)
			self.fields.scroll_attributes:setVisible(true)
			if SoraDIsGameGuide() == nil then
				local guideCtrl = gametop.playertop_:getModule("guideCtrl")
				guideCtrl:updateGuideModule(gGuideModule.PET_ADVANCED)
			end
		else
			self.fields.com_levelup:initData(self.petData)
			self.fields.LoadingBar_progress:initData(self.petData)
			if petCtrl.feedInfo.curToolFeedExp >= PET_FEED_TOOL_EXP_LIMIT then
				self.fields.com_levelup:isFeedItemClick(false)
				self.fields.scroll_attributes:setVisible(true)
			end
		end
		self.fields.Com_power:setString(string.formatnumberthousands(self.petData:getPower()))
		self:updateAttr(petId, self.petData.level, self.curRank, isFull)
		self.fields.text_max_tip:setVisible(self.petData:getPetIsReachMaxRank() and isMaxLv)
	else
		self.fields.text_max_tip:setVisible(false)
		self.fields.com_rankup:setVisible(false)
		self.fields.com_levelup:setVisible(false)
		self.fields.LoadingBar_progress_rank:setVisible(false)
		self.fields.LoadingBar_progress:setVisible(false)
		local maxRank = #self.curPet.rankInfo
		local maxPower = petltCtrl.getPetPowerByLvAndRank(petId, maxLv, maxRank)
		self.fields.Com_power:setString(string.formatnumberthousands(maxPower))
		_ENV = string.formatnumberthousands(maxPower)
		string.formatnumberthousands(maxPower).num = maxLv
		self.fields.txt_unlock_lv:setString(i18n("Dear_pet_main_02", string.formatnumberthousands(maxPower)))
		if not self.isCanUnlock then
			self.fields.PetUnLock:initData(petId)
		elseif not self.isAddFinger then
			local spriteFinger = SoraDFingerAction()
			self.fields.node_finger:setContent(spriteFinger)
			self.isAddFinger = true
		end
		self:updateAttr(petId, maxLv, self.curRank)
	end
	if self.isShowPetAdvancePoint then
		self.pointHides[petId] = true
	end
	dump(self.pointHides, "self.pointHides")
end
function PetFguiViewPanel:updateAddExpPreview(data)
	local petMaxLev = petltCtrl.getPetMaxLevInRank(self.petData.petid, self.petData.rank)
	petltCtrl = nil
	;(nil).lv = math.min(data.previewLevel, petMaxLev)
	local level = i18n("common_text_100", nil)
	if data.previewLevel == petMaxLev then
		petltCtrl = math.min(data.previewLevel, petMaxLev)
		math.min(data.previewLevel, petMaxLev).maxValue = data.previewLevelExp
		math.min(data.previewLevel, petMaxLev).curValue = data.previewLevelExp
		self.fields.LoadingBar_progress:setPreviewValue(math.min(data.previewLevel, petMaxLev), level, data.deltaExp, self.petData.level ~= data.previewLevel)
	else
		petltCtrl = math.min(data.previewLevel, petMaxLev)
		math.min(data.previewLevel, petMaxLev).maxValue = data.previewLevelExp
		math.min(data.previewLevel, petMaxLev).curValue = data.previewExp
		self.fields.LoadingBar_progress:setPreviewValue(math.min(data.previewLevel, petMaxLev), level, data.deltaExp, self.petData.level ~= data.previewLevel)
	end
end
function PetFguiViewPanel:onShow()
	print("=======PetFguiViewPanel:onShow")
	self:updateRedPoint()
	self.soundId = SoraDPlaySound("uicontrol", 56)
	local petId = self.proxy.param and self.proxy.param.petid or nil
	self:setSelectPetId(petId, true)
	if self.proxy.param and self.proxy.param.useItem then
		self:gotoUseItem()
	end
end
function PetFguiViewPanel:updateRedPoint()
	self.isShowPetAdvancePoint = petCtrl:getHasCanAdvancePet()
	if self.isShowPetAdvancePoint then
		petCtrl = nil
		;(nil).byUID = true
		SoraDConfigSet("petCtrl:getHasCanAdvancePet:lastOpenTime~integer", serviceFunctions.systemTime(), nil)
		petCtrl = "petCtrl:getHasCanAdvancePet:lastOpenTime~integer"
		;("petCtrl:getHasCanAdvancePet:lastOpenTime~integer").msg = "MESSAGE_MAINCITYVIEW_UPDATE_PET_CENTER_VIEW"
		SoraDSendMessage("petCtrl:getHasCanAdvancePet:lastOpenTime~integer")
	end
	self.pointHides, petCtrl = SoraDSendMessage, SoraDSendMessage
end
function PetFguiViewPanel:onHide()
	if self.soundId then
		AudioEngine.stopEffect(self.soundId)
	end
end
function PetFguiViewPanel:onPetHeadRenderer(index, obj)
	local petData = self.tablePetMap[index + 1]
	local isSelected = petData.pid == self.selectPetId
	if isSelected then
		self.curIndex = index
	end
	obj:initData(petData, index + 1, isSelected, self)
	obj:setIsShowPetAdvancePoint(petCtrl:getPet(petData.pid), self.isShowPetAdvancePoint and self.pointHides[petData.pid] == nil and not isSelected)
end
function PetFguiViewPanel:onAttributeRenderer(index, obj)
	local data = self.atts[index + 1]
	if index == 0 and data.type == 1 then
		self.guideObject = obj
	end
	obj:initData(data, self.petData, index + 1)
end
function PetFguiViewPanel:onAttributeProvider(index)
	local data = self.atts[index + 1]
	if data.type == 2 or data.type == 3 then
		return "ui://PetFguiView/Pet_Com_Attribute_2"
	else
		return "ui://PetFguiView/Pet_Com_Attribute"
	end
end
function PetFguiViewPanel:onUnlockClick()
	SoraDPlaySound()
	SoraDShowLoading()
	petCtrl:reqUnlockPet(self.selectPetId)
end
function PetFguiViewPanel:onClick_btn_strongest(sender, event)
	SoraDPlaySound()
	if self.curPet.pid == 1251 then
		SoraDShowMsgTip(i18n("pet_text_21"))
		return
	end
	self.fields.pet_model:setVisible(false)
	_ENV = i18n("pet_text_21")
	i18n("pet_text_21").pid = self.curPet.pid
	uiManager:show("PetLordView", i18n("pet_text_21"))
end
function PetFguiViewPanel:onClick_btn_share(sender, event)
	SoraDPlaySound()
	local isUnlock = petCtrl:isPetUnlock(self.curPet.pid)
	local isCanUnlock = petCtrl:petIsCanUnlock(self.curPet.pid)
	if not isUnlock then
		SoraDShowMsgTip(i18n("common_text_2274"))
		return
	end
	_ENV = i18n("common_text_2274")
	i18n("common_text_2274").sharePid = self.curPet.pid
	uiManager:show("PetShareBox", i18n("common_text_2274"))
end
function PetFguiViewPanel:onClick_btn_show(sender, event)
	SoraDPlaySound()
	local isUnlock = petCtrl:isPetUnlock(self.curPet.pid)
	local isCanUnlock = petCtrl:petIsCanUnlock(self.curPet.pid)
	if not isUnlock then
		SoraDShowMsgTip(i18n("common_text_2274"))
		return
	end
	_ENV = i18n("common_text_2274")
	i18n("common_text_2274").byUID = true
	local showPid = SoraDConfigGet("Game:petView:cityPetShow~integer", i18n("common_text_2274"))
	if showPid == self.curPet.pid then
		SoraDShowMsgTip(i18n("common_text_3207"))
	else
		SoraDShowMsgTip(i18n("common_text_3206"))
		_ENV = i18n("common_text_3206")
		i18n("common_text_3206").byUID = true
		SoraDConfigSet("Game:petView:cityPetShow~integer", self.curPet.pid, i18n("common_text_3206"))
		self.fields.btn_show:setGrayed(false)
		_ENV = self.fields.btn_show
		self.fields.btn_show.msg = "MESSAGE_MAINCITYVIEW_UPDATE_PET_SHOW"
		SoraDSendMessage(self.fields.btn_show)
	end
end
function PetFguiViewPanel:showPetPreview(sender, param)
	SoraDPlaySound()
	self.fields.pet_model:setVisible(false)
	_ENV = nil
	;(nil).pid = self.curPet.pid
	uiManager:show("PetPreviewView", nil)
end
function PetFguiViewPanel:onPageBtnClick(sender, params)
	local nextIdx = self.selectIndex + params
	if nextIdx > #self.tablePetMap then
		nextIdx = 1
	elseif nextIdx <= 0 then
		nextIdx = #self.tablePetMap
	end
	local curPet = self.tablePetMap[nextIdx]
	self.fields.scroll_attributes:setVisible(true)
	self.fields.com_levelup:isFeedItemClick(false)
	self:setSelectPetId(curPet.pid)
	self.fields.scroll_pets:scrollToView(nextIdx - 1, false, false)
end
function PetFguiViewPanel:gotoUseItem()
	if petCtrl.feedInfo.curToolFeedExp >= PET_FEED_TOOL_EXP_LIMIT then
		self.isCooling = true
	else
		self.isCooling = false
	end
	if self.petData == nil then
		return
	end
	local isFull = self.petData:getPetIsReachMaxLvInCurRank() and not self.petData:getPetIsReachMaxRank()
	if isFull then
	elseif self.petData:getPetIsReachMaxLvInCurRank() and self.petData:getPetIsReachMaxRank() then
	elseif self.isCooling then
		SoraDShowMsgTip(i18n("common_text_2939"))
	else
		self.fields.com_levelup:isFeedItemClick(true)
		petCtrl = self.fields.com_levelup
		self.fields.com_levelup.msg = "MESSAGE_UI_PET_ISFEEDITEM_SHOW"
		self.fields.com_levelup.data = true
		SoraDSendMessage(self.fields.com_levelup)
	end
end
function PetFguiViewPanel:onIntoPanel()
	self.fields.pet_model:setVisible(true)
end
function PetFguiViewPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "btnLock" then
		if self.isUnlock then
			print("宠物已解锁，引导直接完成！", gGuideStep.PET_UNLOCK_COMPLETE)
			guideCtrl:testCompleteGuide(gGuideStep.PET_UNLOCK_COMPLETE)
			_ENV = guideCtrl
			guideCtrl.msg = "MESSAGE_SERVER_GUIDE_STEP_END"
			guideCtrl.step = parameters.endStep
			SoraDSendMessage(guideCtrl)
			_ENV = guideCtrl
			guideCtrl.msg = "MESSAGE_SERVER_CLOSE_GUIDE"
			SoraDSendMessage(guideCtrl)
			return nil
		end
		return self.fields.btn_unlock
	elseif itemName == "Image_proShowRect" then
		return self.fields.Image_proShowRect
	elseif itemName == "Image_proShowRect_Rank" then
		return self.fields.Image_proShowRect_Rank
	elseif itemName == "CCS_commonGoldNormalBtn_feed" then
		return self.fields.com_levelup:gameGuide_getTarget(itemName, parameters)
	elseif itemName == "CCS_commonGoldNormalBtn_advance" then
		return self.fields.com_rankup:gameGuide_getTarget(itemName, parameters)
	elseif itemName == "btn_claim" then
		if not self.guideObject then
			_ENV = self.fields.com_rankup
			self.fields.com_rankup.msg = "MESSAGE_SERVER_GUIDE_STEP_END"
			self.fields.com_rankup.step = parameters.endStep
			SoraDSendMessage(self.fields.com_rankup)
			_ENV = self.fields.com_rankup
			self.fields.com_rankup.msg = "MESSAGE_SERVER_CLOSE_GUIDE"
			SoraDSendMessage(self.fields.com_rankup)
			return nil
		else
			return self.guideObject:gameGuide_getTarget(itemName, parameters)
		end
	end
	return SoraDGetChildByName(self, itemName)
end
return PetFguiViewPanel
