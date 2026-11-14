local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activity_9001630_Ctrl = SoraDGetCtrl("activity_9001630_Ctrl")
local publicRead = include("publicRead")
local constantRead = include("constantRead")
local activity_9001630_Read = include("activity_9001630_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001630_MainPanel = class("Activity_9001630_MainPanel", baseFguiPanel)
function Activity_9001630_MainPanel:ctor(...)
	Activity_9001630_MainPanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001630_MainPanel:ctor", self.viewName)
end
function Activity_9001630_MainPanel:onInit()
	print("=======Activity_9001630_MainPanel:onInit")
	print("=======Activity_9001630_MainPanel:onInit")
	self.activityID = gActivityTimeActivityID.NEBULA_DISNEYLADN
	self.itemID = constantRead.getConstValue("NEBULA_PARADISE_DRAW_ITEM", 868901)
	self.fields.Com_title:initData(i18n("activity_name_9001630"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Label_time:initCommonActivityTime(self.activityID)
	self.fields.Button_Reward:setString(i18n("nebula_paradise_text_05"))
	self.fields.Button_Reward:addClickListener(handler(self, self.onClickPreaward))
	self.fields.btn_dailyReward:setString(i18n("datepalm_tree_text18"))
	self.fields.btn_dailyReward:addClickListener(handler(self, self.onClickDailyReward))
	self.fields.Button_Log:setString(i18n("nebula_paradise_text_07"))
	self.fields.Button_Log:addClickListener(handler(self, self.onClickLog))
	self.fields.Com_Have:initData(self.itemID)
	_ENV = handler(self, self.onClickLog)
	handler(self, self.onClickLog).num = 1
	self.fields.Button_One:setString(i18n("nebula_paradise_text_03", handler(self, self.onClickLog)))
	self.fields.Button_One:addClickListener(handler(self, self.onClickOne))
	_ENV = handler(self, self.onClickOne)
	handler(self, self.onClickOne).num = 10
	self.fields.Button_Ten:setString(i18n("nebula_paradise_text_04", handler(self, self.onClickOne)))
	self.fields.Button_Ten:addClickListener(handler(self, self.onClickTen))
	self.boxInfo = activity_9001630_Read.getStageConfig()
end
function Activity_9001630_MainPanel:onShow()
	print("=======Activity_9001630_MainPanel:onShow")
	self:updateView()
end
function Activity_9001630_MainPanel:updateView()
	self:updateStageButton()
	self:updateButton()
	self:updateDaily()
end
function Activity_9001630_MainPanel:initProgress()
	local fields = fguiHelper.get_fields(self.fields.Bar_score)
	local personScore = activity_9001630_Ctrl:getScore()
	fields.List_box:setItemRenderer(handler(self, self.onBoxRenderer))
	local passIndex = 0
	fields.List_box:setNumItems(#self.boxInfo)
	fields.List_box:setSize(cc.size(110 * #self.boxInfo, 103))
	local singlePassPercent = 1 / #self.boxInfo * 100
	local curShowBoxIdx = 0
	for i, v in ipairs(self.boxInfo) do
		if personScore >= v.point then
			passIndex = passIndex + 1
		end
		local getStatus = activity_9001630_Ctrl:getBoxRewardDataStatus(v.index, v.point)
		if getStatus == gBtnTargetStatusDef.GET and curShowBoxIdx == 0 then
			curShowBoxIdx = i
		end
	end
	if curShowBoxIdx == 0 and passIndex ~= 0 then
		curShowBoxIdx = passIndex + 1
	end
	local percent = 0
	if personScore < self.boxInfo[1].point then
		fields.Bar_score:setPercent(0)
		percent = 0
	elseif passIndex < #self.boxInfo then
		local littlePercent = (personScore - self.boxInfo[passIndex].point) / (self.boxInfo[passIndex + 1].point - self.boxInfo[passIndex].point) * singlePassPercent
		percent = singlePassPercent * passIndex + littlePercent
		fields.Bar_score:setPercent(percent / 100)
	else
		fields.Bar_score:setPercent(1)
		percent = 100
	end
	_UPVALUE3_ = fields.Bar_score
	fields.Bar_score[1] = percent
	fields.Bar_score[2] = passIndex
	fields.Bar_score[3] = curShowBoxIdx
	dump(fields.Bar_score, "percent")
	fields.Bar_score:fixChildrenPos()
	self.fields.Bar_score:getScrollPane():setPercX(SoraDFIsRA() and 1 - curShowBoxIdx / #self.boxInfo + 1 / #self.boxInfo or curShowBoxIdx / #self.boxInfo)
	fields.List_box:setPositionX(SoraDFIsRA() and 0 or 50)
	_ENV = curShowBoxIdx
	_ENV, _ENV, curShowBoxIdx.num = v.index, gBtnTargetStatusDef.GET, personScore
	gBtnTargetStatusDef.GET.num, v.index.color = v.index, "#FFDF2D"
	self.fields.text_value:setString(i18n_html("common_text_2557", curShowBoxIdx, gBtnTargetStatusDef.GET))
end
function Activity_9001630_MainPanel:onBoxRenderer(index, obj)
	local boxInfo = self.boxInfo[index + 1]
	obj:initData(boxInfo, index + 1)
	obj:setClickHandler(handler(self, self.buttonGetRewardCallBack))
end
function Activity_9001630_MainPanel:buttonGetRewardCallBack(button, index)
	SoraDPlaySound()
	_ENV = nil
	;(nil).index = index
	;(nil).data = self.boxInfo[index]
	uiManager:show("Activity_9001630_StageReward", nil)
end
function Activity_9001630_MainPanel:getCardIsSame(newCard, index)
	for i, v in ipairs(newCard) do
		if i ~= index and v == newCard[index] then
			return true
		end
	end
end
function Activity_9001630_MainPanel:updateStageButton()
	self:initProgress()
end
function Activity_9001630_MainPanel:updateButton()
	self.fields.Button_One:setCost(self.itemID, 1)
	self.fields.Button_Ten:setCost(self.itemID, 10)
	self.fields.Com_Have:updateNum()
	self:showDouble(activity_9001630_Ctrl:getIsDouble())
end
function Activity_9001630_MainPanel:updateDaily()
	self.isHaveDaily = activity_9001630_Ctrl:getIsHaveDaily()
	self.fields.btn_dailyReward:setReddot(self.isHaveDaily)
	self.fields.btn_dailyReward:initData(self.isHaveDaily)
end
function Activity_9001630_MainPanel:showDouble(isShow)
	self.controllers.c1:setSelectedIndex(isShow and 1 or 0)
end
function Activity_9001630_MainPanel:playFlipAnimation(reward)
	local newCardId = activity_9001630_Ctrl:getNewCardRecord()
	local newCard = activity_9001630_Read.getRewardCard(newCardId)
	for i = 1, 3 do
		self.fields[string.format("Flip_Icon%d", SoraDFPosX(i, 4))]:initData(newCard[i], false)
		self.fields[string.format("Flip_Icon%d", SoraDFPosX(i, 4))]:setVisible(true)
		self.fields[string.format("Flip_Icon%d", SoraDFPosX(i, 4))]:resetEffect(i)
	end
	self.fields.Usm_OpenEffect:play(false)
	self.fields.Usm_OpenEffect:runAction(ffa.seq(ffa.delay(1.7), ffa.callFunc(function()
		SoraDMailGainItems(reward, true)
		self.isOpen = false
	end)))
end
function Activity_9001630_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	_ENV = nil
	;(nil).item = publicRead.getName(self.itemID)
	;(nil).content = i18n("nebula_paradise_text_01", nil)
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function Activity_9001630_MainPanel:onClickPreaward()
	SoraDPlaySound()
	uiManager:show("Activity_9001630_Preaward")
end
function Activity_9001630_MainPanel:onClickDailyReward()
	SoraDPlaySound()
	if self.isHaveDaily then
		activity_9001630_Ctrl:reqDaily()
	else
		SoraDShowMsgTip(i18n("ramadan_text_29"))
	end
end
function Activity_9001630_MainPanel:onClickLog()
	SoraDPlaySound()
	uiManager:show("Activity_9001630_Log")
end
function Activity_9001630_MainPanel:onClickOne()
	SoraDPlaySound()
	if self.isOpen then
		return
	end
	if backpackCtrl:getItemCount(self.itemID) > 0 then
		self.isOpen = true
		self:showDouble(false)
		SoraDShowLoading(self)
		activity_9001630_Ctrl:reqLottery(1)
	else
		_ENV = nil
		;(nil).item = publicRead.getName(self.itemID)
		SoraDShowMsgTip(i18n("Glory_text_19", nil))
	end
end
function Activity_9001630_MainPanel:onClickTen()
	SoraDPlaySound()
	if self.isOpen then
		return
	end
	if backpackCtrl:getItemCount(self.itemID) >= 10 then
		for i = 1, 3 do
			self.fields[string.format("Flip_Icon%d", SoraDFPosX(i, 4))]:setVisible(false)
		end
		self:showDouble(false)
		SoraDShowLoading(self)
		activity_9001630_Ctrl:reqLottery(10)
	else
		_ENV = nil
		;(nil).item = publicRead.getName(self.itemID)
		SoraDShowMsgTip(i18n("Glory_text_19", nil))
	end
end
return Activity_9001630_MainPanel
