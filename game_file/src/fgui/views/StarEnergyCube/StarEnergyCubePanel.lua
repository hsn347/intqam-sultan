local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local constantRead = include("constantRead")
local starCubeCtrl = SoraDGetCtrl("starCubeCtrl")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local starEnergyCubeRead = include("starEnergyCubeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local StarEnergyCubePanel = class("StarEnergyCubePanel", baseFguiPanel)
function StarEnergyCubePanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("StarEnergyCubePanel:ctor", self.viewName)
end
function StarEnergyCubePanel:getPackageList()
	if not self._packageList then
		_UPVALUE3_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "NebulaRegionSign"
		self._packageList, self._packageList[2] = self._packageList, "CommonBoxSingle"
		self._packageList, self._packageList[3] = self._packageList, "TowerDefend"
	end
	return self._packageList
end
function StarEnergyCubePanel:onInit()
	print("=======StarEnergyCubePanel:onInit")
	_UPVALUE5_ = "=======StarEnergyCubePanel:onInit"
	;("=======StarEnergyCubePanel:onInit")[1] = "Com_key2"
	;("=======StarEnergyCubePanel:onInit")[2] = "Com_key3"
	;("=======StarEnergyCubePanel:onInit")[3] = "Button_add"
	;("=======StarEnergyCubePanel:onInit")[4] = "icon"
	;("=======StarEnergyCubePanel:onInit")[5] = "Button_accuReward"
	for i, v in ipairs("=======StarEnergyCubePanel:onInit") do
		self.fields[v]:fixPos()
	end
	self.functionCol = self:initFunc()
	self.controllers.version:setSelectedIndex(1)
	self.fields.Com_title:initData(i18n("activity_name_9001446"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Label_time:initActivityTimeStyle(gActivityTimeActivityID.STAR_CUBE_ACTIVITY)
	self.fields.Usm_box:setPrepareCallback(function()
		self.fields.Usm_box:getCriSprite():start()
	end)
	self.fields.Usm_box:setCompleteCallback(function()
		self.isOpening = false
		self:updateOpenBtnState()
		self.fields.Usm_box:setVisible(false)
		self.fields.Effect_key:setVisible(false)
		self.controllers.ani:setSelectedIndex(0)
		self.fields.Effect_cube:setVisible(true)
		self:initData()
	end)
	self.fields.Effect_key:setIsLoop(false)
	self.fields.Button_accuReward:getChild("Ani_box"):setAllFrameName("dh_jinengyj01_%03d.png", 0)
	self.fields.Button_go:setTitleText(i18n("star_cube_09"))
	self.fields.Button_open:setTitleText(i18n("Martial_arts_text_08"))
	self.fields.Button_open10:setTitleText(i18n("star_cube_21"))
	self.fields.Text_reward:setString(i18n("star_cube_07"))
	self.fields.Button_go:addClickListener(handler(self, self.onClickGo))
	self.fields.Button_open:addClickListener(handler(self, self.onClickOpen))
	self.fields.Button_open10:addClickListener(handler(self, self.onClickOpen10))
	self.fields.Button_accuReward:addClickListener(handler(self, self.onClickAccuReward))
	self.fields.Button_add:addClickListener(handler(self, self.onClickGo))
	self.fields.List_cube:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRendererReward))
	self.index = 1
	self.isOpening = false
	self.boxOpenLimitTimes = constantRead.getConstValue("STAR_CUBE_BOX_LIMIT")
	self.accuBoxConfig = starEnergyCubeRead:getAccuRewardInfo()
	self:initData()
end
function StarEnergyCubePanel:initData(index)
	self.index = index or self.index
	self:setStageReward()
	self:initPageView(self.index)
	self.fields.List_cube:setNumItems(starEnergyCubeRead:getBoxCount())
	if not self.first then
		self.fields.List_cube:addSelection(0, true)
		self.first = true
	end
end
_UPVALUE5_, StarEnergyCubePanel.setStageReward = function(self)
	local curScore, stageScore, boxIndex, type = starEnergyCubeRead:getNextAccuRewardInfo(starCubeCtrl:getTotalOpenTimes())
	self.fields.Button_accuReward:setTitleText(i18n("STAR_CUBE_16") .. "\n" .. curScore .. "/" .. stageScore)
	self.fields.Button_accuReward:getController("c1"):setSelectedIndex(type - 1)
	local text = self.fields.Button_accuReward:getChild("title")
	if text:getHeight() > 50 then
		text:setAutoSize(fgui.AutoSizeType.SHRINK)
		text:setSize(cc.size(100, 50))
	end
	if type == 1 then
		self.fields.Button_accuReward:setIcon(self.accuBoxConfig[boxIndex].boxIconNormal .. ".png")
	elseif type == 2 then
		self.fields.Button_accuReward:setIcon(self.accuBoxConfig[boxIndex].boxIconNormal .. ".png")
	elseif type == 3 then
		self.fields.Button_accuReward:setIcon(self.accuBoxConfig[boxIndex].boxIconOpened .. ".png")
	end
end, function(self)
	local curScore, stageScore, boxIndex, type = starEnergyCubeRead:getNextAccuRewardInfo(starCubeCtrl:getTotalOpenTimes())
	self.fields.Button_accuReward:setTitleText(i18n("STAR_CUBE_16") .. "\n" .. curScore .. "/" .. stageScore)
	self.fields.Button_accuReward:getController("c1"):setSelectedIndex(type - 1)
	local text = self.fields.Button_accuReward:getChild("title")
	if text:getHeight() > 50 then
		text:setAutoSize(fgui.AutoSizeType.SHRINK)
		text:setSize(cc.size(100, 50))
	end
	if type == 1 then
		self.fields.Button_accuReward:setIcon(self.accuBoxConfig[boxIndex].boxIconNormal .. ".png")
	elseif type == 2 then
		self.fields.Button_accuReward:setIcon(self.accuBoxConfig[boxIndex].boxIconNormal .. ".png")
	elseif type == 3 then
		self.fields.Button_accuReward:setIcon(self.accuBoxConfig[boxIndex].boxIconOpened .. ".png")
	end
end
;(function(self)
	local curScore, stageScore, boxIndex, type = starEnergyCubeRead:getNextAccuRewardInfo(starCubeCtrl:getTotalOpenTimes())
	self.fields.Button_accuReward:setTitleText(i18n("STAR_CUBE_16") .. "\n" .. curScore .. "/" .. stageScore)
	self.fields.Button_accuReward:getController("c1"):setSelectedIndex(type - 1)
	local text = self.fields.Button_accuReward:getChild("title")
	if text:getHeight() > 50 then
		text:setAutoSize(fgui.AutoSizeType.SHRINK)
		text:setSize(cc.size(100, 50))
	end
	if type == 1 then
		self.fields.Button_accuReward:setIcon(self.accuBoxConfig[boxIndex].boxIconNormal .. ".png")
	elseif type == 2 then
		self.fields.Button_accuReward:setIcon(self.accuBoxConfig[boxIndex].boxIconNormal .. ".png")
	elseif type == 3 then
		self.fields.Button_accuReward:setIcon(self.accuBoxConfig[boxIndex].boxIconOpened .. ".png")
	end
end)[1] = "star_01zise"
;(function(self)
	local curScore, stageScore, boxIndex, type = starEnergyCubeRead:getNextAccuRewardInfo(starCubeCtrl:getTotalOpenTimes())
	self.fields.Button_accuReward:setTitleText(i18n("STAR_CUBE_16") .. "\n" .. curScore .. "/" .. stageScore)
	self.fields.Button_accuReward:getController("c1"):setSelectedIndex(type - 1)
	local text = self.fields.Button_accuReward:getChild("title")
	if text:getHeight() > 50 then
		text:setAutoSize(fgui.AutoSizeType.SHRINK)
		text:setSize(cc.size(100, 50))
	end
	if type == 1 then
		self.fields.Button_accuReward:setIcon(self.accuBoxConfig[boxIndex].boxIconNormal .. ".png")
	elseif type == 2 then
		self.fields.Button_accuReward:setIcon(self.accuBoxConfig[boxIndex].boxIconNormal .. ".png")
	elseif type == 3 then
		self.fields.Button_accuReward:setIcon(self.accuBoxConfig[boxIndex].boxIconOpened .. ".png")
	end
end)[2] = "star_03yinse"
;(function(self)
	local curScore, stageScore, boxIndex, type = starEnergyCubeRead:getNextAccuRewardInfo(starCubeCtrl:getTotalOpenTimes())
	self.fields.Button_accuReward:setTitleText(i18n("STAR_CUBE_16") .. "\n" .. curScore .. "/" .. stageScore)
	self.fields.Button_accuReward:getController("c1"):setSelectedIndex(type - 1)
	local text = self.fields.Button_accuReward:getChild("title")
	if text:getHeight() > 50 then
		text:setAutoSize(fgui.AutoSizeType.SHRINK)
		text:setSize(cc.size(100, 50))
	end
	if type == 1 then
		self.fields.Button_accuReward:setIcon(self.accuBoxConfig[boxIndex].boxIconNormal .. ".png")
	elseif type == 2 then
		self.fields.Button_accuReward:setIcon(self.accuBoxConfig[boxIndex].boxIconNormal .. ".png")
	elseif type == 3 then
		self.fields.Button_accuReward:setIcon(self.accuBoxConfig[boxIndex].boxIconOpened .. ".png")
	end
end)[3] = "star_02jinse"
;(function(self)
	local curScore, stageScore, boxIndex, type = starEnergyCubeRead:getNextAccuRewardInfo(starCubeCtrl:getTotalOpenTimes())
	self.fields.Button_accuReward:setTitleText(i18n("STAR_CUBE_16") .. "\n" .. curScore .. "/" .. stageScore)
	self.fields.Button_accuReward:getController("c1"):setSelectedIndex(type - 1)
	local text = self.fields.Button_accuReward:getChild("title")
	if text:getHeight() > 50 then
		text:setAutoSize(fgui.AutoSizeType.SHRINK)
		text:setSize(cc.size(100, 50))
	end
	if type == 1 then
		self.fields.Button_accuReward:setIcon(self.accuBoxConfig[boxIndex].boxIconNormal .. ".png")
	elseif type == 2 then
		self.fields.Button_accuReward:setIcon(self.accuBoxConfig[boxIndex].boxIconNormal .. ".png")
	elseif type == 3 then
		self.fields.Button_accuReward:setIcon(self.accuBoxConfig[boxIndex].boxIconOpened .. ".png")
	end
end)[4] = "star_05lvse"
local (function(self)
	local curScore, stageScore, boxIndex, type = starEnergyCubeRead:getNextAccuRewardInfo(starCubeCtrl:getTotalOpenTimes())
	self.fields.Button_accuReward:setTitleText(i18n("STAR_CUBE_16") .. "\n" .. curScore .. "/" .. stageScore)
	self.fields.Button_accuReward:getController("c1"):setSelectedIndex(type - 1)
	local text = self.fields.Button_accuReward:getChild("title")
	if text:getHeight() > 50 then
		text:setAutoSize(fgui.AutoSizeType.SHRINK)
		text:setSize(cc.size(100, 50))
	end
	if type == 1 then
		self.fields.Button_accuReward:setIcon(self.accuBoxConfig[boxIndex].boxIconNormal .. ".png")
	elseif type == 2 then
		self.fields.Button_accuReward:setIcon(self.accuBoxConfig[boxIndex].boxIconNormal .. ".png")
	elseif type == 3 then
		self.fields.Button_accuReward:setIcon(self.accuBoxConfig[boxIndex].boxIconOpened .. ".png")
	end
end)[5], effectPath = "star_04huise", function(self)
	local curScore, stageScore, boxIndex, type = starEnergyCubeRead:getNextAccuRewardInfo(starCubeCtrl:getTotalOpenTimes())
	self.fields.Button_accuReward:setTitleText(i18n("STAR_CUBE_16") .. "\n" .. curScore .. "/" .. stageScore)
	self.fields.Button_accuReward:getController("c1"):setSelectedIndex(type - 1)
	local text = self.fields.Button_accuReward:getChild("title")
	if text:getHeight() > 50 then
		text:setAutoSize(fgui.AutoSizeType.SHRINK)
		text:setSize(cc.size(100, 50))
	end
	if type == 1 then
		self.fields.Button_accuReward:setIcon(self.accuBoxConfig[boxIndex].boxIconNormal .. ".png")
	elseif type == 2 then
		self.fields.Button_accuReward:setIcon(self.accuBoxConfig[boxIndex].boxIconNormal .. ".png")
	elseif type == 3 then
		self.fields.Button_accuReward:setIcon(self.accuBoxConfig[boxIndex].boxIconOpened .. ".png")
	end
end
function StarEnergyCubePanel:initPageView(boxIndex)
	self.boxIndex = boxIndex
	self.config = starEnergyCubeRead:getTreasureChestInfo(boxIndex)
	self.fields.Text_cubeName:setString(i18n(self.config.name))
	self.fields.Effect_cube:setEffectPath(effectPath[boxIndex])
	self.controllers.zise:setSelectedIndex(boxIndex == 1 and 1 or 0)
	self.rewards = starEnergyCubeRead:getRadomRewardByType(boxIndex)
	if self.rewards and next(self.rewards) then
		self.fields.List_reward:setNumItems(table.nums(self.rewards))
		local highlight = starEnergyCubeRead:getRewardHightlightByType(boxIndex)
		if highlight and next(highlight) then
			for i, v in ipairs(highlight) do
				self.fields.List_reward:getChildAt(v - 1):setAdvance()
			end
		end
	else
		self.controllers.c1:setSelectedIndex(1)
	end
	self.fields.Text_leftTime:setString(i18n("star_cube_04") .. self.boxOpenLimitTimes - starCubeCtrl:getOpenBoxTimes(boxIndex))
	local state = 1
	if 1 <= backpackCtrl:getItemCount(self.config.core1) then
		state = 3
		goto lbl_106
		state = 2
	end
	::lbl_106::
	local remainOpenTimes = self.boxOpenLimitTimes - starCubeCtrl:getOpenBoxTimes(self.boxIndex)
	self:setOpenBtnState(1 <= backpackCtrl:getItemCount(self.config.core1) and remainOpenTimes ~= 0)
	self.fields.Com_key1:initData(1, self.config.core1, state, self.config.name)
	self:setCore1Count(self.config.core1)
	self.fields.Button_go:setVisible(state == 1 and 1 > backpackCtrl:getItemCount(self.config.core1))
	self:updateOpenBtnState()
end
function StarEnergyCubePanel:updateOpenBtnState()
	if self.isOpening then
		return
	end
	if backpackCtrl:getItemCount(self.config.core1) >= 10 then
		self.controllers.openButton:setSelectedIndex(1)
		if SoraDGetDefaultLanguage() ~= "ar" then
			self.fields.Button_open:setPositionX(self:getWidth() / 2 - self.fields.Button_open:getWidth() / 2 + 120)
			self.fields.Button_open10:setPositionX(self:getWidth() / 2 - self.fields.Button_open10:getWidth() / 2 - 120)
		end
	else
		self.controllers.openButton:setSelectedIndex(0)
		if SoraDGetDefaultLanguage() ~= "ar" then
			self.fields.Button_open:setPositionX(self:getWidth() / 2 - self.fields.Button_open:getWidth() / 2)
		end
	end
end
function StarEnergyCubePanel:setCore1Count(itemID)
	self.fields.Text_num:setString(backpackCtrl:getItemCount(itemID))
	self.fields.icon:setURL(publicRead.getIcon(itemID))
end
_UPVALUE5_, StarEnergyCubePanel.refreshView = function(self, data)
	if not data then
		return self:initData()
	end
	self.openRewards = data.reward
	self.itemID = data.itemID
	self.keyID = data.keyID
	local fun = self.functionCol[data.subMsg]
	if fun then
		fun()
	end
end, function(self, data)
	if not data then
		return self:initData()
	end
	self.openRewards = data.reward
	self.itemID = data.itemID
	self.keyID = data.keyID
	local fun = self.functionCol[data.subMsg]
	if fun then
		fun()
	end
end
;(function(self, data)
	if not data then
		return self:initData()
	end
	self.openRewards = data.reward
	self.itemID = data.itemID
	self.keyID = data.keyID
	local fun = self.functionCol[data.subMsg]
	if fun then
		fun()
	end
end)[1] = "xnmf_zise.usm"
;(function(self, data)
	if not data then
		return self:initData()
	end
	self.openRewards = data.reward
	self.itemID = data.itemID
	self.keyID = data.keyID
	local fun = self.functionCol[data.subMsg]
	if fun then
		fun()
	end
end)[2] = "xnmf_yinse.usm"
;(function(self, data)
	if not data then
		return self:initData()
	end
	self.openRewards = data.reward
	self.itemID = data.itemID
	self.keyID = data.keyID
	local fun = self.functionCol[data.subMsg]
	if fun then
		fun()
	end
end)[3] = "xnmf_jinse.usm"
;(function(self, data)
	if not data then
		return self:initData()
	end
	self.openRewards = data.reward
	self.itemID = data.itemID
	self.keyID = data.keyID
	local fun = self.functionCol[data.subMsg]
	if fun then
		fun()
	end
end)[4] = "xnmf_lvse.usm"
local (function(self, data)
	if not data then
		return self:initData()
	end
	self.openRewards = data.reward
	self.itemID = data.itemID
	self.keyID = data.keyID
	local fun = self.functionCol[data.subMsg]
	if fun then
		fun()
	end
end)[5], usmPath = "xnmf_huise.usm", function(self, data)
	if not data then
		return self:initData()
	end
	self.openRewards = data.reward
	self.itemID = data.itemID
	self.keyID = data.keyID
	local fun = self.functionCol[data.subMsg]
	if fun then
		fun()
	end
end
function StarEnergyCubePanel:initFunc()
	_ENV = nil
	;(nil).enterSuccess = function()
		_ENV = nil
		;(nil).itemID = self.itemID
		uiManager:show("StarEnergyCubeGetTreasure", nil):setOwnerKey(self)
	end
	;(nil).snatchSuccess = function()
		if self.keyID ~= nil then
			self = nil
			;(nil).reward = self.openRewards
			;(nil).isWin = true
			;(nil).keyID = self.keyID
			uiManager:show("StarEnergyCubeBattle", nil):setOwnerKey(self)
		end
		self.keyID = nil
	end
	;(nil).openSuccess = function()
		self.isOpening = true
		self.controllers.ani:setSelectedIndex(1)
		self.fields.Effect_key:setVisible(true)
		self.fields.Effect_key:playOnce()
		if self.fields.Effect_key.effect then
			local yuanpan02 = SoraDGetChildByName(self.fields.Effect_key.effect, "yuanpan02")
			if yuanpan02 then
				yuanpan02:setVisible(false)
			end
			local yuanpan01 = SoraDGetChildByName(self.fields.Effect_key.effect, "yuanpan01")
			if yuanpan01 then
				yuanpan01:setVisible(false)
			end
		end
		print("usmPath[self.boxIndex]", usmPath[self.boxIndex], self.boxIndex)
		self.fields.Usm_box:clearEffect()
		self.fields.Usm_box:setVisible(true)
		self.fields.Usm_box:setEffectPath(usmPath[self.boxIndex], false)
		self.fields.Effect_cube:setVisible(false)
		_ENV = false
		;(false)[1] = ffa.delay(1.8)
		;(false)[2] = ffa.callFunc(function()
			_ENV = nil
			;(nil).reward = self.openRewards
			uiManager:show("StarEnergyCubeOpenReward", nil):setOwnerKey(self)
		end)
		;(false)[3] = ffa.callFunc(function()
			_ENV = nil
			;(nil).reward = self.openRewards
			uiManager:show("StarEnergyCubeOpenReward", nil):setOwnerKey(self)
		end)
		self:runAction(ffa.seq(false))
	end
	;(nil).openFail = function()
		self.isOpening = false
		self:updateOpenBtnState()
	end
	;(nil).stageReward = function()
		self:setStageReward()
	end
	local (nil).buyKey, functionCol = function()
		self:updateOpenBtnState()
	end, nil
	return functionCol
end
function StarEnergyCubePanel:setOpenBtnState(flag)
	self.fields.Button_open:setGrayed(not flag)
	self.fields.Button_open10:setGrayed(not flag)
end
function StarEnergyCubePanel:onItemRenderer(index, object)
	object:initData(index + 1, function(boxIndex)
		SoraDPlaySound()
		self:initData(boxIndex)
	end)
end
function StarEnergyCubePanel:onItemRendererReward(index, object)
	object:initData(self.rewards[index + 1])
end
function StarEnergyCubePanel:onClickOpen()
	SoraDPlaySound()
	local remainOpenTimes = self.boxOpenLimitTimes - starCubeCtrl:getOpenBoxTimes(self.boxIndex)
	if not self.isOpening and 0 < remainOpenTimes and 0 < backpackCtrl:getItemCount(self.config.core1) then
		self.isOpening = true
		self.controllers.openButton:setSelectedIndex(2)
		starCubeCtrl:reqStarCubeOpenBox(self.boxIndex, 1)
		return
	end
	if remainOpenTimes == 0 then
		_ENV = 1
		;(1).name = i18n(self.config.name)
		SoraDShowMsgTip(i18n("star_cube_05", 1))
	else
		SoraDShowMsgTip(i18n("common_text_2512"))
	end
end
function StarEnergyCubePanel:onClickOpen10()
	SoraDPlaySound()
	local remainOpenTimes = self.boxOpenLimitTimes - starCubeCtrl:getOpenBoxTimes(self.boxIndex)
	if not self.isOpening and 10 <= remainOpenTimes and 10 <= backpackCtrl:getItemCount(self.config.core1) then
		self.isOpening = true
		self.controllers.openButton:setSelectedIndex(2)
		starCubeCtrl:reqStarCubeOpenBox(self.boxIndex, 10)
		return
	end
	if remainOpenTimes < 10 then
		_ENV = 10
		;(10).name = i18n(self.config.name)
		SoraDShowMsgTip(i18n("star_cube_05", 10))
	else
		SoraDShowMsgTip(i18n("common_text_2512"))
	end
end
function StarEnergyCubePanel:onClickAccuReward()
	SoraDPlaySound()
	uiManager:show("StarEnergyCubeAccuReward"):setOwnerKey(self)
end
function StarEnergyCubePanel:onClickGo()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = self.config.core1
	uiManager:show("StarEnergyGetWay", nil):setOwnerKey(self)
end
function StarEnergyCubePanel:onClickGet(context)
	SoraDPlaySound()
	local obj = context:getSender()
	starCubeCtrl:reqStarCubeEnter(obj:getTag())
end
function StarEnergyCubePanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("star_cube_02")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function StarEnergyCubePanel:onShow()
	print("=======StarEnergyCubePanel:onShow")
end
return StarEnergyCubePanel
