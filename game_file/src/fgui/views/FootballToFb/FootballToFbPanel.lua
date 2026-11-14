local pitchAgainstHeadCtrl = SoraDGetCtrl("pitchAgainstHeadCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local constantRead = include("constantRead")
local publicRead = include("publicRead")
local itemDesRead = include("itemDesRead")
_ENV = "itemDesRead"
;("itemDesRead").TOOL = 1
local ("itemDesRead").GOLD, typeDef = 2, "itemDesRead"
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local FootballToFbPanel = class("FootballToFbPanel", baseFguiPanel)
function FootballToFbPanel:ctor(...)
	self.super.ctor(self, ...)
	print("FootballToFbPanel:ctor", self.viewName)
end
function FootballToFbPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function FootballToFbPanel:onInit()
	print("=======FootballToFbPanel:onInit")
	self.activityID = gActivityTimeActivityID.PITCH_AGAINST_HEAD_ACTIVITY
	self.costID = math.floor(constantRead.getConstValue("PITCH_AGAINST_HEAD_ITEM"))
	self.costGoldNum = constantRead.getConstValue("PITCH_AGAINST_HEAD_GOLD")
	self.fields.Com_title:initData(i18n("activity_name_9001475"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_tip:setString(i18n("pitchagainsthead_04"))
	self.fields.Btn_gold:setString(i18n("pitchagainsthead_02"))
	self.fields.Btn_gold:addClickListener(handler(self, self.onBtnGold))
	self.fields.Btn_tool:setString(i18n("pitchagainsthead_01"))
	self.fields.Btn_tool:setCostIcon(publicRead.getIcon(self.costID))
	self.fields.Btn_tool:addClickListener(handler(self, self.onBtnTool))
	self.fields.Btn_reset:setString(i18n("common_text_4152"))
	self.fields.Btn_reset:setVisible(false)
	self.fields.Btn_reset:addClickListener(handler(self, self.onBtnReset))
	self.fields.Btn_gold:fixPos()
	self.fields.Btn_tool:fixPos()
	pitchAgainstHeadCtrl:sendInit()
end
function FootballToFbPanel:onShow()
	print("=======FootballToFbPanel:onShow")
	local timer = activityShowCtrl:getTimeInfoByID(self.activityID)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.fields.timer:beginTime(leftTime)
	end
	self:updateView()
	if display.height >= 1136 and display.height < 1236 then
		self.fields.bg:setScale(0.89)
	end
end
function FootballToFbPanel:updateView(target, data)
	SoraDCloseLoading(self)
	local isFromMsg = false
	local _ENV, flipData = self, self
	if data and data.index and data.cType then
		isFromMsg = true
		flipData = data
	end
	for i = 1, 10 do
		self.fields["blue_" .. i]:initData(typeDef.TOOL, i, pitchAgainstHeadCtrl:getCellInfo(typeDef.TOOL, i), isFromMsg, flipData)
	end
	for i = 1, 10 do
		self.fields["red_" .. i]:initData(typeDef.GOLD, i, pitchAgainstHeadCtrl:getCellInfo(typeDef.GOLD, i), isFromMsg, flipData)
	end
	self.fields.Btn_gold:setCostNum(self.costGoldNum, SoraDGetGold(), true)
	self.fields.Btn_gold:setVisible(not pitchAgainstHeadCtrl:isAllShow(typeDef.GOLD))
	local itemNum = backpackCtrl:getItemCount(self.costID)
	self.fields.Btn_tool:setCostNum(1, itemNum, true)
	self.fields.Btn_tool:setVisible(not pitchAgainstHeadCtrl:isAllShow(typeDef.TOOL))
	self.fields.Btn_reset:setVisible(pitchAgainstHeadCtrl:isAllShow(typeDef.TOOL) and pitchAgainstHeadCtrl:isAllShow(typeDef.GOLD))
end
function FootballToFbPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("pitchagainsthead_03")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function FootballToFbPanel:onBtnGold()
	SoraDPlaySound()
	if SoraDEnoughGold(self.costGoldNum) then
		SoraDShowLoading(self)
		pitchAgainstHeadCtrl:sendDraw(typeDef.GOLD, pitchAgainstHeadCtrl:getDrawIndex(typeDef.GOLD))
	end
end
function FootballToFbPanel:onBtnTool()
	SoraDPlaySound()
	if backpackCtrl:getItemCount(self.costID) > 0 then
		SoraDShowLoading(self)
		pitchAgainstHeadCtrl:sendDraw(typeDef.TOOL, pitchAgainstHeadCtrl:getDrawIndex(typeDef.TOOL))
	else
		local sources = itemDesRead.getOutput(self.costID)
		_ENV = pitchAgainstHeadCtrl:getDrawIndex(typeDef.TOOL)
		pitchAgainstHeadCtrl:getDrawIndex(typeDef.TOOL).sources = sources
		uiManager:show("CommonSourceGuide", pitchAgainstHeadCtrl:getDrawIndex(typeDef.TOOL))
	end
end
function FootballToFbPanel:onBtnReset()
	SoraDPlaySound()
	SoraDShowLoading(self)
	pitchAgainstHeadCtrl:sendReset()
end
return FootballToFbPanel
